import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct ParticleTextReducer: Reducer, Sendable {
  @ObservableState
  public struct State: Equatable, Sendable {
    public init() {}
    
    var text: String = ""
    var particleCount: Int = 1000
    var particles: [Particle] = []
    var dragPosition: CGPoint?
    var dragVelocity: CGSize?
    var size: CGSize = .zero
  }
  
  public enum Action: BindableAction, Equatable {
    case startTimer
    case updateParticles
    case createParticles
    case updateParticlesValue([Particle])
    case updateDragPosition(CGPoint?)
    case updateDragVelocity(CGSize?)
    case updateSize(CGSize)
    case binding(BindingAction<State>)
  }
  
  @Dependency(\.continuousClock) var clock
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .startTimer:
        return .run { send in
          // NOTE: 1 / 120 sec = 8333.33... micro-sec
          for await _ in clock.timer(interval: .microseconds(8333)) {
            await send(.updateParticles)
          }
        }
      case .updateParticles:
        for i in state.particles.indices {
          state.particles[i].update(
            dragPosition: state.dragPosition,
            dragVelocity: state.dragVelocity
          )
        }
        return .none
      case .createParticles:
        let text = state.text
        let size = state.size
        let particleCount = state.particleCount
        
        return .run { @MainActor send in
          let renderer = ImageRenderer(content: Text(text)
            .font(.system(size: 240, design: .rounded))
            .bold())
          
          renderer.scale = 1.0
          
          guard let image = renderer.uiImage else { return }
          guard let cgImage = image.cgImage else { return }
          
          let width = Int(image.size.width)
          let height = Int(image.size.height)
          
          guard
            let pixelData = cgImage.dataProvider?.data,
            let data = CFDataGetBytePtr(pixelData)
          else { return }
          
          let offsetX = (size.width - CGFloat(width)) / 2
          let offsetY = (size.height - CGFloat(height)) / 2
          
          let particles = (0..<particleCount).map { _ in
            var x, y: Int
            repeat {
              x = Int.random(in: 0..<width)
              y = Int.random(in: 0..<height)
            } while data[((width * y) + x) * 4 + 3] < 128
            
            return Particle(
              x: Double.random(in: -size.width...size.width * 2),
              y: Double.random(in: 0...size.height * 2),
              baseX: Double(x) + offsetX,
              baseY: Double(y) + offsetY,
              density: Double.random(in: 5...20)
            )
          }
          
          send(.updateParticlesValue(particles))
        }
      case .updateParticlesValue(let particles):
        state.particles = particles
        return .none
      case .updateDragPosition(let dragPosition):
        state.dragPosition = dragPosition
        return .none
      case .updateDragVelocity(let dragVelocity):
        state.dragVelocity = dragVelocity
        return .none
      case .updateSize(let size):
        state.size = size
        return .none
      case .binding(\.text):
        return .run { send in
          await send(.createParticles)
        }
      case .binding(_):
        return .none
      }
    }
  }
}
