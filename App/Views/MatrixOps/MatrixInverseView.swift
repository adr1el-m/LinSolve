import SwiftUI

struct MatrixInverseView: View {
    @EnvironmentObject var matrixData: MatrixData
    @State private var steps: [MatrixStep] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Matrix Inversion")
                        .font(.largeTitle)
                        .bold()
                    Text("Gauss-Jordan Elimination on [A | I]")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                if matrixData.rows != matrixData.cols {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        Text("Inverse is only defined for square matrices.")
                            .multilineTextAlignment(.center)
                        Text("Current dimensions: \(matrixData.rows) × \(matrixData.cols)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    .padding()
                } else if steps.isEmpty {
                    ProgressView("Computing steps...")
                        .onAppear {
                            calculateSteps()
                        }
                } else {
                    // Steps
                    ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                        InverseStepCard(step: step, index: index, totalCols: matrixData.cols * 2, originalCols: matrixData.cols)
                    }
                    
                    // Conclusion
                    if let last = steps.last {
                        if last.operation == "Result" {
                            VStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.green)
                                Text("Inverse Found Successfully")
                                    .font(.headline)
                                Text("The right half of the augmented matrix is A⁻¹.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        } else if last.operation == "Singular" {
                            VStack(spacing: 12) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.red)
                                Text("Matrix is Singular")
                                    .font(.headline)
                                Text("It cannot be inverted because it squashes space into a lower dimension (Determinant is 0).")
                                    .multilineTextAlignment(.center)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.bottom, 40)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    func calculateSteps() {
        let matrix = matrixData.getFractionMatrix()
        steps = MatrixEngine.calculateInverseSteps(matrix: matrix)
    }
}

struct InverseStepCard: View {
    let step: MatrixStep
    let index: Int
    let totalCols: Int
    let originalCols: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Step Header
            HStack {
                Text("Step \(index + 1)")
                    .font(.caption)
                    .bold()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(4)
                
                Spacer()
                
                Text(step.operation)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            
            // Description
            Text(step.description)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            
            Divider()
            
            // Matrix Visualization
            ScrollView(.horizontal, showsIndicators: true) {
                VStack(spacing: 4) {
                    ForEach(0..<step.matrix.count, id: \.self) { r in
                        HStack(spacing: 8) {
                            // Left Side (A being reduced)
                            ForEach(0..<originalCols, id: \.self) { c in
                                Text(step.matrix[r][c].description)
                                        .font(.system(.body, design: .monospaced))
                                        .frame(width: 60, height: 40)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 4)
                                        .background(Color(UIColor.secondarySystemBackground))
                                        .cornerRadius(4)
                                        .minimumScaleFactor(0.4)
                                        .lineLimit(1)
                            }
                            
                            // Divider Line
                            Rectangle()
                                .fill(Color.primary)
                                .frame(width: 2, height: 40)
                            
                            // Right Side (Identity becoming Inverse)
                            ForEach(originalCols..<totalCols, id: \.self) { c in
                                Text(step.matrix[r][c].description)
                                        .font(.system(.body, design: .monospaced))
                                        .frame(width: 60, height: 40)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.1)) // Highlight the inverse part
                                        .cornerRadius(4)
                                        .minimumScaleFactor(0.4)
                                        .lineLimit(1)
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}
