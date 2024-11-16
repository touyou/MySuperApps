import SwiftUI
import SwiftData
import SharedModels
import ComposableArchitecture
import ClockFeature

public struct AppFeatureView: View {
  @Bindable var store: StoreOf<AppFeature>
  
  public init(store: StoreOf<AppFeature>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationSplitView {
      List(selection: $store.destinationTag) {
        ForEach(AppFeature.State.DestinationTag.allCases, id: \.self) { value in
          NavigationLink(value: value) {
            Text(value.rawValue.capitalized)
          }
        }
      }
#if os(macOS)
      .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
      //      .toolbar {
      //#if os(iOS)
      //        ToolbarItem(placement: .navigationBarTrailing) {
      //        }
      //#endif
      //        ToolbarItem {
      //        }
      //      }
    } detail: {
      switch store.state.destinationTag {
      case .clock: ClockFeatureView(store: store.scope(state: \.clock, action: \.clock))
      case .none: EmptyView()
      }
    }
  }
}

#Preview {
  //  AppFeatureView()
}
