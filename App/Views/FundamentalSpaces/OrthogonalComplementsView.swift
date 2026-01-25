import SwiftUI

struct OrthogonalComplementsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "angle")
                            .font(.largeTitle)
                            .foregroundColor(.indigo)
                        Text("Orthogonal Complements")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Finding Vectors Perpendicular to a Subspace")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Definition
                VStack(alignment: .leading, spacing: 12) {
                    Text("Definition: W⊥")
                        .font(.headline)
                    
                    Text("The orthogonal complement W⊥ contains all vectors that are orthogonal to EVERY vector in W.")
                        .font(.body)
                    
                    Text("y ∈ W⊥ ⟺ y · x = 0 for all x ∈ W")
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(Color.indigo.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text("**Method:** If W = Span{v₁, ..., vₖ}, finding W⊥ amounts to collecting these basis vectors into rows of a matrix A and finding N(A).")
                        .font(.caption)
                        .padding(8)
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(6)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Example 265
                OrthogonalComplementExample()
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Example 265
struct OrthogonalComplementExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Complement of a Plane")
                .font(.headline)
            
            Text("Input: Subspace W = Span{x₁, x₂}")
                .font(.body)
            
            HStack(spacing: 20) {
                VectorBox(name: "x₁", vector: "[1, 1, 2]ᵀ")
                VectorBox(name: "x₂", vector: "[2, 2, -1]ᵀ")
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Operation: Find y such that y · x₁ = 0 and y · x₂ = 0")
                    .font(.subheadline)
                    .bold()
                
                Text("This sets up a homogeneous system:")
                    .font(.caption)
                
                Text("""
                    ⎧ y₁ + y₂ + 2y₃ = 0
                    ⎩ 2y₁ + 2y₂ - y₃ = 0
                """)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                
                Text("Notice: This is exactly N(A) where rows of A are x₁ᵀ and x₂ᵀ!")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Calculation Results")
                    .font(.subheadline)
                    .bold()
                
                Text("Solving via RREF yields:")
                    .font(.caption)
                
                Text("y₁ = -r,  y₂ = r,  y₃ = 0")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.orange)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Result")
                    .font(.headline)
                
                Text("W⊥ = Span{[-1, 1, 0]ᵀ}")
                    .font(.system(.title3, design: .monospaced))
                    .padding()
                    .background(Color.indigo.opacity(0.1))
                    .cornerRadius(8)
                
                Text("Geometrically, W is a plane and W⊥ is the normal line passing through the origin perpendicular to that plane.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct VectorBox: View {
    let name: String
    let vector: String
    
    var body: some View {
        HStack {
            Text(name + " =")
                .bold()
            Text(vector)
                .font(.system(.body, design: .monospaced))
        }
        .padding(8)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(6)
    }
}
