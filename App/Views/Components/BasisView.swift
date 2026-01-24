import SwiftUI

struct BasisView: View {
    let title: String
    let vectors: [[Fraction]]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !title.isEmpty { Text(title).font(.headline) }
            
            if vectors.isEmpty {
                Text("< 0 >")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Text("<").font(.title2).foregroundColor(.secondary)
                        ForEach(0..<vectors.count, id: \.self) { i in
                            VStack(spacing: 4) {
                                ForEach(0..<vectors[i].count, id: \.self) { j in
                                    Text(vectors[i][j].description)
                                        .font(.system(.body, design: .monospaced))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                }
                            }
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            
                            if i < vectors.count - 1 {
                                Text(",").font(.title2).foregroundColor(.secondary)
                            }
                        }
                        Text(">").font(.title2).foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

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
