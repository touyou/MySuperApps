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
        Canvas { context, size in
          context.blendMode = .normal
          
          for particle in store.particles {
            particle.draw(in: context)
          }
        }
        .onAppear {
          store.send(.createParticles)
          store.send(.startTimer)
        }
        .gesture(
          DragGesture(minimumDistance: 0)
            .onChanged { value in
              store.send(.updateDragPosition(value.location))
              store.send(.updateDragVelocity(value.velocity))
              triggerHapticFeedback()
            }
            .onEnded { value in
              store.send(.updateDragPosition(nil))
              store.send(.updateDragVelocity(nil))
              store.send(.updateParticles)
            }
        )
        .background(.background)
        .overlay(
          GeometryReader { geometry in
            Color.clear
              .onAppear {
                store.send(.updateSize(geometry.size))
                store.send(.createParticles)
              }
          }
        )
        .ignoresSafeArea()
        .opacity(onFocus ? 0.3 : 1)
      }
      
      VStack {
        Text("Text to Particle")
          .foregroundStyle(.primary)
          .padding()
          .font(.system(size: 14, design: .rounded))
        TextField("...", text: $store.text)
          .foregroundStyle(.primary)
          .padding()
          .font(.system(size: 20, design: .rounded))
          .bold()
          .background(.primary.opacity(0.1))
          .cornerRadius(20)
          .frame(width: 200)
          .contentShape(Rectangle())
          .multilineTextAlignment(.center)
          .focused($onFocus)
      }
      .offset(y: onFocus ? 0 : 330)
    }
  }
  
  private func triggerHapticFeedback() {
    let impact = UIImpactFeedbackGenerator(style: .light)
    impact.impactOccurred()
  }
}

#Preview {
  ParticleTextView(
    store: .init(initialState: .init(), reducer: ParticleTextReducer.init)
  )
}