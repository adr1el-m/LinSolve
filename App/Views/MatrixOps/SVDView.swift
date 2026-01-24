import SwiftUI

struct SVDView: View {
    @EnvironmentObject var matrixData: MatrixData
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Singular Value Decomposition (SVD)")
                    .font(.title2)
                    .bold()
                
                Text("Any m×n matrix A can be factored into A = UΣVᵀ, where U is an m×m orthogonal matrix, Σ is an m×n diagonal matrix with non-negative singular values, and V is an n×n orthogonal matrix.")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                let matrix = matrixData.getFractionMatrix()
                let result = MatrixEngine.calculateSVD(matrix: matrix)
                
                if result.steps.isEmpty {
                    Text("Please enter a valid matrix in the Setup section.")
                        .foregroundColor(.red)
                } else {
                    // Result: U, Sigma, V
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Decomposition")
                            .font(.headline)
                        
                        HStack(alignment: .top, spacing: 10) {
                            VStack {
                                Text("U")
                                    .font(.caption)
                                StringMatrixGrid(matrix: result.U)
                            }
                            
                            Text("×")
                                .font(.title)
                                .padding(.top, 30)
                            
                            VStack {
                                Text("Σ")
                                    .font(.caption)
                                let m = matrix.count
                                let n = matrix[0].count
                                let sigmaMatrix = makeSigmaMatrix(sigmas: result.Sigma, m: m, n: n)
                                StringMatrixGrid(matrix: sigmaMatrix)
                            }
                            
                            Text("×")
                                .font(.title)
                                .padding(.top, 30)
                            
                            VStack {
                                Text("Vᵀ")
                                    .font(.caption)
                                let VT = transposeStringMatrix(result.V)
                                StringMatrixGrid(matrix: VT)
                            }
                        }
                        .scroll(.horizontal)
                        
                        Text("A = UΣVᵀ")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    
                    // Singular Values List
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Singular Values")
                            .font(.headline)
                        Text(result.Sigma.joined(separator: ", "))
                            .font(.system(.body, design: .serif))
                    }
                    
                    // Steps
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Step-by-Step Construction")
                            .font(.headline)
                        
                        ForEach(result.steps) { step in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(step.title)
                                    .font(.subheadline)
                                    .bold()
                                
                                Text(step.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                MathView(latex: step.latex)
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(8)
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground).opacity(0.5))
                            .cornerRadius(8)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    func makeSigmaMatrix(sigmas: [String], m: Int, n: Int) -> [[String]] {
        var mat = Array(repeating: Array(repeating: "0", count: n), count: m)
        for i in 0..<min(m, n) {
            if i < sigmas.count {
                mat[i][i] = sigmas[i]
            }
        }
        return mat
    }
    
    func transposeStringMatrix(_ matrix: [[String]]) -> [[String]] {
        guard !matrix.isEmpty else { return [] }
        let rows = matrix.count
        let cols = matrix[0].count
        var res = Array(repeating: Array(repeating: "", count: rows), count: cols)
        for r in 0..<rows {
            for c in 0..<cols {
                res[c][r] = matrix[r][c]
            }
        }
        return res
    }
}
