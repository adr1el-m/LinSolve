import SwiftUI

struct InvertingLinearOperatorsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Inverting Linear Operators")
                    .font(.largeTitle)
                    .bold()
                
                Text("Undoing a linear transformation to return to the original vector.")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                InfoBox(
                    title: "Invertibility Condition",
                    content: "det(A) ≠ 0",
                    description: "A linear operator is invertible if and only if its matrix has a non-zero determinant.",
                    icon: "arrow.uturn.backward",
                    color: .green
                )
                
                InfoBox(
                    title: "The Inverse Transformation",
                    content: "T⁻¹(T(x)) = x",
                    description: "Applying the inverse returns you to where you started.",
                    icon: "arrow.counterclockwise",
                    color: .blue
                )
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("One-to-One and Onto")
                        .font(.headline)
                    
                    Text("For a square matrix, being invertible is equivalent to:")
                    Text("• One-to-One (Kernel is {0})")
                    Text("• Onto (Range is the whole space)")
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
            }
            .padding()
        }
    }
}
