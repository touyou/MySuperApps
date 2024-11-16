import ComposableArchitecture
import ClockFeature
import SwiftUI

@Reducer
public struct AppFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    public init() {}
    
    var clock = ClockFeature.State()
    
    var destinationTag: DestinationTag? = .clock
    
    enum DestinationTag: String, Equatable, CaseIterable {
      case clock = "Clock"
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case clock(ClockFeature.Action)
    case binding(BindingAction<State>)
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.clock, action: \.clock, child: ClockFeature.init)
  }
}
