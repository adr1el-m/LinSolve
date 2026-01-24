import SwiftUI

struct VectorColumnView: View {
    let vector: [Fraction]
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<vector.count, id: \.self) { i in
                Text(vector[i].description)
                    .font(.system(.body, design: .monospaced))
                    .frame(width: 30)
            }
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(color, lineWidth: 2))
    }
}
