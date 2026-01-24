import SwiftUI

struct ColumnSpaceDetailView: View {
    let title: String
    let originalMatrix: [[Fraction]]
    let pivots: [Int]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.green)
                Spacer()
                CopyButton(latex: generateLatex())
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Computation Steps")
                    .font(.headline)
                
                Text("1. Identify pivot columns in RREF.")
                    .font(.body)
                
                if pivots.isEmpty {
                    Text("No pivots found (Zero Matrix).")
                    .foregroundColor(.secondary)
                } else {
                    let pivotCols = pivots.map { "Col \($0 + 1)" }.joined(separator: ", ")
                    Text("The RREF has pivots in: \(pivotCols).")
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Text("2. Select corresponding columns from A.")
                    .font(.body)
                
                Text("The pivot columns of the original matrix form a basis for C(A).")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !pivots.isEmpty {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(pivots, id: \.self) { colIndex in
                        VStack {
                            Text("Col \(colIndex + 1)")
                                .font(.caption)
                                .bold()
                            
                            let vec = originalMatrix.map { $0[colIndex] }
                            VectorColumnView(vector: vec, color: .green)
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
            } else {
                Text("Basis: { 0 }")
                    .font(.system(.body, design: .monospaced))
                    .padding()
            }
            
            Spacer()
        }
        .padding()
    }
    
    func generateLatex() -> String {
        guard !pivots.isEmpty else { return "C(A) = \\{ \\vec{0} \\}" }
        let basisVecs = pivots.map { col -> String in
            let vec = originalMatrix.map { $0[col] }
            let rows = vec.map { $0.description }.joined(separator: "\\\\")
            return "\\begin{bmatrix} \(rows) \\end{bmatrix}"
        }.joined(separator: ", ")
        return "C(A) = \\text{span} \\left\\{ \(basisVecs) \\right\\}"
    }
}
