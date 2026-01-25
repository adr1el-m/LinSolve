import SwiftUI

struct ComputingProjectionsView: View {
    @State private var selectedExample: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "arrow.down.right.circle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("Computing Projections")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Applying the Projection Operator to Vectors")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Methods
                VStack(alignment: .leading, spacing: 12) {
                    Text("Two Main Methods")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        MethodBox(
                            name: "Matrix Multiplication",
                            formula: "proj_W x = Px",
                            desc: "Best when you already have the matrix P.",
                            icon: "grid"
                        )
                        MethodBox(
                            name: "Orthonormal Formulas",
                            formula: "proj_W x = Σ (x · u_i)u_i",
                            desc: "Best when working with an orthonormal basis directly.",
                            icon: "sigma"
                        )
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Picker("Example", selection: $selectedExample) {
                    Text("Using Matrix P").tag(0)
                    Text("Using Basis").tag(1)
                }
                .pickerStyle(.segmented)
                
                if selectedExample == 0 {
                    ProjectionByMatrixExample()
                } else {
                    ProjectionByBasisFormulaExample()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct MethodBox: View {
    let name: String
    let formula: String
    let desc: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(name).font(.subheadline).bold()
                Text(formula).font(.system(.caption, design: .monospaced)).bold()
                Text(desc).font(.caption).foregroundColor(.secondary)
            }
        }
        .padding(8)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Example 277.2
struct ProjectionByMatrixExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Projection using the Matrix")
                .font(.headline)
            
            Text("Input: Vector x = [2, 4, 6]ᵀ and Matrix P (from prev example)")
                .font(.body)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Operation: Matrix Multiplication Px")
                    .font(.subheadline)
                    .bold()
                
                Text("""
                    Px = (1/14) ┌ 13  2  -3 ┐ ┌ 2 ┐
                                │  2 10   6 │ │ 4 │
                                └ -3  6   5 ┘ └ 6 ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding(8)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(6)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Result")
                    .font(.headline)
                
                Text("x_proj = [8/7, 40/7, 24/7]ᵀ")
                    .font(.system(.title3, design: .monospaced))
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

// MARK: - Example 283
struct ProjectionByBasisFormulaExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Projection using Orthonormal Basis Formula")
                .font(.headline)
            
            Text("Input: x = [1, 1, 1]ᵀ, Orthonormal basis {w₁, w₂}")
                .font(.body)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Formula: proj x = (x·w₁)w₁ + (x·w₂)w₂")
                    .font(.subheadline)
                    .bold()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("1. Dot Products (Fourier Coefficients)")
                        .font(.caption).bold()
                    Text("• x · w₁ = 1(1/3) + 1(2/3) + 1(-2/3) = 1/3")
                        .font(.system(.caption, design: .monospaced))
                    Text("• x · w₂ = 1(2/3) + 1(-2/3) + 1(-1/3) = -1/3")
                        .font(.system(.caption, design: .monospaced))
                }
                .padding(8)
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(6)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("2. Linear Combination")
                        .font(.caption).bold()
                    Text("Sum = (1/3)w₁ - (1/3)w₂")
                        .font(.system(.caption, design: .monospaced))
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Result")
                    .font(.headline)
                
                Text("proj x = [-1/9, 4/9, -1/9]ᵀ")
                    .font(.system(.title3, design: .monospaced))
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
