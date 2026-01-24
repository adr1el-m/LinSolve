import SwiftUI

struct LeftNullSpaceDetailView: View {
    let title: String
    let originalMatrix: [[Fraction]]
    
    var body: some View {
        let transposed = MatrixEngine.transpose(originalMatrix)
        let rrefTSteps = MatrixEngine.calculateRREF(matrix: transposed)
        let rrefT = rrefTSteps.last?.matrix ?? []
        let pivotsT = MatrixEngine.getPivotIndices(rref: rrefT)
        
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Circle().fill(Color.purple).frame(width: 10, height: 10)
                Text(title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                Spacer()
                CopyButton(latex: generateLatex(rrefT: rrefT, pivotsT: pivotsT, totalCols: transposed[0].count))
            }
            
            Text("Computation: N(Aᵀ) is the Null Space of Aᵀ.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            NullSpaceComputationView(rref: rrefT, pivots: pivotsT, totalCols: transposed[0].count, title: "N(Aᵀ)")
            
            Spacer()
        }
        .padding()
    }
    
    func generateLatex(rrefT: [[Fraction]], pivotsT: [Int], totalCols: Int) -> String {
        let freeIndices = (0..<totalCols).filter { !pivotsT.contains($0) }
        guard !freeIndices.isEmpty else { return "N(A^T) = \\{ \\vec{0} \\}" }
        let basisVecs = freeIndices.map { freeIdx -> String in
            let rows = (0..<totalCols).map { rowIdx -> String in
                if rowIdx == freeIdx { return "1" }
                if freeIndices.contains(rowIdx) { return "0" }
                if let pivotRank = pivotsT.firstIndex(of: rowIdx), pivotRank < rrefT.count {
                    let val = rrefT[pivotRank][freeIdx]
                    return (Fraction(-1) * val).description
                }
                return "0"
            }.joined(separator: "\\\\")
            return "\\begin{bmatrix} \(rows) \\end{bmatrix}"
        }.joined(separator: ", ")
        return "N(A^T) = \\text{span} \\left\\{ \(basisVecs) \\right\\}"
    }
}
