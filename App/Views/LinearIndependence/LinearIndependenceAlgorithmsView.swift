import SwiftUI

struct LinearIndependenceAlgorithmsView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "function")
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                        Text("Systematic Algorithms")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Testing Linear Independence Efficiently")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Introduction
                VStack(alignment: .leading, spacing: 16) {
                    Text("Beyond the Definition")
                        .font(.headline)
                    
                    Text("While the definition c₁v₁ + ... + cₖvₖ = 0 is fundamental, there are faster ways to test linear independence. The method depends on the relationship between k (number of vectors) and n (dimension of the space).")
                        .font(.body)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Decision Tree
                VStack(alignment: .leading, spacing: 16) {
                    Text("🔀 Which Method to Use?")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        DecisionBranchView(
                            condition: "k > n (More vectors than dimensions)",
                            result: "Always DEPENDENT",
                            explanation: "You can't have more than n independent vectors in ℝⁿ",
                            color: .red
                        )
                        
                        DecisionBranchView(
                            condition: "k = n (Square matrix)",
                            result: "Use DETERMINANT",
                            explanation: "det ≠ 0 → Independent, det = 0 → Dependent",
                            color: .blue
                        )
                        
                        DecisionBranchView(
                            condition: "k < n (Fewer vectors than dimensions)",
                            result: "Use RREF",
                            explanation: "Pivot in every column → Independent",
                            color: .green
                        )
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Tab Selection for Examples
                Picker("Example", selection: $selectedTab) {
                    Text("k > n").tag(0)
                    Text("det ≠ 0").tag(1)
                    Text("det = 0").tag(2)
                    Text("RREF").tag(3)
                }
                .pickerStyle(.segmented)
                
                // Examples
                switch selectedTab {
                case 0:
                    MoreVectorsThanDimensionsExample()
                case 1:
                    DeterminantNonZeroExample()
                case 2:
                    DeterminantZeroExample()
                case 3:
                    RREFMethodExample()
                default:
                    EmptyView()
                }
                
                // Summary Table
                VStack(alignment: .leading, spacing: 16) {
                    Text("📊 Method Summary")
                        .font(.headline)
                    
                    VStack(spacing: 1) {
                        HStack {
                            Text("Scenario")
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Method")
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Independent If")
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        
                        MethodRowView(scenario: "k > n", method: "None needed", independent: "Never")
                        MethodRowView(scenario: "k = n", method: "Determinant", independent: "det(A) ≠ 0")
                        MethodRowView(scenario: "k ≤ n", method: "RREF", independent: "k pivots")
                    }
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
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

struct DecisionBranchView: View {
    let condition: String
    let result: String
    let explanation: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "arrow.right.circle.fill")
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(condition)
                    .font(.subheadline)
                    .bold()
                
                Text(result)
                    .font(.body)
                    .foregroundColor(color)
                    .bold()
                
                Text(explanation)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

struct MethodRowView: View {
    let scenario: String
    let method: String
    let independent: String
    
    var body: some View {
        HStack {
            Text(scenario)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(method)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(independent)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .background(Color(uiColor: .tertiarySystemBackground))
    }
}

// MARK: - Example 169.1: More Vectors Than Dimensions

struct MoreVectorsThanDimensionsExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: k > n (Automatic Dependence)")
                .font(.headline)
            
            Text("Determine if the following vectors in ℝ² are linearly independent:")
                .font(.body)
            
            Text("{[1,-1]ᵀ, [2,0]ᵀ, [3,4]ᵀ}")
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Analysis: Count and Compare")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.red)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Number of vectors:")
                        Spacer()
                        Text("k = 3")
                            .font(.system(.body, design: .monospaced))
                            .bold()
                    }
                    
                    HStack {
                        Text("Dimension of space:")
                        Spacer()
                        Text("n = 2 (ℝ²)")
                            .font(.system(.body, design: .monospaced))
                            .bold()
                    }
                    
                    Divider()
                    
                    Text("Since k = 3 > n = 2:")
                        .font(.body)
                        .bold()
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
                
                HStack {
                    Image(systemName: "xmark.seal.fill")
                        .foregroundColor(.red)
                    Text("The set is automatically LINEARLY DEPENDENT")
                        .font(.body)
                        .bold()
                }
                .padding()
                .background(Color.red.opacity(0.2))
                .cornerRadius(8)
                
                Text("No calculation needed!")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            // Why this works
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text("Why This Works")
                        .font(.subheadline)
                        .bold()
                }
                
                Text("ℝⁿ is n-dimensional, meaning any basis has exactly n vectors. You can never have more than n linearly independent vectors in ℝⁿ — there simply isn't enough \"room\" for more independent directions.")
                    .font(.caption)
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

// MARK: - Example 169.2: Determinant Non-Zero

struct DeterminantNonZeroExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: k = n, det(A) ≠ 0")
                .font(.headline)
            
            Text("Test if these three vectors in ℝ³ are linearly independent:")
                .font(.body)
            
            Text("{[1,1,1]ᵀ, [1,1,0]ᵀ, [1,0,0]ᵀ}")
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Method: Calculate the Determinant")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Step 1: Form the matrix with vectors as columns")
                    .font(.subheadline)
                    .bold()
                
                Text("""
                        ┌ 1  1  1 ┐
                    A = │ 1  1  0 │
                        └ 1  0  0 ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                
                Text("Step 2: Compute det(A) using cofactor expansion")
                    .font(.subheadline)
                    .bold()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Expand along the third row (has zeros):")
                        .font(.body)
                    
                    Text("det(A) = 1 · (-1)³⁺¹ · |1  1|")
                        .font(.system(.caption, design: .monospaced))
                    Text("                       |1  0|")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("       = 1 · (1)(0 - 1)")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("       = -1")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                
                Text("Step 3: Interpret the result")
                    .font(.subheadline)
                    .bold()
                
                Text("det(A) = -1 ≠ 0")
                    .font(.system(.body, design: .monospaced))
                    .bold()
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    Text("The set is LINEARLY INDEPENDENT")
                        .font(.body)
                        .bold()
                }
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
            }
            
            // Connection
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "link")
                        .foregroundColor(.blue)
                    Text("Why Determinant Works")
                        .font(.subheadline)
                        .bold()
                }
                
                Text("det(A) ≠ 0 means the matrix is invertible, which means its columns are linearly independent. This is one of the many equivalent conditions for invertibility!")
                    .font(.caption)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Example 169.3: Determinant Zero

struct DeterminantZeroExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: k = n, det(A) = 0")
                .font(.headline)
            
            Text("Test if these three vectors in ℝ³ are linearly independent:")
                .font(.body)
            
            Text("{[2,-1,1]ᵀ, [1,4,3]ᵀ, [3,3,4]ᵀ}")
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Method: Calculate the Determinant")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.red)
                
                Text("Step 1: Form the matrix with vectors as columns")
                    .font(.subheadline)
                    .bold()
                
                Text("""
                        ┌ 2  1  3 ┐
                    A = │-1  4  3 │
                        └ 1  3  4 ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                
                Text("Step 2: Compute det(A)")
                    .font(.subheadline)
                    .bold()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Using the rule of Sarrus or cofactor expansion:")
                        .font(.body)
                    
                    Text("det(A) = 2(16-9) - 1(-4-3) + 3(-3-4)")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("       = 2(7) - 1(-7) + 3(-7)")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("       = 14 + 7 - 21")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("       = 0")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
                
                Text("Step 3: Interpret the result")
                    .font(.subheadline)
                    .bold()
                
                Text("det(A) = 0")
                    .font(.system(.body, design: .monospaced))
                    .bold()
                
                HStack {
                    Image(systemName: "xmark.seal.fill")
                        .foregroundColor(.red)
                    Text("The set is LINEARLY DEPENDENT")
                        .font(.body)
                        .bold()
                }
                .padding()
                .background(Color.red.opacity(0.2))
                .cornerRadius(8)
            }
            
            // What this means
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.orange)
                    Text("What This Means")
                        .font(.subheadline)
                        .bold()
                }
                
                Text("When det(A) = 0, the matrix is singular (not invertible). One of the columns can be written as a linear combination of the others. Notice that v₃ = v₁ + v₂: [3,3,4]ᵀ = [2,-1,1]ᵀ + [1,4,3]ᵀ.")
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

// MARK: - Example 169.4: RREF Method

struct RREFMethodExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: k < n (RREF Method)")
                .font(.headline)
            
            Text("Test if these three vectors in ℝ⁴ are linearly independent:")
                .font(.body)
            
            Text("{[1,1,-1,1]ᵀ, [-1,0,1,1]ᵀ, [0,-1,-1,2]ᵀ}")
                .font(.system(.caption, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Text("k = 3 vectors in n = 4 dimensions")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Method: Row Reduce and Count Pivots")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.green)
                
                Text("Step 1: Form the matrix with vectors as columns")
                    .font(.subheadline)
                    .bold()
                
                Text("""
                        ┌  1  -1   0 ┐
                    A = │  1   0  -1 │
                        │ -1   1  -1 │
                        └  1   1   2 ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                
                Text("Step 2: Row reduce to RREF")
                    .font(.subheadline)
                    .bold()
                
                Text("""
                               ┌ 1  0  0 ┐
                    RREF(A) = │ 0  1  0 │
                               │ 0  0  1 │
                               └ 0  0  0 ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                
                Text("Step 3: Count pivots and compare to k")
                    .font(.subheadline)
                    .bold()
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Number of pivots:")
                        Spacer()
                        Text("3")
                            .font(.system(.body, design: .monospaced))
                            .bold()
                    }
                    
                    HStack {
                        Text("Number of vectors (k):")
                        Spacer()
                        Text("3")
                            .font(.system(.body, design: .monospaced))
                            .bold()
                    }
                    
                    Divider()
                    
                    Text("Since # of pivots = k, every column has a pivot.")
                        .font(.body)
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    Text("The set is LINEARLY INDEPENDENT")
                        .font(.body)
                        .bold()
                }
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
            }
            
            // The rule
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "checkmark.diamond.fill")
                        .foregroundColor(.blue)
                    Text("The RREF Rule")
                        .font(.subheadline)
                        .bold()
                }
                
                Text("When testing k vectors in ℝⁿ: the vectors are linearly independent if and only if the RREF of the matrix (with vectors as columns) has a pivot in every COLUMN. If any column lacks a pivot, the set is dependent.")
                    .font(.caption)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}
