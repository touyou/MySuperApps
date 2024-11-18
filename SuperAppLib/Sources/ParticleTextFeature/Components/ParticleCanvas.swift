import SwiftUI

/// # ParticleCanvas
/// - パーティクルの情報を受け取り描画するView
struct ParticleCanvas: View {
  let particles: [Particle]
  let onAppear: () -> Void
  let onChangeDrag: (DragGesture.Value) -> Void
  let onEndedDrag: (DragGesture.Value) -> Void
  let onSetGeometry: (GeometryProxy) -> Void
  
  var body: some View {
    Canvas { context, size in
      context.blendMode = .normal
      
      for particle in particles {
        particle.draw(in: context)
      }
    }
    .onAppear {
      onAppear()
    }
    .gesture(
      DragGesture(minimumDistance: 0)
        .onChanged(onChangeDrag)
        .onEnded(onEndedDrag)
    )
    .background(.background)
    .overlay(
      GeometryReader { geometry in
        Color.clear
          .onAppear {
            onSetGeometry(geometry)
          }
      }
    )
  }
}
