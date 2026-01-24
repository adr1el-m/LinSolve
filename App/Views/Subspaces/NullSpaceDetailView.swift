import SwiftUI

struct NullSpaceDetailView: View {
    let title: String
    let matrix: [[Fraction]] // RREF
    let pivots: [Int]
    let totalCols: Int
    
    var body: some View {
        let freeIndices = (0..<totalCols).filter { !pivots.contains($0) }
        
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Circle().fill(Color.blue).frame(width: 10, height: 10)
                Text(title).font(.title).bold().foregroundColor(.primary)
                Spacer()
                CopyButton(latex: generateLatex(freeIndices: freeIndices))
            }
            
            // Explanation
            if freeIndices.isEmpty {
                 Text("No free variables. The only solution is the zero vector.")
                    .foregroundColor(.secondary)
            } else {
                 let freeVars = freeIndices.map { "x\(sub: $0 + 1)" }.joined(separator: ", ")
                 Text("Columns \(freeIndices.map { String($0 + 1) }.joined(separator: ", ")) are free variables (\(freeVars)), so the null space basis vectors are found by setting one free variable to 1 (others 0) and solving for the pivot variables.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
            }

            // Computation Flow
            NullSpaceComputationView(rref: matrix, pivots: pivots, totalCols: totalCols, title: "N(A)")
            
            Spacer()
        }
        .padding()
    }
    
    func generateLatex(freeIndices: [Int]) -> String {
        guard !freeIndices.isEmpty else { return "N(A) = \\{ \\vec{0} \\}" }
        let basisVecs = freeIndices.map { freeIdx -> String in
            let rows = (0..<totalCols).map { rowIdx -> String in
                if rowIdx == freeIdx { return "1" }
                if freeIndices.contains(rowIdx) { return "0" }
                if let pivotRank = pivots.firstIndex(of: rowIdx), pivotRank < matrix.count {
                    let val = matrix[pivotRank][freeIdx]
                    return (Fraction(-1) * val).description
                }
                return "0"
            }.joined(separator: "\\\\")
            return "\\begin{bmatrix} \(rows) \\end{bmatrix}"
        }.joined(separator: ", ")
        return "N(A) = \\text{span} \\left\\{ \(basisVecs) \\right\\}"
    }
}


