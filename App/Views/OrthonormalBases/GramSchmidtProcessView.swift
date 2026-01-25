import SwiftUI

struct GramSchmidtProcessView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                        Text("Gram-Schmidt Process")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Converting Any Basis to Orthonormal")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Algorithm Overview
                VStack(alignment: .leading, spacing: 12) {
                    Text("The Algorithm")
                        .font(.headline)
                    
                    Text("The Gram-Schmidt process takes any linearly independent set and produces an orthonormal set that spans the same space.")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        GSAlgorithmStep(
                            step: 1,
                            formula: "w₁ = v₁",
                            description: "Keep the first vector as-is"
                        )
                        
                        GSAlgorithmStep(
                            step: 2,
                            formula: "w₂ = v₂ - projᵥ₁v₂",
                            description: "Subtract the projection onto w₁"
                        )
                        
                        GSAlgorithmStep(
                            step: 3,
                            formula: "w₃ = v₃ - projᵥ₁v₃ - projᵥ₂v₃",
                            description: "Subtract projections onto w₁ AND w₂"
                        )
                        
                        GSAlgorithmStep(
                            step: 4,
                            formula: "wᵢ* = wᵢ / ||wᵢ||",
                            description: "Normalize each vector to unit length"
                        )
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Example 203
                GramSchmidtExampleView()
                
                Spacer()
            }
            .padding()
        }
    }
}

struct GSAlgorithmStep: View {
    let step: Int
    let formula: String
    let description: String
    
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
                Text(formula)
                    .font(.system(.body, design: .monospaced))
                    .bold()
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Example 203
struct GramSchmidtExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Gram-Schmidt Construction")
                .font(.headline)
            
            Text("Input: Basis for Column Space of A")
                .font(.body)
            
            HStack(spacing: 20) {
                GSVector(vector: ["1", "2", "-1", "0"], title: "v₁")
                GSVector(vector: ["2", "2", "0", "1"], title: "v₂")
                GSVector(vector: ["1", "1", "1", "0"], title: "v₃")
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
            
            Divider()
            
            // Step 1
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 1: Set w₁ = v₁")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("w₁ = [1, 2, -1, 0]ᵀ")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
            }
            
            // Step 2
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 2: Compute w₂ = v₂ - projᵥ₁v₂")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.purple)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Projection coefficient: (v₂ · w₁)/(w₁ · w₁)")
                        .font(.caption)
                    Text("= (2+4+0+0)/(1+4+1+0) = 6/6 = 1")
                        .font(.system(.caption, design: .monospaced))
                }
                
                Text("w₂ = v₂ - 1·w₁ = [2,2,0,1]ᵀ - [1,2,-1,0]ᵀ")
                    .font(.system(.caption, design: .monospaced))
                
                Text("w₂ = [1, 0, 1, 1]ᵀ")
                    .font(.system(.body, design: .monospaced))
                    .bold()
                    .padding(8)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(6)
            }
            
            // Step 3
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 3: Compute w₃ = v₃ - projᵥ₁v₃ - projᵥ₂v₃")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Proj onto w₁: coeff = (1+2-1)/(6) = 2/6 = 1/3")
                        .font(.system(.caption, design: .monospaced))
                    Text("Proj onto w₂: coeff = (1+0+1+0)/(3) = 2/3")
                        .font(.system(.caption, design: .monospaced))
                }
                
                Text("w₃ = v₃ - (1/3)w₁ - (2/3)w₂")
                    .font(.system(.caption, design: .monospaced))
                
                Text("w₃ = [0, 1/3, 2/3, -2/3]ᵀ")
                    .font(.system(.body, design: .monospaced))
                    .bold()
                    .padding(8)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(6)
            }
            
            // Step 4: Normalization
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 4: Normalize Each wᵢ")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("w₁*")
                            .bold()
                        Text("= w₁/||w₁|| = (1/√6)[1, 2, -1, 0]ᵀ")
                            .font(.system(.caption, design: .monospaced))
                    }
                    HStack {
                        Text("w₂*")
                            .bold()
                        Text("= w₂/||w₂|| = (1/√3)[1, 0, 1, 1]ᵀ")
                            .font(.system(.caption, design: .monospaced))
                    }
                    HStack {
                        Text("w₃*")
                            .bold()
                        Text("= already unit length (verify: (1/9+4/9+4/9)=1)")
                            .font(.system(.caption, design: .monospaced))
                    }
                }
            }
            
            // Result
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                VStack(alignment: .leading) {
                    Text("Orthonormal Basis B*")
                        .font(.headline)
                    Text("B* = {w₁*, w₂*, w₃*}")
                        .font(.system(.body, design: .monospaced))
                    Text("All vectors are mutually perpendicular AND have length 1.")
                        .font(.caption)
                        .foregroundColor(.secondary)
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

struct GSVector: View {
    let vector: [String]
    let title: String
    
    var body: some View {
        VStack {
            Text(title).font(.caption).bold()
            VStack(spacing: 2) {
                ForEach(vector, id: \.self) { val in
                    Text(val)
                        .font(.system(.caption, design: .monospaced))
                }
            }
            .padding(6)
            .background(Color.white)
            .cornerRadius(6)
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.green.opacity(0.3)))
        }
    }
}
