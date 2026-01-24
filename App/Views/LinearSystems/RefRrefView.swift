import SwiftUI

struct RefRrefView: View {
    // Input matrix (3x4 for demonstration, matches Example 70)
    @State private var inputMatrix: [[String]] = [
        ["1", "2", "3"],
        ["0", "0", "1"],
        ["0", "2", "4"]
    ]
    
    @State private var matrixRows: Int = 3
    @State private var matrixCols: Int = 3
    
    @State private var showSteps: Bool = false
    @State private var reductionSteps: [ReductionStep] = []
    @State private var selectedMode: ReductionMode = .rref
    
    enum ReductionMode: String, CaseIterable {
        case ref = "REF"
        case rref = "RREF"
        
        var title: String {
            switch self {
            case .ref: return "Row Echelon Form"
            case .rref: return "Reduced Row Echelon Form"
            }
        }
        
        var description: String {
            switch self {
            case .ref: return "All entries below each pivot are zero. Pivots may be any non-zero value."
            case .rref: return "All entries above AND below each pivot are zero. All pivots equal 1."
            }
        }
    }
    
    struct ReductionStep: Identifiable {
        let id = UUID()
        let description: String
        let operation: String
        let matrix: [[Fraction]]
        let pivotPositions: [(row: Int, col: Int)]
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Row Echelon Form (REF) & RREF")
                        .font(.largeTitle)
                        .bold()
                    Text("Matrix Reduction Techniques")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
**Row Echelon Form (REF)** and **Reduced Row Echelon Form (RREF)** are standardized forms for matrices that make solving systems and analyzing matrices easier.

**Key Definitions:**
• **Pivot**: The first non-zero entry in each row
• **Leading entry**: Same as pivot - leftmost non-zero in a row

**REF Requirements:**
1. All zero rows are at the bottom
2. Each pivot is to the right of the pivot in the row above
3. All entries below a pivot are zero

**RREF Requirements** (in addition to REF):
4. Each pivot equals 1
5. Each pivot is the only non-zero entry in its column
""")
                        .font(.body)
                        .padding(.vertical, 4)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Mode Selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Reduction Mode")
                        .font(.headline)
                    
                    Picker("Mode", selection: $selectedMode) {
                        ForEach(ReductionMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Text(selectedMode.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                // Matrix Input
                VStack(alignment: .leading, spacing: 16) {
                    Text("Input Matrix (3 × 3)")
                        .font(.headline)
                    
                    VStack(spacing: 6) {
                        ForEach(0..<3, id: \.self) { row in
                            HStack(spacing: 8) {
                                ForEach(0..<3, id: \.self) { col in
                                    TextField("0", text: $inputMatrix[row][col])
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
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(10)
                    
                    Button(action: performReduction) {
                        Text("Reduce to \(selectedMode.rawValue)")
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
                        Text("Step-by-Step Reduction to \(selectedMode.title)")
                            .font(.title2)
                            .bold()
                        
                        ForEach(Array(reductionSteps.enumerated()), id: \.element.id) { index, step in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Step \(index)")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.blue)
                                        .cornerRadius(6)
                                    
                                    Text(step.operation)
                                        .font(.system(.body, design: .monospaced))
                                        .foregroundColor(.blue)
                                }
                                
                                Text(step.description)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                // Matrix display with pivot highlighting
                                RefMatrixView(matrix: step.matrix, pivots: step.pivotPositions)
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(12)
                        }
                        
                        // Final Summary
                        if let lastStep = reductionSteps.last {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.green)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Matrix is now in \(selectedMode.title)")
                                            .font(.title2)
                                            .bold()
                                        Text("Pivots are marked in yellow")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                RefMatrixView(matrix: lastStep.matrix, pivots: lastStep.pivotPositions, highlightPivots: true)
                                
                                // Properties of the result
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Properties of this \(selectedMode.rawValue):")
                                        .font(.headline)
                                    
                                    if selectedMode == .ref {
                                        Text("✓ All entries below pivots are 0")
                                        Text("✓ Each pivot is to the right of the one above")
                                        Text("✓ Zero rows (if any) are at the bottom")
                                    } else {
                                        Text("✓ All pivots equal 1")
                                        Text("✓ Each pivot is the only non-zero in its column")
                                        Text("✓ Staircase pattern with zeros above and below")
                                    }
                                }
                                .font(.body)
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                            }
                            .padding()
                            .background(Color.green.opacity(0.15))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .transition(.opacity)
                }
                
                Spacer()
            }
        }
        .onChange(of: selectedMode) { _ in
            showSteps = false
        }
    }
    
    func performReduction() {
        reductionSteps = []
        
        // Parse input matrix
        var matrix: [[Fraction]] = inputMatrix.map { row in
            row.map { Fraction(string: $0) }
        }
        var pivots: [(row: Int, col: Int)] = []
        
        let rows = matrix.count
        let cols = matrix[0].count
        
        // Initial matrix
        reductionSteps.append(ReductionStep(
            description: "Starting matrix before any row operations",
            operation: "Initial",
            matrix: matrix,
            pivotPositions: []
        ))
        
        var currentRow = 0
        var currentCol = 0
        
        // Forward elimination (to REF)
        while currentRow < rows && currentCol < cols {
            // Find pivot in current column
            var pivotRow = currentRow
            while pivotRow < rows && matrix[pivotRow][currentCol] == Fraction(0, 1) {
                pivotRow += 1
            }
            
            if pivotRow == rows {
                // No pivot in this column
                currentCol += 1
                continue
            }
            
            // Swap if needed
            if pivotRow != currentRow {
                let temp = matrix[currentRow]
                matrix[currentRow] = matrix[pivotRow]
                matrix[pivotRow] = temp
                
                reductionSteps.append(ReductionStep(
                    description: "Swap rows to move non-zero entry to pivot position",
                    operation: "R\(subscript(currentRow + 1)) ↔ R\(subscript(pivotRow + 1))",
                    matrix: matrix,
                    pivotPositions: pivots
                ))
            }
            
            // Eliminate below
            for row in (currentRow + 1)..<rows {
                if matrix[row][currentCol] != Fraction(0, 1) {
                    let factor = matrix[row][currentCol] / matrix[currentRow][currentCol]
                    for col in 0..<cols {
                        matrix[row][col] = matrix[row][col] - factor * matrix[currentRow][col]
                    }
                    
                    reductionSteps.append(ReductionStep(
                        description: "Eliminate entry below pivot at position (\(currentRow + 1), \(currentCol + 1))",
                        operation: "R\(subscript(row + 1)) → R\(subscript(row + 1)) - (\(factor.description))R\(subscript(currentRow + 1))",
                        matrix: matrix,
                        pivotPositions: pivots
                    ))
                }
            }
            
            pivots.append((currentRow, currentCol))
            currentRow += 1
            currentCol += 1
        }
        
        // If RREF mode, continue with back elimination
        if selectedMode == .rref {
            // Scale pivots to 1
            for (row, col) in pivots {
                if matrix[row][col] != Fraction(1, 1) && matrix[row][col] != Fraction(0, 1) {
                    let scale = Fraction(1, 1) / matrix[row][col]
                    for c in 0..<cols {
                        matrix[row][c] = matrix[row][c] * scale
                    }
                    
                    reductionSteps.append(ReductionStep(
                        description: "Scale row to make pivot equal to 1",
                        operation: "R\(subscript(row + 1)) → (\(scale.description))R\(subscript(row + 1))",
                        matrix: matrix,
                        pivotPositions: pivots
                    ))
                }
            }
            
            // Eliminate above pivots (working from bottom to top)
            for i in (0..<pivots.count).reversed() {
                let (pivotRow, pivotCol) = pivots[i]
                
                for row in 0..<pivotRow {
                    if matrix[row][pivotCol] != Fraction(0, 1) {
                        let factor = matrix[row][pivotCol]
                        for col in 0..<cols {
                            matrix[row][col] = matrix[row][col] - factor * matrix[pivotRow][col]
                        }
                        
                        reductionSteps.append(ReductionStep(
                            description: "Eliminate entry above pivot at position (\(pivotRow + 1), \(pivotCol + 1))",
                            operation: "R\(subscript(row + 1)) → R\(subscript(row + 1)) - (\(factor.description))R\(subscript(pivotRow + 1))",
                            matrix: matrix,
                            pivotPositions: pivots
                        ))
                    }
                }
            }
        }
        
        // Final result
        reductionSteps.append(ReductionStep(
            description: "Matrix is now in \(selectedMode.title)",
            operation: "Complete",
            matrix: matrix,
            pivotPositions: pivots
        ))
        
        withAnimation {
            showSteps = true
        }
    }
    
    func subscript(_ n: Int) -> String {
        let subscripts = ["₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉"]
        return String(String(n).map { subscripts[Int(String($0))!] }.joined())
    }
}

struct RefMatrixView: View {
    let matrix: [[Fraction]]
    let pivots: [(row: Int, col: Int)]
    var highlightPivots: Bool = false
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<matrix.count, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<matrix[row].count, id: \.self) { col in
                        let isPivot = pivots.contains { $0.row == row && $0.col == col }
                        
                        Text(matrix[row][col].description)
                            .font(.system(.body, design: .monospaced))
                            .frame(minWidth: 40)
                            .padding(4)
                            .background(isPivot && highlightPivots ? Color.yellow.opacity(0.4) : Color.clear)
                            .cornerRadius(4)
                    }
                }
            }
        }
        .padding(10)
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
