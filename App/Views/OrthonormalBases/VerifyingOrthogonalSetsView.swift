import SwiftUI

struct VerifyingOrthogonalSetsView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "checkmark.diamond")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Text("Verifying Orthogonal Sets")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Checking Perpendicularity & Unit Length")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Definitions
                VStack(alignment: .leading, spacing: 16) {
                    Text("Key Definitions")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        DefinitionBox(
                            term: "Orthogonal Set",
                            definition: "A set of vectors where every pair is perpendicular (dot product = 0).",
                            symbol: "u · v = 0 for all pairs",
                            color: .blue
                        )
                        
                        DefinitionBox(
                            term: "Orthonormal Set",
                            definition: "An orthogonal set where every vector also has unit length (norm = 1).",
                            symbol: "||v|| = 1 for all vectors",
                            color: .green
                        )
                    }
                    
                    Text("**Why do we care?** Orthonormal bases make calculations incredibly simple — projections become just dot products, and matrices become easy to invert (Q⁻¹ = Qᵀ).")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Picker("Example", selection: $selectedTab) {
                    Text("Verify Orthogonal").tag(0)
                    Text("Normalize to Orthonormal").tag(1)
                }
                .pickerStyle(.segmented)
                
                if selectedTab == 0 {
                    VerifyOrthogonalExample()
                } else {
                    NormalizeToOrthonormalExample()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct DefinitionBox: View {
    let term: String
    let definition: String
    let symbol: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                Text(term)
                    .font(.subheadline)
                    .bold()
            }
            Text(definition)
                .font(.caption)
            Text(symbol)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(color)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Verify Orthogonal Example (Example 195)
struct VerifyOrthogonalExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Verify Orthogonal Set")
                .font(.headline)
            
            Text("Input: S = {v₁, v₂, v₃}")
                .font(.body)
            
            HStack(spacing: 20) {
                OrthoVectorView(vector: ["1", "1", "0"], title: "v₁")
                OrthoVectorView(vector: ["2", "-2", "-1"], title: "v₂")
                OrthoVectorView(vector: ["1", "-1", "4"], title: "v₃")
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
            
            Divider()
            
            Text("Operation: Compute dot products for ALL pairs")
                .font(.subheadline)
                .bold()
            
            VStack(alignment: .leading, spacing: 12) {
                DotProductCalcRow(
                    vectors: "v₁ · v₂",
                    calculation: "(1)(2) + (1)(-2) + (0)(-1)",
                    result: "= 2 - 2 + 0 = 0 ✓"
                )
                
                DotProductCalcRow(
                    vectors: "v₁ · v₃",
                    calculation: "(1)(1) + (1)(-1) + (0)(4)",
                    result: "= 1 - 1 + 0 = 0 ✓"
                )
                
                DotProductCalcRow(
                    vectors: "v₂ · v₃",
                    calculation: "(2)(1) + (-2)(-1) + (-1)(4)",
                    result: "= 2 + 2 - 4 = 0 ✓"
                )
            }
            
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("All dot products are zero → S is ORTHOGONAL")
                    .font(.body)
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

// MARK: - Normalize to Orthonormal (Example 195 continued)
struct NormalizeToOrthonormalExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Normalizing to Orthonormal")
                .font(.headline)
            
            Text("Once we have an orthogonal set, we can make it orthonormal by dividing each vector by its norm.")
                .font(.body)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                NormalizationRow(
                    vector: "v₁",
                    normCalc: "√(1² + 1² + 0²) = √2",
                    result: "v₁/√2"
                )
                
                NormalizationRow(
                    vector: "v₂",
                    normCalc: "√(4 + 4 + 1) = √9 = 3",
                    result: "v₂/3"
                )
                
                NormalizationRow(
                    vector: "v₃",
                    normCalc: "√(1 + 1 + 16) = √18 = 3√2",
                    result: "v₃/(3√2)"
                )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Result: Orthonormal Set Ŝ")
                    .font(.headline)
                
                Text("Ŝ = { (1/√2)v₁, (1/3)v₂, (1/3√2)v₃ }")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(6)
                
                Text("Each vector now has length 1 AND they remain mutually perpendicular.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct OrthoVectorView: View {
    let vector: [String]
    let title: String
    
    var body: some View {
        VStack {
            Text(title).font(.caption).bold()
            VStack(spacing: 4) {
                ForEach(vector, id: \.self) { val in
                    Text(val)
                        .font(.system(.body, design: .monospaced))
                }
            }
            .padding(6)
            .background(Color.white)
            .cornerRadius(6)
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.blue.opacity(0.3)))
        }
    }
}

struct DotProductCalcRow: View {
    let vectors: String
    let calculation: String
    let result: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(vectors)
                .font(.subheadline)
                .bold()
            HStack {
                Text(calculation)
                    .font(.system(.caption, design: .monospaced))
                Text(result)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.green)
            }
        }
        .padding(8)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(6)
    }
}

struct NormalizationRow: View {
    let vector: String
    let normCalc: String
    let result: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("||"+vector+"||")
                    .font(.subheadline)
                    .bold()
                Text(normCalc)
                    .font(.system(.caption, design: .monospaced))
            }
            Spacer()
            Text("→")
            Text(result)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.blue)
        }
        .padding(8)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(6)
    }
}
