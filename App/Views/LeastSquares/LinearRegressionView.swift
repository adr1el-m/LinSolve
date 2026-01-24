import SwiftUI

struct LinearRegressionView: View {
    // Input Points
    @State private var points: [PointInput] = [
        PointInput(x: "1", y: "1"),
        PointInput(x: "2", y: "3"),
        PointInput(x: "3", y: "2"),
        PointInput(x: "4", y: "3")
    ]
    
    // Computed State
    @State private var hasComputed = false
    @State private var matrixA: [[Fraction]] = []
    @State private var vectorY: [Fraction] = []
    @State private var matrixAT: [[Fraction]] = []
    @State private var matrixATA: [[Fraction]] = []
    @State private var matrixATAInv: [[Fraction]] = []
    @State private var matrixATy: [Fraction] = []
    @State private var vectorP: [Fraction] = [] // [intercept, slope]
    @State private var residuals: [Fraction] = []
    @State private var sumSquaredResiduals: String = ""
    @State private var lineEquation: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Linear Regression")
                        .font(.largeTitle)
                        .bold()
                    Text("(Line of Best Fit)")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                
                // Detailed Intro
                Group {
                    Text("Introduction to Linear Regression")
                        .font(.headline)
                        .padding(.bottom, 2)
                    
                    Text("Linear regression is a powerful statistical method used to model the relationship between two variables by fitting a linear equation to observed data. The goal is to find the 'Line of Best Fit' that passes as close as possible to all the data points.")
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Imagine you have scattered points on a graph. Unless they are perfectly aligned, no single straight line can pass through all of them at once. Our task is to find the line that makes the total error as small as possible.")
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 4)
                        
                    Text("The Equation of a Line")
                        .font(.subheadline)
                        .bold()
                        .padding(.top, 8)
                        
                    Text("We want to find a line with the equation:")
                    Text("y = a + bx")
                        .font(.system(.title3, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                        
                    Text("Here:")
                    VStack(alignment: .leading, spacing: 4) {
                        Text("• 'a' is the y-intercept (where the line crosses the vertical axis).")
                        Text("• 'b' is the slope (how steep the line is).")
                        Text("• 'x' is the independent variable (input).")
                        Text("• 'y' is the dependent variable (output).")
                    }
                    .padding(.leading, 8)
                    
                    Text("In the language of linear algebra, we are solving for a vector p containing our two unknowns: p = [a, b]ᵀ.")
                        .padding(.top, 4)
                }
                .font(.body)
                
                Divider()
                
                // Input Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Input Data Points")
                        .font(.headline)
                    
                    ForEach(0..<points.count, id: \.self) { i in
                        HStack {
                            Text("Point \(i+1):")
                                .font(.callout)
                                .frame(width: 60, alignment: .leading)
                            Text("(")
                            TextField("x", text: $points[i].x)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .frame(width: 60)
                            Text(",")
                            TextField("y", text: $points[i].y)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .frame(width: 60)
                            Text(")")
                            
                            Spacer()
                            
                            if points.count > 2 {
                                Button(action: { removePoint(at: i) }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    Button(action: addPoint) {
                        Label("Add Point", systemImage: "plus")
                    }
                    .padding(.top, 8)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Button(action: compute) {
                    Text("Find Line of Best Fit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if hasComputed {
                    Divider()
                    
                    // Step 1: Setup System
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Step 1: Set up the System Ap = y")
                            .font(.title3)
                            .bold()
                        
                        Text("First, we organize our data into matrices. We construct a system of linear equations where each point (x, y) gives us an equation: a + bx = y.")
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Matrix A contains the coefficients for 'a' and 'b'. Since the coefficient of 'a' is always 1, the first column of A is all 1s. The second column contains the x-values.")
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack(alignment: .top, spacing: 30) {
                            VStack {
                                Text("A =")
                                MatrixPreviewView(matrix: matrixA)
                            }
                            VStack {
                                Text("p =")
                                Text("[ a ]")
                                Text("[ b ]")
                            }
                            .font(.system(.body, design: .monospaced))
                            
                            VStack {
                                Text("y =")
                                VectorPreviewView(vector: vectorY)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(10)
                    }
                    
                    // Step 2: Normal Equations
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Step 2: The Normal Equations")
                            .font(.title3)
                            .bold()
                        
                        Text("Often, there is no exact line that passes through all points, so the system Ap = y is inconsistent. To find the 'best' solution (the one that minimizes error), we multiply both sides by Aᵀ (A transpose).")
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("The Normal Equation is: AᵀAp = Aᵀy")
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 4)
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(4)
                        
                        Group {
                            Text("Compute AᵀA:")
                                .font(.headline)
                            HStack {
                                Text("AᵀA =")
                                MatrixPreviewView(matrix: matrixATA)
                            }
                            
                            Text("Compute Aᵀy:")
                                .font(.headline)
                            HStack {
                                Text("Aᵀy =")
                                VectorPreviewView(vector: matrixATy)
                            }
                            
                            Text("Compute (AᵀA)⁻¹:")
                                .font(.headline)
                            HStack {
                                Text("(AᵀA)⁻¹ =")
                                MatrixPreviewView(matrix: matrixATAInv)
                            }
                        }
                    }
                    
                    // Step 3: Solve
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Step 3: Solve for p")
                            .font(.title3)
                            .bold()
                        
                        Text("Now we can solve for p by multiplying the inverse of (AᵀA) with (Aᵀy):")
                        Text("p = (AᵀA)⁻¹ Aᵀy")
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        HStack {
                            Text("p =")
                            VectorPreviewView(vector: vectorP)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                        
                        Text("This gives us our coefficients:")
                        if vectorP.count == 2 {
                            Text("a (intercept) = \(vectorP[0].description)")
                            Text("b (slope) = \(vectorP[1].description)")
                            
                            Text("Therefore, the line of best fit has the equation:")
                                .padding(.top)
                            Text(lineEquation)
                                .font(.system(.title2, design: .serif))
                                .bold()
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    
                    // Step 4: Residuals
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Step 4: Least Squares Error Analysis")
                            .font(.title3)
                            .bold()
                        
                        Text("How good is our fit?")
                            .font(.headline)
                            
                        Text("The 'residual' is the vertical distance between the actual data point and the point on our line. Mathematically, it is the difference between the observed y and the predicted y (which is Ap).")
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("residual vector e = y - Ap")
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        HStack {
                            Text("y - Ap =")
                            VectorPreviewView(vector: residuals)
                        }
                        
                        Text("To get a single number representing the total error, we square each residual and sum them up. This is the quantity we minimized!")
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Sum of Squared Residuals (SSR):")
                            .font(.headline)
                        
                        Text("||y - Ap||² = \(sumSquaredResiduals)")
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    // Plot Representation
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Plot Representation")
                            .font(.title3)
                            .bold()
                        
                        LinearRegressionPlotView(points: points, intercept: vectorP.first?.asDouble ?? 0, slope: vectorP.last?.asDouble ?? 0)
                            .frame(height: 300)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: - Logic
    
    struct PointInput {
        var x: String
        var y: String
    }
    
    private func addPoint() {
        points.append(PointInput(x: "0", y: "0"))
    }
    
    private func removePoint(at index: Int) {
        points.remove(at: index)
    }
    
    private func compute() {
        // Parse Inputs
        let xVals = points.map { Fraction(string: $0.x) }
        let yVals = points.map { Fraction(string: $0.y) }
        
        // 1. Construct Matrix A (cols: [1, x])
        var a: [[Fraction]] = []
        for x in xVals {
            a.append([Fraction.one, x])
        }
        self.matrixA = a
        self.vectorY = yVals
        
        // 2. Normal Equations
        let at = MatrixEngine.transpose(a)
        self.matrixAT = at
        
        let ata = MatrixEngine.multiply(matrixA: at, matrixB: a)
        self.matrixATA = ata
        
        let aty = MatrixEngine.multiply(matrix: at, vector: yVals)
        self.matrixATy = aty
        
        // 3. Solve
        if let inv = MatrixEngine.inverse(ata) {
            self.matrixATAInv = inv
            self.vectorP = MatrixEngine.multiply(matrix: inv, vector: aty)
            
            // Equation String
            if vectorP.count == 2 {
                let intercept = vectorP[0]
                let slope = vectorP[1]
                let sign = slope.numerator < 0 ? "-" : "+"
                let absSlope = Fraction(abs(slope.numerator), slope.denominator)
                self.lineEquation = "y = \(intercept) \(sign) \(absSlope)x"
            }
            
            // 4. Residuals
            let ap = MatrixEngine.multiply(matrix: a, vector: vectorP)
            var res: [Fraction] = []
            for i in 0..<yVals.count {
                res.append(yVals[i] - ap[i])
            }
            self.residuals = res
            
            let sqNorm = MatrixEngine.normSquared(res)
            self.sumSquaredResiduals = sqNorm.description + " = " + String(format: "%.4f", sqNorm.asDouble)
            
        } else {
            // Handle singular case
            self.matrixATAInv = []
            self.vectorP = []
            self.lineEquation = "No unique solution (points may be collinear vertical)"
        }
        
        withAnimation {
            hasComputed = true
        }
    }
}

// MARK: - Plot View
struct LinearRegressionPlotView: View {
    let points: [LinearRegressionView.PointInput]
    let intercept: Double
    let slope: Double
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            // Determine Scale
            let xValues = points.compactMap { Double($0.x) }
            let yValues = points.compactMap { Double($0.y) }
            
            let minX = min(0, xValues.min() ?? 0)
            let maxX = (xValues.max() ?? 10) + 1
            let minY = min(0, yValues.min() ?? 0)
            let maxY = (yValues.max() ?? 10) + 1
            
            let rangeX = maxX - minX
            let rangeY = maxY - minY
            
            let scaleX = width / CGFloat(rangeX)
            let scaleY = height / CGFloat(rangeY)
            
            ZStack {
                // Grid
                Path { path in
                    // Vertical lines
                    for i in Int(minX)...Int(maxX) {
                        let x = (CGFloat(i) - CGFloat(minX)) * scaleX
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: height))
                    }
                    // Horizontal lines
                    for i in Int(minY)...Int(maxY) {
                        let y = height - (CGFloat(i) - CGFloat(minY)) * scaleY
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                }
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                
                // Axes
                Path { path in
                    // Y Axis (x=0)
                    let yAxisX = (0 - CGFloat(minX)) * scaleX
                    path.move(to: CGPoint(x: yAxisX, y: 0))
                    path.addLine(to: CGPoint(x: yAxisX, y: height))
                    
                    // X Axis (y=0)
                    let xAxisY = height - (0 - CGFloat(minY)) * scaleY
                    path.move(to: CGPoint(x: 0, y: xAxisY))
                    path.addLine(to: CGPoint(x: width, y: xAxisY))
                }
                .stroke(Color.black, lineWidth: 2)
                
                // Regression Line
                Path { path in
                    let x1 = CGFloat(minX)
                    let y1 = height - CGFloat(intercept + slope * minX - minY) * scaleY
                    
                    let x2 = CGFloat(maxX)
                    let y2 = height - CGFloat(intercept + slope * maxX - minY) * scaleY
                    
                    path.move(to: CGPoint(x: 0, y: y1)) // Simplified mapping
                    
                    // Better mapping for start/end points
                    let startX = (x1 - CGFloat(minX)) * scaleX
                    let endX = (x2 - CGFloat(minX)) * scaleX
                    
                    path.move(to: CGPoint(x: startX, y: y1))
                    path.addLine(to: CGPoint(x: endX, y: y2))
                }
                .stroke(Color.red, lineWidth: 3)
                
                // Residual Lines
                ForEach(0..<points.count, id: \.self) { i in
                    if let px = Double(points[i].x), let py = Double(points[i].y) {
                        let predictedY = intercept + slope * px
                        
                        let screenX = (CGFloat(px) - CGFloat(minX)) * scaleX
                        let screenActualY = height - (CGFloat(py) - CGFloat(minY)) * scaleY
                        let screenPredY = height - (CGFloat(predictedY) - CGFloat(minY)) * scaleY
                        
                        Path { path in
                            path.move(to: CGPoint(x: screenX, y: screenActualY))
                            path.addLine(to: CGPoint(x: screenX, y: screenPredY))
                        }
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [5]))
                    }
                }
                
                // Points
                ForEach(0..<points.count, id: \.self) { i in
                    if let px = Double(points[i].x), let py = Double(points[i].y) {
                        let x = (CGFloat(px) - CGFloat(minX)) * scaleX
                        let y = height - (CGFloat(py) - CGFloat(minY)) * scaleY
                        
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                            .position(x: x, y: y)
                    }
                }
            }
        }
    }
}
