import SwiftUI

struct SubspaceVerificationView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                        Text("Subspace Verification")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Proving and Disproving Subspace Properties")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Introduction
                VStack(alignment: .leading, spacing: 16) {
                    Text("What is a Subspace?")
                        .font(.headline)
                    
                    Text("""
A **subspace** is one of the most important concepts in linear algebra. Simply put, a subspace is a "smaller" vector space that lives inside a larger one.

**The Intuition:** Imagine you're in 3D space (ℝ³). A plane that passes through the origin is a subspace—it's a 2D "slice" of the 3D world. A line through the origin is also a subspace—a 1D "thread" within the larger space. The key is that these sets behave like complete vector spaces on their own.

**Why Must They Pass Through the Origin?** Because every vector space must contain the zero vector (it's the "identity" for addition). If your plane or line doesn't go through the origin, it can't be a subspace!

**Think of it this way:** A subspace is like a "self-contained playground" where you can freely add vectors and multiply by scalars without ever escaping the playground.
""")
                        .font(.body)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // The Three Axioms
                VStack(alignment: .leading, spacing: 16) {
                    Text("The Subspace Test")
                        .font(.headline)
                    
                    Text("To prove a set W ⊆ ℝⁿ is a subspace, verify these three conditions:")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        AxiomCardView(
                            number: "S0",
                            title: "Non-Empty (Contains Zero)",
                            formula: "0 ∈ W",
                            description: "The zero vector must be in W. This ensures the set is not empty."
                        )
                        
                        AxiomCardView(
                            number: "S1",
                            title: "Closed Under Addition",
                            formula: "x, y ∈ W → x + y ∈ W",
                            description: "If you add any two vectors from W, the result must also be in W."
                        )
                        
                        AxiomCardView(
                            number: "S2",
                            title: "Closed Under Scalar Multiplication",
                            formula: "x ∈ W, c ∈ ℝ → cx ∈ W",
                            description: "If you multiply any vector from W by any scalar, the result must also be in W."
                        )
                    }
                    
                    Text("If ANY of these conditions fails, the set is NOT a subspace!")
                        .font(.caption)
                        .foregroundColor(.red)
                        .bold()
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Common Subspaces
                VStack(alignment: .leading, spacing: 12) {
                    Text("💡 Common Examples of Subspaces")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Lines through the origin")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Planes through the origin")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("The null space N(A) of any matrix")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("The column space Col(A) of any matrix")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("The set {0} containing only the zero vector")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("All of ℝⁿ")
                        }
                    }
                    .font(.body)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                
                // Tab Selection for Examples
                Picker("Example", selection: $selectedTab) {
                    Text("Hyperplane ✓").tag(0)
                    Text("Parabola ✗").tag(1)
                    Text("First Octant ✗").tag(2)
                }
                .pickerStyle(.segmented)
                
                // Examples
                switch selectedTab {
                case 0:
                    HyperplaneExampleView()
                case 1:
                    ParabolaCounterexampleView()
                case 2:
                    FirstOctantCounterexampleView()
                default:
                    EmptyView()
                }
                
                // How to Disprove
                VStack(alignment: .leading, spacing: 16) {
                    Text("🔍 How to Disprove a Subspace Claim")
                        .font(.headline)
                    
                    Text("To show a set is NOT a subspace, you only need ONE counterexample that violates ANY of the three axioms:")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            Image(systemName: "1.circle.fill")
                                .foregroundColor(.orange)
                            Text("Pick specific vectors from the set")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "2.circle.fill")
                                .foregroundColor(.orange)
                            Text("Apply addition or scalar multiplication")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "3.circle.fill")
                                .foregroundColor(.orange)
                            Text("Show the result is NOT in the original set")
                        }
                    }
                    .font(.body)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Axiom Card

struct AxiomCardView: View {
    let number: String
    let title: String
    let formula: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(number)
                    .font(.caption)
                    .bold()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                
                Text(title)
                    .font(.subheadline)
                    .bold()
            }
            
            Text(formula)
                .font(.system(.body, design: .monospaced))
                .padding(8)
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(6)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(8)
    }
}

// MARK: - Hyperplane Example (Example 148)

struct HyperplaneExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Hyperplane Orthogonal to a Vector")
                .font(.headline)
            
            Text("Prove that the following set is a subspace of ℝⁿ:")
                .font(.body)
            
            Text("Πₐ = {x ∈ ℝⁿ | a · x = 0}")
                .font(.system(.title3, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Text("This is the set of all vectors orthogonal (perpendicular) to a fixed vector a.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Proof: Check All Three Axioms")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                // S0
                VStack(alignment: .leading, spacing: 8) {
                    Text("S0: Zero Vector")
                        .font(.subheadline)
                        .bold()
                    
                    Text("a · 0 = 0 ✓")
                        .font(.system(.body, design: .monospaced))
                    
                    Text("The zero vector is orthogonal to everything, so 0 ∈ Πₐ")
                        .font(.caption)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                
                // S1
                VStack(alignment: .leading, spacing: 8) {
                    Text("S1: Closed Under Addition")
                        .font(.subheadline)
                        .bold()
                    
                    Text("Let x, y ∈ Πₐ (so a · x = 0 and a · y = 0)")
                        .font(.caption)
                    
                    Text("a · (x + y) = a · x + a · y = 0 + 0 = 0 ✓")
                        .font(.system(.body, design: .monospaced))
                    
                    Text("The sum x + y is also orthogonal to a, so x + y ∈ Πₐ")
                        .font(.caption)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                
                // S2
                VStack(alignment: .leading, spacing: 8) {
                    Text("S2: Closed Under Scalar Multiplication")
                        .font(.subheadline)
                        .bold()
                    
                    Text("Let x ∈ Πₐ and c ∈ ℝ (so a · x = 0)")
                        .font(.caption)
                    
                    Text("a · (cx) = c(a · x) = c(0) = 0 ✓")
                        .font(.system(.body, design: .monospaced))
                    
                    Text("The scaled vector cx is also orthogonal to a, so cx ∈ Πₐ")
                        .font(.caption)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    Text("All three axioms satisfied. Πₐ is a subspace!")
                        .font(.body)
                        .bold()
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
                    Text("Geometric Interpretation")
                        .font(.subheadline)
                        .bold()
                }
                
                Text("Πₐ is a hyperplane passing through the origin, perpendicular to vector a. In ℝ³, if a is a normal vector, Πₐ is a plane through the origin.")
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

// MARK: - Parabola Counterexample (Example 150)

struct ParabolaCounterexampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Counterexample: Parabola Subset")
                .font(.headline)
            
            Text("Show that the following set is NOT a subspace of ℝ²:")
                .font(.body)
            
            Text("P = {[x, y]ᵀ ∈ ℝ² | y = x²}")
                .font(.system(.title3, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Text("This is the set of all points on the parabola y = x².")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Disproof: Find a Counterexample for S1 (Addition)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.red)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 1: Pick two vectors from P")
                        .font(.caption)
                        .bold()
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text("v₁ = [2, 4]ᵀ")
                                .font(.system(.body, design: .monospaced))
                            Text("(since 4 = 2²)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                        
                        VStack {
                            Text("v₂ = [1, 1]ᵀ")
                                .font(.system(.body, design: .monospaced))
                            Text("(since 1 = 1²)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(6)
                    }
                    
                    Text("Both v₁ and v₂ are in P because they satisfy y = x².")
                        .font(.caption)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 2: Add them")
                        .font(.caption)
                        .bold()
                    
                    Text("v₁ + v₂ = [2, 4]ᵀ + [1, 1]ᵀ = [3, 5]ᵀ")
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(6)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 3: Check if the sum is in P")
                        .font(.caption)
                        .bold()
                    
                    Text("Is 5 = 3²?")
                        .font(.body)
                    
                    Text("5 ≠ 9 = 3² ✗")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(6)
                    
                    Text("The point [3, 5]ᵀ does NOT lie on the parabola y = x².")
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    Text("P fails axiom S1. P is NOT a subspace!")
                        .font(.body)
                        .bold()
                }
                .padding()
                .background(Color.red.opacity(0.2))
                .cornerRadius(8)
            }
            
            // Why this makes sense
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text("Why This Makes Sense")
                        .font(.subheadline)
                        .bold()
                }
                
                Text("Geometrically, a parabola curves away from any straight line. Subspaces must be \"flat\" (lines, planes, etc.) because adding vectors along a flat surface keeps you on that surface. A curved surface doesn't have this property.")
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

// MARK: - First Octant Counterexample (Example 151)

struct FirstOctantCounterexampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Counterexample: First Octant")
                .font(.headline)
            
            Text("Show that the following set is NOT a subspace of ℝ³:")
                .font(.body)
            
            Text("Q = {[x, y, z]ᵀ | x, y, z ≥ 0}")
                .font(.system(.title3, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Text("This is the \"first octant\" - all points with non-negative coordinates.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Disproof: Find a Counterexample for S2 (Scalar Mult)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.red)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 1: Pick a vector from Q")
                        .font(.caption)
                        .bold()
                    
                    Text("v = [1, 1, 1]ᵀ ∈ Q")
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                    
                    Text("All components are ≥ 0, so v is in Q.")
                        .font(.caption)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 2: Multiply by a negative scalar")
                        .font(.caption)
                        .bold()
                    
                    Text("Let c = -1")
                        .font(.body)
                    
                    Text("cv = (-1)[1, 1, 1]ᵀ = [-1, -1, -1]ᵀ")
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(6)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 3: Check if the result is in Q")
                        .font(.caption)
                        .bold()
                    
                    Text("Are all components ≥ 0?")
                        .font(.body)
                    
                    Text("-1 < 0, -1 < 0, -1 < 0 ✗")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(6)
                    
                    Text("The vector [-1, -1, -1]ᵀ has negative components, so it's NOT in Q.")
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    Text("Q fails axiom S2. Q is NOT a subspace!")
                        .font(.body)
                        .bold()
                }
                .padding()
                .background(Color.red.opacity(0.2))
                .cornerRadius(8)
            }
            
            // Why this makes sense
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text("Why This Makes Sense")
                        .font(.subheadline)
                        .bold()
                }
                
                Text("Subspaces must be symmetric about the origin. If v is in a subspace, then -v must also be in the subspace (since -v = (-1)v). The first octant only contains \"one corner\" of space and lacks this symmetry.")
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
