import SwiftUI

struct IntersectionsExtensionsView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "plus.viewfinder")
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                        Text("Intersections & Extensions")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Advanced Operations on Subspaces")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Picker("Topic", selection: $selectedTab) {
                    Text("Intersection").tag(0)
                    Text("Extending Basis").tag(1)
                }
                .pickerStyle(.segmented)
                
                if selectedTab == 0 {
                    IntersectionBasisExample()
                } else {
                    ExtendingBasisExample()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Basis and Dimension of Intersection (Example 185)
struct IntersectionBasisExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basis for Intersection W₁ ∩ W₂")
                .font(.headline)
            
            Text("Input: Two subspaces W₁ = span{w₁, w₂} and W₂ = span{w₃, w₄}.")
                .font(.body)
            
            Text("Goal: Find a basis for the intersection W₁ ∩ W₂.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                OperationStepView(
                    step: 1,
                    title: "Set up Equality",
                    description: "A vector w is in the intersection if it can be written as a combo of W₁ AND W₂.",
                    content: "a₁w₁ + a₂w₂ = a₃w₃ + a₄w₄"
                )
                
                OperationStepView(
                    step: 2,
                    title: "Homogeneous System",
                    description: "Rewrite as a system equalling zero:",
                    content: "a₁w₁ + a₂w₂ - a₃w₃ - a₄w₄ = 0"
                )
                
                OperationStepView(
                    step: 3,
                    title: "Apply RREF",
                    description: "Solving the system yields coefficients:",
                    content: "a₁ = 0, a₂ = r"
                )
                
                OperationStepView(
                    step: 4,
                    title: "Substitution",
                    description: "Substitute scalars back into W₁ combination:",
                    content: "w = 0w₁ + rw₂ = r[0, 1, 0]ᵀ"
                )
            }
            
            HStack {
                Image(systemName: "arrow.triangle.merge")
                    .foregroundColor(.purple)
                VStack(alignment: .leading) {
                    Text("Result")
                        .font(.headline)
                    Text("Basis = {[0, 1, 0]ᵀ}")
                        .font(.system(.body, design: .monospaced))
                    Text("Dimension = 1")
                        .font(.caption)
                        .bold()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.purple.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Extending a Basis (Example 189)
struct ExtendingBasisExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Extending to a Basis")
                .font(.headline)
            
            Text("Input: Independent set I = {v₁, v₂} in ℝ³.")
                .font(.body)
            
            Text("Goal: \"Grow\" this small set into a full basis for ℝ³.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                OperationStepView(
                    step: 1,
                    title: "Union with Standard Basis",
                    description: "Combine I with a known basis (like E) to form a superset S:",
                    content: "S = {v₁, v₂, e₁, e₂, e₃}"
                )
                
                OperationStepView(
                    step: 2,
                    title: "Form Matrix & Reduce",
                    description: "Put ALL vectors into columns and find RREF.",
                    content: "[v₁ v₂ e₁ e₂ e₃] → RREF"
                )
                
                OperationStepView(
                    step: 3,
                    title: "Identify Pivot Columns",
                    description: "The calculation shows pivots in columns 1, 2, and 4.",
                    content: "Keep cols 1, 2, 4"
                )
                
                OperationStepView(
                    step: 4,
                    title: "Selection",
                    description: "The corresponding original vectors form the basis.",
                    content: "Keep v₁, v₂, and e₂"
                )
            }
            
            HStack {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .foregroundColor(.green)
                VStack(alignment: .leading) {
                    Text("Extended Basis Result")
                        .font(.headline)
                    Text("Basis = {v₁, v₂, e₂}")
                        .font(.system(.body, design: .monospaced))
                    Text("We kept our original independent vectors and added just enough standard vectors to span the space.")
                        .font(.caption)
                }
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

struct OperationStepView: View {
    let step: Int
    let title: String
    let description: String
    let content: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(step)")
                .font(.caption)
                .bold()
                .frame(width: 24, height: 24)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                if !content.isEmpty {
                    Text(content)
                        .font(.system(.caption, design: .monospaced))
                        .padding(6)
                        .background(Color.white)
                        .cornerRadius(6)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.2)))
                }
            }
        }
    }
}
