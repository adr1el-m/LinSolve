import SwiftUI

struct SubspaceOperationsView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "arrow.triangle.merge")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Text("Subspace Operations")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Intersection, Union, and Sum of Subspaces")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Introduction
                VStack(alignment: .leading, spacing: 16) {
                    Text("Combining Subspaces")
                        .font(.headline)
                    
                    Text("When we have two subspaces W₁ and W₂, we might want to combine them in various ways. The most natural operations are intersection (∩), union (∪), and sum (+).")
                        .font(.body)
                    
                    Text("Surprisingly, not all of these operations preserve the subspace property!")
                        .font(.body)
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Key Results
                VStack(alignment: .leading, spacing: 16) {
                    Text("Key Results")
                        .font(.headline)
                    
                    // Intersection
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Intersection: W₁ ∩ W₂")
                                .font(.subheadline)
                                .bold()
                        }
                        
                        Text("W₁ ∩ W₂ is ALWAYS a subspace")
                            .font(.system(.body, design: .monospaced))
                            .padding(8)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(6)
                        
                        Text("The intersection of any collection of subspaces is itself a subspace. This is because if a vector is in both W₁ and W₂, then all linear combinations of such vectors remain in both.")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.green.opacity(0.05))
                    .cornerRadius(8)
                    
                    // Union
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("Union: W₁ ∪ W₂")
                                .font(.subheadline)
                                .bold()
                        }
                        
                        Text("W₁ ∪ W₂ is usually NOT a subspace")
                            .font(.system(.body, design: .monospaced))
                            .padding(8)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(6)
                        
                        Text("The union is only a subspace if one subspace contains the other (W₁ ⊆ W₂ or W₂ ⊆ W₁). Otherwise, adding a vector from W₁ to one from W₂ may leave the union.")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.red.opacity(0.05))
                    .cornerRadius(8)
                    
                    // Sum
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Sum: W₁ + W₂")
                                .font(.subheadline)
                                .bold()
                        }
                        
                        Text("W₁ + W₂ = {w₁ + w₂ | w₁ ∈ W₁, w₂ ∈ W₂}")
                            .font(.system(.body, design: .monospaced))
                            .padding(8)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(6)
                        
                        Text("The sum of two subspaces is ALWAYS a subspace. It's the smallest subspace containing both W₁ and W₂.")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.green.opacity(0.05))
                    .cornerRadius(8)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Tab Selection for Examples
                Picker("Example", selection: $selectedTab) {
                    Text("Intersection").tag(0)
                    Text("Union (Fails)").tag(1)
                }
                .pickerStyle(.segmented)
                
                // Examples
                if selectedTab == 0 {
                    IntersectionExampleView()
                } else {
                    UnionCounterexampleView()
                }
                
                // Dimension Formula
                VStack(alignment: .leading, spacing: 16) {
                    Text("📐 Dimension Formula")
                        .font(.headline)
                    
                    Text("For finite-dimensional subspaces:")
                        .font(.body)
                    
                    Text("dim(W₁ + W₂) = dim(W₁) + dim(W₂) − dim(W₁ ∩ W₂)")
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text("This is analogous to the inclusion-exclusion principle for sets: |A ∪ B| = |A| + |B| - |A ∩ B|")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Examples
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Example in ℝ³:")
                            .font(.subheadline)
                            .bold()
                        
                        Text("If W₁ is a 2D plane and W₂ is another 2D plane that intersects W₁ in a line (1D):")
                            .font(.caption)
                        
                        Text("dim(W₁ + W₂) = 2 + 2 − 1 = 3")
                            .font(.system(.caption, design: .monospaced))
                        
                        Text("So W₁ + W₂ = ℝ³ (the whole space)!")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
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

// MARK: - Intersection Example (Example 153)

struct IntersectionExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Intersection of Two Planes")
                .font(.headline)
            
            Text("Find the subspace W₁ ∩ W₂ where:")
                .font(.body)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("W₁: x + y − z = 0 (plane 1)")
                    .font(.system(.body, design: .monospaced))
                Text("W₂: 2x − y + z = 0 (plane 2)")
                    .font(.system(.body, design: .monospaced))
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
            
            Text("Both are planes through the origin (subspaces of ℝ³).")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Solution: Solve the Homogeneous System")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("A vector [x, y, z]ᵀ is in the intersection if it satisfies BOTH equations. Combine into a system:")
                    .font(.body)
                
                Text("Step 1: Set Up the Augmented Matrix")
                    .font(.subheadline)
                    .bold()
                
                Text("""
                    ┌ 1   1  -1 | 0 ┐
                    │               │
                    └ 2  -1   1 | 0 ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                
                Text("Step 2: Row Reduce to RREF")
                    .font(.subheadline)
                    .bold()
                
                Text("R₂ → R₂ - 2R₁:")
                    .font(.caption)
                
                Text("""
                    ┌ 1   1  -1 | 0 ┐       ┌ 1  0  0 | 0 ┐
                    │               │  →    │             │
                    └ 0  -3   3 | 0 ┘       └ 0  1 -1 | 0 ┘
                """)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                Text("Step 3: Parametrize the Solution")
                    .font(.subheadline)
                    .bold()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("From RREF: x = 0, y = z")
                        .font(.body)
                    Text("Let z = r (free variable)")
                        .font(.body)
                    
                    Text("[x, y, z]ᵀ = r[0, 1, 1]ᵀ")
                        .font(.system(.body, design: .monospaced))
                        .padding(8)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(6)
                }
                
                Text("Result:")
                    .font(.subheadline)
                    .bold()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("W₁ ∩ W₂ = span{[0, 1, 1]ᵀ}")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                    
                    Text("The intersection is a LINE through the origin!")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
            }
            
            // Geometric interpretation
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "cube.transparent")
                        .foregroundColor(.purple)
                    Text("Geometric Picture")
                        .font(.subheadline)
                        .bold()
                }
                
                Text("Two distinct planes through the origin in ℝ³ always intersect in a line through the origin. This line is the set of vectors that lie on BOTH planes.")
                    .font(.caption)
            }
            .padding()
            .background(Color.purple.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Union Counterexample (Example 156)

struct UnionCounterexampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Counterexample: Union of Subspaces")
                .font(.headline)
            
            Text("Show that W₁ ∪ W₂ is NOT a subspace when:")
                .font(.body)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("W₁ = {[x, y]ᵀ | x + y = 0} (line y = -x)")
                    .font(.system(.caption, design: .monospaced))
                Text("W₂ = {[x, y]ᵀ | x - y = 0} (line y = x)")
                    .font(.system(.caption, design: .monospaced))
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
            
            Text("Both W₁ and W₂ are lines through the origin (1D subspaces of ℝ²).")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Disproof: Addition Fails")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.red)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 1: Pick vectors from each subspace")
                        .font(.caption)
                        .bold()
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text("x = [1, -1]ᵀ")
                                .font(.system(.body, design: .monospaced))
                            Text("from W₁")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("(1 + (-1) = 0 ✓)")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                        
                        VStack {
                            Text("y = [1, 1]ᵀ")
                                .font(.system(.body, design: .monospaced))
                            Text("from W₂")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("(1 - 1 = 0 ✓)")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(6)
                    }
                    
                    Text("Both x ∈ W₁ ∪ W₂ and y ∈ W₁ ∪ W₂.")
                        .font(.caption)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 2: Compute their sum")
                        .font(.caption)
                        .bold()
                    
                    Text("x + y = [1, -1]ᵀ + [1, 1]ᵀ = [2, 0]ᵀ")
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(6)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 3: Check if sum is in W₁ ∪ W₂")
                        .font(.caption)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Is [2, 0]ᵀ in W₁?")
                            .font(.body)
                        Text("Check: 2 + 0 = 2 ≠ 0 ✗")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.red)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Is [2, 0]ᵀ in W₂?")
                            .font(.body)
                        Text("Check: 2 - 0 = 2 ≠ 0 ✗")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.red)
                    }
                    
                    Text("[2, 0]ᵀ is in NEITHER W₁ nor W₂!")
                        .font(.body)
                        .foregroundColor(.red)
                }
                
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    Text("W₁ ∪ W₂ is NOT closed under addition!")
                        .font(.body)
                        .bold()
                }
                .padding()
                .background(Color.red.opacity(0.2))
                .cornerRadius(8)
            }
            
            // Geometric interpretation
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text("Why This Happens")
                        .font(.subheadline)
                        .bold()
                }
                
                Text("W₁ ∪ W₂ consists of just two lines forming an \"X\" shape. When you add a vector on one line to a vector on the other, the result points \"between\" the lines — not on either one.")
                    .font(.caption)
            }
            .padding()
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(8)
            
            // What to use instead
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.green)
                    Text("What to Use Instead")
                        .font(.subheadline)
                        .bold()
                }
                
                Text("To get a subspace containing both W₁ and W₂, use their SUM: W₁ + W₂ = {w₁ + w₂ | w₁ ∈ W₁, w₂ ∈ W₂}. In this example, W₁ + W₂ = ℝ² (the whole plane).")
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
