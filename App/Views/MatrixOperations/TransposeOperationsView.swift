import SwiftUI

struct TransposeOperationsView: View {
    // Default matrices
    @State private var matrixA: [[String]] = [
        ["1", "2"],
        ["3", "4"],
        ["5", "6"]
    ]
    @State private var matrixB: [[String]] = [
        ["1", "0"],
        ["2", "1"]
    ]
    
    @State private var showSteps: Bool = false
    @State private var selectedOperation: TransposeOperation = .basic
    
    // Results
    @State private var transposeA: [[Fraction]] = []
    @State private var transposeB: [[Fraction]] = []
    @State private var intermediateResults: [[[Fraction]]] = []
    @State private var finalResult: [[Fraction]] = []
    
    enum TransposeOperation: String, CaseIterable {
        case basic = "Aᵀ"
        case sumTranspose = "(A + B)ᵀ"
        case productTranspose = "(AB)ᵀ"
        case combined = "(BAᵀ + ABᵀ)ᵀ"
        
        var description: String {
            switch self {
            case .basic: return "Compute the transpose of A"
            case .sumTranspose: return "Transpose of a sum: (A + B)ᵀ = Aᵀ + Bᵀ"
            case .productTranspose: return "Transpose of a product: (AB)ᵀ = BᵀAᵀ (reversed!)"
            case .combined: return "Complex expression with multiple transpose operations"
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Transpose Operations")
                        .font(.largeTitle)
                        .bold()
                    Text("Flipping Matrices Across the Diagonal")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
The **transpose** of a matrix A, denoted Aᵀ, is obtained by **interchanging rows and columns**. The element at position (i,j) in A becomes the element at position (j,i) in Aᵀ.

**Definition:** If A is m × n, then Aᵀ is n × m, with (Aᵀ)ᵢⱼ = Aⱼᵢ

Think of it as "flipping" the matrix along its main diagonal.
""")
                        .font(.body)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Properties
                VStack(alignment: .leading, spacing: 12) {
                    Text("Key Properties of Transpose")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        TransposePropertyRow(
                            property: "(Aᵀ)ᵀ = A",
                            description: "Transposing twice returns the original"
                        )
                        TransposePropertyRow(
                            property: "(A + B)ᵀ = Aᵀ + Bᵀ",
                            description: "Transpose distributes over addition"
                        )
                        TransposePropertyRow(
                            property: "(cA)ᵀ = cAᵀ",
                            description: "Scalars factor out"
                        )
                        TransposePropertyRow(
                            property: "(AB)ᵀ = BᵀAᵀ",
                            description: "⚠️ Order reverses for products!"
                        )
                    }
                    
                    // Special matrices
                    VStack(alignment: .leading, spacing: 8) {
                        Text("**Special Cases:**")
                            .font(.subheadline)
                        Text("• **Symmetric**: Aᵀ = A (unchanged by transpose)")
                            .font(.body)
                        Text("• **Skew-Symmetric**: Aᵀ = -A (negates under transpose)")
                            .font(.body)
                    }
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                // Input Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Input Matrices")
                        .font(.headline)
                    
                    Picker("Operation", selection: $selectedOperation) {
                        ForEach(TransposeOperation.allCases, id: \.self) { op in
                            Text(op.rawValue).tag(op)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Text(selectedOperation.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(alignment: .top, spacing: 30) {
                        VStack {
                            Text("A (\(matrixA.count)×\(matrixA.first?.count ?? 0))")
                                .font(.caption)
                                .foregroundColor(.blue)
                            TransposeMatrixInput(matrix: $matrixA, color: .blue)
                        }
                        
                        if selectedOperation != .basic {
                            VStack {
                                Text("B (\(matrixB.count)×\(matrixB.first?.count ?? 0))")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                TransposeMatrixInput(matrix: $matrixB, color: .green)
                            }
                        }
                    }
                    
                    Button(action: compute) {
                        Text("Compute Transpose")
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
                        
                        switch selectedOperation {
                        case .basic:
                            BasicTransposeSteps(original: matrixA, result: transposeA)
                        case .sumTranspose:
                            SumTransposeSteps(
                                matrixA: matrixA,
                                matrixB: matrixB,
                                transposeA: transposeA,
                                transposeB: transposeB,
                                result: finalResult
                            )
                        case .productTranspose:
                            ProductTransposeSteps(
                                matrixA: matrixA,
                                matrixB: matrixB,
                                transposeA: transposeA,
                                transposeB: transposeB,
                                result: finalResult
                            )
                        case .combined:
                            CombinedTransposeSteps(
                                matrixA: matrixA,
                                matrixB: matrixB,
                                intermediates: intermediateResults,
                                result: finalResult
                            )
                        }
                        
                        // Theorem note
                        if selectedOperation == .combined {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("🔍 Theoretical Insight")
                                    .font(.headline)
                                
                                Text("""
For the expression (BAᵀ + ABᵀ)ᵀ, we can show:

(BAᵀ + ABᵀ)ᵀ = (BAᵀ)ᵀ + (ABᵀ)ᵀ = (Aᵀ)ᵀBᵀ + (Bᵀ)ᵀAᵀ = ABᵀ + BAᵀ

This equals the original expression, meaning (BAᵀ + ABᵀ) is **symmetric**!
""")
                                    .font(.body)
                            }
                            .padding()
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(12)
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
        let a = matrixA.map { row in row.map { Fraction(string: $0) } }
        let b = matrixB.map { row in row.map { Fraction(string: $0) } }
        
        transposeA = transpose(a)
        transposeB = transpose(b)
        intermediateResults = []
        
        switch selectedOperation {
        case .basic:
            finalResult = transposeA
            
        case .sumTranspose:
            // (A + B)^T = A^T + B^T (assuming same size)
            finalResult = add(transposeA, transposeB)
            
        case .productTranspose:
            // (AB)^T = B^T A^T
            finalResult = multiply(transposeB, transposeA)
            
        case .combined:
            // (BA^T + AB^T)^T
            let baT = multiply(b, transposeA)
            let abT = multiply(a, transposeB)
            intermediateResults.append(baT)
            intermediateResults.append(abT)
            let sum = add(baT, abT)
            intermediateResults.append(sum)
            finalResult = transpose(sum)
        }
        
        withAnimation {
            showSteps = true
        }
    }
    
    func transpose(_ m: [[Fraction]]) -> [[Fraction]] {
        guard !m.isEmpty else { return [] }
        let rows = m.count
        let cols = m[0].count
        var result = [[Fraction]](repeating: [Fraction](repeating: Fraction(0), count: rows), count: cols)
        for i in 0..<rows {
            for j in 0..<cols {
                result[j][i] = m[i][j]
            }
        }
        return result
    }
    
    func add(_ a: [[Fraction]], _ b: [[Fraction]]) -> [[Fraction]] {
        return zip(a, b).map { rowPair in
            zip(rowPair.0, rowPair.1).map { $0 + $1 }
        }
    }
    
    func multiply(_ a: [[Fraction]], _ b: [[Fraction]]) -> [[Fraction]] {
        let m = a.count
        guard m > 0 else { return [] }
        let n = b.first?.count ?? 0
        let k = a.first?.count ?? 0
        
        var result = [[Fraction]](repeating: [Fraction](repeating: Fraction(0), count: n), count: m)
        for i in 0..<m {
            for j in 0..<n {
                var sum = Fraction(0)
                for p in 0..<k {
                    sum = sum + (a[i][p] * b[p][j])
                }
                result[i][j] = sum
            }
        }
        return result
    }
}

// MARK: - Supporting Views

struct TransposePropertyRow: View {
    let property: String
    let description: String
    
    var body: some View {
        HStack {
            Text(property)
                .font(.system(.body, design: .serif))
                .italic()
                .frame(width: 120, alignment: .leading)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(6)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(4)
    }
}

struct TransposeMatrixInput: View {
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
                            .frame(width: 40, height: 30)
                            .background(Color(uiColor: .systemBackground))
                            .cornerRadius(4)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(color.opacity(0.4)))
                    }
                }
            }
        }
        .padding(6)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(6)
    }
}

struct BasicTransposeSteps: View {
    let original: [[String]]
    let result: [[Fraction]]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 10) {
                Text("How Transpose Works")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text("Row i of A becomes Column i of Aᵀ:")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(0..<original.count, id: \.self) { i in
                        Text("Row \(i+1) of A → Column \(i+1) of Aᵀ: [\(original[i].joined(separator: ", "))]")
                            .font(.system(.caption, design: .monospaced))
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Result")
                    .font(.headline)
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Aᵀ (\(result.count)×\(result.first?.count ?? 0)) =")
                        .font(.headline)
                    MatrixResultDisplay(matrix: result, color: .green)
                }
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct SumTransposeSteps: View {
    let matrixA: [[String]]
    let matrixB: [[String]]
    let transposeA: [[Fraction]]
    let transposeB: [[Fraction]]
    let result: [[Fraction]]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Using: (A + B)ᵀ = Aᵀ + Bᵀ")
                .font(.system(.body, design: .serif))
                .italic()
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
            
            HStack(spacing: 20) {
                VStack {
                    Text("Aᵀ =")
                    MatrixResultDisplay(matrix: transposeA, color: .blue)
                }
                VStack {
                    Text("Bᵀ =")
                    MatrixResultDisplay(matrix: transposeB, color: .green)
                }
            }
            
            VStack(alignment: .leading) {
                Text("Result: Aᵀ + Bᵀ =")
                    .font(.headline)
                MatrixResultDisplay(matrix: result, color: .green)
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct ProductTransposeSteps: View {
    let matrixA: [[String]]
    let matrixB: [[String]]
    let transposeA: [[Fraction]]
    let transposeB: [[Fraction]]
    let result: [[Fraction]]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("⚠️ Key Insight: Order Reverses!")
                    .font(.headline)
                    .foregroundColor(.orange)
                
                Text("(AB)ᵀ = BᵀAᵀ  (NOT AᵀBᵀ)")
                    .font(.system(.body, design: .serif))
                    .italic()
                    .padding(8)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(6)
            }
            
            HStack(spacing: 20) {
                VStack {
                    Text("Bᵀ =")
                    MatrixResultDisplay(matrix: transposeB, color: .green)
                }
                Text("×")
                VStack {
                    Text("Aᵀ =")
                    MatrixResultDisplay(matrix: transposeA, color: .blue)
                }
            }
            
            VStack(alignment: .leading) {
                Text("Result: (AB)ᵀ = BᵀAᵀ =")
                    .font(.headline)
                MatrixResultDisplay(matrix: result, color: .green)
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct CombinedTransposeSteps: View {
    let matrixA: [[String]]
    let matrixB: [[String]]
    let intermediates: [[[Fraction]]]
    let result: [[Fraction]]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Computing (BAᵀ + ABᵀ)ᵀ")
                .font(.headline)
                .foregroundColor(.purple)
            
            if intermediates.count >= 3 {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 1: BAᵀ =")
                    MatrixResultDisplay(matrix: intermediates[0], color: .blue)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 2: ABᵀ =")
                    MatrixResultDisplay(matrix: intermediates[1], color: .green)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 3: BAᵀ + ABᵀ =")
                    MatrixResultDisplay(matrix: intermediates[2], color: .orange)
                }
            }
            
            VStack(alignment: .leading) {
                Text("Step 4: Final Result (BAᵀ + ABᵀ)ᵀ =")
                    .font(.headline)
                MatrixResultDisplay(matrix: result, color: .green)
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
        }
    }
}
