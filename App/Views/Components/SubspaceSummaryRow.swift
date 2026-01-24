import SwiftUI

struct SubspaceSummaryRow: View {
    let title: String
    let basis: [[Fraction]]
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                Button(action: action) {
                    Text("See Computation")
                        .font(.caption).bold()
                        .padding(6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                }
            }
            BasisView(title: "", vectors: basis)
        }
        .padding(.vertical, 4)
    }
}
