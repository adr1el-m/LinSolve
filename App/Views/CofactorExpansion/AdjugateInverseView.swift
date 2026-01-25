import SwiftUI

struct AdjugateInverseView: View {
    @State private var selectedTab: Int = 0
    
    // Example matrix for adjugate
    @State private var matrix: [[String]] = [
        ["2", "0", "-1"],
        ["1", "1", "0"],
        ["0", "-2", "3"]
    ]
    @State private var showSolution: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "arrow.uturn.backward.square")
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                        Text("Adjugate Matrix & Inverse")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Computing Inverses Without Row Reduction")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Introduction
                VStack(alignment: .leading, spacing: 16) {
                    Text("What is the Adjugate?")
                        .font(.headline)
                    
                    Text("The adjugate (also called the classical adjoint) of a matrix A is the transpose of the matrix of cofactors. It provides an alternative method for finding the inverse that doesn't require row reduction.")
                        .font(.body)
                    
                    Text("This method is particularly useful for theoretical work, symbolic calculations, and when you need an explicit formula for the inverse.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Definitions
                VStack(alignment: .leading, spacing: 16) {
                    Text("Key Definitions")
                        .font(.headline)
                    
                    // Minor
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Minor Mᵢⱼ")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.blue)
                        Text("The determinant of the (n-1)×(n-1) matrix obtained by deleting row i and column j from A.")
                            .font(.body)
                    }
                    
                    // Cofactor
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Cofactor Cᵢⱼ")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.purple)
                        Text("Cᵢⱼ = (-1)^(i+j) × Mᵢⱼ")
                            .font(.system(.body, design: .monospaced))
                            .padding(8)
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(6)
                        Text("The minor with the appropriate sign from the checkerboard pattern.")
                            .font(.caption)
                    }
                    
                    // Cofactor Matrix
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Cofactor Matrix C")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.orange)
                        Text("The matrix where each entry aᵢⱼ is replaced by its cofactor Cᵢⱼ.")
                            .font(.body)
                    }
                    
                    // Adjugate
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Adjugate adj(A)")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.green)
                        Text("adj(A) = Cᵀ")
                            .font(.system(.body, design: .monospaced))
                            .padding(8)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(6)
                        Text("The TRANSPOSE of the cofactor matrix. This step is crucial!")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // The Inverse Formula
                VStack(alignment: .leading, spacing: 16) {
                    Text("The Inverse Formula")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        Text("A⁻¹ = (1/det A) × adj(A)")
                            .font(.system(.title2, design: .monospaced))
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("This formula works for any invertible matrix (when det A ≠ 0).")
                            .font(.body)
                        
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("The matrix must be invertible (det A ≠ 0) for this formula to work.")
                                .font(.caption)
                        }
                    }
                    
                    // Important property
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Verification Property")
                            .font(.subheadline)
                            .bold()
                        
                        Text("A × adj(A) = adj(A) × A = det(A) × I")
                            .font(.system(.body, design: .monospaced))
                            .padding(8)
                            .background(Color(uiColor: .tertiarySystemBackground))
                            .cornerRadius(6)
                        
                        Text("This property allows you to verify your adjugate calculation! The product should equal det(A) times the identity matrix.")
                            .font(.caption)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Tab Selection for Examples
                Picker("Example", selection: $selectedTab) {
                    Text("Adjugate").tag(0)
                    Text("Inverse").tag(1)
                }
                .pickerStyle(.segmented)
                
                // Examples
                if selectedTab == 0 {
                    AdjugateExampleView()
                } else {
                    InverseViaAdjugateView()
                }
                
                // Interactive Calculator
                AdjugateCalculator(matrix: $matrix, showSolution: $showSolution)
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Adjugate Example (Example 140)

struct AdjugateExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Computing the Adjugate")
                .font(.headline)
            
            Text("Calculate adj(A) where:")
                .font(.body)
            
            // Matrix display
            Text("""
                    ┌  2   0  -1 ┐
                A = │  1   1   0 │
                    └  0  -2   3 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Step 1: Calculate ALL Cofactors")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("We need to find the cofactor for every position (i,j):")
                    .font(.body)
                
                // First row cofactors
                VStack(alignment: .leading, spacing: 8) {
                    Text("Row 1 Cofactors:")
                        .font(.caption)
                        .bold()
                    
                    Text("C₁₁ = (+)|1  0 | = 1(3) - 0(-2) = 3")
                        .font(.system(.caption, design: .monospaced))
                    Text("        |-2 3 |")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("C₁₂ = (-)|1  0| = -(1(3) - 0(0)) = -3")
                        .font(.system(.caption, design: .monospaced))
                    Text("        |0  3|")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("C₁₃ = (+)|1   1| = 1(-2) - 1(0) = -2")
                        .font(.system(.caption, design: .monospaced))
                    Text("        |0  -2|")
                        .font(.system(.caption, design: .monospaced))
                }
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
                
                // Second row cofactors
                VStack(alignment: .leading, spacing: 8) {
                    Text("Row 2 Cofactors:")
                        .font(.caption)
                        .bold()
                    
                    Text("C₂₁ = (-)|0  -1| = -(0(3) - (-1)(-2)) = -(-2) = 2")
                        .font(.system(.caption, design: .monospaced))
                    Text("        |-2  3|")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("C₂₂ = (+)|2  -1| = 2(3) - (-1)(0) = 6")
                        .font(.system(.caption, design: .monospaced))
                    Text("        |0   3|")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("C₂₃ = (-)|2   0| = -(2(-2) - 0(0)) = -(-4) = 4")
                        .font(.system(.caption, design: .monospaced))
                    Text("        |0  -2|")
                        .font(.system(.caption, design: .monospaced))
                }
                .padding(8)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(6)
                
                // Third row cofactors
                VStack(alignment: .leading, spacing: 8) {
                    Text("Row 3 Cofactors:")
                        .font(.caption)
                        .bold()
                    
                    Text("C₃₁ = (+)|0  -1| = 0(0) - (-1)(1) = 1")
                        .font(.system(.caption, design: .monospaced))
                    Text("        |1   0|")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("C₃₂ = (-)|2  -1| = -(2(0) - (-1)(1)) = -(1) = -1")
                        .font(.system(.caption, design: .monospaced))
                    Text("        |1   0|")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("C₃₃ = (+)|2  0| = 2(1) - 0(1) = 2")
                        .font(.system(.caption, design: .monospaced))
                    Text("        |1  1|")
                        .font(.system(.caption, design: .monospaced))
                }
                .padding(8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(6)
                
                Text("Step 2: Form the Cofactor Matrix")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("""
                        ┌  3  -3  -2 ┐
                    C = │  2   6   4 │
                        └  1  -1   2 ┘
                """)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                
                Text("Step 3: Transpose to Get the Adjugate")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Swap rows and columns: adj(A) = Cᵀ")
                    .font(.body)
                
                Text("""
                            ┌  3   2   1 ┐
                    adj(A) = │ -3   6  -1 │
                            └ -2   4   2 ┘
                """)
                    .font(.system(.body, design: .monospaced))
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
                
                // Verification
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                        Text("Verification")
                            .font(.subheadline)
                            .bold()
                    }
                    
                    Text("det(A) = 2(3) + 0 + (-1)(-2) = 6 + 2 = 8")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("A × adj(A) should equal 8I (8 times the identity matrix)")
                        .font(.caption)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Inverse via Adjugate (Example 143)

struct InverseViaAdjugateView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Finding the Inverse")
                .font(.headline)
            
            Text("Using the same matrix from the adjugate example, find A⁻¹:")
                .font(.body)
            
            Text("""
                    ┌  2   0  -1 ┐
                A = │  1   1   0 │
                    └  0  -2   3 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Step 1: We already computed adj(A)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("""
                            ┌  3   2   1 ┐
                    adj(A) = │ -3   6  -1 │
                            └ -2   4   2 ┘
                """)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                
                Text("Step 2: Calculate det(A)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("det(A) = 8 (computed earlier)")
                    .font(.body)
                
                Text("Since det(A) ≠ 0, the inverse exists!")
                    .font(.caption)
                    .foregroundColor(.green)
                
                Text("Step 3: Apply the Formula")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("A⁻¹ = (1/det A) × adj(A) = (1/8) × adj(A)")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                
                Text("Step 4: Multiply Each Entry by 1/8")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("""
                           ┌  3/8   2/8   1/8 ┐     ┌  3/8   1/4   1/8 ┐
                    A⁻¹ = │ -3/8   6/8  -1/8 │  =  │ -3/8   3/4  -1/8 │
                           └ -2/8   4/8   2/8 ┘     └ -1/4   1/2   1/4 ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
                
                // Verification tip
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                        Text("How to Verify")
                            .font(.subheadline)
                            .bold()
                    }
                    
                    Text("Multiply A × A⁻¹ and check that you get the identity matrix I. If any entry is off, recheck your cofactor calculations.")
                        .font(.caption)
                }
                .padding()
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(8)
            }
            
            // When to use this method
            VStack(alignment: .leading, spacing: 8) {
                Text("When to Use This Method")
                    .font(.subheadline)
                    .bold()
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("When you need a formula for the inverse (symbolic work)")
                    }
                    HStack(alignment: .top) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("For small matrices (2×2 or 3×3)")
                    }
                    HStack(alignment: .top) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("When teaching or learning the theory")
                    }
                    HStack(alignment: .top) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                        Text("For large numerical matrices (row reduction is faster)")
                    }
                }
                .font(.caption)
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Interactive Calculator

struct AdjugateCalculator: View {
    @Binding var matrix: [[String]]
    @Binding var showSolution: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🧮 Interactive Calculator")
                .font(.headline)
            
            Text("Enter your own 3×3 matrix to compute its adjugate and inverse:")
                .font(.body)
            
            // Matrix input
            VStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 6) {
                        ForEach(0..<3, id: \.self) { col in
                            TextField("0", text: $matrix[row][col])
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.center)
                                .frame(width: 50, height: 40)
                                .background(Color(uiColor: .systemBackground))
                                .cornerRadius(6)
                                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.purple.opacity(0.3)))
                        }
                    }
                }
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(10)
            
            Button(action: { showSolution.toggle() }) {
                HStack {
                    Image(systemName: showSolution ? "eye.slash" : "eye")
                    Text(showSolution ? "Hide Solution" : "Calculate Adjugate & Inverse")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple)
                .cornerRadius(10)
            }
            
            if showSolution {
                AdjugateInverseSolutionView(matrix: matrix)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct AdjugateInverseSolutionView: View {
    let matrix: [[String]]
    
    var m: [[Double]] {
        matrix.map { row in
            row.map { Double($0) ?? 0 }
        }
    }
    
    // Calculate cofactors
    func cofactor(_ i: Int, _ j: Int) -> Double {
        let sign = ((i + j) % 2 == 0) ? 1.0 : -1.0
        return sign * minor(i, j)
    }
    
    func minor(_ i: Int, _ j: Int) -> Double {
        var subMatrix: [[Double]] = []
        for row in 0..<3 {
            if row == i { continue }
            var newRow: [Double] = []
            for col in 0..<3 {
                if col == j { continue }
                newRow.append(m[row][col])
            }
            subMatrix.append(newRow)
        }
        return subMatrix[0][0] * subMatrix[1][1] - subMatrix[0][1] * subMatrix[1][0]
    }
    
    var det: Double {
        m[0][0] * cofactor(0, 0) + m[0][1] * cofactor(0, 1) + m[0][2] * cofactor(0, 2)
    }
    
    var adjugate: [[Double]] {
        var adj = [[Double]](repeating: [Double](repeating: 0, count: 3), count: 3)
        for i in 0..<3 {
            for j in 0..<3 {
                adj[j][i] = cofactor(i, j) // Transpose
            }
        }
        return adj
    }
    
    func formatNumber(_ n: Double) -> String {
        if n == floor(n) {
            return String(Int(n))
        }
        return String(format: "%.2f", n)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Determinant: det(A) = \(formatNumber(det))")
                .font(.system(.body, design: .monospaced))
            
            if abs(det) < 0.0001 {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    Text("Matrix is singular (det = 0). No inverse exists!")
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            } else {
                Text("Adjugate:")
                    .font(.subheadline)
                    .bold()
                
                VStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { row in
                        HStack(spacing: 12) {
                            ForEach(0..<3, id: \.self) { col in
                                Text(formatNumber(adjugate[row][col]))
                                    .font(.system(.caption, design: .monospaced))
                                    .frame(minWidth: 40)
                            }
                        }
                    }
                }
                .padding(8)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(6)
                
                Text("Inverse A⁻¹ = (1/\(formatNumber(det))) × adj(A):")
                    .font(.subheadline)
                    .bold()
                
                VStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { row in
                        HStack(spacing: 12) {
                            ForEach(0..<3, id: \.self) { col in
                                Text(formatNumber(adjugate[row][col] / det))
                                    .font(.system(.caption, design: .monospaced))
                                    .frame(minWidth: 50)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(8)
    }
}
