import SwiftUI

struct VerifyingBasisView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "checkmark.seal")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Text("Verifying a Basis")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Two Requirements: Independence & Span")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Definition
                VStack(alignment: .leading, spacing: 16) {
                    Text("What Makes a Basis?")
                        .font(.headline)
                    
                    Text("A set of vectors B = {v₁, ..., vₙ} is a basis for a vector space V if it satisfies two conditions:")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top) {
                            Image(systemName: "1.circle.fill")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text("Linearly Independent")
                                    .font(.subheadline)
                                    .bold()
                                Text("No vector is redundant; none can be written as a combination of others.")
                                    .font(.caption)
                            }
                        }
                        
                        HStack(alignment: .top) {
                            Image(systemName: "2.circle.fill")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text("Spans the Space")
                                    .font(.subheadline)
                                    .bold()
                                Text("Every vector in V can be generated as a linear combination of B.")
                                    .font(.caption)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Examples Tab
                Picker("Example", selection: $selectedTab) {
                    Text("Standard Basis").tag(0)
                    Text("Determinant Test").tag(1)
                }
                .pickerStyle(.segmented)
                
                if selectedTab == 0 {
                    StandardBasisVerificationView()
                } else {
                    DeterminantTestView()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Standard Basis Verification (Example 176)
struct StandardBasisVerificationView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Standard Basis for ℝ³")
                .font(.headline)
            
            Text("Goal: Show that E = {e₁, e₂, e₃} is a basis for ℝ³.")
                .font(.body)
            
            HStack(spacing: 20) {
                BasisVectorColumnView(vector: ["1", "0", "0"], title: "e₁")
                BasisVectorColumnView(vector: ["0", "1", "0"], title: "e₂")
                BasisVectorColumnView(vector: ["0", "0", "1"], title: "e₃")
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
            
            Divider()
            
            // Check 1: Span
            VStack(alignment: .leading, spacing: 10) {
                Text("Check 1: Does it Span ℝ³?")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Pick ANY vector v = [x, y, z]ᵀ in ℝ³. Can we write it using E?")
                    .font(.body)
                
                Text("v = x·e₁ + y·e₂ + z·e₃")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                
                Text("Yes! Any vector is just a combination of the standard basis vectors using its own components as weights.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Check 2: Independence
            VStack(alignment: .leading, spacing: 10) {
                Text("Check 2: Is it Linearly Independent?")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.green)
                
                Text("Can we write 0 as a non-trivial combination?")
                    .font(.body)
                
                Text("c₁e₁ + c₂e₂ + c₃e₃ = [c₁, c₂, c₃]ᵀ = 0")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(6)
                
                Text("This implies c₁=0, c₂=0, c₃=0. The only solution is trivial.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                Text("Conclusion: E is a Basis")
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Determinant Test (Example 177)
struct DeterminantTestView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Determinant Test")
                .font(.headline)
            
            Text("Goal: Verify {v₁, v₂, v₃} is a basis for ℝ³.")
                .font(.body)
            
            HStack(spacing: 20) {
                BasisVectorColumnView(vector: ["0", "1", "1"], title: "v₁")
                BasisVectorColumnView(vector: ["1", "0", "1"], title: "v₂")
                BasisVectorColumnView(vector: ["1", "1", "0"], title: "v₃")
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("The Shortcut")
                    .font(.headline)
                
                Text("For n vectors in ℝⁿ, form a square matrix A with vectors as columns. If det(A) ≠ 0, then the vectors are linearly independent AND span ℝⁿ. They form a basis.")
                    .font(.body)
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Step 1: Form Matrix A")
                    .font(.subheadline)
                    .bold()
                
                Text("""
                    ┌ 0  1  1 ┐
                A = │ 1  0  1 │
                    └ 1  1  0 ┘
                """)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Step 2: Calculate Determinant")
                    .font(.subheadline)
                    .bold()
                
                Text("det(A) = 0(0-1) - 1(0-1) + 1(1-0)")
                    .font(.system(.caption, design: .monospaced))
                Text("       = 0 + 1 + 1")
                    .font(.system(.caption, design: .monospaced))
                
                Text("det(A) = 2")
                    .font(.system(.title3, design: .monospaced))
                    .bold()
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Step 3: Conclusion")
                    .font(.subheadline)
                    .bold()
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("2 ≠ 0 → Matrix is Nonsingular")
                        .font(.body)
                        .bold()
                }
                
                Text("Since A is nonsingular (invertible), its columns are linearly independent and span ℝ³. Therefore, they form a basis.")
                    .font(.caption)
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct BasisVectorColumnView: View {
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
            .overlay(
                RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.3))
            )
        }
    }
}
