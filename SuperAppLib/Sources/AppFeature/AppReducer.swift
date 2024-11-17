import ComposableArchitecture
import ClockFeature
import ParticleTextFeature
import SwiftUI

@Reducer
public struct AppReducer: Reducer {
  @ObservableState
  public struct State: Equatable {
    public init() {}
    
    var clock = ClockReducer.State()
    var particleText = ParticleTextReducer.State()
    
    var destinationTag: DestinationTag? = nil
    
    enum DestinationTag: String, Equatable, CaseIterable {
      case clock = "Clock"
      case particleText = "Particle Text"
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case clock(ClockReducer.Action)
    case particleText(ParticleTextReducer.Action)
    case binding(BindingAction<State>)
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.clock, action: \.clock, child: ClockReducer.init)
    Scope(state: \.particleText, action: \.particleText, child: ParticleTextReducer.init)
  }
}
