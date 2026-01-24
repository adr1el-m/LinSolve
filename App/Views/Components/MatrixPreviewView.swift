import SwiftUI

struct MatrixPreviewView: View {
    let matrix: [[Fraction]]
    
    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            // Left Bracket
            bracket(isLeft: true)
            
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
            bracket(isLeft: false)
        }
    }
    
    func bracket(isLeft: Bool) -> some View {
        Rectangle()
            .fill(Color.primary)
            .frame(width: 2)
            .mask(
                HStack(spacing: 0) {
                    if isLeft {
                        Rectangle().frame(width: 2)
                        VStack {
                            Rectangle().frame(height: 2)
                            Spacer()
                            Rectangle().frame(height: 2)
                        }
                        .frame(width: 6)
                    } else {
                        VStack {
                            Rectangle().frame(height: 2)
                            Spacer()
                            Rectangle().frame(height: 2)
                        }
                        .frame(width: 6)
                        Rectangle().frame(width: 2)
                    }
                }
            )
    }
}
