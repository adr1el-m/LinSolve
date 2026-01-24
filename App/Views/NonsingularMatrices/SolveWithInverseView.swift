import SwiftUI

struct SolveWithInverseView: View {
    // System Ax = b where A is 2x2
    @State private var matrixA: [[String]] = [["1", "3"], ["1", "4"]]
    @State private var vectorB: [String] = ["5", "7"]
    
    @State private var showSteps: Bool = false
    @State private var inverseA: [[Fraction]] = []
    @State private var solution: [Fraction] = []
    @State private var determinant: Fraction = Fraction(0, 1)
    @State private var isSingular: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Solving Systems with Inverses")
                        .font(.largeTitle)
                        .bold()
                    Text("Using x = A⁻¹b")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
When a matrix A is **nonsingular** (invertible), we can solve the linear system **Ax = b** directly using:

**x = A⁻¹b**

**Why this works:**
Starting with Ax = b, we multiply both sides on the left by A⁻¹:
• A⁻¹(Ax) = A⁻¹b
• (A⁻¹A)x = A⁻¹b
• Ix = A⁻¹b
• **x = A⁻¹b**

**Advantages:**
• Once you have A⁻¹, you can solve for ANY vector b instantly
• Useful when solving many systems with the same coefficient matrix A

**Limitation:**
• This only works if A is a square, nonsingular matrix
""")
                        .font(.body)
                        .padding(.vertical, 4)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Input Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Enter Your Linear System")
                        .font(.headline)
                    
                    Text("System: Ax = b")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 20) {
                        // Matrix A
                        VStack(spacing: 4) {
                            Text("A")
                                .font(.caption)
                                .foregroundColor(.blue)
                            VStack(spacing: 6) {
                                ForEach(0..<2, id: \.self) { row in
                                    HStack(spacing: 8) {
                                        ForEach(0..<2, id: \.self) { col in
                                            TextField("0", text: $matrixA[row][col])
                                                .keyboardType(.numbersAndPunctuation)
                                                .multilineTextAlignment(.center)
                                                .frame(width: 50, height: 36)
                                                .background(Color(uiColor: .systemBackground))
                                                .cornerRadius(6)
                                                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.blue.opacity(0.5)))
                                        }
                                    }
                                }
                            }
                            .padding(8)
                            .overlay(
                                HStack {
                                    BracketShape(left: true).stroke(Color.primary, lineWidth: 1.5).frame(width: 8)
                                    Spacer()
                                    BracketShape(left: false).stroke(Color.primary, lineWidth: 1.5).frame(width: 8)
                                }
                            )
                        }
                        
                        // Variable vector
                        VStack(spacing: 4) {
                            Text("x")
                                .font(.caption)
                                .foregroundColor(.purple)
                            VStack(spacing: 6) {
                                Text("x")
                                Text("y")
                            }
                            .font(.system(.body, design: .serif))
                            .italic()
                            .padding(8)
                            .overlay(
                                HStack {
                                    BracketShape(left: true).stroke(Color.primary, lineWidth: 1.5).frame(width: 8)
                                    Spacer()
                                    BracketShape(left: false).stroke(Color.primary, lineWidth: 1.5).frame(width: 8)
                                }
                            )
                        }
                        
                        Text("=")
                            .font(.title2)
                        
                        // Vector b
                        VStack(spacing: 4) {
                            Text("b")
                                .font(.caption)
                                .foregroundColor(.green)
                            VStack(spacing: 6) {
                                ForEach(0..<2, id: \.self) { i in
                                    TextField("0", text: $vectorB[i])
                                        .keyboardType(.numbersAndPunctuation)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 50, height: 36)
                                        .background(Color(uiColor: .systemBackground))
                                        .cornerRadius(6)
                                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.green.opacity(0.5)))
                                }
                            }
                            .padding(8)
                            .overlay(
                                HStack {
                                    BracketShape(left: true).stroke(Color.primary, lineWidth: 1.5).frame(width: 8)
                                    Spacer()
                                    BracketShape(left: false).stroke(Color.primary, lineWidth: 1.5).frame(width: 8)
                                }
                            )
                        }
                    }
                    
                    Button(action: solve) {
                        Text("Solve System")
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
                        
                        let a = Fraction(string: matrixA[0][0])
                        let b = Fraction(string: matrixA[0][1])
                        let c = Fraction(string: matrixA[1][0])
                        let d = Fraction(string: matrixA[1][1])
                        
                        // Step 1: Find inverse
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Step 1: Find A⁻¹")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Text("Using the 2×2 inverse formula:")
                                .font(.body)
                            
                            Text("det(A) = (\(a.description))(\(d.description)) - (\(b.description))(\(c.description)) = \(determinant.description)")
                                .font(.system(.body, design: .monospaced))
                            
                            if isSingular {
                                Text("⚠️ det(A) = 0, matrix is singular!")
                                    .font(.body)
                                    .foregroundColor(.red)
                            } else {
                                Text("A⁻¹ = (1/\(determinant.description)) × [d -b; -c a]")
                                    .font(.system(.body, design: .monospaced))
                                
                                HStack(spacing: 20) {
                                    Text("A⁻¹ =")
                                    InverseResultMatrixView(matrix: inverseA)
                                }
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                        
                        if !isSingular {
                            // Step 2: Multiply A⁻¹ × b
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Step 2: Calculate x = A⁻¹b")
                                    .font(.headline)
                                    .foregroundColor(.purple)
                                
                                Text("Multiply A⁻¹ by b:")
                                    .font(.body)
                                
                                let b1 = Fraction(string: vectorB[0])
                                let b2 = Fraction(string: vectorB[1])
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("x =")
                                        InverseResultMatrixView(matrix: inverseA)
                                        Text("×")
                                        VStack {
                                            Text(b1.description)
                                            Text(b2.description)
                                        }
                                        .font(.system(.body, design: .monospaced))
                                        .padding(6)
                                        .overlay(
                                            HStack {
                                                BracketShape(left: true).stroke(Color.primary, lineWidth: 1.5).frame(width: 6)
                                                Spacer()
                                                BracketShape(left: false).stroke(Color.primary, lineWidth: 1.5).frame(width: 6)
                                            }
                                        )
                                    }
                                }
                                
                                // Show the multiplication
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("x = (\(inverseA[0][0].description))(\(b1.description)) + (\(inverseA[0][1].description))(\(b2.description)) = \(solution[0].description)")
                                        .font(.system(.caption, design: .monospaced))
                                    Text("y = (\(inverseA[1][0].description))(\(b1.description)) + (\(inverseA[1][1].description))(\(b2.description)) = \(solution[1].description)")
                                        .font(.system(.caption, design: .monospaced))
                                }
                                .padding()
                                .background(Color.purple.opacity(0.1))
                                .cornerRadius(8)
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(10)
                            
                            // Final Solution
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.green)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Solution Found!")
                                            .font(.title2)
                                            .bold()
                                        Text("x = A⁻¹b")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                HStack(spacing: 30) {
                                    Text("x = \(solution[0].description)")
                                        .font(.system(.title3, design: .monospaced))
                                        .bold()
                                    Text("y = \(solution[1].description)")
                                        .font(.system(.title3, design: .monospaced))
                                        .bold()
                                }
                                
                                // Verification
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("✓ Verification")
                                        .font(.headline)
                                    Text("Substitute back into original equations to verify:")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    let eq1Result = Fraction(string: matrixA[0][0]) * solution[0] + Fraction(string: matrixA[0][1]) * solution[1]
                                    let eq2Result = Fraction(string: matrixA[1][0]) * solution[0] + Fraction(string: matrixA[1][1]) * solution[1]
                                    
                                    Text("\(matrixA[0][0])(\(solution[0].description)) + \(matrixA[0][1])(\(solution[1].description)) = \(eq1Result.description) ✓")
                                        .font(.system(.caption, design: .monospaced))
                                    Text("\(matrixA[1][0])(\(solution[0].description)) + \(matrixA[1][1])(\(solution[1].description)) = \(eq2Result.description) ✓")
                                        .font(.system(.caption, design: .monospaced))
                                }
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                            }
                            .padding()
                            .background(Color.green.opacity(0.15))
                            .cornerRadius(12)
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.red)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Cannot Solve with Inverse")
                                            .font(.title2)
                                            .bold()
                                        Text("Matrix A is singular")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Text("Since det(A) = 0, the matrix has no inverse. This system may have no solution or infinitely many solutions. Use Gaussian elimination to analyze further.")
                                    .font(.body)
                            }
                            .padding()
                            .background(Color.red.opacity(0.15))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .transition(.opacity)
                }
                
                Spacer()
            }
        }
    }
    
    func solve() {
        let a = Fraction(string: matrixA[0][0])
        let b = Fraction(string: matrixA[0][1])
        let c = Fraction(string: matrixA[1][0])
        let d = Fraction(string: matrixA[1][1])
        
        determinant = (a * d) - (b * c)
        
        if determinant == Fraction(0, 1) {
            isSingular = true
            inverseA = []
            solution = []
        } else {
            isSingular = false
            let invDet = Fraction(1, 1) / determinant
            inverseA = [
                [d * invDet, (Fraction(0, 1) - b) * invDet],
                [(Fraction(0, 1) - c) * invDet, a * invDet]
            ]
            
            // Calculate x = A⁻¹ × b
            let b1 = Fraction(string: vectorB[0])
            let b2 = Fraction(string: vectorB[1])
            
            solution = [
                inverseA[0][0] * b1 + inverseA[0][1] * b2,
                inverseA[1][0] * b1 + inverseA[1][1] * b2
            ]
        }
        
        withAnimation {
            showSteps = true
        }
    }
}
