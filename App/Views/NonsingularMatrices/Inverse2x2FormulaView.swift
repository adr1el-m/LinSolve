import SwiftUI

struct Inverse2x2FormulaView: View {
    @State private var matrix: [[String]] = [["1", "3"], ["1", "4"]]
    @State private var showResult: Bool = false
    @State private var determinant: Fraction = Fraction(0, 1)
    @State private var inverseMatrix: [[Fraction]] = []
    @State private var isSingular: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("2×2 Inverse Formula")
                        .font(.largeTitle)
                        .bold()
                    Text("The Direct Formula Method")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
For a **2×2 matrix**, there is a simple closed-form formula to compute the inverse directly. This is much faster than row reduction for small matrices.

**The Formula:**
For matrix A = [a b; c d], the inverse is:

A⁻¹ = (1/(ad-bc)) × [d -b; -c a]

**Key Insight:**
• The term **(ad - bc)** is the **determinant** of the matrix
• If det(A) = 0, the matrix is **singular** (no inverse exists)
• We swap the diagonal elements, negate the off-diagonal elements, and divide by the determinant
""")
                        .font(.body)
                        .padding(.vertical, 4)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Formula Display
                VStack(alignment: .leading, spacing: 12) {
                    Text("The 2×2 Inverse Formula")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        // Original matrix
                        VStack {
                            Text("A")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            MatrixFormulaView(elements: [["a", "b"], ["c", "d"]])
                        }
                        
                        Text("→")
                            .font(.title2)
                        
                        // Inverse
                        VStack {
                            Text("A⁻¹")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack(spacing: 4) {
                                Text("1/(ad-bc)")
                                    .font(.system(.caption, design: .monospaced))
                                Text("×")
                                MatrixFormulaView(elements: [["d", "-b"], ["-c", "a"]])
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                // Input Matrix
                VStack(alignment: .leading, spacing: 16) {
                    Text("Enter Your 2×2 Matrix")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        Text("A =")
                            .font(.title2)
                        
                        VStack(spacing: 6) {
                            ForEach(0..<2, id: \.self) { row in
                                HStack(spacing: 8) {
                                    ForEach(0..<2, id: \.self) { col in
                                        TextField("0", text: $matrix[row][col])
                                            .keyboardType(.numbersAndPunctuation)
                                            .multilineTextAlignment(.center)
                                            .frame(width: 60, height: 40)
                                            .background(Color(uiColor: .systemBackground))
                                            .cornerRadius(8)
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue.opacity(0.5)))
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            HStack {
                                BracketShape(left: true).stroke(Color.primary, lineWidth: 1.5).frame(width: 8)
                                Spacer()
                                BracketShape(left: false).stroke(Color.primary, lineWidth: 1.5).frame(width: 8)
                            }
                        )
                    }
                    
                    Button(action: calculateInverse) {
                        Text("Calculate Inverse")
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
                        Text("Step-by-Step Solution")
                            .font(.title2)
                            .bold()
                        
                        let a = Fraction(string: matrix[0][0])
                        let b = Fraction(string: matrix[0][1])
                        let c = Fraction(string: matrix[1][0])
                        let d = Fraction(string: matrix[1][1])
                        
                        // Step 1: Identify elements
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Step 1: Identify Matrix Elements")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            HStack(spacing: 30) {
                                Text("a = \(a.description)")
                                Text("b = \(b.description)")
                                Text("c = \(c.description)")
                                Text("d = \(d.description)")
                            }
                            .font(.system(.body, design: .monospaced))
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                        
                        // Step 2: Calculate determinant
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Step 2: Calculate the Determinant")
                                .font(.headline)
                                .foregroundColor(.purple)
                            
                            let ad = a * d
                            let bc = b * c
                            
                            Text("det(A) = ad - bc")
                                .font(.body)
                            Text("det(A) = (\(a.description))(\(d.description)) - (\(b.description))(\(c.description))")
                                .font(.system(.body, design: .monospaced))
                            Text("det(A) = \(ad.description) - \(bc.description)")
                                .font(.system(.body, design: .monospaced))
                            Text("det(A) = \(determinant.description)")
                                .font(.system(.title3, design: .monospaced))
                                .bold()
                                .foregroundColor(isSingular ? .red : .green)
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                        
                        if isSingular {
                            // Singular case
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.red)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Matrix is Singular!")
                                            .font(.title2)
                                            .bold()
                                        Text("Since det(A) = 0, the matrix has no inverse.")
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Text("""
**Why does this happen?**
When the determinant is zero, it means the matrix transforms space into a lower dimension (all vectors get compressed onto a line or point). This transformation cannot be reversed, hence no inverse exists.
""")
                                    .font(.body)
                            }
                            .padding()
                            .background(Color.red.opacity(0.15))
                            .cornerRadius(12)
                        } else {
                            // Step 3: Apply formula
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Step 3: Apply the Inverse Formula")
                                    .font(.headline)
                                    .foregroundColor(.orange)
                                
                                Text("A⁻¹ = (1/\(determinant.description)) × [d -b; -c a]")
                                    .font(.system(.body, design: .monospaced))
                                
                                let negB = Fraction(0, 1) - b
                                let negC = Fraction(0, 1) - c
                                
                                Text("A⁻¹ = (1/\(determinant.description)) × [\(d.description) \(negB.description); \(negC.description) \(a.description)]")
                                    .font(.system(.body, design: .monospaced))
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(10)
                            
                            // Final Result
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.green)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Inverse Found!")
                                            .font(.title2)
                                            .bold()
                                        Text("A⁻¹ is shown below")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                HStack(spacing: 20) {
                                    Text("A⁻¹ =")
                                        .font(.title2)
                                    
                                    InverseResultMatrixView(matrix: inverseMatrix)
                                }
                            }
                            .padding()
                            .background(Color.green.opacity(0.15))
                            .cornerRadius(12)
                            
                            // Verification hint
                            VStack(alignment: .leading, spacing: 8) {
                                Text("💡 Verification Tip")
                                    .font(.headline)
                                Text("You can verify this is correct by multiplying A × A⁻¹. The result should be the identity matrix I₂.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color.yellow.opacity(0.1))
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
    
    func calculateInverse() {
        let a = Fraction(string: matrix[0][0])
        let b = Fraction(string: matrix[0][1])
        let c = Fraction(string: matrix[1][0])
        let d = Fraction(string: matrix[1][1])
        
        // Calculate determinant
        determinant = (a * d) - (b * c)
        
        if determinant == Fraction(0, 1) {
            isSingular = true
            inverseMatrix = []
        } else {
            isSingular = false
            // Apply formula: A⁻¹ = (1/det) * [d -b; -c a]
            let invDet = Fraction(1, 1) / determinant
            inverseMatrix = [
                [d * invDet, (Fraction(0, 1) - b) * invDet],
                [(Fraction(0, 1) - c) * invDet, a * invDet]
            ]
        }
        
        withAnimation {
            showResult = true
        }
    }
}

struct MatrixFormulaView: View {
    let elements: [[String]]
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<elements.count, id: \.self) { row in
                HStack(spacing: 16) {
                    ForEach(0..<elements[row].count, id: \.self) { col in
                        Text(elements[row][col])
                            .font(.system(.body, design: .serif))
                            .italic()
                            .frame(minWidth: 25)
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
}

struct InverseResultMatrixView: View {
    let matrix: [[Fraction]]
    
    var body: some View {
        VStack(spacing: 6) {
            ForEach(0..<matrix.count, id: \.self) { row in
                HStack(spacing: 16) {
                    ForEach(0..<matrix[row].count, id: \.self) { col in
                        Text(matrix[row][col].description)
                            .font(.system(.body, design: .monospaced))
                            .frame(minWidth: 50)
                    }
                }
            }
        }
        .padding(12)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(8)
        .overlay(
            HStack {
                BracketShape(left: true).stroke(Color.primary, lineWidth: 1.5).frame(width: 8)
                Spacer()
                BracketShape(left: false).stroke(Color.primary, lineWidth: 1.5).frame(width: 8)
            }
        )
    }
}
