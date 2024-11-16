import ComposableArchitecture
import Foundation

@Reducer
public struct ClockFeature: Reducer, Sendable {
  @ObservableState
  public struct State: Equatable {
    public init() {}
    
    var currentTime: Date = .now
    
    var hourClockAngle: Double {
      Double(Calendar.current.component(.hour, from: currentTime)) * 30 + Double(Calendar.current.component(.minute, from: currentTime)) * 0.5
    }
    
    var minuteClockAngle: Double {
      Double(Calendar.current.component(.minute, from: currentTime)) * 6
    }
    
    var secondClockAngle: Double {
      Double(Calendar.current.component(.second, from: currentTime)) * 6
    }
  }
  
  public enum Action: Equatable {
    case onAppear
    case updateTime(Date)
  }
  
  @Dependency(\.continuousClock) var clock
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          for await _ in clock.timer(interval: .seconds(1)) {
            await send(.updateTime(.now))
          }
        }
      case .updateTime(let date):
        state.currentTime = date
        return .none
      }
    }
  }
}
