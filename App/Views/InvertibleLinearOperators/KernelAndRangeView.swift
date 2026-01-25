import SwiftUI

struct KernelAndRangeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Kernel and Range")
                    .font(.largeTitle)
                    .bold()
                
                Text("The fundamental subspaces viewed through the lens of transformations.")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                InfoBox(
                    title: "Kernel (Null Space)",
                    content: "Ker(T) = {x | T(x) = 0}",
                    description: "The set of all vectors that are squashed to zero.",
                    icon: "circle.dashed",
                    color: .red
                )
                
                InfoBox(
                    title: "Range (Image / Column Space)",
                    content: "Im(T) = {T(x) | x ∈ V}",
                    description: "The set of all possible outputs of the transformation.",
                    icon: "arrow.up.right.square",
                    color: .blue
                )
                
                InfoBox(
                    title: "Rank-Nullity Theorem",
                    content: "dim(Ker) + dim(Im) = n",
                    description: "The dimensions must sum to the size of the input space.",
                    icon: "sum",
                    color: .purple
                )
            }
            .padding()
        }
    }
}
