import SwiftUI

struct OrthogonalityView: View {
    @EnvironmentObject var matrixData: MatrixData
    @State private var steps: [MatrixEngine.VectorStep] = []
    @State private var selectedCol1: Int = 0
    @State private var selectedCol2: Int = 1
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Inner Product & Orthogonality")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                    Text("Analysis of Selected Columns")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                if matrixData.cols < 1 {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        Text("Please enter a matrix with at least 1 column.")
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                } else {
                    // Column Selection
                    HStack(spacing: 20) {
                        VStack {
                            Text("Vector u")
                                .font(.caption)
                                .bold()
                            Picker("Column 1", selection: $selectedCol1) {
                                ForEach(0..<matrixData.cols, id: \.self) { i in
                                    Text("Col \(i + 1)").tag(i)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(8)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        Text("·")
                            .font(.largeTitle)
                            .padding(.top, 10)
                        
                        VStack {
                            Text("Vector v")
                                .font(.caption)
                                .bold()
                            Picker("Column 2", selection: $selectedCol2) {
                                ForEach(0..<matrixData.cols, id: \.self) { i in
                                    Text("Col \(i + 1)").tag(i)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(8)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                        }
                    }
                    
                    // Vector Display
                    HStack(spacing: 40) {
                        VStack {
                            Text("u")
                                .font(.headline)
                                .italic()
                            let u = getColumn(selectedCol1)
                            VectorColumnView(vector: u, color: .blue)
                        }
                        
                        VStack {
                            Text("v")
                                .font(.headline)
                                .italic()
                            let v = getColumn(selectedCol2)
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
        .onChange(of: matrixData.values) { _ in calculate() }
        .onChange(of: matrixData.cols) { _ in calculate() }
        .onChange(of: selectedCol1) { _ in calculate() }
        .onChange(of: selectedCol2) { _ in calculate() }
    }
    
    func getColumn(_ colIndex: Int) -> [Fraction] {
        let matrix = matrixData.getFractionMatrix()
        guard !matrix.isEmpty, colIndex < matrix[0].count else { return [] }
        var col: [Fraction] = []
        for r in 0..<matrix.count {
            col.append(matrix[r][colIndex])
        }
        return col
    }
    
    func calculate() {
        let matrix = matrixData.getFractionMatrix()
        if matrix.isEmpty || matrix[0].isEmpty {
            steps = []
            return
        }
        
        // Ensure indices are valid
        if selectedCol1 >= matrixData.cols { selectedCol1 = 0 }
        if selectedCol2 >= matrixData.cols { selectedCol2 = 0 }
        
        let u = getColumn(selectedCol1)
        let v = getColumn(selectedCol2)
        
        steps = MatrixEngine.analyzeOrthogonality(u: u, v: v)
        
        // Add Orthogonal Set Check for the whole matrix
        let setSteps = MatrixEngine.checkOrthogonalSet(matrix: matrix)
        if !setSteps.isEmpty {
            steps.append(contentsOf: setSteps)
        }
    }
}
