import SwiftUI

struct MatrixExponentsView: View {
    // Default matrix from example
    @State private var matrix: [[String]] = [
        ["1", "-1"],
        ["1", "1"]
    ]
    @State private var scalar: String = "1"
    @State private var exponent: Int = 2
    
    @State private var showSteps: Bool = false
    @State private var powerResults: [[[Fraction]]] = []
    @State private var finalResult: [[Fraction]] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Matrix Powers")
                        .font(.largeTitle)
                        .bold()
                    Text("Computing Aⁿ Through Repeated Multiplication")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
A **matrix power** Aⁿ is the result of multiplying a square matrix A by itself n times. This operation is only defined for **square matrices** (same number of rows and columns).

**Definition:**
• A¹ = A
• A² = A · A
• A³ = A · A · A
• Aⁿ = A · A · ... · A  (n times)

**Efficiency:** For higher powers, we can use the property A⁴ = (A²)² to reduce the number of multiplications.
""")
                        .font(.body)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Properties
                VStack(alignment: .leading, spacing: 12) {
                    Text("Properties of Matrix Powers")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        PropertyRow(property: "Aᵐ · Aⁿ = Aᵐ⁺ⁿ", description: "Powers add when multiplying")
                        PropertyRow(property: "(Aᵐ)ⁿ = Aᵐⁿ", description: "Powers multiply when raising a power")
                        PropertyRow(property: "A⁰ = I", description: "Any matrix to the 0th power is the identity")
                        PropertyRow(property: "A⁻¹ exists ⟹ A⁻ⁿ = (A⁻¹)ⁿ", description: "Negative powers use the inverse")
                    }
                    
                    // Scalar handling
                    VStack(alignment: .leading, spacing: 4) {
                        Text("**Scalar Factor:**")
                            .font(.subheadline)
                        Text("If A = cM (scalar times a matrix), then Aⁿ = cⁿMⁿ")
                            .font(.body)
                            .padding(8)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                // Input Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Input (Square Matrix)")
                        .font(.headline)
                    
                    HStack(alignment: .top, spacing: 30) {
                        VStack {
                            Text("Matrix M")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            
                            VStack(spacing: 4) {
                                ForEach(0..<matrix.count, id: \.self) { r in
                                    HStack(spacing: 4) {
                                        ForEach(0..<matrix[r].count, id: \.self) { c in
                                            TextField("0", text: $matrix[r][c])
                                                .keyboardType(.numbersAndPunctuation)
                                                .multilineTextAlignment(.center)
                                                .frame(width: 45, height: 35)
                                                .background(Color(uiColor: .systemBackground))
                                                .cornerRadius(4)
                                                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.blue.opacity(0.4)))
                                        }
                                    }
                                }
                            }
                            .padding(8)
                            .background(Color(uiColor: .tertiarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading) {
                                Text("Scalar (optional)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                HStack {
                                    Text("A =")
                                    TextField("1", text: $scalar)
                                        .keyboardType(.numbersAndPunctuation)
                                        .frame(width: 50)
                                        .textFieldStyle(.roundedBorder)
                                    Text("· M")
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Power")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Picker("Power", selection: $exponent) {
                                    Text("²").tag(2)
                                    Text("³").tag(3)
                                    Text("⁴").tag(4)
                                    Text("⁵").tag(5)
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 150)
                            }
                        }
                    }
                    
                    Button(action: compute) {
                        Text("Compute A^\(exponent)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                // Solution
                if showSteps {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Step-by-Step Solution")
                            .font(.title2)
                            .bold()
                        
                        let scalarVal = Fraction(string: scalar)
                        if scalarVal != Fraction(1) {
                            // Handle scalar
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Step 0: Factor Out Scalar")
                                    .font(.headline)
                                    .foregroundColor(.purple)
                                
                                Text("Since A = \(scalar) · M, we have:")
                                    .font(.body)
                                
                                Text("A^\(exponent) = (\(scalar))^\(exponent) · M^\(exponent)")
                                    .font(.system(.body, design: .monospaced))
                                    .padding(8)
                                    .background(Color.purple.opacity(0.1))
                                    .cornerRadius(6)
                                
                                let scalarPower = pow(scalarVal.asDouble, Double(exponent))
                                Text("(\(scalar))^\(exponent) = \(formatNumber(scalarPower))")
                                    .font(.system(.body, design: .monospaced))
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(10)
                        }
                        
                        // Show each power step
                        ForEach(0..<powerResults.count, id: \.self) { i in
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Step \(i + 1): Compute M^\(i + 2)")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                if i == 0 {
                                    Text("M² = M · M")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("M^\(i + 2) = M^\(i + 1) · M")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                                
                                HStack {
                                    Text("M^\(i + 2) =")
                                        .font(.headline)
                                    MatrixResultDisplay(matrix: powerResults[i], color: .blue)
                                }
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(10)
                        }
                        
                        // Final Result
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Final Result")
                                .font(.headline)
                            
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title)
                                
                                VStack(alignment: .leading) {
                                    Text("A^\(exponent) =")
                                        .font(.headline)
                                    MatrixResultDisplay(matrix: finalResult, color: .green)
                                }
                            }
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                        
                        // Application Note
                        VStack(alignment: .leading, spacing: 8) {
                            Text("💡 Applications")
                                .font(.headline)
                            
                            Text("""
Matrix powers are essential in:
• **Markov Chains**: Aⁿ gives state probabilities after n steps
• **Graph Theory**: Aⁿᵢⱼ counts walks of length n from vertex i to j
• **Differential Equations**: Solutions involve eᴬᵗ ≈ I + At + A²t²/2! + ...
• **Computer Graphics**: Repeated transformations
""")
                                .font(.body)
                        }
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding()
                    .transition(.opacity)
                }
                
                Spacer()
            }
        }
    }
    
    func formatNumber(_ d: Double) -> String {
        if abs(d - round(d)) < 0.0001 {
            return String(format: "%.0f", d)
        }
        // Try to express as simple fraction
        for denom in 1...16 {
            let numer = d * Double(denom)
            if abs(numer - round(numer)) < 0.0001 {
                return Fraction(Int(round(numer)), denom).description
            }
        }
        return String(format: "%.4f", d)
    }
    
    func compute() {
        let m = matrix.map { row in row.map { Fraction(string: $0) } }
        let scalarVal = Fraction(string: scalar)
        
        powerResults = []
        var current = m
        
        // Compute M^2, M^3, etc.
        for _ in 2...exponent {
            current = multiplyMatrices(current, m)
            powerResults.append(current)
        }
        
        // Apply scalar
        let scalarPowerDouble = pow(scalarVal.asDouble, Double(exponent))
        // Try to keep as fraction if possible
        var scalarPower = Fraction(1)
        for _ in 0..<exponent {
            scalarPower = scalarPower * scalarVal
        }
        
        finalResult = current.map { row in
            row.map { $0 * scalarPower }
        }
        
        withAnimation {
            showSteps = true
        }
    }
    
    func multiplyMatrices(_ a: [[Fraction]], _ b: [[Fraction]]) -> [[Fraction]] {
        let n = a.count
        var result = [[Fraction]](repeating: [Fraction](repeating: Fraction(0), count: n), count: n)
        
        for i in 0..<n {
            for j in 0..<n {
                var sum = Fraction(0)
                for k in 0..<n {
                    sum = sum + (a[i][k] * b[k][j])
                }
                result[i][j] = sum
            }
        }
        return result
    }
}

struct PropertyRow: View {
    let property: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(property)
                .font(.system(.body, design: .serif))
                .italic()
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(8)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(6)
    }
}
