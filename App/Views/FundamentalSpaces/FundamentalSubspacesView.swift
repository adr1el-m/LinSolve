import SwiftUI

struct FundamentalSubspacesView: View {
    @State private var selectedExample: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "square.stack.3d.down.right")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Text("Fundamental Subspaces")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("The Four Pillars of Linear Algebra")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Definitions
                VStack(alignment: .leading, spacing: 16) {
                    Text("The Big Four")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        SubspaceDefinitionRow(
                            name: "Column Space C(A)",
                            desc: "Space spanned by columns. Range of transformation.",
                            dim: "dim = r (Rank)",
                            color: .blue
                        )
                        
                        SubspaceDefinitionRow(
                            name: "Row Space R(A) = C(Aᵀ)",
                            desc: "Space spanned by rows. Orthogonal to Null Space.",
                            dim: "dim = r (Rank)",
                            color: .purple
                        )
                        
                        SubspaceDefinitionRow(
                            name: "Null Space N(A)",
                            desc: "Solutions to Ax=0. Kernel of transformation.",
                            dim: "dim = n - r",
                            color: .orange
                        )
                        
                        SubspaceDefinitionRow(
                            name: "Left Null Space N(Aᵀ)",
                            desc: "Solutions to Aᵀy=0. Orthogonal to Column Space.",
                            dim: "dim = m - r",
                            color: .red
                        )
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Picker("Example", selection: $selectedExample) {
                    Text("Full Analysis").tag(0)
                    Text("Visualizing").tag(1)
                }
                .pickerStyle(.segmented)
                
                if selectedExample == 0 {
                    FullSubspaceAnalysisExample()
                } else {
                    VisualizingSubspacesExample()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct SubspaceDefinitionRow: View {
    let name: String
    let desc: String
    let dim: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
                .padding(4)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(color)
                    Spacer()
                    Text(dim)
                        .font(.caption)
                        .padding(4)
                        .background(color.opacity(0.1))
                        .cornerRadius(4)
                }
                
                Text(desc)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(8)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Example 261: Full Analysis
struct FullSubspaceAnalysisExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Full Subspace Analysis")
                .font(.headline)
            
            Text("Input Matrix A (2×4)")
                .font(.caption)
            
            Text("""
                ┌ 1  3  -1  1 ┐
            A = │             │
                └ 0  1   1  6 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            // C(A) and N(A)
            VStack(alignment: .leading, spacing: 12) {
                Text("1. Column Space & Null Space (via RREF of A)")
                    .font(.subheadline)
                    .bold()
                
                Text("""
                         ┌ 1  0  -4  -17 ┐
                RREF(A) = │               │
                         └ 0  1   1    6 ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding(8)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(6)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("C(A):")
                            .bold()
                            .foregroundColor(.blue)
                        Text("Pivot cols 1 & 2 of ORIGINAL A")
                            .font(.caption)
                    }
                    Text("Basis = {[1, 0]ᵀ, [3, 1]ᵀ}")
                        .font(.system(.caption, design: .monospaced))
                    
                    HStack {
                        Text("N(A):")
                            .bold()
                            .foregroundColor(.orange)
                        Text("Free vars x₃, x₄. Solve Ax=0")
                            .font(.caption)
                    }
                    Text("Basis = {[-4, -1, 1, 0]ᵀ, [-17, -6, 0, 1]ᵀ}")
                        .font(.system(.caption, design: .monospaced))
                }
                .padding()
                .background(Color.blue.opacity(0.05))
                .cornerRadius(8)
            }
            
            // R(A) and N(Aᵀ)
            VStack(alignment: .leading, spacing: 12) {
                Text("2. Row Space & Left Null Space (via RREF of Aᵀ)")
                    .font(.subheadline)
                    .bold()
                
                Text("""
                          ┌ 1  0 ┐
                RREF(Aᵀ) = │ 0  1 │
                          │ 0  0 │
                          └ 0  0 ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding(8)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(6)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("R(A):")
                            .bold()
                            .foregroundColor(.purple)
                        Text("Pivot cols of original Aᵀ (rows of A)")
                            .font(.caption)
                    }
                    Text("Basis = {[1, 3, -1, 1]ᵀ, [0, 1, 1, 6]ᵀ}")
                        .font(.system(.caption, design: .monospaced))
                    
                    HStack {
                        Text("N(Aᵀ):")
                            .bold()
                            .foregroundColor(.red)
                        Text("Solve Aᵀy=0")
                            .font(.caption)
                    }
                    Text("No free vars → Zero vector only {0}")
                        .font(.system(.caption, design: .monospaced))
                }
                .padding()
                .background(Color.purple.opacity(0.05))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Example 262: Visualizing
struct VisualizingSubspacesExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Visualizing Geometry")
                .font(.headline)
            
            Text("Input Matrix A:")
                .font(.caption)
            Text("""
                ┌ -1   3 ┐
            A = │        │
                └  2  -6 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Subspace Geometry")
                    .font(.subheadline)
                    .bold()
                
                GeometryRow(
                    space: "C(A)",
                    basis: "[-1, 2]ᵀ",
                    desc: "Line through origin",
                    perp: "N(Aᵀ)",
                    color: .blue
                )
                
                GeometryRow(
                    space: "N(Aᵀ)",
                    basis: "[2, 1]ᵀ",
                    desc: "Line perpendicular to C(A)",
                    perp: "C(A)",
                    color: .red
                )
                
                Divider()
                
                GeometryRow(
                    space: "R(A)",
                    basis: "[-1, 3]ᵀ",
                    desc: "Line through origin",
                    perp: "N(A)",
                    color: .purple
                )
                
                GeometryRow(
                    space: "N(A)",
                    basis: "[3, 1]ᵀ",
                    desc: "Line perpendicular to R(A)",
                    perp: "R(A)",
                    color: .orange
                )
            }
            
            HStack {
                Image(systemName: "angle")
                    .foregroundColor(.green)
                Text("Visual Proof: The fundamental subspaces come in orthogonal pairs!")
                    .font(.caption)
                    .bold()
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

struct GeometryRow: View {
    let space: String
    let basis: String
    let desc: String
    let perp: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(space)
                    .font(.headline)
                    .foregroundColor(color)
                Text("Span{" + basis + "}")
                    .font(.system(.caption, design: .monospaced))
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(desc)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text("⊥ " + perp)
                    .font(.caption)
                    .bold()
            }
        }
        .padding(8)
        .background(color.opacity(0.05))
        .cornerRadius(6)
    }
}
