import SwiftUI

struct ClockHand: View {
  var angle: Angle
  var width: CGFloat
  var color: Color
  
  var body: some View {
    RoundedRectangle(cornerRadius: width * 0.5)
      .fill(color)
      .frame(width: width, height: 100)
      .offset(y: -50)
      .rotationEffect(angle)
  }
}
