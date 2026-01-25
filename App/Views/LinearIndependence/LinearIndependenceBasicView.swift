import SwiftUI

struct LinearIndependenceBasicView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "equal.circle")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Text("Linear Independence")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Testing Independence Using the Definition")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Introduction
                VStack(alignment: .leading, spacing: 16) {
                    Text("What is Linear Independence?")
                        .font(.headline)
                    
                    Text("A set of vectors {v₁, v₂, ..., vₖ} is linearly independent if the ONLY way to write the zero vector as a linear combination is with ALL coefficients equal to zero.")
                        .font(.body)
                    
                    Text("In other words: None of the vectors can be written as a combination of the others.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // The Definition
                VStack(alignment: .leading, spacing: 16) {
                    Text("The Formal Definition")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Vectors v₁, v₂, ..., vₖ are linearly independent if:")
                            .font(.body)
                        
                        Text("c₁v₁ + c₂v₂ + ... + cₖvₖ = 0")
                            .font(.system(.title3, design: .monospaced))
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("implies c₁ = c₂ = ... = cₖ = 0")
                            .font(.system(.title3, design: .monospaced))
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("This is called the \"trivial solution\" — the only solution is all zeros.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Vectors are linearly dependent if:")
                            .font(.body)
                        
                        Text("There exist c₁, c₂, ..., cₖ NOT ALL ZERO such that:")
                            .font(.body)
                        
                        Text("c₁v₁ + c₂v₂ + ... + cₖvₖ = 0")
                            .font(.system(.body, design: .monospaced))
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("This means at least one vector can be written as a combination of the others!")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Intuition
                VStack(alignment: .leading, spacing: 16) {
                    Text("💡 Intuition: What Does It Mean?")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            VStack(alignment: .leading) {
                                Text("Linearly Independent")
                                    .font(.subheadline)
                                    .bold()
                                Text("Each vector adds a \"new direction\" — no redundancy. Removing any vector would shrink the span.")
                                    .font(.caption)
                            }
                        }
                        
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            VStack(alignment: .leading) {
                                Text("Linearly Dependent")
                                    .font(.subheadline)
                                    .bold()
                                Text("At least one vector is redundant — it can be expressed using the others. The set has \"extra\" vectors.")
                                    .font(.caption)
                            }
                        }
                    }
                    
                    // Example
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Simple Example:")
                            .font(.subheadline)
                            .bold()
                        
                        Text("If v₃ = v₁ + v₂, then:")
                            .font(.body)
                        
                        Text("1·v₁ + 1·v₂ + (-1)·v₃ = 0")
                            .font(.system(.body, design: .monospaced))
                            .padding(8)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(6)
                        
                        Text("The coefficients (1, 1, -1) are not all zero, so the set is dependent!")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Tab Selection for Examples
                Picker("Example", selection: $selectedTab) {
                    Text("Dependent").tag(0)
                    Text("Independent").tag(1)
                }
                .pickerStyle(.segmented)
                
                // Examples
                if selectedTab == 0 {
                    LinearDependenceExample()
                } else {
                    LinearIndependenceExample()
                }
                
                // Key Properties
                VStack(alignment: .leading, spacing: 16) {
                    Text("📋 Key Properties")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        PropertyCardView(
                            title: "Zero Vector Rule",
                            content: "Any set containing the zero vector is automatically linearly DEPENDENT.",
                            reason: "Because 1·0 + 0·v₁ + ... = 0 is a non-trivial combination."
                        )
                        
                        PropertyCardView(
                            title: "Single Vector Rule",
                            content: "A single non-zero vector {v} is always linearly INDEPENDENT.",
                            reason: "Because c·v = 0 implies c = 0 (if v ≠ 0)."
                        )
                        
                        PropertyCardView(
                            title: "Two Vectors Rule",
                            content: "Two vectors are linearly dependent ⟺ one is a scalar multiple of the other.",
                            reason: "They're on the same line through the origin."
                        )
                        
                        PropertyCardView(
                            title: "Subset Property",
                            content: "Any subset of a linearly independent set is also linearly independent.",
                            reason: "Removing vectors can't create a dependency."
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

// MARK: - Property Card

struct PropertyCardView: View {
    let title: String
    let content: String
    let reason: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .bold()
                .foregroundColor(.blue)
            
            Text(content)
                .font(.body)
            
            Text(reason)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(8)
    }
}

// MARK: - Linear Dependence Example (Example 167)

struct LinearDependenceExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Proving Linear Dependence")
                .font(.headline)
            
            Text("Show that the following set is linearly dependent:")
                .font(.body)
            
            Text("S = {[1,1,0]ᵀ, [1,0,1]ᵀ, [2,1,1]ᵀ}")
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Method: Find a Non-Trivial Linear Combination = 0")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.red)
                
                Text("Step 1: Look for relationships between the vectors")
                    .font(.subheadline)
                    .bold()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Let's check if v₃ can be written as a combination of v₁ and v₂:")
                        .font(.body)
                    
                    Text("v₁ + v₂ = [1,1,0]ᵀ + [1,0,1]ᵀ")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("        = [1+1, 1+0, 0+1]ᵀ")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("        = [2, 1, 1]ᵀ = v₃ !")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
                
                Text("Step 2: Rewrite as a combination equaling zero")
                    .font(.subheadline)
                    .bold()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Since v₃ = v₁ + v₂, we can write:")
                        .font(.body)
                    
                    Text("v₁ + v₂ - v₃ = 0")
                        .font(.system(.body, design: .monospaced))
                    
                    Text("Or equivalently:")
                        .font(.body)
                    
                    Text("1·v₁ + 1·v₂ + (-1)·v₃ = 0")
                        .font(.system(.title3, design: .monospaced))
                        .bold()
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Text("Step 3: Verify the coefficients")
                    .font(.subheadline)
                    .bold()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("c₁ = 1 ≠ 0")
                    Text("c₂ = 1 ≠ 0")
                    Text("c₃ = -1 ≠ 0")
                }
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(6)
                
                Text("The coefficients are NOT all zero!")
                    .font(.body)
                
                HStack {
                    Image(systemName: "xmark.seal.fill")
                        .foregroundColor(.red)
                    Text("S is linearly DEPENDENT")
                        .font(.body)
                        .bold()
                }
                .padding()
                .background(Color.red.opacity(0.2))
                .cornerRadius(8)
            }
            
            // Why this matters
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text("What This Means")
                        .font(.subheadline)
                        .bold()
                }
                
                Text("Vector v₃ is redundant — it contributes nothing new that v₁ and v₂ don't already provide. The span of S is the same as span{v₁, v₂}.")
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

// MARK: - Linear Independence Example (Example 168)

struct LinearIndependenceExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Proving Linear Independence")
                .font(.headline)
            
            Text("Show that the standard basis for ℝ² is linearly independent:")
                .font(.body)
            
            Text("E = {[1,0]ᵀ, [0,1]ᵀ}")
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Text("These are e₁ and e₂, the standard basis vectors.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Method: Show Only the Trivial Solution Exists")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.green)
                
                Text("Step 1: Set up the equation")
                    .font(.subheadline)
                    .bold()
                
                Text("We need to solve:")
                    .font(.body)
                
                Text("c₁[1,0]ᵀ + c₂[0,1]ᵀ = [0,0]ᵀ")
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                Text("Step 2: Expand the equation")
                    .font(.subheadline)
                    .bold()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("[c₁, 0]ᵀ + [0, c₂]ᵀ = [0, 0]ᵀ")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("[c₁, c₂]ᵀ = [0, 0]ᵀ")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
                
                Text("Step 3: Read off the solution")
                    .font(.subheadline)
                    .bold()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("From component 1: c₁ = 0")
                        .font(.body)
                    Text("From component 2: c₂ = 0")
                        .font(.body)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                
                Text("Step 4: Conclusion")
                    .font(.subheadline)
                    .bold()
                
                Text("The ONLY solution is c₁ = 0 and c₂ = 0 (the trivial solution).")
                    .font(.body)
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    Text("E is linearly INDEPENDENT")
                        .font(.body)
                        .bold()
                }
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
            }
            
            // Why the standard basis is important
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                    Text("Why This Matters")
                        .font(.subheadline)
                        .bold()
                }
                
                Text("The standard basis vectors point along the coordinate axes. They're the simplest example of a basis for ℝⁿ. Every vector can be uniquely written as a combination of basis vectors.")
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
