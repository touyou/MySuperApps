import SwiftUI

/// # SetparticleTextField
/// - パーティクルで表示する文字を設定するテキストフィールドエリア
struct SetParticleTextField: View {
  let text: Binding<String>
  let onFocus: FocusState<Bool>.Binding
  
  var body: some View {
    VStack {
      Text("Text to Particle")
        .foregroundStyle(.primary)
        .padding()
        .font(.system(size: 14, design: .rounded))
      TextField("...", text: text)
        .foregroundStyle(.primary)
        .padding()
        .font(.system(size: 20, design: .rounded))
        .bold()
        .background(.primary.opacity(0.1))
        .cornerRadius(20)
        .frame(width: 200)
        .contentShape(Rectangle())
        .multilineTextAlignment(.center)
        .focused(onFocus)
    }
  }
}
