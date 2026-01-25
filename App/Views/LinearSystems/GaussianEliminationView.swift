import SwiftUI

struct GaussianEliminationView: View {
    // Initial system of equations (3x3 augmented matrix)
    @State private var augmentedMatrix: [[String]] = [
        ["2", "5", "-9", "-10"],
        ["1", "2", "-4", "-4"],
        ["3", "-2", "3", "11"]
    ]
    
    @State private var showSteps: Bool = false
    @State private var eliminationSteps: [EliminationStep] = []
    @State private var solution: [Fraction] = []
    
    struct EliminationStep: Identifiable {
        let id = UUID()
        let description: String
        let operation: String
        let matrix: [[Fraction]]
        let highlightRow: Int?
        let highlightCol: Int?
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Gaussian Elimination")
                        .font(.largeTitle)
                        .bold()
                    Text("The Foundation of Solving Linear Systems")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    // Beginner-friendly explanation
                    VStack(alignment: .leading, spacing: 16) {
                        Text("What is Gaussian Elimination?")
                            .font(.headline)
                        
                        Text("""
**Gaussian Elimination** is a systematic method for solving systems of linear equations—perhaps the most important algorithm in all of linear algebra.

**The Big Idea:** Instead of trying to solve all equations at once, we systematically simplify the system by eliminating variables one at a time. We do this by combining equations in clever ways that preserve the solution.

**Why It Works:** Imagine you have 3 equations with 3 unknowns. If you can combine them to create a simpler equation with just one unknown, you can solve for that variable. Then substitute back to find the others!
""")
                            .font(.body)
                        
                        Divider()
                        
                        Text("The Three Elementary Row Operations")
                            .font(.headline)
                        
                        Text("""
These are the ONLY operations we're allowed to perform. They're called "elementary" because they're simple, and crucially, **they never change the solution set**.

**1. Swap** two rows (Rᵢ ↔ Rⱼ)
   • Just reordering equations doesn't change their solutions
   • Example: "x + y = 3" and "2x - y = 0" is the same system whether equation 1 or 2 comes first

**2. Scale** a row by a non-zero constant (Rᵢ → cRᵢ)
   • Multiplying both sides of an equation by the same number keeps it balanced
   • Example: "x + y = 3" multiplied by 2 gives "2x + 2y = 6" — same line!

**3. Add** a multiple of one row to another (Rᵢ → Rᵢ + cRⱼ)
   • This is the key operation for elimination
   • Example: Adding "-2 times row 1" to row 2 eliminates the x term from row 2
""")
                            .font(.body)
                        
                        // Visual tip
                        HStack(spacing: 12) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                            Text("**Pro Tip:** The goal is to create zeros below each \"pivot\" (the leading non-zero entry in each row). This triangular pattern is called Row Echelon Form.")
                                .font(.callout)
                        }
                        .padding()
                        .background(Color.yellow.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Input Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("System of Equations (Augmented Matrix)")
                        .font(.headline)
                    
                    Text("Enter a 3×3 system as an augmented matrix [A | b]:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Matrix input
                    VStack(spacing: 6) {
                        ForEach(0..<3, id: \.self) { row in
                            HStack(spacing: 8) {
                                ForEach(0..<4, id: \.self) { col in
                                    if col == 3 {
                                        Text("|")
                                            .font(.title2)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    TextField("0", text: $augmentedMatrix[row][col])
                                        .keyboardType(.numbersAndPunctuation)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 50, height: 36)
                                        .background(Color(uiColor: .systemBackground))
                                        .cornerRadius(6)
                                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(col < 3 ? Color.blue.opacity(0.5) : Color.green.opacity(0.5)))
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(10)
                    
                    // Variable labels
                    HStack(spacing: 20) {
                        HStack(spacing: 8) {
                            Text("Variables:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            ForEach(["x", "y", "z"], id: \.self) { v in
                                Text(v)
                                    .font(.system(.caption, design: .serif))
                                    .italic()
                            }
                        }
                        
                        HStack(spacing: 8) {
                            Text("Constants:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("b")
                                .font(.system(.caption, design: .serif))
                                .italic()
                                .foregroundColor(.green)
                        }
                    }
                    
                    Button(action: performElimination) {
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
                        
                        // Forward Elimination Phase
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Phase 1: Forward Elimination")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Text("Transform the matrix to Row Echelon Form by creating zeros below each pivot.")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            ForEach(eliminationSteps) { step in
                                EliminationStepView(step: step)
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(12)
                        
                        // Back Substitution
                        if solution.count == 3 {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Phase 2: Back Substitution")
                                    .font(.headline)
                                    .foregroundColor(.purple)
                                
                                Text("""
Now that the matrix is in Row Echelon Form, we solve from bottom to top:
• Start with the last equation (single variable)
• Substitute into previous equations
• Work our way up to find all variables
""")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Working backwards:")
                                        .font(.subheadline)
                                        .bold()
                                    
                                    // Show back substitution steps
                                    backSubstitutionStepsView
                                }
                                .padding()
                                .background(Color.purple.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(12)
                            
                            // Final Solution
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.green)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Final Solution")
                                            .font(.title2)
                                            .bold()
                                        Text("x = [\(solution.map { $0.description }.joined(separator: ", "))]ᵀ")
                                            .font(.system(.title3, design: .monospaced))
                                    }
                                }
                                
                                HStack(spacing: 30) {
                                    VStack(alignment: .leading) {
                                        Text("x = \(solution[0].description)")
                                        Text("y = \(solution[1].description)")
                                        Text("z = \(solution[2].description)")
                                    }
                                    .font(.system(.body, design: .monospaced))
                                    .bold()
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
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
    }
    
    var backSubstitutionStepsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            if solution.count == 3 {
                Text("1. z = \(solution[2].description)")
                    .font(.system(.body, design: .monospaced))
                
                Text("2. y - z = -2  →  y = -2 + \(solution[2].description) = \(solution[1].description)")
                    .font(.system(.body, design: .monospaced))
                
                Text("3. x + 2y - 4z = -4  →  x = -4 - 2(\(solution[1].description)) + 4(\(solution[2].description)) = \(solution[0].description)")
                    .font(.system(.body, design: .monospaced))
            }
        }
    }
    
    func performElimination() {
        eliminationSteps = []
        
        // Parse input matrix
        var matrix: [[Fraction]] = augmentedMatrix.map { row in
            row.map { Fraction(string: $0) }
        }
        
        // Step 0: Initial matrix
        eliminationSteps.append(EliminationStep(
            description: "Initial augmented matrix",
            operation: "Start",
            matrix: matrix,
            highlightRow: nil,
            highlightCol: nil
        ))
        
        // Step 1: Swap R1 and R2 to get coefficient 1 in top-left
        if matrix[1][0].numerator == 1 && matrix[1][0].denominator == 1 {
            let temp = matrix[0]
            matrix[0] = matrix[1]
            matrix[1] = temp
            
            eliminationSteps.append(EliminationStep(
                description: "Swap rows to put coefficient 1 in top-left position",
                operation: "R₁ ↔ R₂",
                matrix: matrix,
                highlightRow: 0,
                highlightCol: 0
            ))
        }
        
        // Step 2: Eliminate x from R2
        if matrix[1][0] != Fraction(0, 1) {
            let factor = matrix[1][0] / matrix[0][0]
            for j in 0..<4 {
                matrix[1][j] = matrix[1][j] - factor * matrix[0][j]
            }
            
            eliminationSteps.append(EliminationStep(
                description: "Eliminate x from Row 2",
                operation: "R₂ → R₂ + (-\(factor.description))R₁",
                matrix: matrix,
                highlightRow: 1,
                highlightCol: 0
            ))
        }
        
        // Step 3: Eliminate x from R3
        if matrix[2][0] != Fraction(0, 1) {
            let factor = matrix[2][0] / matrix[0][0]
            for j in 0..<4 {
                matrix[2][j] = matrix[2][j] - factor * matrix[0][j]
            }
            
            eliminationSteps.append(EliminationStep(
                description: "Eliminate x from Row 3",
                operation: "R₃ → R₃ + (-\(factor.description))R₁",
                matrix: matrix,
                highlightRow: 2,
                highlightCol: 0
            ))
        }
        
        // Step 4: Eliminate y from R3 using R2
        if matrix[2][1] != Fraction(0, 1) && matrix[1][1] != Fraction(0, 1) {
            let factor = matrix[2][1] / matrix[1][1]
            for j in 0..<4 {
                matrix[2][j] = matrix[2][j] - factor * matrix[1][j]
            }
            
            eliminationSteps.append(EliminationStep(
                description: "Eliminate y from Row 3",
                operation: "R₃ → R₃ + (\(factor.description))R₂",
                matrix: matrix,
                highlightRow: 2,
                highlightCol: 1
            ))
        }
        
        // Step 5: Scale R3 to make pivot = 1
        if matrix[2][2] != Fraction(0, 1) && matrix[2][2] != Fraction(1, 1) {
            let scale = Fraction(1, 1) / matrix[2][2]
            for j in 0..<4 {
                matrix[2][j] = matrix[2][j] * scale
            }
            
            eliminationSteps.append(EliminationStep(
                description: "Scale Row 3 to isolate z",
                operation: "R₃ → (\(scale.description))R₃",
                matrix: matrix,
                highlightRow: 2,
                highlightCol: 2
            ))
        }
        
        // Back substitution
        let z = matrix[2][3]
        let y = matrix[1][3] - matrix[1][2] * z
        let x = matrix[0][3] - matrix[0][1] * y - matrix[0][2] * z
        
        solution = [x, y, z]
        
        withAnimation {
            showSteps = true
        }
    }
}

struct EliminationStepView: View {
    let step: GaussianEliminationView.EliminationStep
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(step.operation)
                    .font(.system(.body, design: .monospaced))
                    .bold()
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(6)
                
                Text(step.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Matrix display
            AugmentedMatrixView(matrix: step.matrix, highlightRow: step.highlightRow)
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(10)
    }
}

struct AugmentedMatrixView: View {
    let matrix: [[Fraction]]
    var highlightRow: Int? = nil
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<matrix.count, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<matrix[row].count, id: \.self) { col in
                        if col == 3 {
                            Rectangle()
                                .frame(width: 1, height: 20)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(matrix[row][col].description)
                            .font(.system(.body, design: .monospaced))
                            .frame(minWidth: 40)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(highlightRow == row ? Color.yellow.opacity(0.2) : Color.clear)
                .cornerRadius(4)
            }
        }
        .padding(8)
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
