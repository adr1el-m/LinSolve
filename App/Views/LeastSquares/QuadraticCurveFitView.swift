import SwiftUI
import Charts

struct PointData: Identifiable, Equatable {
    let id = UUID()
    var x: Double
    var y: Double
}

// Quadratic Curve Fit View
// Verified Clean Build
struct QuadraticCurveFitView: View {
    @State private var points: [PointData] = [
        PointData(x: -1, y: 1),
        PointData(x: 0, y: -1),
        PointData(x: 0, y: 1),
        PointData(x: 1, y: 3),
        PointData(x: 2, y: 4)
    ]
    
    @State private var resultEquation: String = ""
    @State private var coefficients: [Double] = []
    
    // Computation Results for Display
    @State private var displayMatrixA: [[Fraction]] = []
    @State private var displayVectorY: [[Fraction]] = []
    @State private var displayATA: [[Fraction]] = []
    @State private var displayATy: [[Fraction]] = []
    @State private var displayP: [[Fraction]] = []
    @State private var showSteps: Bool = false
    
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
                
                if showSteps {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Solution Steps")
                            .font(.title2)
                            .bold()
                        
                        // Step 1: Setup
                        VStack(alignment: .leading, spacing: 8) {
                            Text("1. Setup System")
                                .font(.headline)
                            Text("We fit y = a₀ + a₁x + a₂x² by solving Ap = y where p = [a₀, a₁, a₂]ᵀ.")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            HStack(alignment: .top, spacing: 20) {
                                VStack {
                                    Text("A =")
                                    MatrixPreviewView(matrix: displayMatrixA)
                                }
                                VStack {
                                    Text("y =")
                                    MatrixPreviewView(matrix: displayVectorY)
                                }
                            }
                            .padding(.top, 4)
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(8)
                        
                        // Step 2: Normal Equation
                        VStack(alignment: .leading, spacing: 8) {
                            Text("2. Normal Equation")
                                .font(.headline)
                            Text("Compute AᵀA and Aᵀy for the normal equation AᵀAp = Aᵀy.")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Text("AᵀA =")
                                    MatrixPreviewView(matrix: displayATA)
                                }
                                HStack {
                                    Text("Aᵀy =")
                                    MatrixPreviewView(matrix: displayATy)
                                }
                            }
                            .padding(.top, 4)
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(8)
                        
                        // Step 3: Solve
                        VStack(alignment: .leading, spacing: 8) {
                            Text("3. Solve for p")
                                .font(.headline)
                            Text("p = (AᵀA)⁻¹ Aᵀy")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Text("p =")
                                MatrixPreviewView(matrix: displayP)
                            }
                            .padding(.top, 4)
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(8)
                        
                        // Step 4: Result
                        VStack(alignment: .leading, spacing: 8) {
                            Text("4. Result")
                                .font(.headline)
                            Text("The quadratic function that fits the data is:")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            Text(resultEquation)
                                .font(.system(.title3, design: .serif))
                                .bold()
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(8)
                        
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
            matrixA.append([
                Fraction(1),
                Fraction(string: "\(x)"),
                Fraction(string: "\(x*x)")
            ])
            
            vectorY.append([Fraction(string: "\(y)")])
        }
        
        self.displayMatrixA = matrixA
        self.displayVectorY = vectorY
        
        // 2. Normal Equation
        // A^T A p = A^T y
        let aT = MatrixEngine.transpose(matrixA)
        let aTa = MatrixEngine.multiply(matrixA: aT, matrixB: matrixA)
        let aTy = MatrixEngine.multiply(matrixA: aT, matrixB: vectorY)
        
        self.displayATA = aTa
        self.displayATy = aTy
        
        // 3. Solve
        if let invAtA = MatrixEngine.inverse(aTa) {
            let p = MatrixEngine.multiply(matrixA: invAtA, matrixB: aTy)
            self.displayP = p
            
            let a0 = p[0][0].asDouble
            let a1 = p[1][0].asDouble
            let a2 = p[2][0].asDouble
            
            self.coefficients = [a0, a1, a2]
            
            let eq = "y = \(String(format: "%.4f", a0)) + \(String(format: "%.4f", a1))x + \(String(format: "%.4f", a2))x²"
            self.resultEquation = eq
            self.showSteps = true
            
        } else {
            self.resultEquation = "Error: AᵀA is singular."
            self.coefficients = []
            self.showSteps = true
        }
    }
}
