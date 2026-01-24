import SwiftUI

struct RankNullityView: View {
    @EnvironmentObject var matrixData: MatrixData
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Rank-Nullity Dashboard")
                    .font(.title2)
                    .bold()
                
                Text("The Rank-Nullity Theorem states that for an m×n matrix A, rank(A) + nullity(A) = n.")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                let matrix = matrixData.getFractionMatrix()
                let result = MatrixEngine.calculateRankNullity(matrix: matrix)
                
                // Dashboard Cards
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    DashboardCard(title: "Rank", value: "\(result.rank)", icon: "list.number", color: .blue)
                    DashboardCard(title: "Nullity", value: "\(result.nullity)", icon: "circle.grid.2x2", color: .purple)
                    DashboardCard(title: "Columns (n)", value: "\(matrixData.cols)", icon: "arrow.right.to.line", color: .orange)
                    DashboardCard(title: "Rows (m)", value: "\(matrixData.rows)", icon: "arrow.down.to.line", color: .green)
                }
                
                // Theorem Check
                VStack(alignment: .leading, spacing: 12) {
                    Text("Theorem Verification")
                        .font(.headline)
                    
                    Text(result.theoremCheck)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(8)
                    
                    if result.rank + result.nullity == matrixData.cols {
                        Label("Theorem Holds", systemImage: "checkmark.seal.fill")
                            .foregroundColor(.green)
                            .font(.headline)
                    } else {
                        Label("Calculation Error", systemImage: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Definitions
                VStack(alignment: .leading, spacing: 16) {
                    Text("Definitions")
                        .font(.headline)
                    
                    DefinitionRow(term: "Rank", definition: "The dimension of the column space (number of pivot columns).")
                    DefinitionRow(term: "Nullity", definition: "The dimension of the null space (number of free variables).")
                    DefinitionRow(term: "Column Space", definition: "Span of the pivot columns of A.")
                    DefinitionRow(term: "Null Space", definition: "Set of all x such that Ax = 0.")
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground).opacity(0.5))
                .cornerRadius(12)
            }
            .padding()
        }
    }
}

struct DashboardCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct DefinitionRow: View {
    let term: String
    let definition: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(term)
                .font(.subheadline)
                .bold()
            Text(definition)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
