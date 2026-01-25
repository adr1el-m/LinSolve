import SwiftUI

struct TransformationsFromBasisView: View {
    @State private var selectedExample: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "arrow.triangle.branch")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                        Text("Transformations from Basis")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Determining T from Where It Sends Basis Vectors")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Core Principle
                VStack(alignment: .leading, spacing: 12) {
                    Text("The Fundamental Principle")
                        .font(.headline)
                    
                    Text("A linear transformation is completely determined by its action on any basis. If you know where the basis vectors go, you know everything!")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Given: T(b₁), T(b₂), ..., T(bₙ)")
                            .font(.system(.body, design: .monospaced))
                        Text("For any v = c₁b₁ + c₂b₂ + ... + cₙbₙ:")
                            .font(.caption)
                        Text("T(v) = c₁T(b₁) + c₂T(b₂) + ... + cₙT(bₙ)")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Picker("Example", selection: $selectedExample) {
                    Text("Find Formula").tag(0)
                    Text("Standard Matrix").tag(1)
                    Text("Geometry").tag(2)
                }
                .pickerStyle(.segmented)
                
                if selectedExample == 0 {
                    FindFormulaFromBasisExample()
                } else if selectedExample == 1 {
                    StandardMatrixExample()
                } else {
                    GeometryTransformExample()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Example 221: Finding Formula from Basis Images
struct FindFormulaFromBasisExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Finding Formula from Basis Images")
                .font(.headline)
            
            Text("Given: Basis B and the images T(b₁), T(b₂), T(b₃)")
                .font(.body)
            
            VStack(alignment: .leading, spacing: 8) {
                BasisImageRow(basis: "b₁ = [-1, 1, 1]ᵀ", image: "T(b₁) = [-2, 0]ᵀ")
                BasisImageRow(basis: "b₂ = [1, -1, 1]ᵀ", image: "T(b₂) = [-4, 2]ᵀ")
                BasisImageRow(basis: "b₃ = [1, 1, -1]ᵀ", image: "T(b₃) = [6, 2]ᵀ")
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                BasisStepView(
                    step: 1,
                    title: "Express General Vector in Terms of B",
                    content: "Write [x, y, z]ᵀ = c₁b₁ + c₂b₂ + c₃b₃ and solve for c₁, c₂, c₃"
                )
                
                BasisStepView(
                    step: 2,
                    title: "Apply Linearity",
                    content: "T(v) = c₁T(b₁) + c₂T(b₂) + c₃T(b₃)"
                )
                
                BasisStepView(
                    step: 3,
                    title: "Substitute Known Images",
                    content: "Replace T(bᵢ) with given values and simplify"
                )
            }
            
            HStack {
                Image(systemName: "function")
                    .foregroundColor(.green)
                VStack(alignment: .leading) {
                    Text("Result")
                        .font(.headline)
                    Text("T([x,y,z]ᵀ) = [x + 2y - 3z, 2x + y + z]ᵀ")
                        .font(.system(.caption, design: .monospaced))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.green.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Example 225: Finding the Standard Matrix
struct StandardMatrixExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Finding the Standard Matrix")
                .font(.headline)
            
            Text("Input: T([x,y,z]ᵀ) = [x + 2y - 3z, 2x + y + z]ᵀ")
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Text("Goal: Find the matrix [T] such that T(v) = [T]v")
                .font(.body)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Compute Images of Standard Basis")
                    .font(.subheadline)
                    .bold()
                
                Text("The columns of [T] are T(e₁), T(e₂), T(e₃):")
                    .font(.caption)
                
                HStack(spacing: 16) {
                    StandardBasisColView(
                        input: "e₁ = [1,0,0]",
                        output: "[1, 2]ᵀ",
                        source: "coeff of x"
                    )
                    StandardBasisColView(
                        input: "e₂ = [0,1,0]",
                        output: "[2, 1]ᵀ",
                        source: "coeff of y"
                    )
                    StandardBasisColView(
                        input: "e₃ = [0,0,1]",
                        output: "[-3, 1]ᵀ",
                        source: "coeff of z"
                    )
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Result: Standard Matrix")
                    .font(.headline)
                
                Text("""
                        ┌  1   2  -3 ┐
                    [T] = │            │
                        └  2   1   1 ┘
                """)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                Text("Now T(v) = [T]v for ANY vector v!")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Example 217, 220: Geometry
struct GeometryTransformExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Linearity and Geometry")
                .font(.headline)
            
            // Unit Square Example
            VStack(alignment: .leading, spacing: 12) {
                Text("Transforming a Unit Square")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Matrix A:")
                    .font(.caption)
                
                Text("""
                    ┌  2   1 ┐
                A = │        │
                    └ -1   2 ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding(8)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(6)
                
                Text("Where basis vectors go:")
                    .font(.caption)
                
                HStack {
                    Text("e₁ → [2, -1]ᵀ")
                        .font(.system(.caption, design: .monospaced))
                    Text("e₂ → [1, 2]ᵀ")
                        .font(.system(.caption, design: .monospaced))
                }
                
                Text("Result: The unit square becomes a parallelogram spanned by these new vectors.")
                    .font(.caption)
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
            }
            
            Divider()
            
            // Dependent Sets Example
            VStack(alignment: .leading, spacing: 12) {
                Text("Independence Can Be Lost!")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.orange)
                
                Text("Truncation map Tₚ (project to 2D) applied to independent set:")
                    .font(.caption)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Input: {[1,1,1]ᵀ, [2,2,-1]ᵀ} — linearly independent")
                        .font(.caption)
                    Text("Output: {[1,1]ᵀ, [2,2]ᵀ} — DEPENDENT! ([2,2] = 2[1,1])")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding(8)
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(6)
                
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("Linear transformations do NOT always preserve independence. Information can be lost!")
                        .font(.caption)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct BasisImageRow: View {
    let basis: String
    let image: String
    
    var body: some View {
        HStack {
            Text(basis)
                .font(.system(.caption, design: .monospaced))
            Spacer()
            Text("→")
            Text(image)
                .font(.system(.caption, design: .monospaced))
                .bold()
                .foregroundColor(.green)
        }
    }
}

struct BasisStepView: View {
    let step: Int
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(step)")
                .font(.caption)
                .bold()
                .frame(width: 24, height: 24)
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                Text(content)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct StandardBasisColView: View {
    let input: String
    let output: String
    let source: String
    
    var body: some View {
        VStack {
            Text(input)
                .font(.caption2)
            Text("↓")
            Text(output)
                .font(.system(.caption, design: .monospaced))
                .bold()
                .foregroundColor(.blue)
            Text(source)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(6)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(6)
    }
}
