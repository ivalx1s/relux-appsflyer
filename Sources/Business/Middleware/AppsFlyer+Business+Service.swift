import Foundation
import AppsFlyerLib

extension AppsFlyer.Business {
    public protocol IService: Sendable {
        typealias Model = AppsFlyer.Business.Model
        typealias Err = AppsFlyer.Business.Err

        func setup(with config: Model.Config) async -> Result<Void, Err>
        func identifyUser(id: Model.UserId?) async
        func setUserData(_ data: Model.UserData) async
        func track(event: Model.Event) async ->  Result<Void, Err>
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

extension AppsFlyer.Business.Service: AppsFlyer.Business.IService {
    public func setup(with config: Model.Config) async -> Result<Void, Err> {
        appsFlyerSDK.currentDeviceLanguage = NSLocale.current.language.languageCode?.identifier
        appsFlyerSDK.appleAppID = config.appId
        appsFlyerSDK.appsFlyerDevKey = config.apiKey
        appsFlyerSDK.isDebug = config.debugEnabled

        return await withCheckedContinuation { ctn in
            appsFlyerSDK.start { (_, error) in
                switch error {
                    case .none: ctn.resume(returning: .success(()))
                    case let .some(err): ctn.resume(returning: .failure(.failedToSetup(config: config, cause: err)))
                }
            }
        }
    }

    public func identifyUser(id: Model.UserId?) async {
        appsFlyerSDK.customerUserID = id
    }

    public func setUserData(_ data: Model.UserData) async {
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

