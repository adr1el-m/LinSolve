import SwiftUI

struct StepView: View {
    let step: MatrixStep
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if step.operation != "Start" {
                VStack(spacing: 4) {
                    Text(step.operation).font(.caption2).padding(.horizontal, 8).padding(.vertical, 4).background(Color.gray.opacity(0.3)).clipShape(Capsule())
                    Image(systemName: "arrow.right.circle.fill").font(.title2).foregroundColor(.gray)
                }
                .padding(.horizontal, 5)
            }
            
            VStack(spacing: 8) {
                if step.isFinal {
                    Text(step.operation == "Start" ? "Initial" : "RREF").font(.caption2).fontWeight(.bold).foregroundColor(.white).padding(.horizontal, 8).padding(.vertical, 4).background(Color.blue).cornerRadius(4)
                }
                
                MatrixGridView(matrix: step.matrix)
                
                Text(step.description).font(.caption).foregroundColor(.secondary).multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: true).frame(width: 140)
            }
        }
        .padding(.trailing, 10)
    }
}

struct MatrixGridView: View {
    let matrix: [[Fraction]]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<matrix.count, id: \.self) { r in
                HStack(spacing: 12) {
                    ForEach(0..<matrix[r].count, id: \.self) { c in
                        Text(matrix[r][c].description)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 40)
                            .minimumScaleFactor(0.4)
                            .lineLimit(1)
                    }
                }
            }
        }
        .padding(12)
        .background(Color(red: 0.1, green: 0.12, blue: 0.2))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}
