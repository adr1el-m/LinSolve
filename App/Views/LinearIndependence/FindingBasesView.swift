import SwiftUI

struct FindingBasesView: View {
    @State private var showPruningExample: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "cube")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("Finding Bases")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Identifying Redundant Vectors in Spanning Sets")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Introduction
                VStack(alignment: .leading, spacing: 16) {
                    Text("From Spanning Sets to Bases")
                        .font(.headline)
                    
                    Text("A basis is a spanning set that is also linearly independent — it has no redundant vectors. Given a spanning set with dependencies, we can \"prune\" it to find a basis.")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Spanning Set → Remove Redundant Vectors → Basis")
                            .font(.system(.body, design: .monospaced))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // What is a Basis?
                VStack(alignment: .leading, spacing: 16) {
                    Text("📐 What is a Basis?")
                        .font(.headline)
                    
                    Text("A basis B for a subspace W is a set of vectors that:")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top) {
                            Image(systemName: "1.circle.fill")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text("Spans W")
                                    .font(.subheadline)
                                    .bold()
                                Text("Every vector in W can be written as a combination of basis vectors")
                                    .font(.caption)
                            }
                        }
                        
                        HStack(alignment: .top) {
                            Image(systemName: "2.circle.fill")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text("Is Linearly Independent")
                                    .font(.subheadline)
                                    .bold()
                                Text("No redundancy — every vector is essential")
                                    .font(.caption)
                            }
                        }
                    }
                    
                    Text("The number of vectors in any basis is the dimension of W.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // The Pivot Column Method
                VStack(alignment: .leading, spacing: 16) {
                    Text("🔑 The Pivot Column Method")
                        .font(.headline)
                    
                    Text("To find a linearly independent subset (basis) from a spanning set:")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        PivotMethodStepView(
                            number: 1,
                            title: "Form the Matrix",
                            description: "Put the spanning vectors as columns of a matrix A"
                        )
                        
                        PivotMethodStepView(
                            number: 2,
                            title: "Row Reduce to RREF",
                            description: "Find the reduced row echelon form"
                        )
                        
                        PivotMethodStepView(
                            number: 3,
                            title: "Identify Pivot Columns",
                            description: "Find which columns contain the leading 1s (pivots)"
                        )
                        
                        PivotMethodStepView(
                            number: 4,
                            title: "Select Original Vectors",
                            description: "The ORIGINAL vectors from the pivot columns form a basis"
                        )
                    }
                    
                    // Important warning
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("Important!")
                                .font(.subheadline)
                                .bold()
                        }
                        
                        Text("Use the ORIGINAL vectors from A, not the vectors from RREF(A)! The RREF tells you WHICH columns to keep, but you keep the original vectors.")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Main Example
                PruningExampleView()
                
                // Why Non-Pivot Columns Are Redundant
                VStack(alignment: .leading, spacing: 16) {
                    Text("❓ Why Are Non-Pivot Columns Redundant?")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("In RREF, each non-pivot column can be written as a combination of the pivot columns to its left. This relationship carries over to the original matrix!")
                            .font(.body)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Example from RREF:")
                                .font(.subheadline)
                                .bold()
                            
                            Text("If column 4 in RREF is [1, 1, 0]ᵀ, this means:")
                                .font(.caption)
                            
                            Text("v₄ = 1·v₁ + 1·v₃ (assuming cols 1,3 are pivots)")
                                .font(.system(.caption, design: .monospaced))
                                .padding(8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(6)
                            
                            Text("So v₄ is a linear combination of v₁ and v₃ — it's redundant!")
                                .font(.caption)
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Summary
                VStack(alignment: .leading, spacing: 16) {
                    Text("📋 Summary")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        SummaryPointView(
                            icon: "arrow.right.circle.fill",
                            color: .blue,
                            text: "Pivot columns correspond to linearly independent vectors"
                        )
                        
                        SummaryPointView(
                            icon: "arrow.right.circle.fill",
                            color: .red,
                            text: "Non-pivot columns correspond to redundant vectors"
                        )
                        
                        SummaryPointView(
                            icon: "arrow.right.circle.fill",
                            color: .green,
                            text: "The pivot column vectors from the ORIGINAL matrix form a basis"
                        )
                        
                        SummaryPointView(
                            icon: "arrow.right.circle.fill",
                            color: .purple,
                            text: "The number of pivots equals the dimension of the span"
                        )
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Helper Views

struct PivotMethodStepView: View {
    let number: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Color.orange)
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

struct SummaryPointView: View {
    let icon: String
    let color: Color
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(text)
                .font(.body)
        }
    }
}

// MARK: - Pruning Example (Example 174)

struct PruningExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Finding a Linearly Independent Spanning Set")
                .font(.headline)
            
            Text("Given four column vectors v₁, v₂, v₃, v₄ of matrix A, find a linearly independent subset that spans the same space.")
                .font(.body)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Step 1: Form the matrix and find RREF")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                HStack(spacing: 30) {
                    VStack {
                        Text("Original A")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("""
                            ┌ v₁ v₂ v₃ v₄ ┐
                            │             │
                            │ (columns)   │
                            └             ┘
                        """)
                            .font(.system(.caption, design: .monospaced))
                    }
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.blue)
                    
                    VStack {
                        Text("RREF(A)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("""
                            ┌ 1 -2  0  1 ┐
                            │ 0  0  1  1 │
                            └ 0  0  0  0 ┘
                        """)
                            .font(.system(.caption, design: .monospaced))
                    }
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
                
                Text("Step 2: Identify pivot columns")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Text("Column 1:")
                        Text("PIVOT")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        Text("(has leading 1 in row 1)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Text("Column 2:")
                        Text("NOT PIVOT")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        Text("(no leading 1)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Text("Column 3:")
                        Text("PIVOT")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        Text("(has leading 1 in row 2)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Text("Column 4:")
                        Text("NOT PIVOT")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        Text("(no leading 1)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
                
                Text("Step 3: Analyze redundancy")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("From RREF, column 4 = [1, 1, 0]ᵀ tells us:")
                        .font(.body)
                    
                    Text("v₄ = 1·v₁ + 0·v₂ + 1·v₃ = v₁ + v₃")
                        .font(.system(.body, design: .monospaced))
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(6)
                    
                    Text("So v₄ is redundant (can be expressed using other vectors).")
                        .font(.caption)
                        .foregroundColor(.red)
                    
                    Text("Similarly, column 2 = [-2, 0, 0]ᵀ tells us:")
                        .font(.body)
                    
                    Text("v₂ = -2·v₁")
                        .font(.system(.body, design: .monospaced))
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(6)
                    
                    Text("So v₂ is also redundant.")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
                
                Text("Step 4: Conclusion")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("The pivot columns are 1 and 3.")
                        .font(.body)
                    
                    Text("Therefore, {v₁, v₃} forms a linearly independent spanning set (a basis for Col(A)).")
                        .font(.body)
                }
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    Text("Basis = {v₁, v₃}")
                        .font(.body)
                        .bold()
                }
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
                
                // Verification
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.diamond.fill")
                            .foregroundColor(.blue)
                        Text("Verification")
                            .font(.subheadline)
                            .bold()
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("• dim(Col(A)) = 2 (number of pivots)")
                            .font(.caption)
                        Text("• {v₁, v₃} has 2 vectors")
                            .font(.caption)
                        Text("• span{v₁, v₃} = span{v₁, v₂, v₃, v₄}")
                            .font(.caption)
                        Text("• {v₁, v₃} is linearly independent")
                            .font(.caption)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}
