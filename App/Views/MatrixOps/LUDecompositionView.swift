import SwiftUI

struct LUDecompositionView: View {
    @EnvironmentObject var matrixData: MatrixData
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("LU Decomposition")
                    .font(.title2)
                    .bold()
                
                Text("Factors a matrix A into a lower triangular matrix L and an upper triangular matrix U. A = LU.")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                let matrix = matrixData.getFractionMatrix()
                let result = MatrixEngine.calculateLUDecomposition(matrix: matrix)
                
                if result.steps.isEmpty {
                    Text("LU Decomposition requires a square matrix and no row exchanges (for basic LU).")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // Result: L and U
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Decomposition")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 10) {
                                VStack {
                                    Text("L (Lower)")
                                        .font(.caption)
                                    MatrixGridView(matrix: result.L)
                                }
                                
                                Text("×")
                                    .font(.title)
                                    .padding(.top, 30)
                                
                                VStack {
                                    Text("U (Upper)")
                                        .font(.caption)
                                    MatrixGridView(matrix: result.U)
                                }
                            }
                        }
                        
                        Text("A = LU")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    
                    // Steps
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Row Reduction Steps")
                            .font(.headline)
                        
                        ForEach(result.steps, id: \.id) { step in
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
}
