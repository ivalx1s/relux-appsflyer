import SwiftUI
import Relux

extension View {
    public func trackEvent(
        _ event: AppsFlyer.Business.Model.Event,
        condition: @escaping () -> Bool = { true }
    ) {
        if condition() {
            performAsync {
                AppsFlyer.Business.Effect.track(event: event)
            }
        }
    }

    public func trackAppearance(
        event: AppsFlyer.Business.Model.Event,
        condition: @escaping () -> Bool = { true }
    ) -> some View {
        self.onAppear {
            trackEvent(event, condition: condition)
        }
    }

    public func onTapTrackEvent(
        _ event: AppsFlyer.Business.Model.Event,
        condition: @escaping () -> Bool = { true }
    ) -> some View {
        self.simultaneousGesture(TapGesture().onEnded{
            trackEvent(event, condition: condition)
        })
    }
}
