import SwiftUI

struct MatrixPreviewView: View {
    let matrix: [[Fraction]]
    
    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            // Left Bracket
            BracketShape(left: true)
                .stroke(Color.primary, lineWidth: 1.5)
                .frame(width: 8)
            
            // Matrix Content
            VStack(spacing: 4) {
                ForEach(0..<matrix.count, id: \.self) { r in
                    HStack(spacing: 8) {
                        ForEach(0..<matrix[r].count, id: \.self) { c in
                            Text(matrix[r][c].description)
                                .font(.system(.body, design: .monospaced))
                                .frame(minWidth: 30)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .padding(.horizontal, 2)
            
            // Right Bracket
            BracketShape(left: false)
                .stroke(Color.primary, lineWidth: 1.5)
                .frame(width: 8)
        }
    }
}
