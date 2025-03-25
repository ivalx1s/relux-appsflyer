import Relux
import Foundation
@preconcurrency import Combine

public extension AppsFlyer.UI {
    @MainActor
    final class ViewState: Relux.Presentation.StatePresenting, ObservableObject {
        public typealias Model = AppsFlyer.Business.Model

        @Published public private(set) var status: Model.ATTStatus?

        public init(
            state: AppsFlyer.Business.State
        ) {
            Task { await initPipelines(state: state) }
        }

        private func initPipelines(state: AppsFlyer.Business.State) async {
            await state.$status
                .receive(on: DispatchQueue.main)
                .assign(to: &$status)
        }
    }
}
