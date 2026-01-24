import SwiftUI

struct StringMatrixGrid: View {
    let matrix: [[String]]
    var highlights: [Int] = []
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<matrix.count, id: \.self) { r in
                HStack(spacing: 12) {
                    ForEach(0..<matrix[r].count, id: \.self) { c in
                        Text(matrix[r][c])
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(highlights.contains(c) ? .blue : .primary)
                            .frame(minWidth: 40, minHeight: 30)
                            .padding(.horizontal, 4)
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
