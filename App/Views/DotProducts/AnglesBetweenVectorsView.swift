import SwiftUI

struct AnglesBetweenVectorsView: View {
    // Default vectors from example
    @State private var xVec: [String] = ["0", "-2", "-1", "1"]
    @State private var yVec: [String] = ["-3", "2", "4", "4"]
    
    @State private var showSteps: Bool = false
    
    // Results
    @State private var dotProduct: Fraction = Fraction(0)
    @State private var normX: Double = 0
    @State private var normY: Double = 0
    @State private var cosTheta: Double = 0
    @State private var angleDegrees: Double = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Angles Between Vectors")
                        .font(.largeTitle)
                        .bold()
                    Text("Using the Dot Product to Find θ")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
One of the most powerful applications of the dot product is finding the **angle between two vectors**. This is essential in:
• **Computer graphics** (lighting calculations, camera angles)
• **Physics** (work = force · displacement × cos(θ))
• **Machine learning** (cosine similarity for comparing documents)

The relationship comes from the geometric definition of the dot product:  
**x · y = ||x|| ||y|| cos(θ)**

Solving for the angle gives us a simple formula.
""")
                        .font(.body)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Formula
                VStack(alignment: .leading, spacing: 12) {
                    Text("The Cosine Formula")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        Text("cos(θ) = (x · y) / (||x|| · ||y||)")
                            .font(.system(.title2, design: .serif))
                            .italic()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("θ = arccos((x · y) / (||x|| · ||y||))")
                            .font(.system(.body, design: .serif))
                            .italic()
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("**Interpreting the result:**")
                            .font(.subheadline)
                        Text("• θ = 0° → vectors point in **same direction**")
                        Text("• θ = 90° → vectors are **perpendicular** (orthogonal)")
                        Text("• θ = 180° → vectors point in **opposite directions**")
                    }
                    .font(.body)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                // Input Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Input Vectors")
                        .font(.headline)
                    
                    HStack(alignment: .top, spacing: 30) {
                        VStack {
                            Text("Vector x")
                                .font(.caption)
                                .bold()
                            
                            VStack(spacing: 4) {
                                ForEach(0..<xVec.count, id: \.self) { i in
                                    TextField("0", text: $xVec[i])
                                        .keyboardType(.numbersAndPunctuation)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 50, height: 30)
                                        .background(Color(uiColor: .systemBackground))
                                        .cornerRadius(4)
                                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.blue.opacity(0.5)))
                                }
                            }
                            .padding(8)
                            .background(Color(uiColor: .tertiarySystemBackground))
                            .cornerRadius(8)
                            .overlay(
                                HStack {
                                    BracketShape(left: true).stroke(Color.blue, lineWidth: 1.5).frame(width: 8)
                                    Spacer()
                                    BracketShape(left: false).stroke(Color.blue, lineWidth: 1.5).frame(width: 8)
                                }
                            )
                        }
                        
                        Text("θ = ?")
                            .font(.title)
                            .foregroundColor(.orange)
                            .padding(.top, 40)
                        
                        VStack {
                            Text("Vector y")
                                .font(.caption)
                                .bold()
                            
                            VStack(spacing: 4) {
                                ForEach(0..<yVec.count, id: \.self) { i in
                                    TextField("0", text: $yVec[i])
                                        .keyboardType(.numbersAndPunctuation)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 50, height: 30)
                                        .background(Color(uiColor: .systemBackground))
                                        .cornerRadius(4)
                                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.green.opacity(0.5)))
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
                    
                    Button(action: compute) {
                        Text("Calculate Angle")
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
                        
                        // Step 1: Dot Product
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Step 1: Compute the Dot Product x · y")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Text("Multiply corresponding components and sum:")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            let x = xVec.compactMap { Double($0) }
                            let y = yVec.compactMap { Double($0) }
                            let terms = zip(x, y).map { "(\(formatNumber($0)))(\(formatNumber($1)))" }.joined(separator: " + ")
                            let products = zip(x, y).map { $0 * $1 }
                            let productStr = products.map { formatNumber($0) }.joined(separator: " + ")
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("x · y = \(terms)")
                                    .font(.system(.body, design: .monospaced))
                                Text("x · y = \(productStr)")
                                    .font(.system(.body, design: .monospaced))
                                Text("x · y = \(dotProduct.description)")
                                    .font(.system(.body, design: .monospaced))
                                    .bold()
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        // Step 2: Norms
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Step 2: Compute the Norms")
                                .font(.headline)
                                .foregroundColor(.purple)
                            
                            Text("Find the length of each vector:")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            let x = xVec.compactMap { Double($0) }
                            let y = yVec.compactMap { Double($0) }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                let xSquares = x.map { $0 * $0 }
                                let xSquareStr = xSquares.map { formatNumber($0) }.joined(separator: " + ")
                                Text("||x|| = √(\(xSquareStr)) = √\(formatNumber(xSquares.reduce(0, +))) = \(String(format: "%.4f", normX))")
                                    .font(.system(.body, design: .monospaced))
                                
                                let ySquares = y.map { $0 * $0 }
                                let ySquareStr = ySquares.map { formatNumber($0) }.joined(separator: " + ")
                                Text("||y|| = √(\(ySquareStr)) = √\(formatNumber(ySquares.reduce(0, +))) = \(String(format: "%.4f", normY))")
                                    .font(.system(.body, design: .monospaced))
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        // Step 3: Apply Formula
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Step 3: Apply the Cosine Formula")
                                .font(.headline)
                                .foregroundColor(.orange)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("cos(θ) = (x · y) / (||x|| · ||y||)")
                                    .font(.system(.body, design: .monospaced))
                                
                                Text("cos(θ) = \(dotProduct.description) / (\(String(format: "%.4f", normX)) × \(String(format: "%.4f", normY)))")
                                    .font(.system(.body, design: .monospaced))
                                
                                Text("cos(θ) = \(dotProduct.description) / \(String(format: "%.4f", normX * normY))")
                                    .font(.system(.body, design: .monospaced))
                                
                                Text("cos(θ) = \(String(format: "%.6f", cosTheta))")
                                    .font(.system(.body, design: .monospaced))
                                    .bold()
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        // Step 4: Find Angle
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Step 4: Find the Angle θ")
                                .font(.headline)
                                .foregroundColor(.green)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("θ = arccos(\(String(format: "%.6f", cosTheta)))")
                                    .font(.system(.body, design: .monospaced))
                                
                                Text("θ ≈ \(String(format: "%.2f", angleDegrees))°")
                                    .font(.system(.title3, design: .monospaced))
                                    .bold()
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        // Result Summary
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Result")
                                .font(.headline)
                            
                            HStack(spacing: 15) {
                                Image(systemName: "angle")
                                    .font(.largeTitle)
                                    .foregroundColor(.orange)
                                
                                VStack(alignment: .leading) {
                                    Text("θ ≈ \(String(format: "%.2f", angleDegrees))°")
                                        .font(.title)
                                        .bold()
                                    
                                    Text(angleInterpretation)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        // Geometry Application
                        VStack(alignment: .leading, spacing: 10) {
                            Text("💡 Geometry Application: Cube Diagonal")
                                .font(.headline)
                            
                            Text("""
A classic application is finding the angle between a cube's edge and its space diagonal.

• Edge vector: e₁ = [1, 0, 0]ᵀ
• Diagonal vector: d = [a, a, a]ᵀ (for a cube with side length a)

Using our formula:
• e₁ · d = a
• ||e₁|| = 1
• ||d|| = √(3a²) = a√3
• cos(θ) = a / (1 × a√3) = 1/√3
• θ ≈ **54.74°**

This is a fixed property of all cubes!
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
    
    var angleInterpretation: String {
        if abs(angleDegrees - 90) < 0.1 {
            return "The vectors are perpendicular (orthogonal)!"
        } else if angleDegrees < 90 {
            return "The vectors form an acute angle"
        } else {
            return "The vectors form an obtuse angle"
        }
    }
    
    func formatNumber(_ d: Double) -> String {
        if abs(d - round(d)) < 0.0001 {
            return String(format: "%.0f", d)
        }
        return String(format: "%.2f", d)
    }
    
    func compute() {
        let x = xVec.compactMap { Double($0) }
        let y = yVec.compactMap { Double($0) }
        
        guard x.count == xVec.count, y.count == yVec.count, x.count == y.count else { return }
        
        // Dot product
        let dp = zip(x, y).reduce(0) { $0 + ($1.0 * $1.1) }
        dotProduct = Fraction(Int(dp))
        
        // Norms
        normX = sqrt(x.reduce(0) { $0 + ($1 * $1) })
        normY = sqrt(y.reduce(0) { $0 + ($1 * $1) })
        
        guard normX > 0, normY > 0 else { return }
        
        // Cosine
        cosTheta = dp / (normX * normY)
        
        // Angle in degrees
        let angleRadians = acos(max(-1, min(1, cosTheta)))
        angleDegrees = angleRadians * 180 / .pi
        
        withAnimation {
            showSteps = true
        }
    }
}
