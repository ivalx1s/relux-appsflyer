import Foundation
import AppsFlyerLib
import AppTrackingTransparency
import AdSupport

extension AppsFlyer.Business {
    public protocol IAppsFlyerIdProvider: Sendable {
        var appsFlyerUID: String { get async }
    }
}

extension AppsFlyer.Business {
    public protocol IService: IAppsFlyerIdProvider, Actor {
        typealias Model = AppsFlyer.Business.Model
        typealias Err = AppsFlyer.Business.Err
        
        func setup(with config: Model.Config) async -> Result<Void, Err>
        func identifyUser(id: Model.UserId?) async
        func setUserData(_ data: Model.UserData) async
        func startCollectMetrics(with delay: TimeInterval) async -> Result<Model.AppsFlyerStartState, Err>
        func track(event: Model.Event) async
        
        func getStatus() -> Model.ATTStatus
        func requestStatus() async -> Model.ATTStatus
    }
}


extension AppsFlyer.Business {
    public actor Service {
        private let appsFlyerSDK = AppsFlyerLib.shared()
        
        public init(
        ) {
        }
    }
}

// appsfilyer
extension AppsFlyer.Business.Service: AppsFlyer.Business.IService {
    public var appsFlyerUID: String {
        get async {
            appsFlyerSDK.getAppsFlyerUID()
        }
    }
    
    public func setup(with config: Model.Config) async -> Result<Void, Err> {
        AppsFlyer.log("setup with config: \(config)")
        
        appsFlyerSDK.currentDeviceLanguage = config.language
        appsFlyerSDK.appleAppID = config.appId
        appsFlyerSDK.appsFlyerDevKey = config.apiKey
        appsFlyerSDK.isDebug = config.debugEnabled
        
        return .success(())
    }
    
    public func identifyUser(id: Model.UserId?) async {
        AppsFlyer.log("identify user with id: \(id ?? "null")")
        appsFlyerSDK.customerUserID = id
    }
    
    func _startCollectMetrics(_ delay: TimeInterval) async -> Result<Model.AppsFlyerStartState, AppsFlyer.Business.Err> {
        AppsFlyer.log("starting appsflyer")
        
        return await withCheckedContinuation { continuation in
            let protectedContinuation = ProtectedCheckedContinuation(continuation)
            
            // Precaution to return from continuation if underlying method does not return
            let calculatedDelay = max(delay * 2, 10) // Ensure delay is at least 10 seconds
            let timeout = UInt64(calculatedDelay * 1_000_000_000)
            Task {
                try? await Task.sleep(nanoseconds: timeout)
                let timeoutError = NSError.appsFlyerStarttimeout
                let startError = Self.parseStartError(timeoutError)
                await protectedContinuation.resumeOnce(.failure(.failedToStart(cause: startError)))
            }
            
            appsFlyerSDK.start { _, error in
                Task {
                    if let err = error {
                        let startError = Self.parseStartError(err)
                        await protectedContinuation.resumeOnce(.failure(.failedToStart(cause: startError)))
                    } else {
                        await protectedContinuation.resumeOnce(.success(.success))
                    }
                }
            }
        }
    }
    
    public func startCollectMetrics(with delay: TimeInterval) async -> Result<Model.AppsFlyerStartState, Err> {
        guard delay > 0
        else { return await _startCollectMetrics(delay) }
        
        AppsFlyer.log("starting await for IDFA authorization token")
        appsFlyerSDK.waitForATTUserAuthorization(timeoutInterval: delay)
        return await _startCollectMetrics(delay)
    }
    
    public func setUserData(_ data: Model.UserData) async {
        AppsFlyer.log("setting user data \(data)")
        appsFlyerSDK.customData = data
    }
    
    public func track(event: AppsFlyer.Business.Model.Event) async {
        await appsFlyerSDK.logEvent(
            name: event.name,
            values: event.data
        ) { result, error in
            if let error {
                AppsFlyer.log("track error: \(error)")
            } else if let result {
                AppsFlyer.log("track result: \(result)")
            }
        }
    }
}

// ATT
extension AppsFlyer.Business.Service {
    public func getStatus() -> Model.ATTStatus {
        ATTrackingManager.trackingAuthorizationStatus
            .asATTStatus
    }
    
    public func requestStatus() async-> Model.ATTStatus {
        await ATTrackingManager.requestTrackingAuthorization()
            .asATTStatus
    }
}


extension AppsFlyer.Business.Service {
    /// Recursively collects `self` and all underlying errors into an array.
    private static func flattenErrors(_ error: Error) -> [NSError] {
        var results = [NSError]()
        var current = error as NSError
        results.append(current)
        
        // Keep following NSUnderlyingErrorKey if present
        while let next = current.userInfo[NSUnderlyingErrorKey] as? NSError {
            results.append(next)
            current = next
        }
        return results
    }
    
    /// Inspects every level of the chain, returning the most specific `StartError`.
    private static func parseStartError(_ error: Error) -> AppsFlyer.Business.StartError {
        let allErrors = flattenErrors(error)
        
        if let badURLError = allErrors.first(where: {
            $0.domain == NSURLErrorDomain && $0.code == -1000
        }) {
            return .badURL(underlying: badURLError)
        }
        
        if let networkError = allErrors.first(where: {
            $0.domain == "com.appsflyer.sdk.network" && $0.code == 40
        }) {
            return .networkFailure(underlying: networkError)
        }
        
        if let timeoutError = allErrors.first(where: {
            $0.domain == "com.appsflyer.sdk.timeout"
        }) {
            return .timeout(underlying: timeoutError)
        }
        
        let nsError = error as NSError
        return .unknown(underlying: nsError)
    }
}


extension AppsFlyer.Business.Service {
    actor ProtectedCheckedContinuation {
        private var hasResumed = false
        private var continuation: CheckedContinuation<Result<Model.AppsFlyerStartState, AppsFlyer.Business.Err>, Never>?
        
        init(_ continuation: CheckedContinuation<Result<Model.AppsFlyerStartState, AppsFlyer.Business.Err>, Never>) {
            self.continuation = continuation
        }
        
        func resumeOnce(_ result: Result<Model.AppsFlyerStartState, AppsFlyer.Business.Err>) {
            guard !hasResumed else { return }
            hasResumed = true
            continuation?.resume(returning: result)
            continuation = nil
        }
    }
}

extension NSError {
    static let appsFlyerStarttimeout = NSError(
        domain: "com.appsflyer.sdk.timeout",
        code: 9999,
        userInfo: [NSLocalizedDescriptionKey: "AppsFlyer start() did not invoke its callback."]
    )
}
