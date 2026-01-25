import SwiftUI

struct SymmetricMatrixProductsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "square.on.square")
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                        Text("Symmetric Matrix Products")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Products AᵀA and AAᵀ")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Properties
                VStack(alignment: .leading, spacing: 12) {
                    Text("Important Properties")
                        .font(.headline)
                    
                    Text("For ANY rectangular matrix A (m×n):")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        SymmetricPropertyRow(
                            name: "Symmetry",
                            desc: "Both AᵀA and AAᵀ are always symmetric matrices.",
                            icon: "arrow.triangle.2.circlepath"
                        )
                        
                        SymmetricPropertyRow(
                            name: "Dimensions",
                            desc: "AᵀA is n×n, AAᵀ is m×m.",
                            icon: "square.dashed"
                        )
                        
                        SymmetricPropertyRow(
                            name: "Applications",
                            desc: "Used in Least Squares (normal equation) and Singular Value Decomposition (SVD).",
                            icon: "function"
                        )
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Example 269
                SymmetricProductsExample()
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Example 269
struct SymmetricProductsExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Calculating Products")
                .font(.headline)
            
            Text("Input: Matrix A (2×3)")
                .font(.caption)
            Text("""
                ┌ 1   2  -1 ┐
            A = │           │
                └ 2  -3   1 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            // A^T A
            VStack(alignment: .leading, spacing: 12) {
                Text("1. Operation AᵀA (Inner Product Matrix)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.purple)
                
                Text("Compute dot products of the COLUMNS of A:")
                    .font(.caption)
                
                VStack(alignment: .leading, spacing: 6) {
                    ProductCalcRow(row: "Col 1 · Col 1", calc: "1(1) + 2(2) = 5")
                    ProductCalcRow(row: "Col 1 · Col 2", calc: "1(2) + 2(-3) = -4")
                    ProductCalcRow(row: "Col 1 · Col 3", calc: "1(-1) + 2(1) = 1")
                    // And so on... simplified for UI
                }
                .padding(8)
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(6)
                
                HStack {
                    Text("Result (3×3):")
                        .font(.caption)
                    Spacer()
                    Text("""
                        ┌  5  -4   1 ┐
                        │ -4  13  -5 │
                        └  1  -5   2 ┘
                    """)
                        .font(.system(.caption, design: .monospaced))
                }
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(8)
            }
            
            // A A^T
            VStack(alignment: .leading, spacing: 12) {
                Text("2. Operation AAᵀ (Outer Product Matrix)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Compute dot products of the ROWS of A:")
                    .font(.caption)
                
                VStack(alignment: .leading, spacing: 6) {
                    ProductCalcRow(row: "Row 1 · Row 1", calc: "1(1) + 2(2) + (-1)(-1) = 6")
                    ProductCalcRow(row: "Row 1 · Row 2", calc: "1(2) + 2(-3) + (-1)(1) = -5")
                }
                .padding(8)
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(6)
                
                HStack {
                    Text("Result (2×2):")
                        .font(.caption)
                    Spacer()
                    Text("""
                        ┌  6  -5 ┐
                        └ -5  14 ┘
                    """)
                        .font(.system(.body, design: .monospaced))
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

private struct SymmetricPropertyRow: View {
    let name: String
    let desc: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.purple)
                .frame(width: 20)
            VStack(alignment: .leading) {
                Text(name).font(.subheadline).bold()
                Text(desc).font(.caption).foregroundColor(.secondary)
            }
        }
    }
}

struct ProductCalcRow: View {
    let row: String
    let calc: String
    
    var body: some View {
        HStack {
            Text(row)
                .font(.caption)
                .bold()
            Spacer()
            Text(calc)
                .font(.system(.caption, design: .monospaced))
        }
    }
}
