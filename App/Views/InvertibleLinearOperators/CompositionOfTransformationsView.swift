import SwiftUI

struct CompositionOfTransformationsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Composition of Transformations")
                    .font(.largeTitle)
                    .bold()
                
                Text("Combining multiple linear transformations into a single operation.")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                InfoBox(
                    title: "Definition",
                    content: "(S ∘ T)(x) = S(T(x))",
                    description: "Applying transformation T first, then transformation S.",
                    icon: "arrow.triangle.2.circlepath",
                    color: .purple
                )
                
                InfoBox(
                    title: "Matrix Representation",
                    content: "[S ∘ T] = [S][T]",
                    description: "The matrix for the composition is the product of the individual matrices.",
                    icon: "square.grid.3x3.fill",
                    color: .blue
                )
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Example")
                        .font(.headline)
                    
                    Text("If T rotates by 90° and S scales by 2, then S ∘ T rotates by 90° AND scales by 2.")
                        .font(.body)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
            }
            .padding()
        }
    }
}
