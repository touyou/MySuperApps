import SwiftUI
import SwiftData
import SharedModels
import ComposableArchitecture
import ClockFeature

public struct AppView: View {
  @Bindable var store: StoreOf<AppReducer>
  
  public init(store: StoreOf<AppReducer>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationSplitView {
      List(selection: $store.destinationTag) {
        ForEach(AppReducer.State.DestinationTag.allCases, id: \.self) { value in
          NavigationLink(value: value) {
            Text(value.rawValue.capitalized)
          }
        }
      }
      .navigationTitle("Apps")
#if os(macOS)
      .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
    } detail: {
      switch store.state.destinationTag {
      case .clock: ClockView(store: store.scope(state: \.clock, action: \.clock))
      case .none: EmptyView()
      }
    }
  }
}

#Preview {
    AppView(store: Store(initialState: AppReducer.State(), reducer: AppReducer.init))
}
