import SwiftUI

struct VerifyingIsometriesView: View {
    @State private var selectedExample: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "ruler")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Text("Verifying Isometries")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Checking Preservation of Angles and Lengths")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Definition
                VStack(alignment: .leading, spacing: 12) {
                    Text("What is an Isometry?")
                        .font(.headline)
                    
                    Text("An isometry (or orthogonal transformation) is a linear map that preserves geometric structure:")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        IsometryPropertyBox(
                            property: "Length Preservation",
                            formula: "||T(x)|| = ||x||",
                            meaning: "Vectors keep the same length",
                            color: .blue
                        )
                        
                        IsometryPropertyBox(
                            property: "Angle Preservation",
                            formula: "∠(T(u), T(v)) = ∠(u, v)",
                            meaning: "Angles between vectors stay the same",
                            color: .purple
                        )
                    }
                    
                    Text("**Key fact:** A transformation is an isometry ⟺ its matrix is orthogonal (QᵀQ = I)")
                        .font(.caption)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Picker("Example", selection: $selectedExample) {
                    Text("Verify Isometry").tag(0)
                    Text("Prove Length").tag(1)
                    Text("Non-Isometry").tag(2)
                }
                .pickerStyle(.segmented)
                
                if selectedExample == 0 {
                    VerifyGeometryExample()
                } else if selectedExample == 1 {
                    ProveLengthPreservationExample()
                } else {
                    NonIsometryExample()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct IsometryPropertyBox: View {
    let property: String
    let formula: String
    let meaning: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(color)
            VStack(alignment: .leading, spacing: 2) {
                Text(property)
                    .font(.subheadline)
                    .bold()
                Text(formula)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(color)
                Text(meaning)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Verify Geometry Example
struct VerifyGeometryExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Verifying Preservation of Geometry")
                .font(.headline)
            
            Text("Input Matrix A:")
                .font(.caption)
            
            Text("""
                ┌  0  -1 ┐
            A = │        │
                └  1   0 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Text("Test vectors: u = [1, 1]ᵀ, v = [-2, 0]ᵀ")
                .font(.caption)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                IsometryStepView(
                    step: 1,
                    title: "Check Original Angle",
                    content: "cos θ = (u · v)/(||u|| ||v||) = -2/(√2 · 2) = -1/√2",
                    result: "θ = 135°"
                )
                
                IsometryStepView(
                    step: 2,
                    title: "Transform Vectors",
                    content: "T(u) = [1, -1]ᵀ, T(v) = [0, -2]ᵀ",
                    result: ""
                )
                
                IsometryStepView(
                    step: 3,
                    title: "Check Image Angle",
                    content: "cos α = (T(u) · T(v))/(||T(u)|| ||T(v)||) = -2/(√2 · 2) = -1/√2",
                    result: "α = 135°"
                )
                
                IsometryStepView(
                    step: 4,
                    title: "Check Lengths",
                    content: "||u|| = √2 = ||T(u)||, ||v|| = 2 = ||T(v)||",
                    result: "Preserved ✓"
                )
            }
            
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                Text("Angles and lengths preserved → This is an isometry!")
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

// MARK: - Length Preservation Proof (Example 229)
struct ProveLengthPreservationExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Proving Length Preservation")
                .font(.headline)
            
            Text("Same matrix A, arbitrary vector x = [x₁, x₂]ᵀ")
                .font(.body)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Step 1: Compute T(x)")
                        .font(.subheadline)
                        .bold()
                    Text("T(x) = [-x₂, x₁]ᵀ")
                        .font(.system(.body, design: .monospaced))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Step 2: Compute ||T(x)||")
                        .font(.subheadline)
                        .bold()
                    Text("||T(x)|| = √((-x₂)² + x₁²) = √(x₁² + x₂²)")
                        .font(.system(.caption, design: .monospaced))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Step 3: Compare with ||x||")
                        .font(.subheadline)
                        .bold()
                    Text("||x|| = √(x₁² + x₂²)")
                        .font(.system(.caption, design: .monospaced))
                }
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
            
            HStack {
                Image(systemName: "equal.circle.fill")
                    .foregroundColor(.blue)
                Text("||T(x)|| = ||x|| for ALL vectors → T is a linear isometry")
                    .font(.caption)
                    .bold()
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
            
            Text("**Note:** This matrix represents a 90° rotation. Rotations always preserve lengths!")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Non-Isometry Example (Example 230)
struct NonIsometryExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Proving Non-Isometry: Shear Matrix")
                .font(.headline)
            
            Text("Input: Shear Matrix A")
                .font(.caption)
            
            Text("""
                ┌ 1  1 ┐
            A = │      │
                └ 0  1 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Compare Angles Before and After")
                    .font(.subheadline)
                    .bold()
                
                HStack(alignment: .top, spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Original:")
                            .font(.caption).bold()
                        Text("e₁ = [1, 0]ᵀ")
                            .font(.system(.caption2, design: .monospaced))
                        Text("e₂ = [0, 1]ᵀ")
                            .font(.system(.caption2, design: .monospaced))
                        Text("Angle = 90°")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    Text("→")
                    
                    VStack(alignment: .leading) {
                        Text("After T:")
                            .font(.caption).bold()
                        Text("T(e₁) = [1, 0]ᵀ")
                            .font(.system(.caption2, design: .monospaced))
                        Text("T(e₂) = [1, 1]ᵀ")
                            .font(.system(.caption2, design: .monospaced))
                        Text("Angle = 45°")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            }
            
            HStack {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                Text("90° ≠ 45° → The shear is NOT an isometry")
                    .font(.body)
                    .bold()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.red.opacity(0.1))
            .cornerRadius(8)
            
            Text("Shears \"slant\" the space, changing angles. Only orthogonal matrices (rotations and reflections) are isometries.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct IsometryStepView: View {
    let step: Int
    let title: String
    let content: String
    let result: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(step)")
                .font(.caption)
                .bold()
                .frame(width: 24, height: 24)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                Text(content)
                    .font(.system(.caption, design: .monospaced))
                if !result.isEmpty {
                    Text(result)
                        .font(.caption)
                        .foregroundColor(.green)
                        .bold()
                }
            }
        }
    }
}
