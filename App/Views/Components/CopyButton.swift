import SwiftUI
import UIKit

struct CopyButton: View {
    let latex: String
    @State private var copied = false
    
    var body: some View {
        Button(action: {
            UIPasteboard.general.string = latex
            withAnimation {
                copied = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    copied = false
                }
            }
        }) {
            HStack(spacing: 4) {
                Image(systemName: copied ? "checkmark" : "doc.on.doc")
                Text(copied ? "Copied" : "Copy LaTeX")
            }
            .font(.caption)
            .bold()
            .padding(8)
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }
    }
}
