import SwiftUI

struct BasicDeterminantCalcView: View {
    // 2x2 matrix input
    @State private var matrix2x2: [[String]] = [
        ["4", "-2"],
        ["5", "-3"]
    ]
    @State private var show2x2Result: Bool = false
    @State private var det2x2Result: Fraction = Fraction(0)
    
    // 3x3 matrix input
    @State private var matrix3x3: [[String]] = [
        ["2", "-1", "3"],
        ["1", "5", "0"],
        ["-2", "1", "4"]
    ]
    @State private var show3x3Result: Bool = false
    @State private var det3x3Result: Fraction = Fraction(0)
    @State private var downDiag: Fraction = Fraction(0)
    @State private var upDiag: Fraction = Fraction(0)
    
    @State private var selectedMethod: Int = 0  // 0 = Rule of Sarrus, 1 = Cofactor
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Computing Determinants")
                        .font(.largeTitle)
                        .bold()
                    Text("From Simple 2×2 to Any Size Matrix")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("What is a Determinant?")
                            .font(.headline)
                        
                        Text("""
The **determinant** is a special number computed from a square matrix. Think of it as a "summary" that tells you crucial information about the matrix at a glance.

**What the Determinant Tells You:**
• **det(A) ≠ 0** → The matrix is invertible (you can "undo" it)
• **det(A) = 0** → The matrix is singular (not invertible, "squishes" space to a lower dimension)
• **|det(A)|** → The factor by which the matrix scales areas (2D) or volumes (3D)
• **sign(det(A))** → Whether the transformation preserves (+) or reverses (−) orientation

**Geometric Intuition:** If you apply a matrix to a unit square, the determinant tells you the area of the resulting parallelogram. A determinant of 2 means the area doubled; a determinant of −1 means the area is preserved but the orientation flipped (like a mirror).
""")
                            .font(.body)
                        
                        // Quick reference card
                        HStack(spacing: 16) {
                            VStack {
                                Text("det > 0")
                                    .font(.caption).bold()
                                Image(systemName: "arrow.right.square")
                                    .font(.title2)
                                    .foregroundColor(.green)
                                Text("Preserves\norientation")
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                            
                            VStack {
                                Text("det < 0")
                                    .font(.caption).bold()
                                Image(systemName: "arrow.left.arrow.right.square")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                Text("Reverses\norientation")
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                            
                            VStack {
                                Text("det = 0")
                                    .font(.caption).bold()
                                Image(systemName: "rectangle.compress.vertical")
                                    .font(.title2)
                                    .foregroundColor(.red)
                                Text("Collapses\ndimension")
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Section 1: 2x2 Determinant
                VStack(alignment: .leading, spacing: 16) {
                    Text("1. The 2×2 Determinant Formula")
                        .font(.title2)
                        .bold()
                    
                    Text("""
For a 2×2 matrix, the determinant has a simple closed-form formula:

**det(A) = a·d − b·c**

Where the matrix is:
┌ a  b ┐
└ c  d ┘

**Memory trick:** Multiply the main diagonal (↘) and subtract the anti-diagonal (↗).
""")
                        .font(.body)
                    
                    // Interactive 2x2 Calculator
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Try It: 2×2 Determinant")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        HStack(spacing: 20) {
                            // Matrix input
                            VStack(spacing: 4) {
                                HStack(spacing: 4) {
                                    TextField("a", text: $matrix2x2[0][0])
                                        .frame(width: 50)
                                        .textFieldStyle(.roundedBorder)
                                        .keyboardType(.numbersAndPunctuation)
                                    TextField("b", text: $matrix2x2[0][1])
                                        .frame(width: 50)
                                        .textFieldStyle(.roundedBorder)
                                        .keyboardType(.numbersAndPunctuation)
                                }
                                HStack(spacing: 4) {
                                    TextField("c", text: $matrix2x2[1][0])
                                        .frame(width: 50)
                                        .textFieldStyle(.roundedBorder)
                                        .keyboardType(.numbersAndPunctuation)
                                    TextField("d", text: $matrix2x2[1][1])
                                        .frame(width: 50)
                                        .textFieldStyle(.roundedBorder)
                                        .keyboardType(.numbersAndPunctuation)
                                }
                            }
                            .padding(8)
                            .background(Color(uiColor: .tertiarySystemBackground))
                            .cornerRadius(8)
                            
                            Button("Calculate") {
                                compute2x2Determinant()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        
                        if show2x2Result {
                            VStack(alignment: .leading, spacing: 8) {
                                let a = matrix2x2[0][0]
                                let b = matrix2x2[0][1]
                                let c = matrix2x2[1][0]
                                let d = matrix2x2[1][1]
                                
                                Text("Step-by-step:")
                                    .font(.subheadline)
                                    .bold()
                                
                                Text("det(A) = (\(a))(\(d)) − (\(c))(\(b))")
                                    .font(.system(.body, design: .monospaced))
                                
                                let ad = Fraction(string: a) * Fraction(string: d)
                                let bc = Fraction(string: c) * Fraction(string: b)
                                
                                Text("       = \(ad.description) − \(bc.description)")
                                    .font(.system(.body, design: .monospaced))
                                
                                HStack {
                                    Text("       =")
                                        .font(.system(.body, design: .monospaced))
                                    Text("\(det2x2Result.description)")
                                        .font(.system(.title3, design: .monospaced))
                                        .bold()
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Section 2: 3x3 Determinant with Rule of Sarrus
                VStack(alignment: .leading, spacing: 16) {
                    Text("2. The 3×3 Determinant")
                        .font(.title2)
                        .bold()
                    
                    Picker("Method", selection: $selectedMethod) {
                        Text("Rule of Sarrus").tag(0)
                        Text("Cofactor Expansion").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    if selectedMethod == 0 {
                        Text("""
**Rule of Sarrus (Diagonal Method):**

For a 3×3 matrix, copy the first two columns to the right, then:
1. Add products of the three **downward diagonals** (↘)
2. Subtract products of the three **upward diagonals** (↗)

This only works for 3×3 matrices!
""")
                            .font(.body)
                    } else {
                        Text("""
**Cofactor Expansion:**

Expand along any row or column by:
1. For each element, multiply by its cofactor
2. The cofactor = (−1)^(i+j) × determinant of the minor
3. Sum all contributions

**det(A) = a₁₁C₁₁ + a₁₂C₁₂ + a₁₃C₁₃** (expanding along row 1)
""")
                            .font(.body)
                    }
                    
                    // Interactive 3x3 Calculator
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Try It: 3×3 Determinant")
                            .font(.headline)
                            .foregroundColor(.purple)
                        
                        // Matrix input
                        VStack(spacing: 4) {
                            ForEach(0..<3, id: \.self) { row in
                                HStack(spacing: 4) {
                                    ForEach(0..<3, id: \.self) { col in
                                        TextField("0", text: $matrix3x3[row][col])
                                            .frame(width: 45)
                                            .textFieldStyle(.roundedBorder)
                                            .keyboardType(.numbersAndPunctuation)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                        }
                        .padding(8)
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(8)
                        
                        Button("Calculate") {
                            compute3x3Determinant()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.purple)
                        
                        if show3x3Result && selectedMethod == 0 {
                            SarrusStepsView(
                                matrix: matrix3x3,
                                downDiag: downDiag,
                                upDiag: upDiag,
                                result: det3x3Result
                            )
                        } else if show3x3Result && selectedMethod == 1 {
                            CofactorStepsView(
                                matrix: matrix3x3,
                                result: det3x3Result
                            )
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Worked Examples Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("3. Worked Examples")
                        .font(.title2)
                        .bold()
                    
                    // Example 1
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Example: 3×3 with Zero Determinant")
                            .font(.headline)
                            .foregroundColor(.orange)
                        
                        Text("""
Matrix:
┌ −5   1   2 ┐
│  1   2   3 │
└ −4   3   5 ┘

**Calculation using Row 1 expansion:**
""")
                            .font(.body)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("det = (−5)|2 3| − (1)|1 3| + (2)|1 2|")
                                .font(.system(.caption, design: .monospaced))
                            Text("            |3 5|      |−4 5|     |−4 3|")
                                .font(.system(.caption, design: .monospaced))
                            Text("")
                            Text("    = (−5)(10−9) − (1)(5+12) + (2)(3+8)")
                                .font(.system(.caption, design: .monospaced))
                            Text("    = (−5)(1) − (1)(17) + (2)(11)")
                                .font(.system(.caption, design: .monospaced))
                            Text("    = −5 − 17 + 22")
                                .font(.system(.caption, design: .monospaced))
                            Text("    = 0")
                                .font(.system(.body, design: .monospaced))
                                .bold()
                                .foregroundColor(.orange)
                        }
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                        
                        Text("**Interpretation:** A determinant of 0 means the matrix is **singular** (not invertible) and its rows/columns are linearly dependent.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(10)
                    
                    // Example 2: Sparse Matrix
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Example: Sparse 4×4 Matrix")
                            .font(.headline)
                            .foregroundColor(.teal)
                        
                        Text("""
When a matrix has many zeros, we can use a shortcut. Consider:

┌ 3  0  0  0 ┐
│ 0  0  4  0 │
│ 0 −3  0  0 │
│ 0  0  0  5 │

Only **one permutation** contributes (the one matching non-zero entries):
• Row 1 uses column 1 (value 3)
• Row 2 uses column 3 (value 4)
• Row 3 uses column 2 (value −3)
• Row 4 uses column 4 (value 5)

Permutation π = 1324 → Check inversions: (2,3) → 3 > 2 → 1 inversion → **Odd** → Sign = −1

**det = (−1) × 3 × 4 × (−3) × 5 = (−1) × (−180) = 180**
""")
                            .font(.body)
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .onChange(of: selectedMethod) { _ in
            show3x3Result = false
        }
    }
    
    // MARK: - Computation Functions
    
    func compute2x2Determinant() {
        let a = Fraction(string: matrix2x2[0][0])
        let b = Fraction(string: matrix2x2[0][1])
        let c = Fraction(string: matrix2x2[1][0])
        let d = Fraction(string: matrix2x2[1][1])
        
        det2x2Result = (a * d) - (b * c)
        
        withAnimation {
            show2x2Result = true
        }
    }
    
    func compute3x3Determinant() {
        let m = matrix3x3.map { row in row.map { Fraction(string: $0) } }
        
        // Downward diagonals
        let d1 = m[0][0] * m[1][1] * m[2][2]
        let d2 = m[0][1] * m[1][2] * m[2][0]
        let d3 = m[0][2] * m[1][0] * m[2][1]
        downDiag = d1 + d2 + d3
        
        // Upward diagonals
        let u1 = m[2][0] * m[1][1] * m[0][2]
        let u2 = m[2][1] * m[1][2] * m[0][0]
        let u3 = m[2][2] * m[1][0] * m[0][1]
        upDiag = u1 + u2 + u3
        
        det3x3Result = downDiag - upDiag
        
        withAnimation {
            show3x3Result = true
        }
    }
}

// MARK: - Supporting Views

struct SarrusStepsView: View {
    let matrix: [[String]]
    let downDiag: Fraction
    let upDiag: Fraction
    let result: Fraction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rule of Sarrus Steps:")
                .font(.subheadline)
                .bold()
            
            // Visual representation
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { col in
                    VStack(spacing: 2) {
                        ForEach(0..<3, id: \.self) { row in
                            let actualCol = col % 3
                            Text(matrix[row][actualCol])
                                .font(.system(.caption, design: .monospaced))
                                .frame(width: 30, height: 25)
                                .background(col >= 3 ? Color.gray.opacity(0.2) : Color.clear)
                                .cornerRadius(4)
                        }
                    }
                }
            }
            .padding(8)
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(8)
            
            let m = matrix.map { row in row.map { Fraction(string: $0).description } }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("↘ Downward diagonals (add):")
                    .font(.caption)
                    .foregroundColor(.red)
                Text("(\(m[0][0]))(\(m[1][1]))(\(m[2][2])) + (\(m[0][1]))(\(m[1][2]))(\(m[2][0])) + (\(m[0][2]))(\(m[1][0]))(\(m[2][1])) = \(downDiag.description)")
                    .font(.system(.caption, design: .monospaced))
                
                Text("↗ Upward diagonals (subtract):")
                    .font(.caption)
                    .foregroundColor(.blue)
                Text("(\(m[2][0]))(\(m[1][1]))(\(m[0][2])) + (\(m[2][1]))(\(m[1][2]))(\(m[0][0])) + (\(m[2][2]))(\(m[1][0]))(\(m[0][1])) = \(upDiag.description)")
                    .font(.system(.caption, design: .monospaced))
            }
            
            HStack {
                Text("det(A) = \(downDiag.description) − \(upDiag.description) =")
                    .font(.system(.body, design: .monospaced))
                Text(result.description)
                    .font(.system(.title3, design: .monospaced))
                    .bold()
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(8)
    }
}

struct CofactorStepsView: View {
    let matrix: [[String]]
    let result: Fraction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cofactor Expansion (Row 1):")
                .font(.subheadline)
                .bold()
            
            let m = matrix.map { row in row.map { Fraction(string: $0) } }
            
            // Calculate minors
            let M11 = m[1][1] * m[2][2] - m[1][2] * m[2][1]
            let M12 = m[1][0] * m[2][2] - m[1][2] * m[2][0]
            let M13 = m[1][0] * m[2][1] - m[1][1] * m[2][0]
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Expanding along row 1:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("det = a₁₁C₁₁ + a₁₂C₁₂ + a₁₃C₁₃")
                    .font(.system(.caption, design: .monospaced))
                
                Text("    = (\(m[0][0].description))(+M₁₁) + (\(m[0][1].description))(−M₁₂) + (\(m[0][2].description))(+M₁₃)")
                    .font(.system(.caption, design: .monospaced))
                
                Text("Minor M₁₁ = \(M11.description), M₁₂ = \(M12.description), M₁₃ = \(M13.description)")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
                
                let term1 = m[0][0] * M11
                let term2 = m[0][1] * M12
                let term3 = m[0][2] * M13
                
                Text("    = (\(term1.description)) − (\(term2.description)) + (\(term3.description))")
                    .font(.system(.caption, design: .monospaced))
            }
            
            HStack {
                Text("det(A) =")
                    .font(.system(.body, design: .monospaced))
                Text(result.description)
                    .font(.system(.title3, design: .monospaced))
                    .bold()
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(8)
    }
}
