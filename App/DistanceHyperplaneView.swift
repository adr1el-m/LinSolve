import SwiftUI

struct DistanceHyperplaneView: View {
    @State private var dimension: Int = 3
    @State private var coefficients: [String] = ["1", "-2", "2"]
    @State private var point: [String] = ["2", "5", "1"]
    
    @State private var steps: [LeastSquaresStep] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Calculate the distance from a point to a hyperplane passing through the origin (a·x = 0).")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                // Dimension Stepper
                HStack {
                    Text("Dimension: \(dimension)")
                    Stepper("", value: $dimension, in: 2...5)
                        .onChange(of: dimension) { newValue in
                            updateArrays(count: newValue)
                        }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
                
                // Inputs
                HStack(alignment: .top, spacing: 20) {
                    // Coefficients (Normal Vector a)
                    VStack(alignment: .leading) {
                        Text("Hyperplane Coefficients (a)")
                            .font(.headline)
                        Text("Equation: " + equationString)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        ForEach(0..<dimension, id: \.self) { i in
                            HStack {
                                Text("a\(subscriptStr(i+1)):")
                                TextField("0", text: $coefficients[i])
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.numbersAndPunctuation)
                            }
                        }
                    }
                    
                    // Point b
                    VStack(alignment: .leading) {
                        Text("Point (b)")
                            .font(.headline)
                        Text("Coordinates")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .hidden() // Spacer
                        
                        ForEach(0..<dimension, id: \.self) { i in
                            HStack {
                                Text("b\(subscriptStr(i+1)):")
                                TextField("0", text: $point[i])
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.numbersAndPunctuation)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
                
                Button(action: compute) {
                    Text("Calculate Distance")
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
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Distance to Hyperplane")
        .onAppear {
            if coefficients.count != dimension { updateArrays(count: dimension) }
        }
    }
    
    var equationString: String {
        var parts: [String] = []
        let vars = ["x", "y", "z", "w", "v"]
        for i in 0..<dimension {
            let val = coefficients[i]
            let v = (i < vars.count) ? vars[i] : "x_\(i+1)"
            
            // Try to format nicely
            if i == 0 {
                parts.append("\(val)\(v)")
            } else {
                if val.hasPrefix("-") {
                    parts.append("\(val)\(v)")
                } else {
                    parts.append("+\(val)\(v)")
                }
            }
        }
        return parts.joined(separator: " ") + " = 0"
    }
    
    func subscriptStr(_ i: Int) -> String {
        let map = ["0":"₀", "1":"₁", "2":"₂", "3":"₃", "4":"₄", "5":"₅", "6":"₆", "7":"₇", "8":"₈", "9":"₉"]
        return "\(i)".compactMap { map[String($0)] }.joined()
    }
    
    func updateArrays(count: Int) {
        if count > coefficients.count {
            coefficients.append(contentsOf: Array(repeating: "0", count: count - coefficients.count))
            point.append(contentsOf: Array(repeating: "0", count: count - point.count))
        } else {
            coefficients = Array(coefficients.prefix(count))
            point = Array(point.prefix(count))
        }
    }
    
    func compute() {
        // Convert inputs to Fraction
        let aVec = coefficients.map { Fraction(string: $0) }
        let bVec = point.map { Fraction(string: $0) }
        
        var computedSteps: [LeastSquaresStep] = []
        
        // 1. Identify Vectors
        let aLatex = "\\begin{bmatrix} " + aVec.map { $0.description }.joined(separator: " \\\\ ") + " \\end{bmatrix}"
        let bLatex = "\\begin{bmatrix} " + bVec.map { $0.description }.joined(separator: " \\\\ ") + " \\end{bmatrix}"
        
        computedSteps.append(LeastSquaresStep(
            title: "1. Identify Vectors",
            description: "From the hyperplane equation and point:",
            latex: "\\vec{a} = \(aLatex), \\quad \\vec{b} = \(bLatex)",
            latexHeight: 100
        ))
        
        // 2. Formula
        computedSteps.append(LeastSquaresStep(
            title: "2. Formula",
            description: "The distance d is given by the projection formula:",
            latex: "d = \\frac{|\\vec{a} \\cdot \\vec{b}|}{||\\vec{a}||} = \\frac{|a_1 b_1 + \\dots + a_n b_n|}{\\sqrt{a_1^2 + \\dots + a_n^2}}",
            latexHeight: 60
        ))
        
        // 3. Plug in values
        // Dot Product
        var dotTerms: [String] = []
        var dotSum = Fraction.zero
        for i in 0..<dimension {
            dotTerms.append("(\(aVec[i]))(\(bVec[i]))")
            dotSum = dotSum + (aVec[i] * bVec[i])
        }
        let dotStr = dotTerms.joined(separator: " + ")
        
        // Norm Squared
        var normTerms: [String] = []
        var normSq = Fraction.zero
        for i in 0..<dimension {
            normTerms.append("(\(aVec[i]))^2")
            normSq = normSq + (aVec[i] * aVec[i])
        }
        let normStr = normTerms.joined(separator: " + ")
        
        computedSteps.append(LeastSquaresStep(
            title: "3. Substitute Values",
            description: "Plug the coefficients and coordinates into the formula.",
            latex: "d = \\frac{|\(dotStr)|}{\\sqrt{\(normStr)}}",
            latexHeight: 60
        ))
        
        // 4. Simplify
        let dotVal = abs(dotSum.asDouble) // Absolute value
        let normVal = sqrt(normSq.asDouble)
        
        let dotFraction = dotSum.numerator < 0 ? Fraction(-dotSum.numerator, dotSum.denominator) : dotSum
        
        let result = dotVal / normVal
        
        // Try to keep it exact if possible (e.g. sqrt(30))
        // The image shows d = 6/3 = 2.
        
        let normDisplay: String
        if abs(normVal - round(normVal)) < 1e-9 {
            normDisplay = "\(Int(round(normVal)))"
        } else {
            if normSq.denominator == 1 {
                normDisplay = "\\\\sqrt{\(normSq.numerator)}"
            } else {
                normDisplay = "\\\\sqrt{\(normSq)}"
            }
        }
        
        computedSteps.append(LeastSquaresStep(
            title: "4. Simplify",
            description: "Calculate the numerator and denominator.",
            latex: "d = \\\\frac{\(dotFraction)}{\(normDisplay)}",
            latexHeight: 50
        ))
        
        // 5. Final Result
        var finalStr = ""
        if abs(result - round(result)) < 1e-9 {
            finalStr = "\(Int(round(result)))"
        } else {
            finalStr = String(format: "%.4f", result)
        }
        
        computedSteps.append(LeastSquaresStep(
            title: "5. Final Answer",
            description: "",
            latex: "d = \(finalStr)",
            latexHeight: 40
        ))
        
        self.steps = computedSteps
    }
}
