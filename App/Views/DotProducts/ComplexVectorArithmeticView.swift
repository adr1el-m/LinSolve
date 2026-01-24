import SwiftUI

struct ComplexVectorArithmeticView: View {
    // Default vectors from the example (4D vectors)
    @State private var uVec: [String] = ["-2", "-1", "4", "5"]
    @State private var vVec: [String] = ["3", "1", "-5", "7"]
    @State private var wVec: [String] = ["-6", "2", "1", "1"]
    
    @State private var showSteps: Bool = false
    @State private var selectedOperation: OperationType = .operationA
    
    // Computed results
    @State private var stepResults: [ComputationStep] = []
    @State private var finalResult: String = ""
    
    enum OperationType: String, CaseIterable {
        case operationA = "||u + (u·v)w||"
        case operationB = "||u||²v + (v·w)w"
        
        var description: String {
            switch self {
            case .operationA:
                return "Compute the norm of u plus a scalar multiple of w, where the scalar is the dot product of u and v."
            case .operationB:
                return "Compute a linear combination: the norm-squared of u times v, plus the dot product of v and w times w."
            }
        }
    }
    
    struct ComputationStep: Identifiable {
        let id = UUID()
        let title: String
        let explanation: String
        let calculation: String
        let result: String
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Complex Vector Arithmetic")
                        .font(.largeTitle)
                        .bold()
                    Text("Combining Norms, Dot Products & Scalar Multiplication")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
In real applications, we often need to **combine multiple vector operations** in a single expression. This module demonstrates how to break down complex expressions into manageable steps.

**Key operations involved:**
• **Dot Product (u·v)**: Multiplies corresponding components and sums them → produces a scalar
• **Norm (||u||)**: The "length" of a vector → √(u₁² + u₂² + ... + uₙ²)
• **Scalar Multiplication**: Multiplying a vector by a number
• **Vector Addition**: Adding vectors component-by-component
""")
                        .font(.body)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Vector Inputs
                VStack(alignment: .leading, spacing: 15) {
                    Text("Define Vectors (ℝ⁴)")
                        .font(.headline)
                    
                    HStack(alignment: .top, spacing: 20) {
                        VectorInputWithLabel(label: "u", vector: $uVec, color: .blue)
                        VectorInputWithLabel(label: "v", vector: $vVec, color: .green)
                        VectorInputWithLabel(label: "w", vector: $wVec, color: .orange)
                    }
                    
                    // Operation Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Operation")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Picker("Operation", selection: $selectedOperation) {
                            ForEach(OperationType.allCases, id: \.self) { op in
                                Text(op.rawValue).tag(op)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Text(selectedOperation.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                    }
                    
                    Button(action: compute) {
                        Text("Calculate Step-by-Step")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                // Solution Steps
                if showSteps {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Step-by-Step Solution")
                            .font(.title2)
                            .bold()
                        
                        Text("Expression: **\(selectedOperation.rawValue)**")
                            .font(.headline)
                            .padding()
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(8)
                        
                        ForEach(Array(stepResults.enumerated()), id: \.element.id) { index, step in
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Step \(index + 1): \(step.title)")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                Text(step.explanation)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                if !step.calculation.isEmpty {
                                    Text(step.calculation)
                                        .font(.system(.body, design: .monospaced))
                                        .padding(8)
                                        .background(Color.yellow.opacity(0.1))
                                        .cornerRadius(6)
                                }
                                
                                HStack {
                                    Text("Result:")
                                        .bold()
                                    Text(step.result)
                                        .font(.system(.body, design: .monospaced))
                                }
                                .padding(8)
                                .background(Color(uiColor: .tertiarySystemBackground))
                                .cornerRadius(6)
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(12)
                        }
                        
                        // Final Result
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Final Answer")
                                .font(.headline)
                            
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title)
                                
                                Text("\(selectedOperation.rawValue) = \(finalResult)")
                                    .font(.title3)
                                    .bold()
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .transition(.opacity)
                }
                
                Spacer()
            }
        }
        .onChange(of: selectedOperation) { _ in
            showSteps = false
        }
    }
    
    func compute() {
        let u = uVec.map { Fraction(string: $0) }
        let v = vVec.map { Fraction(string: $0) }
        let w = wVec.map { Fraction(string: $0) }
        
        stepResults = []
        
        switch selectedOperation {
        case .operationA:
            computeOperationA(u: u, v: v, w: w)
        case .operationB:
            computeOperationB(u: u, v: v, w: w)
        }
        
        withAnimation {
            showSteps = true
        }
    }
    
    // ||u + (u·v)w||
    func computeOperationA(u: [Fraction], v: [Fraction], w: [Fraction]) {
        // Step 1: Compute u·v
        let uvDot = dotProduct(u, v)
        let uvCalc = zip(u, v).map { "(\($0.description))(\($1.description))" }.joined(separator: " + ")
        stepResults.append(ComputationStep(
            title: "Compute Dot Product u·v",
            explanation: "Multiply corresponding components and add them together.",
            calculation: "u·v = \(uvCalc)",
            result: "u·v = \(uvDot.description)"
        ))
        
        // Step 2: Compute (u·v)w - scalar multiplication
        let scaledW = w.map { $0 * uvDot }
        let scaledWCalc = "(\(uvDot.description)) × w"
        stepResults.append(ComputationStep(
            title: "Scalar Multiply: (u·v)w",
            explanation: "Multiply each component of w by the scalar \(uvDot.description).",
            calculation: scaledWCalc,
            result: "(u·v)w = [\(scaledW.map { $0.description }.joined(separator: ", "))]ᵀ"
        ))
        
        // Step 3: Compute u + (u·v)w
        let sum = zip(u, scaledW).map { $0 + $1 }
        stepResults.append(ComputationStep(
            title: "Vector Addition: u + (u·v)w",
            explanation: "Add vectors component-by-component.",
            calculation: "[\(u.map { $0.description }.joined(separator: ", "))]ᵀ + [\(scaledW.map { $0.description }.joined(separator: ", "))]ᵀ",
            result: "u + (u·v)w = [\(sum.map { $0.description }.joined(separator: ", "))]ᵀ"
        ))
        
        // Step 4: Compute the norm
        let normSquared = sum.reduce(Fraction(0)) { $0 + ($1 * $1) }
        let normCalc = sum.map { "(\($0.description))²" }.joined(separator: " + ")
        let normValue = sqrt(normSquared.asDouble)
        
        stepResults.append(ComputationStep(
            title: "Compute Norm ||u + (u·v)w||",
            explanation: "The norm is the square root of the sum of squared components.",
            calculation: "||...|| = √(\(normCalc)) = √(\(normSquared.description))",
            result: "||u + (u·v)w|| = √\(normSquared.description) ≈ \(String(format: "%.4f", normValue))"
        ))
        
        finalResult = "√\(normSquared.description) ≈ \(String(format: "%.4f", normValue))"
    }
    
    // ||u||²v + (v·w)w
    func computeOperationB(u: [Fraction], v: [Fraction], w: [Fraction]) {
        // Step 1: Compute ||u||²
        let normUSquared = u.reduce(Fraction(0)) { $0 + ($1 * $1) }
        let normCalc = u.map { "(\($0.description))²" }.joined(separator: " + ")
        stepResults.append(ComputationStep(
            title: "Compute ||u||² (Norm Squared)",
            explanation: "The norm squared is the sum of squared components (no square root yet).",
            calculation: "||u||² = \(normCalc)",
            result: "||u||² = \(normUSquared.description)"
        ))
        
        // Step 2: Compute ||u||²v
        let scaledV = v.map { $0 * normUSquared }
        stepResults.append(ComputationStep(
            title: "Scalar Multiply: ||u||²v",
            explanation: "Multiply each component of v by \(normUSquared.description).",
            calculation: "\(normUSquared.description) × v",
            result: "||u||²v = [\(scaledV.map { $0.description }.joined(separator: ", "))]ᵀ"
        ))
        
        // Step 3: Compute v·w
        let vwDot = dotProduct(v, w)
        let vwCalc = zip(v, w).map { "(\($0.description))(\($1.description))" }.joined(separator: " + ")
        stepResults.append(ComputationStep(
            title: "Compute Dot Product v·w",
            explanation: "Multiply corresponding components and add them.",
            calculation: "v·w = \(vwCalc)",
            result: "v·w = \(vwDot.description)"
        ))
        
        // Step 4: Compute (v·w)w
        let scaledW = w.map { $0 * vwDot }
        stepResults.append(ComputationStep(
            title: "Scalar Multiply: (v·w)w",
            explanation: "Multiply each component of w by \(vwDot.description).",
            calculation: "\(vwDot.description) × w",
            result: "(v·w)w = [\(scaledW.map { $0.description }.joined(separator: ", "))]ᵀ"
        ))
        
        // Step 5: Add them
        let result = zip(scaledV, scaledW).map { $0 + $1 }
        stepResults.append(ComputationStep(
            title: "Vector Addition: ||u||²v + (v·w)w",
            explanation: "Add the two scaled vectors component-by-component.",
            calculation: "[\(scaledV.map { $0.description }.joined(separator: ", "))]ᵀ + [\(scaledW.map { $0.description }.joined(separator: ", "))]ᵀ",
            result: "[\(result.map { $0.description }.joined(separator: ", "))]ᵀ"
        ))
        
        finalResult = "[\(result.map { $0.description }.joined(separator: ", "))]ᵀ"
    }
    
    func dotProduct(_ a: [Fraction], _ b: [Fraction]) -> Fraction {
        zip(a, b).reduce(Fraction(0)) { $0 + ($1.0 * $1.1) }
    }
}

struct VectorInputWithLabel: View {
    let label: String
    @Binding var vector: [String]
    var color: Color = .primary
    
    var body: some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.headline)
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                ForEach(0..<vector.count, id: \.self) { i in
                    TextField("0", text: $vector[i])
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.center)
                        .frame(width: 50, height: 30)
                        .background(Color(uiColor: .systemBackground))
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(color.opacity(0.5)))
                }
            }
            .padding(8)
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
            .overlay(
                HStack {
                    BracketShape(left: true)
                        .stroke(color, lineWidth: 1.5)
                        .frame(width: 8)
                    Spacer()
                    BracketShape(left: false)
                        .stroke(color, lineWidth: 1.5)
                        .frame(width: 8)
                }
            )
        }
    }
}
