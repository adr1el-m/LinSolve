import SwiftUI

struct ConstructingBasesView: View {
    @State private var selectedExample: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "hammer")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("Constructing Bases")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Deriving Bases from Descriptions or Matrices")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Introduction
                Text("We often define subspaces using equations (like planes) or as properties of matrices (like Null Space). Here's how to explicitly construct a basis for them.")
                    .font(.body)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                
                // Example Selector
                Picker("Example", selection: $selectedExample) {
                    Text("Hyperplanes").tag(0)
                    Text("Col/Null Space").tag(1)
                    Text("General Plane").tag(2)
                }
                .pickerStyle(.segmented)
                
                if selectedExample == 0 {
                    IntersectionHyperplanesExample()
                } else if selectedExample == 1 {
                    ColumnAndNullBaseExample()
                } else {
                    GeneralHyperplaneExample()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Intersection of Hyperplanes (Example 178)
struct IntersectionHyperplanesExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basis for Intersection of Hyperplanes")
                .font(.headline)
            
            Text("Input: Subspace W defined by the system:")
                .font(.body)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("x₁ + 2x₂ - x₃ + 3x₄ = 0")
                Text("2x₁ + 4x₂ + x₃ + 6x₄ = 0")
            }
            .font(.system(.body, design: .monospaced))
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                ProcessStepView(step: 1, title: "Gauss-Jordan to RREF", content: AnyView(
                    VStack(alignment: .leading, spacing: 4) {
                        Text("""
                            ┌ 1  2  0  3 ┐
                            └ 0  0  1  0 ┘
                        """)
                            .font(.system(.body, design: .monospaced))
                            .padding(8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("Pivots are in columns 1 and 3. Free variables are x₂ and x₄.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                ))
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ProcessStepView(step: 2, title: "Parametrization", content: AnyView(
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Express pivot variables in terms of free variables (r, s):")
                            .font(.caption)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("x₁ = -2r - 3s")
                            Text("x₂ = r  (free)")
                            Text("x₃ = 0")
                            Text("x₄ = s  (free)")
                        }
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(8)
                    }
                ))
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ProcessStepView(step: 3, title: "Vector Extraction", content: AnyView(
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Decompose into vectors multiplied by r and s:")
                            .font(.caption)
                        
                        HStack(alignment: .top) {
                            Text("x = r")
                            BasisVectorColumnView(vector: ["-2", "1", "0", "0"], title: "")
                            Text("+ s")
                            BasisVectorColumnView(vector: ["-3", "0", "0", "1"], title: "")
                        }
                    }
                ))
            }
            
            HStack {
                Image(systemName: "cube.fill")
                    .foregroundColor(.orange)
                VStack(alignment: .leading) {
                    Text("Basis Result")
                        .font(.headline)
                    Text("B = {[-2, 1, 0, 0]ᵀ, [-3, 0, 0, 1]ᵀ}")
                        .font(.system(.caption, design: .monospaced))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Column Space and Null Space (Example 179)
struct ColumnAndNullBaseExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basis for C(A) and N(A)")
                .font(.headline)
            
            Text("Input Matrix A:")
                .font(.caption)
            
            Text("""
                ┌  2   6  -4 ┐
            A = │ -1  -3   2 │
                └  1   3  -2 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            // C(A)
            VStack(alignment: .leading, spacing: 12) {
                Text("Part A: Column Space C(A)")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text("1. Compute RREF implies pivot in column 1.")
                Text("2. Take **original** column 1 from A.")
                
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.blue)
                    Text("Basis for C(A) = {[2, -1, 1]ᵀ}")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            
            Divider()
            
            // N(A)
            VStack(alignment: .leading, spacing: 12) {
                Text("Part B: Null Space N(A)")
                    .font(.headline)
                    .foregroundColor(.purple)
                
                Text("1. Solve Ax = 0 using RREF.")
                Text("2. Parametrize solution (free vars x₂, x₃):")
                
                Text("x = -3r + 2s,  y = r,  z = s")
                    .font(.system(.caption, design: .monospaced))
                    .padding(6)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(4)
                
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.purple)
                    Text("Basis for N(A) = {[-3, 1, 0]ᵀ, [2, 0, 1]ᵀ}")
                        .font(.system(.caption, design: .monospaced))
                        .bold()
                }
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - General Hyperplane (Example 184)
struct GeneralHyperplaneExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basis for General Hyperplane")
                .font(.headline)
            
            Text("Input: Equation a₁x₁ + ... + aₙxₙ = 0 (with aₙ ≠ 0)")
                .font(.body)
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 12) {
                ProcessStepView(
                    step: 1,
                    title: "Solve for Leading Variable",
                    content: AnyView(
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Rewrite xₙ in terms of other variables:")
                                .font(.caption)
                            Text("xₙ = b₁x₁ + ... + bₙ₋₁xₙ₋₁")
                                .font(.system(.body, design: .monospaced))
                                .padding(6)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(6)
                        }
                    )
                )
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ProcessStepView(step: 2, title: "Identify Free Variables", text: "Variables x₁ ... xₙ₋₁ are free.")
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ProcessStepView(step: 3, title: "Result", text: "We get (n-1) linearly independent vectors.")
                
                HStack {
                    Image(systemName: "ruler.fill")
                        .foregroundColor(.green)
                    Text("Dimension = n - 1")
                        .font(.title3)
                        .bold()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}
