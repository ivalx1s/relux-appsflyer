import Foundation
import AppsFlyerLib
import AppTrackingTransparency
import AdSupport

extension AppsFlyer.Business {
    public protocol IService: Actor {
        typealias Model = AppsFlyer.Business.Model
        typealias Err = AppsFlyer.Business.Err

        func setup(with config: Model.Config) async -> Result<Void, Err>
        func identifyUser(id: Model.UserId?) async
        func setUserData(_ data: Model.UserData) async
        func startCollectMetrics() async -> Result<Void, Err>
        func startCollectMetrics(with delay: TimeInterval) async -> Result<Void, Err>
        func track(event: Model.Event) async ->  Result<Void, Err>

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

    public func startCollectMetrics() async -> Result<Void, Err> {
        AppsFlyer.log("starting appsflyer")

        return await withCheckedContinuation { ctn in
            appsFlyerSDK.start { (_, error) in
                switch error {
                    case .none: ctn.resume(returning: .success(()))
                    case let .some(err): ctn.resume(returning: .failure(.failedToStart(cause: err)))
                }
            }
        }
    }

    public func startCollectMetrics(with delay: TimeInterval) async -> Result<Void, Err> {
        guard delay > 0
        else { return await startCollectMetrics() }

        AppsFlyer.log("starting await for IDFA authorization token")
        appsFlyerSDK.waitForATTUserAuthorization(timeoutInterval: delay)
        return await startCollectMetrics()
    }

    public func setUserData(_ data: Model.UserData) async {
        AppsFlyer.log("setting user data \(data)")
        appsFlyerSDK.customData = data
    }

    public func track(event: AppsFlyer.Business.Model.Event) async -> Result<Void, Err> {
        await withCheckedContinuation { ctn in
            appsFlyerSDK.logEvent(
                name: event.name,
                values: event.data
            ) { _, error in
                switch error {
                    case .none: ctn.resume(returning: .success(()))
                    case let .some(err): ctn.resume(returning: .failure(.failedToTrack(event: event, cause: err)))
                }
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
