import SwiftUI

struct DiagonalizationView: View {
    @EnvironmentObject var matrixData: MatrixData
    @State private var result: MatrixEngine.DiagonalizationResult?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Diagonalization")
                        .font(.largeTitle)
                        .bold()
                    Text("P⁻¹AP = D")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                if matrixData.rows != matrixData.cols {
                     Text("Diagonalization is only defined for square matrices.")
                         .foregroundColor(.secondary)
                         .padding()
                } else if let res = result {
                    ForEach(res.steps) { step in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(step.title)
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Text(MatrixEngine.formatLatex(step.description))
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            if let latex = step.latex {
                                Text(MatrixEngine.formatLatex(latex))
                                    .font(.system(.body, design: .serif))
                                    .padding(8)
                                    .background(Color(uiColor: .tertiarySystemBackground))
                                    .cornerRadius(8)
                            }
                            
                            if let matrix = step.matrix {
                                SimpleMatrixView(matrix: matrix)
                            }
                            
                            Divider()
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(12)
                    }
                } else {
                    ProgressView()
                }
            }
            .padding()
            .padding(.bottom, 50)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            calculate()
        }
        .onChange(of: matrixData.values) { _ in
            calculate()
        }
    }
    
    func calculate() {
        let matrix = matrixData.getFractionMatrix()
        result = MatrixEngine.calculateDiagonalization(matrix: matrix)
    }
}
