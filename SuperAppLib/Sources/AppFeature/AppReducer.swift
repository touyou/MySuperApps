import ComposableArchitecture
import ClockFeature
import SwiftUI

@Reducer
public struct AppReducer: Reducer {
  @ObservableState
  public struct State: Equatable {
    public init() {}
    
    var clock = ClockReducer.State()
    
    var destinationTag: DestinationTag? = .clock
    
    enum DestinationTag: String, Equatable, CaseIterable {
      case clock = "Clock"
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case clock(ClockReducer.Action)
    case binding(BindingAction<State>)
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.clock, action: \.clock, child: ClockReducer.init)
  }
}
