import SwiftUI

struct OrthogonalityView: View {
    @EnvironmentObject var matrixData: MatrixData
    @State private var steps: [MatrixEngine.VectorStep] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Inner Product & Orthogonality")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                    Text("Analysis of Column 1 (u) and Column 2 (v)")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                if matrixData.cols < 2 {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        Text("Please enter a matrix with at least 2 columns to define vectors u and v.")
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                } else {
                    // Vector Display
                    HStack(spacing: 40) {
                        VStack {
                            Text("u")
                                .font(.headline)
                                .italic()
                            let u = getColumn(0)
                            VectorColumnView(vector: u, color: .blue)
                        }
                        
                        VStack {
                            Text("v")
                                .font(.headline)
                                .italic()
                            let v = getColumn(1)
                            VectorColumnView(vector: v, color: .green)
                        }
                    }
                    .padding()
                    
                    // Steps
                    ForEach(steps) { step in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(step.title)
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Text(step.description)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            if !step.latex.isEmpty {
                                Text(MatrixEngine.formatLatex(step.latex))
                                    .font(.system(.body, design: .serif))
                                    .padding(8)
                                    .background(Color(uiColor: .tertiarySystemBackground))
                                    .cornerRadius(8)
                            }
                            
                            Divider()
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(12)
                    }
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
    
    func getColumn(_ colIndex: Int) -> [Fraction] {
        let matrix = matrixData.getFractionMatrix()
        guard colIndex < matrix[0].count else { return [] }
        var col: [Fraction] = []
        for r in 0..<matrix.count {
            col.append(matrix[r][colIndex])
        }
        return col
    }
    
    func calculate() {
        let matrix = matrixData.getFractionMatrix()
        if matrix.isEmpty || matrix[0].count < 2 {
            steps = []
            return
        }
        
        let u = getColumn(0)
        let v = getColumn(1)
        
        steps = MatrixEngine.analyzeOrthogonality(u: u, v: v)
        
        // Add Orthogonal Set Check for the whole matrix
        let setSteps = MatrixEngine.checkOrthogonalSet(matrix: matrix)
        if !setSteps.isEmpty {
            // Add a visual separator step if needed, or just append
            steps.append(contentsOf: setSteps)
        }
    }
}
