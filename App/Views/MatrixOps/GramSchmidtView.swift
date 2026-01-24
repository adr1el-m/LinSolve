import SwiftUI

struct GramSchmidtView: View {
    @EnvironmentObject var matrixData: MatrixData
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Gram-Schmidt Process & QR Decomposition")
                    .font(.title2)
                    .bold()
                
                Text("Converts a set of linearly independent vectors (columns of A) into an orthonormal set (columns of Q). A = QR.")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                let matrix = matrixData.getFractionMatrix()
                let result = MatrixEngine.calculateGramSchmidt(matrix: matrix)
                
                if result.steps.isEmpty {
                     VStack(alignment: .leading, spacing: 8) {
                        Text("Please enter a valid matrix with linearly independent columns.")
                            .foregroundColor(.red)
                         Text("Note: The Gram-Schmidt process requires linearly independent columns.")
                             .font(.caption)
                             .foregroundColor(.secondary)
                     }
                     .padding()
                     .background(Color.red.opacity(0.1))
                     .cornerRadius(8)
                } else {
                    // Result: Q and R
                    VStack(alignment: .leading, spacing: 12) {
                        Text("QR Decomposition")
                            .font(.headline)
                        
                        HStack(alignment: .top, spacing: 10) {
                            VStack {
                                Text("Q (Orthonormal)")
                                    .font(.caption)
                                StringMatrixGrid(matrix: result.Q)
                            }
                            
                            Text("×")
                                .font(.title)
                                .padding(.top, 30)
                            
                            VStack {
                                Text("R (Upper Triangular)")
                                    .font(.caption)
                                StringMatrixGrid(matrix: result.R)
                            }
                        }
                        .scroll(.horizontal)
                        
                        Text("A = QR")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    
                    // Orthogonal Basis
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Orthogonal Basis (Unnormalized)")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            ForEach(0..<result.orthogonalBasis.count, id: \.self) { i in
                                VStack {
                                    Text("v\(i+1)'")
                                        .font(.caption)
                                        .italic()
                                    VectorColumnView(vector: result.orthogonalBasis[i], color: .purple)
                                }
                            }
                        }
                        .scroll(.horizontal)
                    }
                    .padding()
                    
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
}
