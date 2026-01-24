import SwiftUI

struct BracketOverlay: View {
    var body: some View {
        HStack {
            Rectangle().frame(width: 2).padding(.vertical, 4)
            Spacer()
            Rectangle().frame(width: 2).padding(.vertical, 4)
        }
        .foregroundColor(.primary.opacity(0.3))
    }
}
