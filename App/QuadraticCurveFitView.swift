import SwiftUI
import Charts

struct PointData: Identifiable, Equatable {
    let id = UUID()
    var x: Double
    var y: Double
}

struct QuadraticCurveFitView: View {
    @State private var points: [PointData] = [
        PointData(x: -1, y: 1),
        PointData(x: 0, y: -1),
        PointData(x: 0, y: 1),
        PointData(x: 1, y: 3),
        PointData(x: 2, y: 4)
    ]
    
    @State private var steps: [LeastSquaresStep] = []
    @State private var resultEquation: String = ""
    @State private var coefficients: [Double] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Find the best quadratic fit y = a₀ + a₁x + a₂x² to the data.")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                // Points Input
                VStack(alignment: .leading) {
                    Text("Data Points")
                        .font(.headline)
                    
                    ForEach($points) { $point in
                        HStack {
                            Text("x:")
                            TextField("x", value: $point.x, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numbersAndPunctuation)
                            Text("y:")
                            TextField("y", value: $point.y, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numbersAndPunctuation)
                            
                            Button(action: {
                                if let idx = points.firstIndex(of: point) {
                                    points.remove(at: idx)
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    Button("Add Point") {
                        points.append(PointData(x: 0, y: 0))
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
                
                Button(action: compute) {
                    Text("Compute Quadratic Fit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if !steps.isEmpty {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Solution Steps")
                            .font(.title2)
                            .bold()
                        
                        ForEach(steps) { step in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(step.title)
                                    .font(.headline)
                                Text(step.description)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                if !step.latex.isEmpty {
                                    MathText(latex: step.latex)
                                        .frame(height: step.latexHeight)
                                }
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        if !coefficients.isEmpty {
                            Text("Visualization")
                                .font(.title2)
                                .bold()
                                .padding(.top)
                            
                            Chart {
                                // Data Points
                                ForEach(points) { point in
                                    PointMark(
                                        x: .value("x", point.x),
                                        y: .value("y", point.y)
                                    )
                                    .foregroundStyle(.red)
                                    .symbolSize(50)
                                }
                                
                                // Curve
                                ForEach(curvePoints, id: \.x) { pt in
                                    LineMark(
                                        x: .value("x", pt.x),
                                        y: .value("y", pt.y)
                                    )
                                    .foregroundStyle(.blue)
                                    .interpolationMethod(.catmullRom)
                                }
                            }
                            .frame(height: 300)
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Quadratic Curve Fit")
    }
    
    var curvePoints: [PointData] {
        guard coefficients.count == 3 else { return [] }
        let a0 = coefficients[0]
        let a1 = coefficients[1]
        let a2 = coefficients[2]
        
        let xs = points.map { $0.x }
        guard let minX = xs.min(), let maxX = xs.max() else { return [] }
        
        let range = maxX - minX
        let padding = range * 0.2
        let start = minX - padding
        let end = maxX + padding
        let steps = 50
        let stepSize = (end - start) / Double(steps)
        
        var res: [PointData] = []
        for i in 0...steps {
            let x = start + Double(i) * stepSize
            let y = a0 + a1 * x + a2 * x * x
            res.append(PointData(x: x, y: y))
        }
        return res
    }
    
    func compute() {
        // A = [[1, x, x^2], ...]
        // y = [[y], ...]
        
        var matrixA: [[Fraction]] = []
        var vectorY: [[Fraction]] = []
        
        for p in points {
            let x = p.x
            let y = p.y
            
            // Row: 1, x, x^2
            // We need to convert Double to Fraction.
            // For educational purposes, let's try to keep them simple if they are integers
            matrixA.append([
                Fraction(1),
                Fraction(string: "\(x)"),
                Fraction(string: "\(x*x)")
            ])
            
            vectorY.append([Fraction(string: "\(y)")])
        }
        
        // Steps
        var computedSteps: [LeastSquaresStep] = []
        
        // 1. Show A and y
        let aLatex = matrixToLatex(matrixA)
        let yLatex = matrixToLatex(vectorY)
        
        computedSteps.append(LeastSquaresStep(
            title: "1. Setup System",
            description: "We fit y = a₀ + a₁x + a₂x² by solving Ap = y where p = [a₀, a₁, a₂]ᵀ.",
            latex: "A = \\\\begin{bmatrix} \(aLatex) \\\\end{bmatrix}, \\\\vec{y} = \\\\begin{bmatrix} \(yLatex) \\\\end{bmatrix}",
            latexHeight: 150
        ))
        
        // 2. Normal Equation
        // A^T A p = A^T y
        let aT = MatrixEngine.transpose(matrixA)
        let aTa = MatrixEngine.multiply(matrixA: aT, matrixB: matrixA)
        let aTy = MatrixEngine.multiply(matrixA: aT, matrixB: vectorY)
        

        let aTaLatex = matrixToLatex(aTa)
        let aTyLatex = matrixToLatex(aTy)
        
        computedSteps.append(LeastSquaresStep(
            title: "2. Normal Equation",
            description: "Compute AᵀA and Aᵀy for the normal equation AᵀAp = Aᵀy.",
            latex: "\\\\begin{aligned} A^T A &= \\\\begin{bmatrix} \(aTaLatex) \\\\end{bmatrix} \\\\\\\\ A^T \\\\vec{y} &= \\\\begin{bmatrix} \(aTyLatex) \\\\end{bmatrix} \\\\end{aligned}",
            latexHeight: 160
        ))
        
        // 3. Solve
        if let invAtA = MatrixEngine.inverse(aTa) {
            let p = MatrixEngine.multiply(matrixA: invAtA, matrixB: aTy)
            let pLatex = matrixToLatex(p)
            
            let a0 = p[0][0].asDouble
            let a1 = p[1][0].asDouble
            let a2 = p[2][0].asDouble
            
            self.coefficients = [a0, a1, a2]
            
            computedSteps.append(LeastSquaresStep(
                title: "3. Solve for p",
                description: "p = (AᵀA)⁻¹ Aᵀy",
                latex: "\\\\vec{p} = \\\\begin{bmatrix} \(pLatex) \\\\end{bmatrix} = \\\\begin{bmatrix} \(String(format: "%.4f", a0)) \\\\\\\\ \(String(format: "%.4f", a1)) \\\\\\\\ \(String(format: "%.4f", a2)) \\\\end{bmatrix}",
                latexHeight: 100
            ))
            
            let eq = "y = \(String(format: "%.4f", a0)) + \(String(format: "%.4f", a1))x + \(String(format: "%.4f", a2))x^2"
            self.resultEquation = eq
            
            computedSteps.append(LeastSquaresStep(
                title: "4. Result",
                description: "The quadratic function that fits the data is:",
                latex: eq,
                latexHeight: 40
            ))
            
        } else {
            computedSteps.append(LeastSquaresStep(
                title: "Error",
                description: "AᵀA is not invertible. No unique solution.",
                latex: "",
                latexHeight: 20
            ))
        }
        
        self.steps = computedSteps
    }
    
    func matrixToLatex(_ m: [[Fraction]]) -> String {
        var rows: [String] = []
        for row in m {
            let rowStr = row.map { $0.description }.joined(separator: " & ")
            rows.append(rowStr)
        }
        return rows.joined(separator: " \\\\ ")
    }
}

struct LeastSquaresStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let latex: String
    let latexHeight: CGFloat
}
