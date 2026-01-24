import SwiftUI

struct RowSpaceDetailView: View {
    let title: String
    let originalMatrix: [[Fraction]]
    
    var body: some View {
        let transposed = MatrixEngine.transpose(originalMatrix)
        let rrefTSteps = MatrixEngine.calculateRREF(matrix: transposed)
        let rrefT = rrefTSteps.last?.matrix ?? []
        let pivotsT = MatrixEngine.getPivotIndices(rref: rrefT)
        
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Circle().fill(Color.orange).frame(width: 10, height: 10)
                Text(title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                Spacer()
                CopyButton(latex: generateLatex(transposed: transposed, pivotsT: pivotsT))
            }
            
            Text("Computation: R(A) = C(Aᵀ)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            RowSpaceComputationView(transposed: transposed, rrefT: rrefT, pivotsT: pivotsT)
            
            Spacer()
        }
        .padding()
    }
    
    func generateLatex(transposed: [[Fraction]], pivotsT: [Int]) -> String {
        guard !pivotsT.isEmpty else { return "C(A^T) = \\{ \\vec{0} \\}" }
        let basisVecs = pivotsT.map { col -> String in
            let vec = transposed.map { $0[col] }
            let rows = vec.map { $0.description }.joined(separator: "\\\\")
            return "\\begin{bmatrix} \(rows) \\end{bmatrix}"
        }.joined(separator: ", ")
        return "C(A^T) = \\text{span} \\left\\{ \(basisVecs) \\right\\}"
    }
}

struct RowSpaceComputationView: View {
    let transposed: [[Fraction]]
    let rrefT: [[Fraction]]
    let pivotsT: [Int]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            // Step 1: Transpose
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 1: Transpose Matrix A")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("The row space of A is the column space of Aᵀ. First, we transpose A.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                SimpleMatrixGrid(matrix: transposed, highlights: [])
                    .padding(.top, 4)
            }
            
            // Step 2: RREF
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 2: RREF(Aᵀ)")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Compute the Reduced Row Echelon Form of Aᵀ to find pivot columns.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                SimpleMatrixGrid(matrix: rrefT, highlights: pivotsT)
                
                Text("Pivots: \(pivotsT.map { "Col \($0+1)" }.joined(separator: ", "))")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            // Step 3: Basis
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 3: Basis Vectors")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("The pivot columns of Aᵀ (which correspond to rows of A) form a basis for the Row Space.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if pivotsT.isEmpty {
                     Text("{ 0 }").font(.title).bold().foregroundColor(.secondary)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(pivotsT, id: \.self) { colIndex in
                                let vec = transposed.map { $0[colIndex] }
                                VectorColumnView(vector: vec, color: .orange)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
