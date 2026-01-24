import SwiftUI

struct MatrixArithmeticView: View {
    // Default matrices from example: A (2x3), B (2x3), C (2x3)
    @State private var matrixA: [[String]] = [
        ["1", "3", "-2"],
        ["1", "0", "2"]
    ]
    @State private var matrixB: [[String]] = [
        ["4", "3", "0"],
        ["1", "-5", "5"]
    ]
    @State private var matrixC: [[String]] = [
        ["2", "1", "-1"],
        ["6", "-1", "2"]
    ]
    
    @State private var scalarA: String = "2"
    @State private var scalarB: String = "3"
    
    @State private var showSteps: Bool = false
    @State private var selectedOperation: OperationType = .combined
    
    // Results
    @State private var scaledA: [[Fraction]] = []
    @State private var scaledB: [[Fraction]] = []
    @State private var finalResult: [[Fraction]] = []
    
    enum OperationType: String, CaseIterable {
        case addition = "A + B"
        case subtraction = "A - B"
        case scalarMult = "cA"
        case combined = "cA - dB + C"
        
        var description: String {
            switch self {
            case .addition: return "Add two matrices element-by-element"
            case .subtraction: return "Subtract matrices element-by-element"
            case .scalarMult: return "Multiply every element by a scalar"
            case .combined: return "Combine scalar multiplication with addition/subtraction"
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Basic Matrix Arithmetic")
                        .font(.largeTitle)
                        .bold()
                    Text("Addition, Subtraction & Scalar Multiplication")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
Matrix arithmetic extends the familiar operations of addition, subtraction, and scalar multiplication to rectangular arrays of numbers. These operations are **element-wise** and require matrices of the **same dimensions**.

**Key Rules:**
• **Addition/Subtraction**: Matrices must have the **exact same size** (m × n)
• **Scalar Multiplication**: Multiply **every entry** by the scalar
• Operations are performed **component-by-component**
""")
                        .font(.body)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Formulas
                VStack(alignment: .leading, spacing: 16) {
                    Text("Formal Definitions")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        FormulaRow(
                            title: "Matrix Addition",
                            formula: "(A + B)ᵢⱼ = Aᵢⱼ + Bᵢⱼ",
                            note: "Add corresponding entries"
                        )
                        
                        Divider()
                        
                        FormulaRow(
                            title: "Matrix Subtraction",
                            formula: "(A - B)ᵢⱼ = Aᵢⱼ - Bᵢⱼ",
                            note: "Subtract corresponding entries"
                        )
                        
                        Divider()
                        
                        FormulaRow(
                            title: "Scalar Multiplication",
                            formula: "(cA)ᵢⱼ = c · Aᵢⱼ",
                            note: "Multiply every entry by c"
                        )
                    }
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(8)
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                // Input Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Input Matrices (2 × 3)")
                        .font(.headline)
                    
                    // Operation Picker
                    Picker("Operation", selection: $selectedOperation) {
                        ForEach(OperationType.allCases, id: \.self) { op in
                            Text(op.rawValue).tag(op)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Text(selectedOperation.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Scalar inputs for relevant operations
                    if selectedOperation == .scalarMult || selectedOperation == .combined {
                        HStack(spacing: 20) {
                            HStack {
                                Text("c =")
                                    .font(.headline)
                                TextField("2", text: $scalarA)
                                    .keyboardType(.numbersAndPunctuation)
                                    .frame(width: 50)
                                    .textFieldStyle(.roundedBorder)
                            }
                            
                            if selectedOperation == .combined {
                                HStack {
                                    Text("d =")
                                        .font(.headline)
                                    TextField("3", text: $scalarB)
                                        .keyboardType(.numbersAndPunctuation)
                                        .frame(width: 50)
                                        .textFieldStyle(.roundedBorder)
                                }
                            }
                        }
                    }
                    
                    // Matrix inputs
                    HStack(alignment: .top, spacing: 20) {
                        MatrixInputGrid(label: "A", matrix: $matrixA, color: .blue)
                        
                        if selectedOperation != .scalarMult {
                            MatrixInputGrid(label: "B", matrix: $matrixB, color: .green)
                        }
                        
                        if selectedOperation == .combined {
                            MatrixInputGrid(label: "C", matrix: $matrixC, color: .orange)
                        }
                    }
                    
                    Button(action: compute) {
                        Text("Calculate")
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
                        
                        // Display based on operation type
                        switch selectedOperation {
                        case .combined:
                            CombinedOperationSteps(
                                scalarA: scalarA,
                                scalarB: scalarB,
                                matrixA: matrixA,
                                matrixB: matrixB,
                                matrixC: matrixC,
                                scaledA: scaledA,
                                scaledB: scaledB,
                                finalResult: finalResult
                            )
                        case .scalarMult:
                            ScalarMultiplicationSteps(
                                scalar: scalarA,
                                matrix: matrixA,
                                result: scaledA
                            )
                        case .addition:
                            AdditionSteps(
                                matrixA: matrixA,
                                matrixB: matrixB,
                                result: finalResult,
                                isSubtraction: false
                            )
                        case .subtraction:
                            AdditionSteps(
                                matrixA: matrixA,
                                matrixB: matrixB,
                                result: finalResult,
                                isSubtraction: true
                            )
                        }
                        
                        // Important Note
                        VStack(alignment: .leading, spacing: 8) {
                            Text("⚠️ Dimension Requirement")
                                .font(.headline)
                            
                            Text("""
Matrix addition and subtraction are only defined when both matrices have the **exact same dimensions**. Attempting to add a 2×2 matrix to a 2×4 matrix is **undefined** — the operation simply cannot be performed.

This is different from matrix multiplication, which has its own dimension requirements.
""")
                                .font(.body)
                        }
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
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
        let c = matrixC.map { row in row.map { Fraction(string: $0) } }
        let cScalar = Fraction(string: scalarA)
        let dScalar = Fraction(string: scalarB)
        
        switch selectedOperation {
        case .combined:
            // cA - dB + C
            scaledA = a.map { row in row.map { $0 * cScalar } }
            scaledB = b.map { row in row.map { $0 * dScalar } }
            
            finalResult = (0..<a.count).map { r in
                (0..<a[0].count).map { c in
                    scaledA[r][c] - scaledB[r][c] + self.matrixC[r][c].asFraction
                }
            }
            
        case .scalarMult:
            scaledA = a.map { row in row.map { $0 * cScalar } }
            finalResult = scaledA
            
        case .addition:
            finalResult = (0..<a.count).map { r in
                (0..<a[0].count).map { c in
                    a[r][c] + b[r][c]
                }
            }
            
        case .subtraction:
            finalResult = (0..<a.count).map { r in
                (0..<a[0].count).map { c in
                    a[r][c] - b[r][c]
                }
            }
        }
        
        withAnimation {
            showSteps = true
        }
    }
}

// MARK: - Helper Extension
extension String {
    var asFraction: Fraction {
        Fraction(string: self)
    }
}

// MARK: - Supporting Views

struct FormulaRow: View {
    let title: String
    let formula: String
    let note: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .bold()
            Text(formula)
                .font(.system(.body, design: .serif))
                .italic()
            Text(note)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct MatrixInputGrid: View {
    let label: String
    @Binding var matrix: [[String]]
    var color: Color = .primary
    
    var body: some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.headline)
                .foregroundColor(color)
            
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
}

struct CombinedOperationSteps: View {
    let scalarA: String
    let scalarB: String
    let matrixA: [[String]]
    let matrixB: [[String]]
    let matrixC: [[String]]
    let scaledA: [[Fraction]]
    let scaledB: [[Fraction]]
    let finalResult: [[Fraction]]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Step 1: Scalar multiplication
            VStack(alignment: .leading, spacing: 10) {
                Text("Step 1: Scalar Multiplication")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text("First, multiply each matrix by its scalar. Every element gets multiplied individually.")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 20) {
                    VStack {
                        Text("\(scalarA)A =")
                            .font(.system(.body, design: .monospaced))
                        MatrixDisplay(matrix: scaledA, color: .blue)
                    }
                    
                    VStack {
                        Text("\(scalarB)B =")
                            .font(.system(.body, design: .monospaced))
                        MatrixDisplay(matrix: scaledB, color: .green)
                    }
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(10)
            
            // Step 2: Subtraction and Addition
            VStack(alignment: .leading, spacing: 10) {
                Text("Step 2: Combine with C")
                    .font(.headline)
                    .foregroundColor(.purple)
                
                Text("Now perform the subtraction and addition element-by-element:")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("\(scalarA)A - \(scalarB)B + C")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(6)
                
                Text("For each position (i,j), calculate: (\(scalarA)A)ᵢⱼ - (\(scalarB)B)ᵢⱼ + Cᵢⱼ")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(10)
            
            // Final Result
            VStack(alignment: .leading, spacing: 10) {
                Text("Final Result")
                    .font(.headline)
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title)
                    
                    VStack(alignment: .leading) {
                        Text("\(scalarA)A - \(scalarB)B + C =")
                            .font(.headline)
                        MatrixDisplay(matrix: finalResult, color: .green)
                    }
                }
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct ScalarMultiplicationSteps: View {
    let scalar: String
    let matrix: [[String]]
    let result: [[Fraction]]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Scalar Multiplication")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text("Multiply every element of the matrix by \(scalar):")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("(\(scalar)A)ᵢⱼ = \(scalar) × Aᵢⱼ")
                    .font(.system(.body, design: .serif))
                    .italic()
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Result")
                    .font(.headline)
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title)
                    
                    VStack(alignment: .leading) {
                        Text("\(scalar)A =")
                            .font(.headline)
                        MatrixDisplay(matrix: result, color: .green)
                    }
                }
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct AdditionSteps: View {
    let matrixA: [[String]]
    let matrixB: [[String]]
    let result: [[Fraction]]
    let isSubtraction: Bool
    
    var opSymbol: String { isSubtraction ? "-" : "+" }
    var opName: String { isSubtraction ? "Subtraction" : "Addition" }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Matrix \(opName)")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text("\(isSubtraction ? "Subtract" : "Add") corresponding elements at each position:")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("(A \(opSymbol) B)ᵢⱼ = Aᵢⱼ \(opSymbol) Bᵢⱼ")
                    .font(.system(.body, design: .serif))
                    .italic()
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Result")
                    .font(.headline)
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title)
                    
                    VStack(alignment: .leading) {
                        Text("A \(opSymbol) B =")
                            .font(.headline)
                        MatrixDisplay(matrix: result, color: .green)
                    }
                }
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct MatrixDisplay: View {
    let matrix: [[Fraction]]
    var color: Color = .primary
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<matrix.count, id: \.self) { r in
                HStack(spacing: 8) {
                    ForEach(0..<matrix[r].count, id: \.self) { c in
                        Text(matrix[r][c].description)
                            .font(.system(.body, design: .monospaced))
                            .frame(minWidth: 35)
                    }
                }
            }
        }
        .padding(8)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(6)
        .overlay(
            HStack {
                BracketShape(left: true).stroke(color, lineWidth: 1.5).frame(width: 8)
                Spacer()
                BracketShape(left: false).stroke(color, lineWidth: 1.5).frame(width: 8)
            }
        )
    }
}
