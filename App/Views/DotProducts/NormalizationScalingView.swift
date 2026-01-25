import SwiftUI

struct NormalizationScalingView: View {
    // Default vector from example
    @State private var xVec: [String] = ["2", "-1", "2"]
    @State private var targetLength: String = "5"
    
    @State private var showSteps: Bool = false
    
    // Results
    @State private var norm: Fraction = Fraction(0)
    @State private var normDouble: Double = 0
    @State private var unitVector: [Fraction] = []
    @State private var scaledVector: [Fraction] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Normalization & Scaling")
                        .font(.largeTitle)
                        .bold()
                    Text("Creating Vectors of Specific Lengths")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
**Normalization** is the process of converting any vector into a **unit vector** (a vector with length 1) that points in the same direction. This is incredibly useful in computer graphics, physics, and machine learning.

**Why normalize?**
• Unit vectors represent **pure direction** without magnitude
• They simplify calculations involving angles
• Many algorithms require vectors to be normalized (e.g., normal maps in 3D graphics)

Once you have a unit vector, you can **scale** it to create a vector of any desired length while preserving its direction.
""")
                        .font(.body)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Formulas
                VStack(alignment: .leading, spacing: 12) {
                    Text("Key Formulas")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("**1. Norm (Length) of a Vector:**")
                                .font(.subheadline)
                            Text("||x|| = √(x₁² + x₂² + ... + xₙ²)")
                                .font(.system(.body, design: .serif))
                                .italic()
                                .padding(8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(6)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("**2. Unit Vector (Normalization):**")
                                .font(.subheadline)
                            Text("û = x / ||x||")
                                .font(.system(.body, design: .serif))
                                .italic()
                                .padding(8)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(6)
                            Text("Divide each component by the norm to get ||û|| = 1")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("**3. Scaling to Target Length:**")
                                .font(.subheadline)
                            Text("v = k · û")
                                .font(.system(.body, design: .serif))
                                .italic()
                                .padding(8)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(6)
                            Text("Multiply the unit vector by desired length k")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                // Input Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Input Vector")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text("Vector x")
                                .font(.caption)
                                .bold()
                            
                            VStack(spacing: 4) {
                                ForEach(0..<xVec.count, id: \.self) { i in
                                    TextField("0", text: $xVec[i])
                                        .keyboardType(.numbersAndPunctuation)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 60, height: 35)
                                        .background(Color(uiColor: .systemBackground))
                                        .cornerRadius(6)
                                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.blue.opacity(0.5)))
                                }
                            }
                            .padding(10)
                            .background(Color(uiColor: .tertiarySystemBackground))
                            .cornerRadius(8)
                            .overlay(
                                HStack {
                                    BracketShape(left: true)
                                        .stroke(Color.blue, lineWidth: 1.5)
                                        .frame(width: 8)
                                    Spacer()
                                    BracketShape(left: false)
                                        .stroke(Color.blue, lineWidth: 1.5)
                                        .frame(width: 8)
                                }
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Target Length")
                                .font(.caption)
                                .bold()
                            
                            HStack {
                                TextField("5", text: $targetLength)
                                    .keyboardType(.numbersAndPunctuation)
                                    .frame(width: 60, height: 35)
                                    .multilineTextAlignment(.center)
                                    .background(Color(uiColor: .systemBackground))
                                    .cornerRadius(6)
                                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.orange.opacity(0.5)))
                            }
                            
                            Text("We'll create a vector with this length")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(action: compute) {
                        Text("Normalize and Scale")
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
                        
                        // Step 1: Find Norm
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Step 1: Find the Norm ||x||")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Text("The norm tells us the **current length** of the vector. We compute it using the Pythagorean theorem extended to n dimensions.")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            let squareTerms = xVec.map { "(\($0))²" }.joined(separator: " + ")
                            let squareValues = xVec.compactMap { Double($0) }.map { $0 * $0 }
                            let sumOfSquares = squareValues.reduce(0, +)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("||x|| = √(\(squareTerms))")
                                    .font(.system(.body, design: .monospaced))
                                Text("||x|| = √(\(squareValues.map { String(format: "%.0f", $0) }.joined(separator: " + ")))")
                                    .font(.system(.body, design: .monospaced))
                                Text("||x|| = √\(String(format: "%.0f", sumOfSquares)) = \(String(format: "%.4f", normDouble))")
                                    .font(.system(.body, design: .monospaced))
                                    .bold()
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        // Step 2: Create Unit Vector
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Step 2: Normalize to Unit Vector û")
                                .font(.headline)
                                .foregroundColor(.green)
                            
                            Text("Divide each component by the norm. The result has length 1 but points in the **same direction**.")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("û = x / ||x|| = x / \(String(format: "%.4f", normDouble))")
                                    .font(.system(.body, design: .monospaced))
                                
                                HStack(spacing: 30) {
                                    VStack {
                                        Text("Original x")
                                            .font(.caption)
                                        VectorDisplay(values: xVec, color: .blue)
                                    }
                                    
                                    Text("→")
                                        .font(.title)
                                    
                                    VStack {
                                        Text("Unit Vector û")
                                            .font(.caption)
                                        VStack(spacing: 4) {
                                            ForEach(unitVector, id: \.description) { val in
                                                Text(String(format: "%.4f", val.asDouble))
                                                    .font(.system(.body, design: .monospaced))
                                                    .frame(minWidth: 60)
                                                    .foregroundColor(.green)
                                            }
                                        }
                                        .padding(8)
                                        .background(Color(uiColor: .tertiarySystemBackground))
                                        .cornerRadius(8)
                                        .overlay(
                                            HStack {
                                                BracketShape(left: true).stroke(Color.green, lineWidth: 1.5).frame(width: 8)
                                                Spacer()
                                                BracketShape(left: false).stroke(Color.green, lineWidth: 1.5).frame(width: 8)
                                            }
                                        )
                                    }
                                }
                                
                                Text("✓ ||û|| = 1 (you can verify by computing the norm)")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                    .padding(.top, 4)
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        // Step 3: Scale
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Step 3: Scale to Target Length \(targetLength)")
                                .font(.headline)
                                .foregroundColor(.orange)
                            
                            Text("Multiply the unit vector by your desired length to get a vector pointing in the same direction with the target magnitude.")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("v = \(targetLength) · û")
                                    .font(.system(.body, design: .monospaced))
                                
                                HStack(spacing: 30) {
                                    VStack {
                                        Text("Final Vector v")
                                            .font(.caption)
                                        VStack(spacing: 4) {
                                            ForEach(scaledVector, id: \.description) { val in
                                                Text(val.description)
                                                    .font(.system(.body, design: .monospaced))
                                                    .frame(minWidth: 60)
                                                    .foregroundColor(.orange)
                                            }
                                        }
                                        .padding(8)
                                        .background(Color(uiColor: .tertiarySystemBackground))
                                        .cornerRadius(8)
                                        .overlay(
                                            HStack {
                                                BracketShape(left: true).stroke(Color.orange, lineWidth: 1.5).frame(width: 8)
                                                Spacer()
                                                BracketShape(left: false).stroke(Color.orange, lineWidth: 1.5).frame(width: 8)
                                            }
                                        )
                                    }
                                }
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        // Final Summary
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Summary")
                                .font(.headline)
                            
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title2)
                                
                                VStack(alignment: .leading) {
                                    Text("Created a vector of length \(targetLength)")
                                        .font(.headline)
                                    Text("pointing in the same direction as the original vector x")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
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
    }
    
    func compute() {
        let x = xVec.compactMap { Double($0) }
        guard x.count == xVec.count else { return }
        
        let target = Double(targetLength) ?? 5.0
        
        // Compute norm
        let sumOfSquares = x.reduce(0) { $0 + ($1 * $1) }
        normDouble = sqrt(sumOfSquares)
        
        guard normDouble > 0 else { return }
        
        // Unit vector
        let unitVecDouble = x.map { $0 / normDouble }
        unitVector = unitVecDouble.map { Fraction(Int(round($0 * 10000)), 10000) }
        
        // Scaled vector - keep as fractions for cleaner display

        
        // For nice display, compute scaled vector as (target/norm) * x
        let scaleFactor = target / normDouble
        scaledVector = x.map { component in
            let scaled = component * scaleFactor
            // Try to find a nice fraction
            if abs(scaled - round(scaled)) < 0.0001 {
                return Fraction(Int(round(scaled)))
            } else {
                // Return as fraction with denominator 3 if it fits the pattern
                let asThirds = scaled * 3
                if abs(asThirds - round(asThirds)) < 0.0001 {
                    return Fraction(Int(round(asThirds)), 3)
                }
                return Fraction(Int(round(scaled * 100)), 100)
            }
        }
        
        withAnimation {
            showSteps = true
        }
    }
}
