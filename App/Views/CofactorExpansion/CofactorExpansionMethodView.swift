import SwiftUI

struct CofactorExpansionMethodView: View {
    @State private var selectedTab: Int = 0
    
    // Example 3x3 matrix
    @State private var matrix3x3: [[String]] = [
        ["2", "3", "-1"],
        ["0", "1", "-1"],
        ["3", "0", "2"]
    ]
    @State private var show3x3Solution: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "rectangle.split.3x3")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Text("Cofactor Expansion Method")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Computing Determinants by Breaking Down Matrices")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Introduction
                VStack(alignment: .leading, spacing: 16) {
                    Text("What is Cofactor Expansion?")
                        .font(.headline)
                    
                    Text("Cofactor expansion (also called Laplace expansion) is a technique for computing the determinant of a matrix by breaking it down into smaller, more manageable pieces. Instead of memorizing complex formulas for large matrices, you can repeatedly use the simple 2×2 determinant formula.")
                        .font(.body)
                    
                    Text("The key insight is that the determinant of an n×n matrix can be expressed as a weighted sum of determinants of (n-1)×(n-1) matrices called minors.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Formula Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("The Cofactor Expansion Formula")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Expanding along row i:")
                            .font(.subheadline)
                            .bold()
                        
                        Text("det(A) = Σⱼ aᵢⱼ · Cᵢⱼ")
                            .font(.system(.title2, design: .monospaced))
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("Where:")
                            .font(.subheadline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top) {
                                Text("•")
                                Text("aᵢⱼ is the entry in row i, column j")
                            }
                            HStack(alignment: .top) {
                                Text("•")
                                Text("Cᵢⱼ is the cofactor of aᵢⱼ")
                            }
                            HStack(alignment: .top) {
                                Text("•")
                                Text("Cᵢⱼ = (-1)^(i+j) × Mᵢⱼ")
                            }
                            HStack(alignment: .top) {
                                Text("•")
                                Text("Mᵢⱼ is the minor (determinant of the matrix after deleting row i and column j)")
                            }
                        }
                        .font(.body)
                    }
                    
                    // Sign pattern
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sign Pattern (Checkerboard)")
                            .font(.subheadline)
                            .bold()
                        
                        Text("The factor (-1)^(i+j) creates a checkerboard pattern of + and - signs:")
                            .font(.caption)
                        
                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { row in
                                VStack(spacing: 4) {
                                    ForEach(0..<3, id: \.self) { col in
                                        Text((row + col) % 2 == 0 ? "+" : "−")
                                            .font(.title3)
                                            .bold()
                                            .frame(width: 30, height: 30)
                                            .background((row + col) % 2 == 0 ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
                                            .cornerRadius(4)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Strategy Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("💡 Strategy: Choosing the Best Row or Column")
                        .font(.headline)
                    
                    Text("You can expand along ANY row or column and get the same answer. However, to minimize computation:")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            Image(systemName: "1.circle.fill")
                                .foregroundColor(.green)
                            Text("Choose the row or column with the MOST ZEROS")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "2.circle.fill")
                                .foregroundColor(.green)
                            Text("Each zero entry means one fewer minor to compute")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "3.circle.fill")
                                .foregroundColor(.green)
                            Text("For sparse matrices, this can dramatically reduce work")
                        }
                    }
                    .font(.body)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                
                // Tab Selection for Examples
                Picker("Example", selection: $selectedTab) {
                    Text("3×3 Example").tag(0)
                    Text("Sparse 5×5").tag(1)
                    Text("Block Matrix").tag(2)
                }
                .pickerStyle(.segmented)
                
                // Examples
                switch selectedTab {
                case 0:
                    Example3x3View()
                case 1:
                    SparseMatrixExample()
                case 2:
                    BlockMatrixExample()
                default:
                    EmptyView()
                }
                
                // Interactive Calculator
                InteractiveCofactorCalculator(matrix: $matrix3x3, showSolution: $show3x3Solution)
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - 3x3 Example (Example 136.1)

struct Example3x3View: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: 3×3 Determinant")
                .font(.headline)
            
            Text("Calculate det(A) where:")
                .font(.body)
            
            // Matrix display
            HStack {
                Text("A =")
                    .font(.title3)
                MatrixView3x3(values: [[2, 3, -1], [0, 1, -1], [3, 0, 2]])
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Step 1: Choose the Row with Most Zeros")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Looking at our matrix, Row 2 has a zero in position (2,1). This means when we expand along Row 2, we can skip one minor calculation entirely!")
                    .font(.body)
                
                Text("Step 2: Write the Expansion Formula")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("det(A) = a₂₁·C₂₁ + a₂₂·C₂₂ + a₂₃·C₂₃")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(6)
                
                Text("Since a₂₁ = 0, the first term vanishes:")
                    .font(.body)
                
                Text("det(A) = 0·C₂₁ + 1·C₂₂ + (-1)·C₂₃")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(6)
                
                Text("Step 3: Calculate the Cofactors")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("C₂₂ = (-1)^(2+2) × M₂₂ = (+1) × |2  -1| = 2(2) - (-1)(3) = 4 + 3 = 7")
                        .font(.system(.caption, design: .monospaced))
                    Text("                                              |3   2|")
                        .font(.system(.caption, design: .monospaced))
                }
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("C₂₃ = (-1)^(2+3) × M₂₃ = (-1) × |2  3| = -[2(0) - 3(3)] = -(-9) = 9")
                        .font(.system(.caption, design: .monospaced))
                    Text("                                              |3  0|")
                        .font(.system(.caption, design: .monospaced))
                }
                .padding(8)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(6)
                
                Text("Step 4: Combine")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("det(A) = 0 + 1(7) + (-1)(9) = 7 - 9 = -2")
                    .font(.system(.body, design: .monospaced))
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Sparse 5x5 Example (Example 136.2)

struct SparseMatrixExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Sparse 5×5 Matrix")
                .font(.headline)
            
            Text("When a matrix has many zeros, strategic expansion can dramatically simplify the calculation.")
                .font(.body)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Strategy: Sequential Expansion")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("For a sparse matrix, always look for rows or columns with the most zeros. Each zero means one fewer determinant to calculate!")
                    .font(.body)
                
                HStack(alignment: .top) {
                    Image(systemName: "1.circle.fill")
                        .foregroundColor(.orange)
                    VStack(alignment: .leading) {
                        Text("First Expansion")
                            .font(.subheadline)
                            .bold()
                        Text("Expand along Column 2 (only one non-zero entry). This immediately reduces a 5×5 to a 4×4 determinant.")
                            .font(.caption)
                    }
                }
                
                HStack(alignment: .top) {
                    Image(systemName: "2.circle.fill")
                        .foregroundColor(.orange)
                    VStack(alignment: .leading) {
                        Text("Second Expansion")
                            .font(.subheadline)
                            .bold()
                        Text("In the resulting 4×4 minor, expand along Column 4 (again, only one non-zero entry). Now we have a 3×3.")
                            .font(.caption)
                    }
                }
                
                HStack(alignment: .top) {
                    Image(systemName: "3.circle.fill")
                        .foregroundColor(.orange)
                    VStack(alignment: .leading) {
                        Text("Third Expansion")
                            .font(.subheadline)
                            .bold()
                        Text("In the 3×3 minor, expand along Column 2 (one non-zero entry). Now we have a simple 2×2.")
                            .font(.caption)
                    }
                }
                
                HStack(alignment: .top) {
                    Image(systemName: "4.circle.fill")
                        .foregroundColor(.green)
                    VStack(alignment: .leading) {
                        Text("Final Calculation")
                            .font(.subheadline)
                            .bold()
                        Text("Apply the 2×2 formula: ad - bc")
                            .font(.caption)
                    }
                }
                
                Text("Result: det(A) = -12")
                    .font(.system(.body, design: .monospaced))
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
            }
            
            // Key insight
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text("Key Insight")
                        .font(.subheadline)
                        .bold()
                }
                Text("By choosing rows/columns with zeros, we turned what could be 5! = 120 terms into just a handful of simple calculations. This is the power of strategic cofactor expansion!")
                    .font(.caption)
            }
            .padding()
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Block Matrix Example (Example 137)

struct BlockMatrixExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Symbolic Block Determinant")
                .font(.headline)
            
            Text("Sometimes matrices contain symbolic entries (variables) or have a special block structure. Cofactor expansion still works!")
                .font(.body)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Consider a 4×4 matrix:")
                    .font(.subheadline)
                
                Text("""
                    ┌  5   0  0  0 ┐
                    │  0   a  b  0 │
                    │  0   c  d  0 │
                    └  0   0  0  1 ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                
                Text("This matrix has a special block diagonal structure. The non-zero entries form blocks along the diagonal.")
                    .font(.body)
                
                Text("Step 1: Expand Along Row 1")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Only position (1,1) has a non-zero entry (5), so:")
                    .font(.body)
                
                Text("det = 5 × M₁₁")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                
                Text("Step 2: Analyze the 3×3 Minor")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("The minor M₁₁ is also sparse - expand along its first column:")
                    .font(.body)
                
                Text("""
                    M₁₁ = | a  b  0 |
                          | c  d  0 |
                          | 0  0  1 |
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding(8)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(6)
                
                Text("Step 3: Final Result")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Expanding the 3×3 along the last column (only the 1 is non-zero):")
                    .font(.body)
                
                Text("M₁₁ = 1 × |a  b| = ad - bc")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(6)
                
                Text("Therefore: det(A) = 5(ad - bc)")
                    .font(.system(.body, design: .monospaced))
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
                
                Text("If (ad - bc) = 5, then det(A) = 5 × 5 = 25")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Block diagonal property
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "square.grid.2x2")
                        .foregroundColor(.purple)
                    Text("Block Diagonal Property")
                        .font(.subheadline)
                        .bold()
                }
                Text("For block diagonal matrices, the determinant equals the product of the determinants of each block. This example illustrates: det(A) = 5 × 1 × (ad - bc) where 5 and 1 are the 1×1 blocks.")
                    .font(.caption)
            }
            .padding()
            .background(Color.purple.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Interactive Calculator

struct InteractiveCofactorCalculator: View {
    @Binding var matrix: [[String]]
    @Binding var showSolution: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🧮 Interactive Calculator")
                .font(.headline)
            
            Text("Enter your own 3×3 matrix:")
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
                                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.blue.opacity(0.3)))
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
                    Text(showSolution ? "Hide Solution" : "Calculate Determinant")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            
            if showSolution {
                CofactorSolutionView(matrix: matrix)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct CofactorSolutionView: View {
    let matrix: [[String]]
    
    var m: [[Int]] {
        matrix.map { row in
            row.map { Int($0) ?? 0 }
        }
    }
    
    var det: Int {
        let a = m[0][0], b = m[0][1], c = m[0][2]
        let d = m[1][0], e = m[1][1], f = m[1][2]
        let g = m[2][0], h = m[2][1], i = m[2][2]
        
        return a*(e*i - f*h) - b*(d*i - f*g) + c*(d*h - e*g)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Solution (Expanding along Row 1):")
                .font(.subheadline)
                .bold()
            
            let a = m[0][0], b = m[0][1], c = m[0][2]
            let d = m[1][0], e = m[1][1], f = m[1][2]
            let g = m[2][0], h = m[2][1], i = m[2][2]
            
            Text("det = a₁₁·C₁₁ + a₁₂·C₁₂ + a₁₃·C₁₃")
                .font(.system(.caption, design: .monospaced))
            
            let c11 = e*i - f*h
            let c12 = -(d*i - f*g)
            let c13 = d*h - e*g
            
            Text("C₁₁ = +|\(e) \(f)| = \(e)×\(i) - \(f)×\(h) = \(c11)")
                .font(.system(.caption, design: .monospaced))
            Text("      |\(h) \(i)|")
                .font(.system(.caption, design: .monospaced))
            
            Text("C₁₂ = -|\(d) \(f)| = -(\(d)×\(i) - \(f)×\(g)) = \(c12)")
                .font(.system(.caption, design: .monospaced))
            Text("      |\(g) \(i)|")
                .font(.system(.caption, design: .monospaced))
            
            Text("C₁₃ = +|\(d) \(e)| = \(d)×\(h) - \(e)×\(g) = \(c13)")
                .font(.system(.caption, design: .monospaced))
            Text("      |\(g) \(h)|")
                .font(.system(.caption, design: .monospaced))
            
            Text("det = \(a)×\(c11) + \(b)×\(c12) + \(c)×\(c13)")
                .font(.system(.caption, design: .monospaced))
            
            Text("det = \(a*c11) + \(b*c12) + \(c*c13) = \(det)")
                .font(.system(.body, design: .monospaced))
                .bold()
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Helper Views

struct MatrixView3x3: View {
    let values: [[Int]]
    
    var body: some View {
        HStack(spacing: 0) {
            // Left bracket
            BracketShape(left: true)
                .stroke(Color.primary, lineWidth: 1.5)
                .frame(width: 8, height: 70)
            
            // Values
            VStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(0..<3, id: \.self) { col in
                            Text("\(values[row][col])")
                                .font(.system(.body, design: .monospaced))
                                .frame(minWidth: 25)
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            
            // Right bracket
            BracketShape(left: false)
                .stroke(Color.primary, lineWidth: 1.5)
                .frame(width: 8, height: 70)
        }
    }
}
