import SwiftUI

struct VectorValueView: View {
    let title: String
    let vector: Vec3
    let color: Color
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.caption)
                .bold()
                .foregroundColor(color)
            
            VStack(spacing: 2) {
                Text(String(format: "%.2f", vector.x))
                Text(String(format: "%.2f", vector.y))
                Text(String(format: "%.2f", vector.z))
            }
            .font(.system(.caption, design: .monospaced))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(color.opacity(0.5), lineWidth: 1)
            )
        }
    }
}
