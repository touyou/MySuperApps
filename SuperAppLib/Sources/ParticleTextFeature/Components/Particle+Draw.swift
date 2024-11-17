import SwiftUI

extension Particle {
  func draw(in context: GraphicsContext) {
    let path = Path(ellipseIn: CGRect(x: x, y: y, width: 2, height: 2))
    context.fill(path, with: .color(.primary.opacity(0.7)))
  }
}
