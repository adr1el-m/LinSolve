import SwiftUI

struct MatrixMultiplicationView: View {
    // Default matrices from example
    @State private var matrixA: [[String]] = [
        ["2", "-1"],
        ["1", "0"]
    ]
    @State private var matrixB: [[String]] = [
        ["2", "-3", "1"],
        ["0", "1", "2"]
    ]
    
    @State private var showSteps: Bool = false
    @State private var result: [[Fraction]] = []
    @State private var cellCalculations: [[(String, Fraction)]] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Matrix Multiplication")
                        .font(.largeTitle)
                        .bold()
                    Text("Row-by-Column Method")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
Matrix multiplication is fundamentally different from element-wise operations. Instead of simply multiplying corresponding entries, we use the **row-by-column** method: each entry in the result is computed by taking the **dot product** of a row from the first matrix with a column from the second.

**Critical Dimension Rule:**
To multiply A (m × n) by B (p × q):
• The inner dimensions must match: **n = p**
• Result size: **m × q**
""")
                        .font(.body)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Formula
                VStack(alignment: .leading, spacing: 12) {
                    Text("The Row-by-Column Formula")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        Text("(AB)ᵢⱼ = Σₖ Aᵢₖ · Bₖⱼ")
                            .font(.system(.title2, design: .serif))
                            .italic()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("Entry (i,j) of AB = (Row i of A) · (Column j of B)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("**⚠️ Non-Commutative:**")
                            .font(.subheadline)
                        Text("AB ≠ BA in general! Matrix multiplication order matters.")
                            .font(.body)
                            .foregroundColor(.orange)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                // Input Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Input Matrices")
                        .font(.headline)
                    
                    HStack(spacing: 8) {
                        Text("A: \(matrixA.count) × \(matrixA.first?.count ?? 0)")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text("·")
                        Text("B: \(matrixB.count) × \(matrixB.first?.count ?? 0)")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("→")
                        Text("AB: \(matrixA.count) × \(matrixB.first?.count ?? 0)")
                            .font(.caption)
                            .foregroundColor(.purple)
                            .bold()
                    }
                    .padding(8)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(6)
                    
                    HStack(alignment: .top, spacing: 30) {
                        VStack {
                            Text("Matrix A")
                                .font(.headline)
                                .foregroundColor(.blue)
                            MatrixEditor(matrix: $matrixA, color: .blue)
                        }
                        
                        Text("×")
                            .font(.largeTitle)
                            .padding(.top, 40)
                        
                        VStack {
                            Text("Matrix B")
                                .font(.headline)
                                .foregroundColor(.green)
                            MatrixEditor(matrix: $matrixB, color: .green)
                        }
                    }
                    
                    // Dimension check
                    if matrixA.first?.count != matrixB.count {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text("Dimension mismatch! A has \(matrixA.first?.count ?? 0) columns but B has \(matrixB.count) rows.")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Button(action: compute) {
                        Text("Multiply Matrices")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background((matrixA.first?.count == matrixB.count) ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(matrixA.first?.count != matrixB.count)
                }
                .padding()
                
                // Solution
                if showSteps {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Step-by-Step Solution")
                            .font(.title2)
                            .bold()
                        
                        Text("For each entry (i,j), we compute the dot product of row i from A and column j from B:")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        // Show calculations for each cell
                        ForEach(0..<result.count, id: \.self) { row in
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Row \(row + 1) of Result:")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                ForEach(0..<result[row].count, id: \.self) { col in
                                    HStack(alignment: .top) {
                                        Text("(\(row+1),\(col+1)):")
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundColor(.secondary)
                                            .frame(width: 40)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(cellCalculations[row][col].0)
                                                .font(.system(.caption, design: .monospaced))
                                            Text("= \(cellCalculations[row][col].1.description)")
                                                .font(.system(.body, design: .monospaced))
                                                .bold()
                                        }
                                    }
                                    .padding(6)
                                    .background(Color(uiColor: .tertiarySystemBackground))
                                    .cornerRadius(4)
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
                                    Text("AB =")
                                        .font(.headline)
                                    MatrixResultDisplay(matrix: result, color: .green)
                                }
                            }
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                        
                        // Properties
                        VStack(alignment: .leading, spacing: 8) {
                            Text("📐 Properties of Matrix Multiplication")
                                .font(.headline)
                            
                            Text("""
• **Associative**: (AB)C = A(BC)
• **Distributive**: A(B + C) = AB + AC
• **NOT Commutative**: AB ≠ BA (in general)
• **Identity**: AI = IA = A (where I is the identity matrix)
• **Transpose**: (AB)ᵀ = BᵀAᵀ (reverse order!)
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
    
    func compute() {
        guard let aCols = matrixA.first?.count, aCols == matrixB.count else { return }
        
        let a = matrixA.map { row in row.map { Fraction(string: $0) } }
        let b = matrixB.map { row in row.map { Fraction(string: $0) } }
        
        let m = a.count
        let n = b.first?.count ?? 0
        
        result = []
        cellCalculations = []
        
        for i in 0..<m {
            var resultRow: [Fraction] = []
            var calcRow: [(String, Fraction)] = []
            
            for j in 0..<n {
                // Compute dot product of row i of A and column j of B
                var sum = Fraction(0)
                var terms: [String] = []
                
                for k in 0..<aCols {
                    let product = a[i][k] * b[k][j]
                    sum = sum + product
                    terms.append("(\(a[i][k].description))(\(b[k][j].description))")
                }
                
                resultRow.append(sum)
                calcRow.append((terms.joined(separator: " + "), sum))
            }
            
            result.append(resultRow)
            cellCalculations.append(calcRow)
        }
        
        withAnimation {
            showSteps = true
        }
    }
}

struct MatrixEditor: View {
    @Binding var matrix: [[String]]
    var color: Color = .primary
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<matrix.count, id: \.self) { r in
                HStack(spacing: 4) {
                    ForEach(0..<matrix[r].count, id: \.self) { c in
                        TextField("0", text: $matrix[r][c])
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.center)
                            .frame(width: 40, height: 32)
                            .background(Color(uiColor: .systemBackground))
                            .cornerRadius(4)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(color.opacity(0.4)))
                    }
                }
            }
        }
        .padding(8)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(8)
    }
}

struct MatrixResultDisplay: View {
    let matrix: [[Fraction]]
    var color: Color = .primary
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<matrix.count, id: \.self) { r in
                HStack(spacing: 10) {
                    ForEach(0..<matrix[r].count, id: \.self) { c in
                        Text(matrix[r][c].description)
                            .font(.system(.body, design: .monospaced))
                            .frame(minWidth: 40)
                    }
                }
            }
        }
        .padding(10)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(8)
        .overlay(
            HStack {
                BracketShape(left: true).stroke(color, lineWidth: 1.5).frame(width: 8)
                Spacer()
                BracketShape(left: false).stroke(color, lineWidth: 1.5).frame(width: 8)
            }
        )
    }
}
