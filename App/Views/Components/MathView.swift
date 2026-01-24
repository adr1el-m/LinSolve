import SwiftUI

struct MathView: View {
    let latex: String
    
    var body: some View {
        Text(latex)
            .font(.system(.body, design: .serif))
            .multilineTextAlignment(.center)
            .padding(8)
            .background(Color.white.opacity(0.5))
            .cornerRadius(8)
    }
}
