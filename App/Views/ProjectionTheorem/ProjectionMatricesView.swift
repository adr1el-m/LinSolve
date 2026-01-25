import SwiftUI

struct ProjectionMatricesView: View {
    @State private var selectedExample: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "square.grid.3x3")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Text("Projection Matrices")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Finding the Matrix P where P(x) = proj_W x")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Formulas
                VStack(alignment: .leading, spacing: 16) {
                    Text("Standard Matrix Formulas")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        FormulaBox(
                            title: "General Basis (Columns of A)",
                            formula: "P = A(AᵀA)⁻¹Aᵀ",
                            desc: "Works for any independent basis vectors.",
                            color: .blue
                        )
                        
                        FormulaBox(
                            title: "Orthonormal Basis (Columns of A)",
                            formula: "P = AAᵀ",
                            desc: "Simpler formula! Only works if columns are orthonormal.",
                            color: .green
                        )
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Picker("Example", selection: $selectedExample) {
                    Text("General Basis").tag(0)
                    Text("Line").tag(1)
                    Text("Orthonormal").tag(2)
                }
                .pickerStyle(.segmented)
                
                if selectedExample == 0 {
                    GeneralBasisProjectionExample()
                } else if selectedExample == 1 {
                    LineProjectionExample()
                } else {
                    OrthonormalProjectionExample()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct FormulaBox: View {
    let title: String
    let formula: String
    let desc: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .bold()
            Text(formula)
                .font(.system(.title3, design: .monospaced))
                .foregroundColor(color)
                .bold()
                .padding(8)
                .background(color.opacity(0.1))
                .cornerRadius(6)
            Text(desc)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Example 277: General Basis
struct GeneralBasisProjectionExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Projection onto a Plane")
                .font(.headline)
            
            Text("Input: Subspace W defined by plane x - 2y + 3z = 0")
                .font(.body)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("1. Find a Basis")
                    .font(.subheadline)
                    .bold()
                Text("Variables y, z are free. Basis vectors:")
                    .font(.caption)
                Text("v₁ = [2, 1, 0]ᵀ, v₂ = [-3, 0, 1]ᵀ")
                    .font(.system(.caption, design: .monospaced))
                
                Text("2. Form Matrix A")
                    .font(.subheadline)
                    .bold()
                Text("""
                    ┌  2  -3 ┐
                A = │  1   0 │
                    └  0   1 ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding(8)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(6)
                
                Text("3. Compute P = A(AᵀA)⁻¹Aᵀ")
                    .font(.subheadline)
                    .bold()
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("AᵀA = [[5, -6], [-6, 10]]")
                        .font(.caption2)
                    Text("Inverse = (1/14)[[10, 6], [6, 5]]")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Result")
                    .font(.headline)
                Text("""
                        ┌ 13/14   1/7  -3/14 ┐
                    P = │  1/7    5/7    3/7  │
                        └ -3/14   3/7    5/14 ┘
                """)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Example 280: Projection onto a Line
struct LineProjectionExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Analysis of a Projection Matrix")
                .font(.headline)
            
            Text("Input Matrix P:")
                .font(.caption)
            Text("""
                ┌ 1/5  2/5 ┐
            P = │          │
                └ 2/5  4/5 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Verify P is a projection:")
                    .font(.subheadline)
                    .bold()
                
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                    Text("Symmetric? Pᵀ = P ✓")
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                    Text("Idempotent? P² = P ✓")
                        .font(.caption)
                }
                .padding(.bottom, 4)
                
                Text("Find Subspace W:")
                    .font(.subheadline)
                    .bold()
                Text("W = Col(P) = Span{[1, 2]ᵀ}")
                    .font(.caption)
                Text("This corresponds to the line y = 2x.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Example 281: Orthonormal Basis
struct OrthonormalProjectionExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Projection with Orthonormal Basis")
                .font(.headline)
            
            Text("Input: Orthonormal vectors w₁, w₂")
                .font(.body)
            
            Text("w₁ = [1/3, 2/3, -2/3]ᵀ, w₂ = [2/3, -2/3, -1/3]ᵀ")
                .font(.system(.caption, design: .monospaced))
                .padding(8)
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(6)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.yellow)
                    Text("Shortcut: Since basis is orthonormal, use P = AAᵀ")
                        .font(.caption)
                        .bold()
                }
                
                Text("""
                    ┌  1/3   2/3 ┐ ┌ 1/3   2/3  -2/3 ┐
                A = │  2/3  -2/3 │ │                    │
                    └ -2/3  -1/3 ┘ └ 2/3  -2/3  -1/3 ┘
                """)
                    .font(.system(.caption, design: .monospaced))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Result")
                    .font(.headline)
                Text("""
                        ┌  5/9  -2/9  -4/9 ┐
                    P = │ -2/9   8/9  -2/9 │
                        └ -4/9  -2/9   5/9 ┘
                """)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}
