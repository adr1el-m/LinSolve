import SwiftUI

struct RotationsReflectionsView: View {
    @State private var selectedExample: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "rotate.right")
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                        Text("Rotations & Reflections")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Constructing Standard Orthogonal Matrices")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Matrix Templates
                VStack(alignment: .leading, spacing: 16) {
                    Text("Standard Forms")
                        .font(.headline)
                    
                    HStack(alignment: .top, spacing: 16) {
                        MatrixTemplateBox(
                            title: "Rotation by θ",
                            matrix: "┌ cos θ  -sin θ ┐\n└ sin θ   cos θ ┘",
                            note: "det = +1",
                            color: .blue
                        )
                        
                        MatrixTemplateBox(
                            title: "Reflection over line at θ/2",
                            matrix: "┌ cos θ   sin θ ┐\n└ sin θ  -cos θ ┘",
                            note: "det = -1",
                            color: .orange
                        )
                    }
                    
                    Text("**How to tell them apart?** Check the determinant! Rotations have det = +1, reflections have det = -1.")
                        .font(.caption)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Picker("Example", selection: $selectedExample) {
                    Text("Rotation").tag(0)
                    Text("Reflection").tag(1)
                }
                .pickerStyle(.segmented)
                
                if selectedExample == 0 {
                    RotationExample()
                } else {
                    ReflectionExample()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct MatrixTemplateBox: View {
    let title: String
    let matrix: String
    let note: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .bold()
            Text(matrix)
                .font(.system(.caption, design: .monospaced))
            Text(note)
                .font(.caption2)
                .foregroundColor(color)
                .bold()
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Rotation Example (Example 237.1)
struct RotationExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Rotation by 120°")
                .font(.headline)
            
            Text("Goal: Find the matrix R₁₂₀° that rotates vectors counterclockwise by 120°")
                .font(.body)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                RotationStepView(
                    step: 1,
                    title: "Substitute θ = 120° into the template",
                    values: ["cos 120° = -1/2", "sin 120° = √3/2"]
                )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Step 2: Build the Matrix")
                        .font(.subheadline)
                        .bold()
                    
                    Text("""
                               ┌ cos 120°  -sin 120° ┐
                        R₁₂₀° = │                     │
                               └ sin 120°   cos 120° ┘
                    """)
                        .font(.system(.caption, design: .monospaced))
                        .padding(8)
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(6)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Result")
                    .font(.headline)
                
                Text("""
                           ┌ -1/2    -√3/2 ┐
                    R₁₂₀° = │              │
                           └  √3/2   -1/2  ┘
                """)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                Text("This matrix rotates any vector 120° counterclockwise around the origin.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "arrow.counterclockwise")
                    .foregroundColor(.blue)
                Text("Verify: det(R) = (-1/2)(-1/2) - (-√3/2)(√3/2) = 1/4 + 3/4 = 1 ✓")
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

// MARK: - Reflection Example (Example 237.2)
struct ReflectionExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reflection Across y = x")
                .font(.headline)
            
            Text("Goal: Find the matrix H₄₅° for reflection about the line y = x (which makes 45° with x-axis)")
                .font(.body)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Step 1: Identify the line angle")
                        .font(.subheadline)
                        .bold()
                    Text("Line y = x has angle 45° with x-axis → θ/2 = 45° → θ = 90°")
                        .font(.caption)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Step 2: Substitute θ = 90° into reflection template")
                        .font(.subheadline)
                        .bold()
                    
                    Text("""
                        ┌ cos 90°   sin 90° ┐     ┌ 0  1 ┐
                        │                   │  =  │      │
                        └ sin 90°  -cos 90° ┘     └ 1  0 ┘
                    """)
                        .font(.system(.caption, design: .monospaced))
                        .padding(8)
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(6)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Result")
                    .font(.headline)
                
                Text("""
                          ┌ 0  1 ┐
                    H₄₅° = │      │
                          └ 1  0 ┘
                """)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                
                Text("This matrix swaps x and y coordinates, which is exactly what reflection over y = x does!")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "arrow.left.and.right")
                    .foregroundColor(.orange)
                Text("Verify: det(H) = 0 - 1 = -1 ✓ (reflection has det = -1)")
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

struct RotationStepView: View {
    let step: Int
    let title: String
    let values: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Step \(step): \(title)")
                .font(.subheadline)
                .bold()
            ForEach(values, id: \.self) { val in
                Text("• \(val)")
                    .font(.system(.caption, design: .monospaced))
            }
        }
    }
}
