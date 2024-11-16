import ComposableArchitecture
import Foundation

@Reducer
public struct ClockFeature: Reducer, Sendable {
  @ObservableState
  public struct State: Equatable {
    public init() {}
    
    var currentTime: Date = .now
    var isTickVisible: Bool = true
    
    private var hour: Int { Calendar.current.component(.hour, from: currentTime) }
    
    private var minute: Int { Calendar.current.component(.minute, from: currentTime) }
    
    private var second: Int { Calendar.current.component(.second, from: currentTime) }
    
    var hourClockAngle: Double {
      Double(hour) * 30 + Double(minute) * 0.5
    }
    
    var minuteClockAngle: Double {
      Double(minute) * 6
    }
    
    var secondClockAngle: Double {
      Double(second) * 6
    }
    
    private var hourString: String {
      currentTime.formatted(.dateTime.hour(.twoDigits(amPM: .omitted)))
    }
    
    private var minuteString: String {
      currentTime.formatted(.dateTime.minute(.twoDigits))
    }
    
    private var secondString: String {
      currentTime.formatted(.dateTime.second(.twoDigits))
    }
    
    var timeText: String {
//      isTickVisible ?
      "\(hourString):\(minuteString):\(secondString)"
//      : "\(hourString) \(minuteString) \(secondString)"
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
          for await _ in clock.timer(interval: .seconds(0.5)) {
            await send(.updateTime(.now))
          }
        }
      case .updateTime(let date):
        state.currentTime = date
        state.isTickVisible.toggle()
        return .none
      }
    }
  }
}
