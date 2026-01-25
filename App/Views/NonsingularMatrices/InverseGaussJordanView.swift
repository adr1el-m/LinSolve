import SwiftUI

struct InverseGaussJordanView: View {
    @State private var matrixSize: Int = 2
    @State private var matrix2x2: [[String]] = [["1", "-4"], ["-1", "3"]]
    @State private var matrix3x3: [[String]] = [
        ["1", "-4", "2"],
        ["-1", "3", "-3"],
        ["3", "-10", "9"]
    ]
    
    @State private var showSteps: Bool = false
    @State private var reductionSteps: [InverseStep] = []
    @State private var isSingular: Bool = false
    
    struct InverseStep: Identifiable {
        let id = UUID()
        let description: String
        let operation: String
        let leftMatrix: [[Fraction]]
        let rightMatrix: [[Fraction]]
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Inverse via Gauss-Jordan")
                        .font(.largeTitle)
                        .bold()
                    Text("The [A|I] → [I|A⁻¹] Algorithm")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
The **Gauss-Jordan method** finds the inverse of a matrix by augmenting it with the identity matrix and then performing row operations until the left side becomes the identity. Whatever appears on the right side is the inverse!

**Algorithm:**
1. **Setup**: Create augmented matrix [A | Iₙ]
2. **Row Reduce**: Apply elementary row operations to reduce A to the identity matrix I
3. **Result**: The right side transforms into A⁻¹

**Why it works:**
If we apply the same row operations to I that we apply to A, and A becomes I, then I becomes A⁻¹. This is because row operations are equivalent to left-multiplication by elementary matrices.

**Singularity Detection:**
If we get a row of zeros on the left side at any point, the matrix is **singular** and has no inverse.
""")
                        .font(.body)
                        .padding(.vertical, 4)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Size Selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Matrix Size")
                        .font(.headline)
                    
                    Picker("Size", selection: $matrixSize) {
                        Text("2×2").tag(2)
                        Text("3×3").tag(3)
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                // Matrix Input
                VStack(alignment: .leading, spacing: 16) {
                    Text("Enter Matrix A")
                        .font(.headline)
                    
                    if matrixSize == 2 {
                        matrix2x2InputView
                    } else {
                        matrix3x3InputView
                    }
                    
                    Button(action: findInverse) {
                        Text("Find Inverse")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                // Steps
                if showSteps {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Step-by-Step Solution")
                            .font(.title2)
                            .bold()
                        
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
                                    
                                    if !step.operation.isEmpty && step.operation != "Start" && step.operation != "Complete" {
                                        Text(step.operation)
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundColor(.blue)
                                    }
                                }
                                
                                Text(step.description)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                // Augmented matrix display
                                AugmentedInverseMatrixView(left: step.leftMatrix, right: step.rightMatrix)
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(12)
                        }
                        
                        // Final Result
                        if isSingular {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.red)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Matrix is Singular")
                                            .font(.title2)
                                            .bold()
                                        Text("No inverse exists")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Text("A row of zeros appeared on the left side, meaning the matrix cannot be reduced to the identity. The determinant is zero, so there is no inverse.")
                                    .font(.body)
                            }
                            .padding()
                            .background(Color.red.opacity(0.15))
                            .cornerRadius(12)
                        } else if let lastStep = reductionSteps.last {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.green)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Inverse Found!")
                                            .font(.title2)
                                            .bold()
                                        Text("A⁻¹ is shown on the right side")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                HStack(spacing: 20) {
                                    Text("A⁻¹ =")
                                        .font(.title2)
                                    
                                    InverseResultMatrixView(matrix: lastStep.rightMatrix)
                                }
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
        .onChange(of: matrixSize) { _ in
            showSteps = false
        }
    }
    
    var matrix2x2InputView: some View {
        VStack(spacing: 6) {
            ForEach(0..<2, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<2, id: \.self) { col in
                        TextField("0", text: $matrix2x2[row][col])
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
    }
    
    var matrix3x3InputView: some View {
        VStack(spacing: 6) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { col in
                        TextField("0", text: $matrix3x3[row][col])
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
    }
    
    func findInverse() {
        reductionSteps = []
        isSingular = false
        
        let n = matrixSize
        let inputMatrix = matrixSize == 2 ? matrix2x2 : matrix3x3
        
        // Parse input
        var left: [[Fraction]] = inputMatrix.prefix(n).map { row in
            row.prefix(n).map { Fraction(string: $0) }
        }
        
        // Create identity matrix
        var right: [[Fraction]] = (0..<n).map { i in
            (0..<n).map { j in i == j ? Fraction(1, 1) : Fraction(0, 1) }
        }
        
        // Initial setup
        reductionSteps.append(InverseStep(
            description: "Set up augmented matrix [A | I]",
            operation: "Start",
            leftMatrix: left,
            rightMatrix: right
        ))
        
        // Gauss-Jordan elimination
        for col in 0..<n {
            // Find pivot
            var pivotRow = col
            while pivotRow < n && left[pivotRow][col] == Fraction(0, 1) {
                pivotRow += 1
            }
            
            if pivotRow == n {
                // Singular
                isSingular = true
                reductionSteps.append(InverseStep(
                    description: "Column \(col + 1) has no valid pivot - matrix is singular!",
                    operation: "Singular",
                    leftMatrix: left,
                    rightMatrix: right
                ))
                break
            }
            
            // Swap if needed
            if pivotRow != col {
                let tempLeft = left[col]
                left[col] = left[pivotRow]
                left[pivotRow] = tempLeft
                
                let tempRight = right[col]
                right[col] = right[pivotRow]
                right[pivotRow] = tempRight
                
                reductionSteps.append(InverseStep(
                    description: "Swap rows to position pivot",
                    operation: "R\(toSubscript(col + 1)) ↔ R\(toSubscript(pivotRow + 1))",
                    leftMatrix: left,
                    rightMatrix: right
                ))
            }
            
            // Scale pivot row to make pivot = 1
            let pivot = left[col][col]
            if pivot != Fraction(1, 1) {
                let scale = Fraction(1, 1) / pivot
                for j in 0..<n {
                    left[col][j] = left[col][j] * scale
                    right[col][j] = right[col][j] * scale
                }
                
                reductionSteps.append(InverseStep(
                    description: "Scale row to make pivot = 1",
                    operation: "R\(toSubscript(col + 1)) → (\(scale.description))R\(toSubscript(col + 1))",
                    leftMatrix: left,
                    rightMatrix: right
                ))
            }
            
            // Eliminate in all other rows
            for row in 0..<n where row != col {
                if left[row][col] != Fraction(0, 1) {
                    let factor = left[row][col]
                    for j in 0..<n {
                        left[row][j] = left[row][j] - factor * left[col][j]
                        right[row][j] = right[row][j] - factor * right[col][j]
                    }
                    
                    reductionSteps.append(InverseStep(
                        description: "Eliminate entry in row \(row + 1)",
                        operation: "R\(toSubscript(row + 1)) → R\(toSubscript(row + 1)) - (\(factor.description))R\(toSubscript(col + 1))",
                        leftMatrix: left,
                        rightMatrix: right
                    ))
                }
            }
        }
        
        if !isSingular {
            reductionSteps.append(InverseStep(
                description: "Left side is now I, right side is A⁻¹",
                operation: "Complete",
                leftMatrix: left,
                rightMatrix: right
            ))
        }
        
        withAnimation {
            showSteps = true
        }
    }
    
    func toSubscript(_ n: Int) -> String {
        let subscripts = ["₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉"]
        return String(String(n).map { subscripts[Int(String($0))!] }.joined())
    }
}

struct AugmentedInverseMatrixView: View {
    let left: [[Fraction]]
    let right: [[Fraction]]
    
    var body: some View {
        HStack(spacing: 8) {
            // Left matrix
            VStack(spacing: 4) {
                ForEach(0..<left.count, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(0..<left[row].count, id: \.self) { col in
                            Text(left[row][col].description)
                                .font(.system(.body, design: .monospaced))
                                .frame(minWidth: 35)
                        }
                    }
                }
            }
            
            // Separator
            Rectangle()
                .frame(width: 2, height: CGFloat(left.count * 24))
                .foregroundColor(.secondary)
            
            // Right matrix
            VStack(spacing: 4) {
                ForEach(0..<right.count, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(0..<right[row].count, id: \.self) { col in
                            Text(right[row][col].description)
                                .font(.system(.body, design: .monospaced))
                                .frame(minWidth: 35)
                        }
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
