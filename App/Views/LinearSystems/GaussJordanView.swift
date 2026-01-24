import SwiftUI

struct GaussJordanView: View {
    @State private var selectedCase: SolutionCase = .unique
    @State private var showSteps: Bool = false
    @State private var reductionSteps: [GJReductionStep] = []
    
    // Matrices for different cases
    @State private var uniqueMatrix: [[String]] = [
        ["1", "2", "-1", "3"],
        ["1", "3", "1", "5"],
        ["3", "8", "4", "17"]
    ]
    
    @State private var inconsistentMatrix: [[String]] = [
        ["1", "-2", "4", "2"],
        ["2", "-3", "5", "3"],
        ["3", "-4", "6", "7"]
    ]
    
    @State private var infiniteMatrix: [[String]] = [
        ["1", "0", "1", "0", "24", "21"],
        ["0", "1", "-2", "0", "-8", "-7"],
        ["0", "0", "0", "1", "2", "3"]
    ]
    
    enum SolutionCase: String, CaseIterable {
        case unique = "Unique Solution"
        case inconsistent = "No Solution"
        case infinite = "Infinitely Many"
        
        var description: String {
            switch self {
            case .unique: return "RREF leads to identity matrix portion - exactly one solution"
            case .inconsistent: return "RREF reveals a contradiction (0 = non-zero) - no solution exists"
            case .infinite: return "Free variables exist - infinitely many solutions in parametric form"
            }
        }
        
        var color: Color {
            switch self {
            case .unique: return .green
            case .inconsistent: return .red
            case .infinite: return .purple
            }
        }
    }
    
    struct GJReductionStep: Identifiable {
        let id = UUID()
        let description: String
        let operation: String
        let matrix: [[Fraction]]
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Gauss-Jordan Method")
                        .font(.largeTitle)
                        .bold()
                    Text("Solving Linear Systems Completely")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
The **Gauss-Jordan Method** extends Gaussian Elimination by reducing the augmented matrix all the way to **Reduced Row Echelon Form (RREF)**. This eliminates the need for back substitution—the solution is read directly from the final matrix.

**Three Possible Outcomes:**

1. **Unique Solution**: The coefficient matrix portion reduces to the identity matrix. There is exactly one solution.

2. **No Solution (Inconsistent)**: A row of the form [0 0 ... 0 | c] appears where c ≠ 0. This says 0 = c, which is impossible.

3. **Infinitely Many Solutions**: Free variables remain. The solution set is expressed parametrically using those free variables.
""")
                        .font(.body)
                        .padding(.vertical, 4)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Case Selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Solution Type")
                        .font(.headline)
                    
                    Picker("Case", selection: $selectedCase) {
                        ForEach(SolutionCase.allCases, id: \.self) { c in
                            Text(c.rawValue).tag(c)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    HStack {
                        Circle()
                            .fill(selectedCase.color)
                            .frame(width: 10, height: 10)
                        Text(selectedCase.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                // Matrix Input (display only for demonstration)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Augmented Matrix [A | b]")
                        .font(.headline)
                    
                    Text("Example system for \(selectedCase.rawValue) case:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Matrix display
                    currentMatrixInputView
                    
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
                
                // Steps and Result
                if showSteps {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Step-by-Step Solution")
                            .font(.title2)
                            .bold()
                        
                        // Show reduction steps
                        ForEach(Array(reductionSteps.enumerated()), id: \.element.id) { index, step in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Step \(index)")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.blue)
                                        .cornerRadius(6)
                                    
                                    if step.operation != "Start" && step.operation != "Final" {
                                        Text(step.operation)
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundColor(.blue)
                                    }
                                }
                                
                                Text(step.description)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                GJMatrixView(matrix: step.matrix)
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(12)
                        }
                        
                        // Result Interpretation
                        resultInterpretationView
                    }
                    .padding()
                    .transition(.opacity)
                }
                
                Spacer()
            }
        }
        .onChange(of: selectedCase) { _ in
            showSteps = false
        }
    }
    
    @ViewBuilder
    var currentMatrixInputView: some View {
        let matrix = currentMatrix
        let cols = matrix[0].count
        
        VStack(spacing: 6) {
            ForEach(0..<matrix.count, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<cols, id: \.self) { col in
                        if col == cols - 1 {
                            Text("|")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                        
                        TextField("0", text: binding(for: row, col: col))
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.center)
                            .frame(width: 40, height: 32)
                            .background(Color(uiColor: .systemBackground))
                            .cornerRadius(6)
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(col < cols - 1 ? Color.blue.opacity(0.5) : Color.green.opacity(0.5)))
                    }
                }
            }
        }
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(10)
    }
    
    var currentMatrix: [[String]] {
        switch selectedCase {
        case .unique: return uniqueMatrix
        case .inconsistent: return inconsistentMatrix
        case .infinite: return infiniteMatrix
        }
    }
    
    func binding(for row: Int, col: Int) -> Binding<String> {
        switch selectedCase {
        case .unique:
            return $uniqueMatrix[row][col]
        case .inconsistent:
            return $inconsistentMatrix[row][col]
        case .infinite:
            return $infiniteMatrix[row][col]
        }
    }
    
    @ViewBuilder
    var resultInterpretationView: some View {
        switch selectedCase {
        case .unique:
            uniqueSolutionResultView
        case .inconsistent:
            inconsistentResultView
        case .infinite:
            infiniteSolutionResultView
        }
    }
    
    var uniqueSolutionResultView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading) {
                    Text("Unique Solution Found")
                        .font(.title2)
                        .bold()
                    Text("The RREF reveals the identity matrix - one exact solution")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("The solution can be read directly from the augmented column:")
                    .font(.body)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("x = 17/3")
                    Text("y = -2/3")
                    Text("z = 4/3")
                }
                .font(.system(.title3, design: .monospaced))
                .bold()
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                
                Text("**Solution Vector**: x = [17/3, -2/3, 4/3]ᵀ")
                    .font(.body)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.green.opacity(0.15))
        .cornerRadius(12)
    }
    
    var inconsistentResultView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                
                VStack(alignment: .leading) {
                    Text("No Solution Exists")
                        .font(.title2)
                        .bold()
                    Text("The system is inconsistent")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("During elimination, a row appeared of the form:")
                    .font(.body)
                
                Text("[0  0  0 | 1]")
                    .font(.system(.title3, design: .monospaced))
                    .bold()
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                
                Text("""
This row represents the equation:
**0x + 0y + 0z = 1**

Which simplifies to **0 = 1**, a contradiction!

Since no values of x, y, z can make this true, the system has **no solution**.
""")
                    .font(.body)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.15))
        .cornerRadius(12)
    }
    
    var infiniteSolutionResultView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "infinity.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.purple)
                
                VStack(alignment: .leading) {
                    Text("Infinitely Many Solutions")
                        .font(.title2)
                        .bold()
                    Text("Free variables lead to parametric form")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("**Analysis of the RREF:**")
                    .font(.headline)
                
                Text("""
• Variables with pivots (x₁, x₂, x₄): **Leading variables** (dependent)
• Variables without pivots (x₃, x₅): **Free variables** (can be any value)
""")
                    .font(.body)
                
                Divider()
                
                Text("**Parametric Solution:**")
                    .font(.headline)
                
                Text("Let x₃ = r and x₅ = s (free parameters)")
                    .font(.body)
                    .italic()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("x₁ = 21 - r - 24s")
                    Text("x₂ = -7 + 2r + 8s")
                    Text("x₃ = r")
                    Text("x₄ = 3 - 2s")
                    Text("x₅ = s")
                }
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(8)
                
                Text("For any real values of r and s, this gives a valid solution!")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.purple.opacity(0.15))
        .cornerRadius(12)
    }
    
    func solve() {
        reductionSteps = []
        
        let matrix = currentMatrix
        var fractionMatrix: [[Fraction]] = matrix.map { row in
            row.map { Fraction(string: $0) }
        }
        
        // Add initial step
        reductionSteps.append(GJReductionStep(
            description: "Starting augmented matrix",
            operation: "Start",
            matrix: fractionMatrix
        ))
        
        let rows = fractionMatrix.count
        let cols = fractionMatrix[0].count
        
        var currentRow = 0
        var currentCol = 0
        
        // Forward elimination
        while currentRow < rows && currentCol < cols - 1 {
            // Find pivot
            var pivotRow = currentRow
            while pivotRow < rows && fractionMatrix[pivotRow][currentCol] == Fraction(0, 1) {
                pivotRow += 1
            }
            
            if pivotRow == rows {
                currentCol += 1
                continue
            }
            
            // Swap if needed
            if pivotRow != currentRow {
                let temp = fractionMatrix[currentRow]
                fractionMatrix[currentRow] = fractionMatrix[pivotRow]
                fractionMatrix[pivotRow] = temp
                
                reductionSteps.append(GJReductionStep(
                    description: "Swap to position pivot",
                    operation: "R\(subscript(currentRow + 1)) ↔ R\(subscript(pivotRow + 1))",
                    matrix: fractionMatrix
                ))
            }
            
            // Scale pivot to 1
            if fractionMatrix[currentRow][currentCol] != Fraction(1, 1) {
                let scale = Fraction(1, 1) / fractionMatrix[currentRow][currentCol]
                for c in 0..<cols {
                    fractionMatrix[currentRow][c] = fractionMatrix[currentRow][c] * scale
                }
                
                reductionSteps.append(GJReductionStep(
                    description: "Scale row to make pivot equal 1",
                    operation: "R\(subscript(currentRow + 1)) → (\(scale.description))R\(subscript(currentRow + 1))",
                    matrix: fractionMatrix
                ))
            }
            
            // Eliminate in all other rows
            for row in 0..<rows {
                if row != currentRow && fractionMatrix[row][currentCol] != Fraction(0, 1) {
                    let factor = fractionMatrix[row][currentCol]
                    for c in 0..<cols {
                        fractionMatrix[row][c] = fractionMatrix[row][c] - factor * fractionMatrix[currentRow][c]
                    }
                    
                    reductionSteps.append(GJReductionStep(
                        description: "Eliminate entry in row \(row + 1)",
                        operation: "R\(subscript(row + 1)) → R\(subscript(row + 1)) - (\(factor.description))R\(subscript(currentRow + 1))",
                        matrix: fractionMatrix
                    ))
                }
            }
            
            currentRow += 1
            currentCol += 1
        }
        
        // Final RREF
        reductionSteps.append(GJReductionStep(
            description: "Matrix is now in Reduced Row Echelon Form (RREF)",
            operation: "Final",
            matrix: fractionMatrix
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

struct GJMatrixView: View {
    let matrix: [[Fraction]]
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<matrix.count, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<matrix[row].count, id: \.self) { col in
                        if col == matrix[row].count - 1 {
                            Rectangle()
                                .frame(width: 1, height: 20)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(matrix[row][col].description)
                            .font(.system(.body, design: .monospaced))
                            .frame(minWidth: 35)
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
