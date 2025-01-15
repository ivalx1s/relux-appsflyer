import Relux
import Foundation
@preconcurrency import Combine

extension AppsFlyer.UI {
    @MainActor
    final class ViewState: Relux.Presentation.StatePresenting {
        typealias Model = AppsFlyer.Business.Model

        @Published var status: Model.ATTStatus?

        init(
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
