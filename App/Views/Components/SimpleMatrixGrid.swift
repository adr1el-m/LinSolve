import SwiftUI

struct SimpleMatrixGrid: View {
    let matrix: [[Fraction]]
    let highlights: [Int]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<matrix.count, id: \.self) { r in
                HStack(spacing: 12) {
                    ForEach(0..<matrix[0].count, id: \.self) { c in
                        Text(c < matrix[r].count ? matrix[r][c].description : "0")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(highlights.contains(c) ? .blue : .primary)
                            .frame(width: 40, height: 30)
                            .background(highlights.contains(c) ? Color.blue.opacity(0.1) : Color.clear)
                            .cornerRadius(4)
                    }
                }
            }
        }
        .padding(12)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}
