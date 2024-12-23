import SwiftUI
import ComposableArchitecture

public struct ClockView: View {
  @Bindable var store: StoreOf<ClockReducer>
  
  public init(store: StoreOf<ClockReducer>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      ZStack {
        Circle()
          .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
          .stroke(.gray, style: .init(lineWidth: 2))
          .shadow(color: .black.opacity(0.2), radius: 10, x: 10, y: 10)
        
        ForEach(0..<12) { hour in
          Rectangle()
            .fill(.white)
            .frame(width: 2, height: hour % 3 == 0 ? 15 : 7)
            .offset(y: -120)
            .rotationEffect(.degrees(Double(hour) * 30))
        }
        
        ClockHand(angle: .degrees(store.state.hourClockAngle), width: 5, color: .white)
        ClockHand(angle: .degrees(store.state.minuteClockAngle), width: 3, color: .white)
        ClockHand(angle: .degrees(store.state.secondClockAngle), width: 1, color: .red)
        
        Circle()
          .fill(.red)
          .frame(width: 12, height: 12)
      }
      .frame(width: 300, height: 300)
      .padding()
      Text(store.state.timeText)
        .font(.title.monospaced())
    }
    .onAppear {
      store.send(.startTimer)
    }
  }
}

#Preview {
  ClockView(
    store: .init(initialState: .init(), reducer: ClockReducer.init)
  )
}
