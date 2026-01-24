import SwiftUI

struct OrthogonalSetsView: View {
    // Default orthogonal set from example
    @State private var v1: [String] = ["1", "2", "2", "4"]
    @State private var v2: [String] = ["-2", "1", "-4", "2"]
    @State private var v3: [String] = ["-4", "2", "2", "1"]
    
    @State private var showSteps: Bool = false
    
    // Results
    @State private var dotProducts: [(String, Fraction)] = []
    @State private var norms: [Double] = []
    @State private var isOrthogonal: Bool = false
    @State private var normalizedVectors: [[Double]] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Orthogonality & Orthonormal Sets")
                        .font(.largeTitle)
                        .bold()
                    Text("Perpendicular Vectors and Unit Length")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
**Orthogonal vectors** are vectors that are perpendicular to each other. When the dot product of two vectors equals zero, they are orthogonal.

**Why orthogonality matters:**
• Orthogonal vectors form efficient **coordinate systems**
• They simplify projections and decompositions
• Orthogonal matrices preserve lengths and angles
• Used in **QR decomposition**, **Principal Component Analysis**, and more

An **orthonormal set** takes this further: all vectors are orthogonal to each other AND each has length 1 (unit vectors).
""")
                        .font(.body)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Definitions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Key Definitions")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("**Orthogonal Vectors:**")
                                .font(.subheadline)
                            Text("u ⊥ v  ⟺  u · v = 0")
                                .font(.system(.body, design: .serif))
                                .italic()
                                .padding(8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(6)
                            Text("Two vectors are orthogonal if their dot product is zero")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("**Orthogonal Set:**")
                                .font(.subheadline)
                            Text("All pairs of distinct vectors are orthogonal")
                                .font(.body)
                                .padding(8)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(6)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("**Orthonormal Set:**")
                                .font(.subheadline)
                            Text("Orthogonal + all vectors have ||vᵢ|| = 1")
                                .font(.body)
                                .padding(8)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(6)
                            Text("To convert: wᵢ = vᵢ / ||vᵢ||")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                // Input Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Test a Set of Vectors")
                        .font(.headline)
                    
                    Text("Enter up to 3 vectors to check if they form an orthogonal set:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(alignment: .top, spacing: 15) {
                        VectorEditor(label: "v₁", vector: $v1, color: .blue)
                        VectorEditor(label: "v₂", vector: $v2, color: .green)
                        VectorEditor(label: "v₃", vector: $v3, color: .orange)
                    }
                    
                    Button(action: compute) {
                        Text("Check Orthogonality")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                // Results
                if showSteps {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Analysis Results")
                            .font(.title2)
                            .bold()
                        
                        // Step 1: Check all pairs
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Step 1: Check All Pairs for Orthogonality")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Text("For a set to be orthogonal, **every pair** of distinct vectors must have dot product = 0:")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            VStack(spacing: 8) {
                                ForEach(dotProducts, id: \.0) { pair in
                                    HStack {
                                        Text(pair.0)
                                            .font(.system(.body, design: .monospaced))
                                            .frame(width: 60, alignment: .leading)
                                        
                                        Text("= \(pair.1.description)")
                                            .font(.system(.body, design: .monospaced))
                                        
                                        Spacer()
                                        
                                        if pair.1 == Fraction(0) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                            Text("Orthogonal")
                                                .font(.caption)
                                                .foregroundColor(.green)
                                        } else {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                            Text("Not Orthogonal")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding(8)
                                    .background(pair.1 == Fraction(0) ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                                    .cornerRadius(6)
                                }
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        // Orthogonality Result
                        VStack(alignment: .leading, spacing: 10) {
                            if isOrthogonal {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.green)
                                    
                                    VStack(alignment: .leading) {
                                        Text("✓ This is an Orthogonal Set!")
                                            .font(.headline)
                                            .foregroundColor(.green)
                                        Text("All pairs have dot product = 0")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(10)
                            } else {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.red)
                                    
                                    VStack(alignment: .leading) {
                                        Text("✗ Not an Orthogonal Set")
                                            .font(.headline)
                                            .foregroundColor(.red)
                                        Text("At least one pair has non-zero dot product")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        
                        // Step 2: Compute norms (if orthogonal)
                        if isOrthogonal {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Step 2: Compute Norms")
                                    .font(.headline)
                                    .foregroundColor(.purple)
                                
                                Text("To create an orthonormal set, we need to know the length of each vector:")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                VStack(spacing: 8) {
                                    ForEach(Array(norms.enumerated()), id: \.offset) { index, norm in
                                        HStack {
                                            Text("||v\(index + 1)||")
                                                .font(.system(.body, design: .monospaced))
                                            Text("= \(String(format: "%.4f", norm))")
                                                .font(.system(.body, design: .monospaced))
                                            
                                            if abs(norm - 1.0) < 0.0001 {
                                                Text("(already unit)")
                                                    .font(.caption)
                                                    .foregroundColor(.green)
                                            }
                                        }
                                        .padding(8)
                                        .background(Color(uiColor: .tertiarySystemBackground))
                                        .cornerRadius(6)
                                    }
                                }
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .cornerRadius(8)
                            }
                            
                            // Step 3: Create orthonormal set
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Step 3: Create Orthonormal Set")
                                    .font(.headline)
                                    .foregroundColor(.orange)
                                
                                Text("Divide each vector by its norm to get unit vectors:")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                Text("wᵢ = vᵢ / ||vᵢ||")
                                    .font(.system(.body, design: .serif))
                                    .italic()
                                    .padding(8)
                                    .background(Color.orange.opacity(0.1))
                                    .cornerRadius(6)
                                
                                HStack(alignment: .top, spacing: 20) {
                                    ForEach(Array(normalizedVectors.enumerated()), id: \.offset) { index, vec in
                                        VStack {
                                            Text("w\(index + 1)")
                                                .font(.caption)
                                                .bold()
                                            
                                            VStack(spacing: 2) {
                                                ForEach(vec, id: \.self) { val in
                                                    Text(String(format: "%.3f", val))
                                                        .font(.system(.caption, design: .monospaced))
                                                }
                                            }
                                            .padding(6)
                                            .background(Color(uiColor: .tertiarySystemBackground))
                                            .cornerRadius(6)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .cornerRadius(8)
                                
                                Text("✓ The set {w₁, w₂, w₃} is now **orthonormal** — each vector has length 1 and all pairs are perpendicular!")
                                    .font(.body)
                                    .foregroundColor(.green)
                                    .padding()
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        
                        // Properties box
                        VStack(alignment: .leading, spacing: 8) {
                            Text("📐 Properties of Orthonormal Sets")
                                .font(.headline)
                            
                            Text("""
• **Easy projections**: projₐ(b) = (a · b)a when a is a unit vector
• **Orthonormal matrices**: Qᵀ = Q⁻¹ (transpose equals inverse)
• **Preserve lengths**: ||Qx|| = ||x|| for orthonormal Q
• **Gram-Schmidt process** creates orthonormal bases from any basis
""")
                                .font(.body)
                        }
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding()
                    .transition(.opacity)
                }
                
                Spacer()
            }
        }
    }
    
    func compute() {
        let vectors: [[Double]] = [
            v1.compactMap { Double($0) },
            v2.compactMap { Double($0) },
            v3.compactMap { Double($0) }
        ]
        
        // Check all have same dimension
        guard vectors[0].count == v1.count,
              vectors[1].count == v2.count,
              vectors[2].count == v3.count,
              vectors[0].count == vectors[1].count,
              vectors[1].count == vectors[2].count else { return }
        
        // Compute dot products for all pairs
        dotProducts = []
        let pairs = [("v₁·v₂", 0, 1), ("v₁·v₃", 0, 2), ("v₂·v₃", 1, 2)]
        
        for (label, i, j) in pairs {
            let dp = zip(vectors[i], vectors[j]).reduce(0) { $0 + ($1.0 * $1.1) }
            dotProducts.append((label, Fraction(Int(dp))))
        }
        
        // Check if all are zero
        isOrthogonal = dotProducts.allSatisfy { $0.1 == Fraction(0) }
        
        // Compute norms
        norms = vectors.map { vec in
            sqrt(vec.reduce(0) { $0 + ($1 * $1) })
        }
        
        // Create normalized vectors
        normalizedVectors = zip(vectors, norms).map { vec, norm in
            guard norm > 0 else { return vec }
            return vec.map { $0 / norm }
        }
        
        withAnimation {
            showSteps = true
        }
    }
}

struct VectorEditor: View {
    let label: String
    @Binding var vector: [String]
    var color: Color = .primary
    
    var body: some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.headline)
                .foregroundColor(color)
            
            VStack(spacing: 3) {
                ForEach(0..<vector.count, id: \.self) { i in
                    TextField("0", text: $vector[i])
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.center)
                        .frame(width: 45, height: 28)
                        .background(Color(uiColor: .systemBackground))
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(color.opacity(0.4)))
                }
            }
            .padding(6)
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(6)
            .overlay(
                HStack {
                    BracketShape(left: true).stroke(color, lineWidth: 1.5).frame(width: 6)
                    Spacer()
                    BracketShape(left: false).stroke(color, lineWidth: 1.5).frame(width: 6)
                }
            )
        }
    }
}
