import SwiftUI

struct MatrixTransformationsView: View {
    @State private var selectedExample: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "arrow.right.arrow.left")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Text("Matrix Transformations")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Computing Images Using Matrices")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Core Concept
                VStack(alignment: .leading, spacing: 12) {
                    Text("The Big Idea")
                        .font(.headline)
                    
                    Text("A matrix A defines a transformation T_A that maps vectors from one space to another via multiplication:")
                        .font(.body)
                    
                    Text("T_A(x) = Ax")
                        .font(.system(.title2, design: .monospaced))
                        .bold()
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text("Every linear transformation between finite-dimensional spaces can be represented this way!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Picker("Example", selection: $selectedExample) {
                    Text("Formula").tag(0)
                    Text("Grid Visual").tag(1)
                    Text("Truncation").tag(2)
                }
                .pickerStyle(.segmented)
                
                if selectedExample == 0 {
                    TransformationFormulaExample()
                } else if selectedExample == 1 {
                    VisualizingTransformationExample()
                } else {
                    TruncationMapExample()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Example 207: Finding Transformation Formula
struct TransformationFormulaExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Finding a Transformation Formula")
                .font(.headline)
            
            Text("Input Matrix A:")
                .font(.caption)
            
            Text("""
                ┌ 2  3  -1 ┐
            A = │          │
                └ 1  0   2 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Compute T_A(x) for general vector x = [x, y, z]ᵀ")
                    .font(.subheadline)
                    .bold()
                
                Text("""
                    ┌ 2  3  -1 ┐   ┌ x ┐     ┌ 2x + 3y - z ┐
                    │          │ × │ y │  =  │             │
                    └ 1  0   2 ┘   └ z ┘     └  x + 2z     ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Standard Basis Images")
                    .font(.subheadline)
                    .bold()
                
                Text("The columns of A tell us where each basis vector goes:")
                    .font(.caption)
                
                HStack(spacing: 16) {
                    TransformImageBox(input: "e₁", output: "[2, 1]ᵀ", note: "Column 1")
                    TransformImageBox(input: "e₂", output: "[3, 0]ᵀ", note: "Column 2")
                    TransformImageBox(input: "e₃", output: "[-1, 2]ᵀ", note: "Column 3")
                }
            }
            
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("Key Insight: The columns of A are the images T(e₁), T(e₂), T(e₃)!")
                    .font(.caption)
                    .bold()
            }
            .padding()
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Example 208: Visualizing Transformation
struct VisualizingTransformationExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Visualizing a Transformation")
                .font(.headline)
            
            Text("Input Matrix A:")
                .font(.caption)
            
            Text("""
                ┌  2  -1 ┐
            A = │        │
                └  1   3 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Map Standard Basis Vectors")
                    .font(.subheadline)
                    .bold()
                
                HStack(spacing: 30) {
                    VStack {
                        Text("e₁ = [1, 0]ᵀ")
                            .font(.caption)
                        Text("↓")
                        Text("[2, 1]ᵀ")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.blue)
                    }
                    
                    VStack {
                        Text("e₂ = [0, 1]ᵀ")
                            .font(.caption)
                        Text("↓")
                        Text("[-1, 3]ᵀ")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.purple)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Geometric Effect")
                    .font(.subheadline)
                    .bold()
                
                Text("• The grid is stretched and rotated")
                    .font(.body)
                Text("• Squares become parallelograms")
                    .font(.body)
                Text("• Lines remain lines (linearity!)")
                    .font(.body)
                
                Text("The area of shapes is scaled by |det(A)| = |6 - (-1)| = 7")
                    .font(.caption)
                    .padding(8)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(6)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Example 209: Truncation Map
struct TruncationMapExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Truncation Map (Projection)")
                .font(.headline)
            
            Text("Input Matrix P:")
                .font(.caption)
            
            Text("""
                ┌ 1  0  0 ┐
            P = │         │
                └ 0  1  0 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Text("This matrix \"forgets\" the z-component, projecting ℝ³ onto the xy-plane.")
                .font(.body)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Apply to vectors:")
                    .font(.subheadline)
                    .bold()
                
                TruncationRow(input: "[1, 1, 1]ᵀ", output: "[1, 1]ᵀ")
                TruncationRow(input: "[-2, 1, -1]ᵀ", output: "[-2, 1]ᵀ")
                TruncationRow(input: "[1, -1, 2]ᵀ", output: "[1, -1]ᵀ")
            }
            
            HStack {
                Image(systemName: "arrow.down.to.line")
                    .foregroundColor(.orange)
                Text("The transformation \"drops\" the last coordinate, like projecting 3D points onto a 2D floor.")
                    .font(.caption)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct TransformImageBox: View {
    let input: String
    let output: String
    let note: String
    
    var body: some View {
        VStack {
            Text(input)
                .font(.caption)
            Text("↓")
            Text(output)
                .font(.system(.caption, design: .monospaced))
                .bold()
            Text(note)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(8)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(6)
    }
}

struct TruncationRow: View {
    let input: String
    let output: String
    
    var body: some View {
        HStack {
            Text("P")
                .font(.caption)
                .foregroundColor(.orange)
            Text(input)
                .font(.system(.caption, design: .monospaced))
            Text("=")
            Text(output)
                .font(.system(.caption, design: .monospaced))
                .bold()
        }
        .padding(6)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(6)
    }
}
