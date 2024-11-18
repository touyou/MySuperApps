import ComposableArchitecture
import SwiftUI

public struct ParticleTextView: View {
  @Bindable var store: StoreOf<ParticleTextReducer>
  @FocusState private var onFocus: Bool
  
  public init(store: StoreOf<ParticleTextReducer>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      VStack {
        ParticleCanvas(
          particles: store.particles,
          onAppear: {
            store.send(.createParticles)
            store.send(.startTimer)
          },
          onChangeDrag: {value in
            store.send(.setDragPosition(value.location))
            store.send(.setDragVelocity(value.velocity))
            triggerHapticFeedback()
          },
          onEndedDrag: { value in
            store.send(.setDragPosition(nil))
            store.send(.setDragVelocity(nil))
            store.send(.updateParticles)
          },
          onSetGeometry: { geometry in
            store.send(.setSize(geometry.size))
            store.send(.createParticles)
          }
        )
        .ignoresSafeArea()
        .opacity(onFocus ? 0.3 : 1)
      }
      
      SetParticleTextField(
        text: $store.text, onFocus: $onFocus
      )
      .offset(y: onFocus ? 0 : 330)
    }
  }
  
  private func triggerHapticFeedback() {
    #if os(iOS)
    let impact = UIImpactFeedbackGenerator(style: .light)
    impact.impactOccurred()
    #endif
  }
}

#Preview {
  ParticleTextView(
    store: .init(initialState: .init(), reducer: ParticleTextReducer.init)
  )
}
