import SwiftUI

struct SpanningSetsView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("Spanning Sets")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Generating Subspaces from Vectors")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Introduction
                VStack(alignment: .leading, spacing: 16) {
                    Text("What is a Spanning Set?")
                        .font(.headline)
                    
                    Text("A spanning set for a subspace W is a collection of vectors whose span equals W. In other words, every vector in W can be written as a linear combination of the spanning vectors.")
                        .font(.body)
                    
                    Text("span{v₁, v₂, ..., vₖ} = W")
                        .font(.system(.title3, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text("If S spans W, we say \"S generates W\" or \"W is spanned by S\".")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Definition
                VStack(alignment: .leading, spacing: 16) {
                    Text("Formal Definition")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("The span of vectors v₁, v₂, ..., vₖ is the set of ALL linear combinations:")
                            .font(.body)
                        
                        Text("span{v₁, ..., vₖ} = {c₁v₁ + c₂v₂ + ... + cₖvₖ | c₁, ..., cₖ ∈ ℝ}")
                            .font(.system(.caption, design: .monospaced))
                            .padding()
                            .background(Color(uiColor: .tertiarySystemBackground))
                            .cornerRadius(8)
                        
                        Text("Key properties:")
                            .font(.subheadline)
                            .bold()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("The span of any set of vectors is always a subspace")
                            }
                            HStack(alignment: .top) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("The zero vector is always in any span (take all coefficients = 0)")
                            }
                            HStack(alignment: .top) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Each vᵢ is in span{v₁, ..., vₖ}")
                            }
                        }
                        .font(.body)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Tab Selection for Examples
                Picker("Example", selection: $selectedTab) {
                    Text("Null Space").tag(0)
                    Text("Spanning ℝ³").tag(1)
                    Text("Redundancy").tag(2)
                }
                .pickerStyle(.segmented)
                
                // Examples
                switch selectedTab {
                case 0:
                    NullSpaceSpanningSetExample()
                case 1:
                    SpanningR3Example()
                case 2:
                    RedundancyExample()
                default:
                    EmptyView()
                }
                
                // Testing if vectors span a space
                VStack(alignment: .leading, spacing: 16) {
                    Text("📋 How to Test if Vectors Span a Space")
                        .font(.headline)
                    
                    Text("To check if {v₁, ..., vₖ} spans ℝⁿ:")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        SpanTestStepView(
                            number: 1,
                            description: "Form a matrix A with the vectors as columns"
                        )
                        
                        SpanTestStepView(
                            number: 2,
                            description: "Row reduce A to RREF"
                        )
                        
                        SpanTestStepView(
                            number: 3,
                            description: "Check if every ROW has a pivot (leading 1)"
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Result:")
                            .font(.subheadline)
                            .bold()
                        
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Pivot in every row → Vectors span ℝⁿ")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("Row without pivot → Vectors do NOT span ℝⁿ")
                        }
                    }
                    .font(.body)
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                    
                    // Why this works
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                            Text("Why This Works")
                                .font(.subheadline)
                                .bold()
                        }
                        
                        Text("A pivot in every row means the system Ax = b is consistent for EVERY b ∈ ℝⁿ. This means every vector in ℝⁿ can be written as a linear combination of the columns of A.")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Minimal Spanning Sets
                VStack(alignment: .leading, spacing: 16) {
                    Text("🎯 Minimal Spanning Sets = Bases")
                        .font(.headline)
                    
                    Text("A basis is a spanning set with no redundant vectors (i.e., it's also linearly independent). For ℝⁿ:")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.blue)
                            Text("You need at least n vectors to span ℝⁿ")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.blue)
                            Text("Any n linearly independent vectors form a basis")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.blue)
                            Text("A basis is both spanning AND linearly independent")
                        }
                    }
                    .font(.body)
                    
                    Text("dim(ℝⁿ) = n")
                        .font(.system(.title3, design: .monospaced))
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
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

struct SpanTestStepView: View {
    let number: Int
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Color.orange)
                .clipShape(Circle())
            
            Text(description)
                .font(.body)
        }
    }
}

// MARK: - Null Space Spanning Set (Example 160)

struct NullSpaceSpanningSetExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Spanning Set for Null Space")
                .font(.headline)
            
            Text("Find vectors that span the null space N(A) of matrix A.")
                .font(.body)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Method: Solve Ax = 0")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Step 1: Row reduce A to RREF")
                    .font(.subheadline)
                    .bold()
                
                Text("After reduction, identify free variables (columns without pivots).")
                    .font(.body)
                
                Text("Step 2: Express solution in parametric form")
                    .font(.subheadline)
                    .bold()
                
                Text("For a system with 4 variables (x, y, z, w) and 2 free variables (r, s):")
                    .font(.body)
                
                Text("""
                    ┌ x ┐       ┌ -1/3 ┐       ┌  1/3 ┐
                    │ y │       │  1/3 │       │ -1/3 │
                    │   │ = r   │      │ + s   │      │
                    │ z │       │   1  │       │   0  │
                    └ w ┘       └   0  ┘       └   1  ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                
                Text("Step 3: Extract the spanning vectors")
                    .font(.subheadline)
                    .bold()
                
                Text("The spanning set for N(A) consists of the coefficient vectors:")
                    .font(.body)
                
                HStack(spacing: 20) {
                    VStack {
                        Text("v₁ =")
                            .font(.body)
                        Text("[-1/3, 1/3, 1, 0]ᵀ")
                            .font(.system(.caption, design: .monospaced))
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                    
                    VStack {
                        Text("v₂ =")
                            .font(.body)
                        Text("[1/3, -1/3, 0, 1]ᵀ")
                            .font(.system(.caption, design: .monospaced))
                    }
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(6)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("N(A) = span{v₁, v₂}")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                    
                    Text("Every vector in N(A) is a linear combination of v₁ and v₂!")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
            }
            
            // Key insight
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text("Key Insight")
                        .font(.subheadline)
                        .bold()
                }
                
                Text("Each free variable contributes ONE spanning vector. If there are k free variables, the null space has dimension k and is spanned by k vectors.")
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

// MARK: - Spanning R^3 Example (Example 161)

struct SpanningR3Example: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Proving a Set Spans ℝ³")
                .font(.headline)
            
            Text("Show that S = {[0,1,1]ᵀ, [1,0,1]ᵀ, [1,1,0]ᵀ} spans ℝ³.")
                .font(.body)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Method: Show any [a,b,c]ᵀ can be written as a linear combination")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("We need to show that for ANY [a,b,c]ᵀ, the system:")
                    .font(.body)
                
                Text("s₁[0,1,1]ᵀ + s₂[1,0,1]ᵀ + s₃[1,1,0]ᵀ = [a,b,c]ᵀ")
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                
                Text("has a solution.")
                    .font(.body)
                
                Text("Step 1: Set up augmented matrix")
                    .font(.subheadline)
                    .bold()
                
                Text("""
                    ┌ 0  1  1 | a ┐
                    │ 1  0  1 | b │
                    └ 1  1  0 | c ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                
                Text("Step 2: Row reduce (Gauss-Jordan)")
                    .font(.subheadline)
                    .bold()
                
                Text("After row reduction, we get:")
                    .font(.body)
                
                Text("""
                    ┌ 1  0  0 | (−a+b+c)/2 ┐
                    │ 0  1  0 | (a−b+c)/2  │
                    └ 0  0  1 | (a+b−c)/2  ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                Text("Step 3: Analyze the result")
                    .font(.subheadline)
                    .bold()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("• Every row has a pivot")
                    Text("• The system is consistent for ALL values of a, b, c")
                    Text("• There's a unique solution for each [a,b,c]ᵀ")
                }
                .font(.body)
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    Text("S spans all of ℝ³!")
                        .font(.body)
                        .bold()
                }
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
            }
            
            // Bonus
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                    Text("Bonus: S is Also Linearly Independent")
                        .font(.subheadline)
                        .bold()
                }
                
                Text("Since every column also has a pivot, S is linearly independent. Three linearly independent vectors that span ℝ³ form a BASIS for ℝ³.")
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

// MARK: - Redundancy Example (Example 164)

struct RedundancyExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Identifying Redundant Vectors")
                .font(.headline)
            
            Text("Simplify the span of {v₁, v₂, v₃}:")
                .font(.body)
            
            HStack(spacing: 15) {
                VStack {
                    Text("v₁ =")
                    Text("[1,1,0]ᵀ")
                        .font(.system(.caption, design: .monospaced))
                }
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
                
                VStack {
                    Text("v₂ =")
                    Text("[1,0,1]ᵀ")
                        .font(.system(.caption, design: .monospaced))
                }
                .padding(8)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(6)
                
                VStack {
                    Text("v₃ =")
                    Text("[2,1,1]ᵀ")
                        .font(.system(.caption, design: .monospaced))
                }
                .padding(8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(6)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Step 1: Look for Linear Relations")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Check if any vector is a linear combination of the others:")
                    .font(.body)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("v₁ + v₂ = [1,1,0]ᵀ + [1,0,1]ᵀ")
                        .font(.system(.caption, design: .monospaced))
                    Text("        = [2, 1, 1]ᵀ")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                    Text("        = v₃ !")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
                
                Text("v₃ is redundant because v₃ = v₁ + v₂")
                    .font(.body)
                    .foregroundColor(.red)
                
                Text("Step 2: Remove the Redundant Vector")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Since v₃ can be expressed in terms of v₁ and v₂:")
                    .font(.body)
                
                Text("span{v₁, v₂, v₃} = span{v₁, v₂}")
                    .font(.system(.body, design: .monospaced))
                    .bold()
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
                
                Text("The third vector contributes nothing new to the span!")
                    .font(.caption)
                
                Text("Step 3: Describe the Space")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("span{v₁, v₂} is a 2-dimensional subspace (a plane through the origin).")
                        .font(.body)
                    
                    Text("The plane can be described by the equation:")
                        .font(.body)
                    
                    Text("x − y + z = 0")
                        .font(.system(.body, design: .monospaced))
                        .padding(8)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(6)
                    
                    Text("(You can verify: both v₁ and v₂ satisfy this equation)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // When is a vector redundant?
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    Text("When is a Vector Redundant?")
                        .font(.subheadline)
                        .bold()
                }
                
                Text("A vector is redundant (can be removed without changing the span) if and only if it's a linear combination of the other vectors. This is equivalent to saying the set is linearly DEPENDENT.")
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
