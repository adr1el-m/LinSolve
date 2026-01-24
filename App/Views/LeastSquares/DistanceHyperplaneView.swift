import SwiftUI

struct DistanceHyperplaneView: View {
    @State private var dimension: Int = 3
    @State private var coefficients: [String] = ["1", "-2", "2"]
    @State private var point: [String] = ["2", "5", "1"]
    
    // Display States
    @State private var displayA: [Fraction] = []
    @State private var displayB: [Fraction] = []
    @State private var dotTerms: [String] = []
    @State private var normTerms: [String] = []
    @State private var dotSum: Fraction?
    @State private var normSq: Fraction?
    @State private var finalResult: String = ""
    @State private var showSteps: Bool = false
    
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
                
                if showSteps {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Solution Steps")
                            .font(.title2)
                            .bold()
                        
                        // 1. Identify Vectors
                        VStack(alignment: .leading, spacing: 8) {
                            Text("1. Identify Vectors")
                                .font(.headline)
                            Text("From the hyperplane equation and point:")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 20) {
                                HStack {
                                    Text("a =")
                                    VectorPreviewView(vector: displayA)
                                }
                                HStack {
                                    Text("b =")
                                    VectorPreviewView(vector: displayB)
                                }
                            }
                            .padding(.top, 4)
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(8)
                        
                        // 2. Formula
                        VStack(alignment: .leading, spacing: 8) {
                            Text("2. Formula")
                                .font(.headline)
                            Text("The distance d is given by the projection formula:")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            HStack(alignment: .center, spacing: 4) {
                                Text("d = ")
                                VStack(spacing: 0) {
                                    Text("|a · b|")
                                    Rectangle().frame(height: 1)
                                    Text("||a||")
                                }
                                .fixedSize()
                                Text(" = ")
                                VStack(spacing: 0) {
                                    Text("|a₁b₁ + ... + aₙbₙ|")
                                    Rectangle().frame(height: 1)
                                    Text("√(a₁² + ... + aₙ²)")
                                }
                                .fixedSize()
                            }
                            .font(.system(.body, design: .serif))
                            .padding(.vertical, 8)
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(8)
                        
                        // 3. Substitute Values
                        VStack(alignment: .leading, spacing: 8) {
                            Text("3. Substitute Values")
                                .font(.headline)
                            Text("Plug the coefficients and coordinates into the formula.")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            HStack(alignment: .center, spacing: 4) {
                                Text("d = ")
                                VStack(spacing: 0) {
                                    Text("|" + dotTerms.joined(separator: " + ") + "|")
                                    Rectangle().frame(height: 1)
                                    Text("√(" + normTerms.joined(separator: " + ") + ")")
                                }
                                .fixedSize()
                            }
                            .font(.system(.caption, design: .serif)) // Smaller font for long expressions
                            .padding(.vertical, 8)
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(8)
                        
                        // 4. Simplify
                        if let dSum = dotSum, let nSq = normSq {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("4. Simplify")
                                    .font(.headline)
                                Text("Calculate the numerator and denominator.")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                HStack(alignment: .center, spacing: 4) {
                                    Text("d = ")
                                    VStack(spacing: 0) {
                                        Text("|\(dSum.description)|")
                                        Rectangle().frame(height: 1)
                                        Text("√\(nSq.description)")
                                    }
                                    .fixedSize()
                                }
                                .font(.system(.body, design: .serif))
                                .padding(.vertical, 8)
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        // 5. Final Result
                        VStack(alignment: .leading, spacing: 8) {
                            Text("5. Final Answer")
                                .font(.headline)
                            
                            Text("d = \(finalResult)")
                                .font(.title3)
                                .bold()
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(8)
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
        
        // Update display states
        self.displayA = aVec
        self.displayB = bVec
        
        // 3. Plug in values
        // Dot Product
        var dTerms: [String] = []
        var dSum = Fraction.zero
        for i in 0..<dimension {
            dTerms.append("(\(aVec[i]))(\(bVec[i]))")
            dSum = dSum + (aVec[i] * bVec[i])
        }
        self.dotTerms = dTerms
        self.dotSum = dSum.numerator < 0 ? Fraction(-dSum.numerator, dSum.denominator) : dSum // Store absolute value effectively for display logic if needed, but logic below handles it
        
        // Norm Squared
        var nTerms: [String] = []
        var nSq = Fraction.zero
        for i in 0..<dimension {
            nTerms.append("(\(aVec[i]))^2")
            nSq = nSq + (aVec[i] * aVec[i])
        }
        self.normTerms = nTerms
        self.normSq = nSq
        
        // Final Result
        let dotVal = abs(dSum.asDouble)
        let normVal = sqrt(nSq.asDouble)
        
        if normVal == 0 {
            self.finalResult = "Undefined (zero normal vector)"
        } else {
            let result = dotVal / normVal
            if abs(result - round(result)) < 1e-9 {
                self.finalResult = "\(Int(round(result)))"
            } else {
                self.finalResult = String(format: "%.4f", result)
            }
        }
        
        // Show steps
        self.showSteps = true
    }
}
