import SwiftUI

struct EigenvectorsView: View {
    @EnvironmentObject var matrixData: MatrixData
    @State private var roots: [Double] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Eigenvectors")
                        .font(.largeTitle)
                        .bold()
                    Text("Basis for Eigenspaces")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                if matrixData.rows != matrixData.cols {
                     Text("Eigenvectors are only defined for square matrices.")
                         .foregroundColor(.secondary)
                         .padding()
                } else if roots.isEmpty {
                    Text("No real eigenvalues to analyze.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(roots, id: \.self) { root in
                        EigenvectorCard(root: root, matrix: matrixData.getFractionMatrix())
                    }
                }
            }
            .padding()
            .padding(.bottom, 50)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            let res = MatrixEngine.getCharacteristicPolynomial(matrix: matrixData.getFractionMatrix())
            roots = res.roots
        }
    }
}

struct EigenvectorCard: View {
    let root: Double
    let matrix: [[Fraction]]
    @State private var steps: [MatrixStep] = []
    @State private var basis: [String] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("For x = \(formatRoot(root))")
                .font(.title2)
                .bold()
                .foregroundColor(.blue)
            
            Divider()
            
            Text("1. Form the matrix (xI - A)")
                .font(.headline)
            
            if let first = steps.first {
                SimpleMatrixView(matrix: first.matrix)
                    .padding(.vertical, 8)
            }
            
            Text("2. Reduce to RREF")
                .font(.headline)
                .padding(.top, 8)
            
            if steps.isEmpty {
                Text("No steps available")
                    .foregroundColor(.secondary)
            } else {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(step.operation)
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.blue)
                            Spacer()
                            if step.isFinal {
                                Text("RREF")
                                    .font(.caption)
                                    .padding(4)
                                    .background(Color.green.opacity(0.1))
                                    .foregroundColor(.green)
                                    .cornerRadius(4)
                            }
                        }
                        
                        Text(MatrixEngine.formatLatex(step.description))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        SimpleMatrixView(matrix: step.matrix)
                    }
                    .padding(.vertical, 8)
                    
                    if index < steps.count - 1 {
                        Divider()
                            .padding(.vertical, 4)
                    }
                }
            }
            
            Text("3. Extract Basis for Null Space")
                .font(.headline)
                .padding(.top, 8)
            
            if basis.isEmpty {
                Text("{ 0 }")
                    .font(.system(.body, design: .monospaced))
                    .padding()
            } else {
                HStack(alignment: .center, spacing: 16) {
                    Text("Basis = span")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 12) {
                        ForEach(basis, id: \.self) { vecLatex in
                             // Clean up latex for display
                             let clean = vecLatex
                                 .replacingOccurrences(of: "\\begin{bmatrix}", with: "")
                                 .replacingOccurrences(of: "\\end{bmatrix}", with: "")
                                 .replacingOccurrences(of: " ", with: "")
                             
                             let rows = clean.components(separatedBy: "\\\\")
                             
                             VStack(spacing: 4) {
                                 ForEach(rows, id: \.self) { rowVal in
                                     Text(rowVal)
                                         .font(.system(.body, design: .monospaced))
                                         .padding(.vertical, 2)
                                 }
                             }
                             .padding(8)
                             .background(Color(uiColor: .tertiarySystemBackground))
                             .cornerRadius(8)
                             .overlay(
                                 RoundedRectangle(cornerRadius: 8)
                                     .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                             )
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .onAppear {
            let res = MatrixEngine.calculateEigenBasis(matrix: matrix, eigenvalue: root)
            steps = res.steps
            basis = res.basis
        }
    }
    
    func formatRoot(_ val: Double) -> String {
        if abs(val - round(val)) < 1e-9 {
            return "\(Int(round(val)))"
        }
        return String(format: "%.2f", val)
    }
}

struct SimpleMatrixView: View {
    let matrix: [[Fraction]]
    
    var body: some View {
        HStack(spacing: 0) {
            // Left Bracket
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 2)
                .padding(.vertical, 4)
            
            VStack(spacing: 8) {
                ForEach(0..<matrix.count, id: \.self) { r in
                    HStack(spacing: 16) {
                        ForEach(0..<matrix[r].count, id: \.self) { c in
                            Text(matrix[r][c].description)
                                .font(.system(.body, design: .monospaced))
                                .frame(width: 40, alignment: .center)
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            
            // Right Bracket
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 2)
                .padding(.vertical, 4)
        }
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(12)
    }
}
