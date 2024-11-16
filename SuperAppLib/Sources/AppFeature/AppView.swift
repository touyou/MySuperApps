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
            Text(value.rawValue)
          }
        }
      }
      .navigationTitle(String(localized: "Apps", bundle: .module))
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
  AppView(store: .init(initialState: .init(), reducer: AppReducer.init))
}
