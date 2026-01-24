import SwiftUI

struct VerifySolutionsView: View {
    // Equation: a₁x₁ + a₂x₂ + a₃x₃ + a₄x₄ = b
    @State private var coefficients: [String] = ["4", "3", "1", "2"]
    @State private var rightHandSide: String = "5"
    
    // Test vector
    @State private var testVector: [String] = ["1", "-1", "0", "2"]
    
    @State private var showResult: Bool = false
    @State private var calculationSteps: [(term: String, value: Fraction)] = []
    @State private var totalSum: Fraction = Fraction(0, 1)
    @State private var isValid: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Verifying Solutions to Linear Equations")
                        .font(.largeTitle)
                        .bold()
                    Text("Check if a vector satisfies an equation")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
A **solution** to a linear equation is a vector whose components, when substituted into the equation, make it true. To verify if a given vector is a solution, we substitute each component into the corresponding variable and check if the left-hand side equals the right-hand side.

**Process:**
1. Take each component of the test vector
2. Multiply by its corresponding coefficient
3. Sum all the products
4. Compare the sum to the right-hand side value
""")
                        .font(.body)
                        .padding(.vertical, 4)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Equation Definition
                VStack(alignment: .leading, spacing: 16) {
                    Text("Define Your Equation")
                        .font(.headline)
                    
                    Text("Enter coefficients for: a₁x₁ + a₂x₂ + a₃x₃ + a₄x₄ = b")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Coefficient inputs
                    HStack(spacing: 8) {
                        ForEach(0..<4, id: \.self) { i in
                            VStack(spacing: 4) {
                                Text("a\(subscript(i + 1))")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                TextField("0", text: $coefficients[i])
                                    .keyboardType(.numbersAndPunctuation)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 50, height: 36)
                                    .background(Color(uiColor: .systemBackground))
                                    .cornerRadius(6)
                                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.blue.opacity(0.5)))
                            }
                            
                            if i < 3 {
                                Text("x\(subscript(i + 1)) +")
                                    .font(.system(.body, design: .serif))
                            } else {
                                Text("x\(subscript(i + 1)) =")
                                    .font(.system(.body, design: .serif))
                            }
                        }
                        
                        VStack(spacing: 4) {
                            Text("b")
                                .font(.caption)
                                .foregroundColor(.green)
                            TextField("0", text: $rightHandSide)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.center)
                                .frame(width: 50, height: 36)
                                .background(Color(uiColor: .systemBackground))
                                .cornerRadius(6)
                                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.green.opacity(0.5)))
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                // Test Vector Input
                VStack(alignment: .leading, spacing: 16) {
                    Text("Test Vector")
                        .font(.headline)
                    
                    Text("Enter the vector to verify: x = [x₁, x₂, x₃, x₄]ᵀ")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 12) {
                        ForEach(0..<4, id: \.self) { i in
                            VStack(spacing: 4) {
                                Text("x\(subscript(i + 1))")
                                    .font(.caption)
                                    .foregroundColor(.purple)
                                TextField("0", text: $testVector[i])
                                    .keyboardType(.numbersAndPunctuation)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 50, height: 36)
                                    .background(Color(uiColor: .systemBackground))
                                    .cornerRadius(6)
                                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.purple.opacity(0.5)))
                            }
                        }
                    }
                    
                    Button(action: verifySolution) {
                        Text("Verify Solution")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                // Results
                if showResult {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Step-by-Step Verification")
                            .font(.title2)
                            .bold()
                        
                        // Step 1: Substitution
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Step 1: Substitute Values")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Text("Replace each xᵢ with the corresponding component from the test vector:")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            // Show the substitution
                            HStack(spacing: 4) {
                                ForEach(0..<4, id: \.self) { i in
                                    Text("\(coefficients[i])(\(testVector[i]))")
                                        .font(.system(.body, design: .monospaced))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 4)
                                        .background(Color.yellow.opacity(0.2))
                                        .cornerRadius(4)
                                    
                                    if i < 3 {
                                        Text("+")
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                        
                        // Step 2: Calculate Each Term
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Step 2: Calculate Each Product")
                                .font(.headline)
                                .foregroundColor(.purple)
                            
                            Text("Multiply each coefficient by its variable value:")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(calculationSteps.enumerated()), id: \.offset) { index, step in
                                    HStack {
                                        Text(step.term)
                                            .font(.system(.body, design: .monospaced))
                                            .frame(width: 120, alignment: .leading)
                                        Text("=")
                                        Text(step.value.description)
                                            .font(.system(.body, design: .monospaced))
                                            .bold()
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color(uiColor: .systemBackground))
                                    .cornerRadius(6)
                                }
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                        
                        // Step 3: Sum All Terms
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Step 3: Sum All Terms")
                                .font(.headline)
                                .foregroundColor(.orange)
                            
                            let termsString = calculationSteps.map { $0.value.description }.joined(separator: " + ")
                            
                            Text("\(termsString) = \(totalSum.description)")
                                .font(.system(.body, design: .monospaced))
                                .padding()
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                        
                        // Step 4: Compare
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Step 4: Compare with Right-Hand Side")
                                .font(.headline)
                                .foregroundColor(isValid ? .green : .red)
                            
                            let rhsFraction = Fraction(string: rightHandSide)
                            
                            HStack(spacing: 20) {
                                VStack {
                                    Text("Left Side")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(totalSum.description)
                                        .font(.title2)
                                        .bold()
                                }
                                
                                Text(isValid ? "=" : "≠")
                                    .font(.title)
                                    .foregroundColor(isValid ? .green : .red)
                                
                                VStack {
                                    Text("Right Side")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(rhsFraction.description)
                                        .font(.title2)
                                        .bold()
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isValid ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                        
                        // Final Verdict
                        HStack {
                            Image(systemName: isValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(isValid ? .green : .red)
                            
                            VStack(alignment: .leading) {
                                Text(isValid ? "Valid Solution!" : "Not a Solution")
                                    .font(.title2)
                                    .bold()
                                Text(isValid
                                     ? "The vector [\(testVector.joined(separator: ", "))]ᵀ satisfies the equation."
                                     : "The vector [\(testVector.joined(separator: ", "))]ᵀ does not satisfy the equation because \(totalSum.description) ≠ \(rightHandSide).")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(isValid ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                        .cornerRadius(12)
                    }
                    .padding()
                    .transition(.opacity)
                }
                
                Spacer()
            }
        }
    }
    
    func subscript(_ n: Int) -> String {
        let subscripts = ["₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉"]
        return String(String(n).map { subscripts[Int(String($0))!] }.joined())
    }
    
    func verifySolution() {
        calculationSteps = []
        totalSum = Fraction(0, 1)
        
        for i in 0..<4 {
            let coeff = Fraction(string: coefficients[i])
            let varValue = Fraction(string: testVector[i])
            let product = coeff * varValue
            
            calculationSteps.append((
                term: "\(coefficients[i]) × \(testVector[i])",
                value: product
            ))
            
            totalSum = totalSum + product
        }
        
        let rhs = Fraction(string: rightHandSide)
        isValid = (totalSum == rhs)
        
        withAnimation {
            showResult = true
        }
    }
}
