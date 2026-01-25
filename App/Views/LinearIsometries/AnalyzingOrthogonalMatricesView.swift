import SwiftUI

struct AnalyzingOrthogonalMatricesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "square.grid.2x2")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                        Text("Analyzing Orthogonal Matrices")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Identifying What Transformation a Matrix Represents")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Process Overview
                VStack(alignment: .leading, spacing: 12) {
                    Text("The Analysis Process")
                        .font(.headline)
                    
                    Text("Given an orthogonal matrix Q, we can determine exactly what geometric transformation it performs:")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        AnalysisStepBox(step: 1, title: "Verify Orthogonality", description: "Check that QᵀQ = I")
                        AnalysisStepBox(step: 2, title: "Classify Type", description: "det(Q) = +1 → Rotation, det(Q) = -1 → Reflection")
                        AnalysisStepBox(step: 3, title: "Find Parameters", description: "Match entries to template to find θ")
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Example 238
                IdentifyingMatrixExample()
                
                Spacer()
            }
            .padding()
        }
    }
}

struct AnalysisStepBox: View {
    let step: Int
    let title: String
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
                Text(title)
                    .font(.subheadline)
                    .bold()
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Example 238
struct IdentifyingMatrixExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Identifying a Matrix Transformation")
                .font(.headline)
            
            Text("Input Matrix Q:")
                .font(.caption)
            
            Text("""
                    ┌ -1/√2   -1/√2 ┐
                Q = │              │
                    └ -1/√2    1/√2 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            // Step 1: Verify Orthogonality
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 1: Verify QᵀQ = I")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Diagonal entries: (-1/√2)² + (-1/√2)² = 1/2 + 1/2 = 1 ✓")
                        .font(.caption)
                    Text("Off-diagonal: (-1/√2)(-1/√2) + (-1/√2)(1/√2) = 1/2 - 1/2 = 0 ✓")
                        .font(.caption)
                }
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
                
                Text("QᵀQ = I₂, so Q is orthogonal ✓")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.green)
            }
            
            // Step 2: Classify Type
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 2: Calculate Determinant")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.purple)
                
                Text("det(Q) = (-1/√2)(1/√2) - (-1/√2)(-1/√2)")
                    .font(.system(.caption, design: .monospaced))
                Text("      = -1/2 - 1/2 = -1")
                    .font(.system(.caption, design: .monospaced))
                
                HStack {
                    Image(systemName: "arrow.left.and.right")
                        .foregroundColor(.orange)
                    Text("det = -1 → This is a REFLECTION")
                        .font(.caption)
                        .bold()
                }
                .padding(8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(6)
            }
            
            // Step 3: Find Axis
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 3: Find Reflection Axis")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.green)
                
                Text("Match to reflection template:")
                    .font(.caption)
                
                Text("""
                    ┌ cos θ   sin θ ┐
                    │               │
                    └ sin θ  -cos θ ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding(8)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(6)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("cos θ = -1/√2 → θ = 225° (or 135°)")
                        .font(.caption)
                    Text("sin θ = -1/√2 → confirms θ = 225°")
                        .font(.caption)
                    Text("Axis angle = θ/2 = 112.5°")
                        .font(.caption)
                        .bold()
                }
            }
            
            // Result
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                VStack(alignment: .leading) {
                    Text("Result")
                        .font(.headline)
                    Text("Q is reflection about the line y = (tan 112.5°)x = (−√2 − 1)x")
                        .font(.system(.caption, design: .monospaced))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.green.opacity(0.1))
            .cornerRadius(8)
            
            Text("By systematically analyzing the matrix, we've identified the exact geometric transformation it performs!")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}
