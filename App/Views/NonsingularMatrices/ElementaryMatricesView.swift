import SwiftUI

struct ElementaryMatricesView: View {
    @State private var selectedType: ElementaryType = .swap
    @State private var showDemo: Bool = false
    
    enum ElementaryType: String, CaseIterable {
        case swap = "Type I: Swap"
        case scale = "Type II: Scale"
        case add = "Type III: Add"
        
        var symbol: String {
            switch self {
            case .swap: return "Eᵢⱼ"
            case .scale: return "Eᵢ(c)"
            case .add: return "Eᵢⱼ(c)"
            }
        }
        
        var description: String {
            switch self {
            case .swap: return "Swaps row i with row j"
            case .scale: return "Multiplies row i by scalar c (c ≠ 0)"
            case .add: return "Adds c times row j to row i"
            }
        }
        
        var color: Color {
            switch self {
            case .swap: return .blue
            case .scale: return .purple
            case .add: return .orange
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Elementary Matrices")
                        .font(.largeTitle)
                        .bold()
                    Text("Building Blocks of Row Operations")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
**Elementary matrices** are special matrices that perform a single row operation when multiplied with another matrix. They are formed by applying one elementary row operation to the identity matrix.

**The Three Types:**
1. **Type I (Swap)**: Swaps two rows
2. **Type II (Scale)**: Multiplies a row by a non-zero scalar
3. **Type III (Add)**: Adds a multiple of one row to another

**Key Properties:**
• Every elementary matrix is **invertible**
• The inverse of an elementary matrix is also elementary
• Row operations can be expressed as left-multiplication by elementary matrices
• Any invertible matrix can be written as a **product of elementary matrices**
""")
                        .font(.body)
                        .padding(.vertical, 4)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Type Selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Elementary Matrix Type")
                        .font(.headline)
                    
                    Picker("Type", selection: $selectedType) {
                        ForEach(ElementaryType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    HStack {
                        Text(selectedType.symbol)
                            .font(.system(.title2, design: .serif))
                            .bold()
                            .foregroundColor(selectedType.color)
                        Text("— \(selectedType.description)")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                // Type-specific content
                Group {
                    switch selectedType {
                    case .swap:
                        swapTypeView
                    case .scale:
                        scaleTypeView
                    case .add:
                        addTypeView
                    }
                }
                
                // Matrix Decomposition Example
                VStack(alignment: .leading, spacing: 16) {
                    Text("Matrix Decomposition Example")
                        .font(.headline)
                    
                    Text("Any invertible matrix can be written as a product of elementary matrices. This is because row reducing to I corresponds to multiplying by elementary matrices.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Example: Express A as a product of elementary matrices")
                            .font(.subheadline)
                            .bold()
                        
                        HStack(spacing: 20) {
                            Text("A =")
                                .font(.title3)
                            ElementaryMatrixDisplay(matrix: [["3", "-4"], ["1", "-1"]])
                        }
                        
                        Text("**Step 1:** Reduce A to I using row operations")
                            .font(.body)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("1. R₁ ↔ R₂ (Swap)")
                            Text("2. R₂ → R₂ - 3R₁ (Add)")
                            Text("3. R₂ → (-1)R₂ (Scale)")
                            Text("4. R₁ → R₁ + R₂ (Add)")
                        }
                        .font(.system(.caption, design: .monospaced))
                        .padding()
                        .background(Color(uiColor: .systemBackground))
                        .cornerRadius(8)
                        
                        Text("**Step 2:** A = product of inverses of these operations (in reverse order)")
                            .font(.body)
                        
                        Text("A = E₁₂ · E₂₁(3) · E₂(-1) · E₁₂(-1)")
                            .font(.system(.body, design: .monospaced))
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
        }
        .onChange(of: selectedType) { _ in
            showDemo = false
        }
    }
    
    var swapTypeView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Type I: Row Swap (Eᵢⱼ)")
                .font(.headline)
                .foregroundColor(.blue)
            
            Text("Swapping rows i and j in the identity matrix creates an elementary matrix that swaps those rows when multiplied.")
                .font(.body)
                .foregroundColor(.secondary)
            
            // Example
            VStack(alignment: .leading, spacing: 12) {
                Text("Example: E₁₂ (swap rows 1 and 2)")
                    .font(.subheadline)
                    .bold()
                
                HStack(spacing: 30) {
                    VStack {
                        Text("E₁₂")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        ElementaryMatrixDisplay(matrix: [["0", "1"], ["1", "0"]])
                    }
                    
                    Text("×")
                        .font(.title2)
                    
                    VStack {
                        Text("A")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        ElementaryMatrixDisplay(matrix: [["a", "b"], ["c", "d"]])
                    }
                    
                    Text("=")
                        .font(.title2)
                    
                    VStack {
                        Text("Result")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        ElementaryMatrixDisplay(matrix: [["c", "d"], ["a", "b"]])
                    }
                }
                
                // Properties
                VStack(alignment: .leading, spacing: 6) {
                    Text("Properties:")
                        .font(.subheadline)
                        .bold()
                    Text("• Inverse: E₁₂⁻¹ = E₁₂ (swapping twice returns to original)")
                    Text("• Determinant: det(Eᵢⱼ) = -1")
                }
                .font(.caption)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
    
    var scaleTypeView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Type II: Row Scale (Eᵢ(c))")
                .font(.headline)
                .foregroundColor(.purple)
            
            Text("Scaling row i by c in the identity matrix creates an elementary matrix that scales that row when multiplied.")
                .font(.body)
                .foregroundColor(.secondary)
            
            // Example
            VStack(alignment: .leading, spacing: 12) {
                Text("Example: E₂(3) (multiply row 2 by 3)")
                    .font(.subheadline)
                    .bold()
                
                HStack(spacing: 30) {
                    VStack {
                        Text("E₂(3)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        ElementaryMatrixDisplay(matrix: [["1", "0"], ["0", "3"]])
                    }
                    
                    Text("×")
                        .font(.title2)
                    
                    VStack {
                        Text("A")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        ElementaryMatrixDisplay(matrix: [["a", "b"], ["c", "d"]])
                    }
                    
                    Text("=")
                        .font(.title2)
                    
                    VStack {
                        Text("Result")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        ElementaryMatrixDisplay(matrix: [["a", "b"], ["3c", "3d"]])
                    }
                }
                
                // Properties
                VStack(alignment: .leading, spacing: 6) {
                    Text("Properties:")
                        .font(.subheadline)
                        .bold()
                    Text("• Inverse: Eᵢ(c)⁻¹ = Eᵢ(1/c)")
                    Text("• Determinant: det(Eᵢ(c)) = c")
                    Text("• Requires c ≠ 0")
                }
                .font(.caption)
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
    
    var addTypeView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Type III: Row Add (Eᵢⱼ(c))")
                .font(.headline)
                .foregroundColor(.orange)
            
            Text("Adding c times row j to row i in the identity creates an elementary matrix that performs this operation when multiplied.")
                .font(.body)
                .foregroundColor(.secondary)
            
            // Example
            VStack(alignment: .leading, spacing: 12) {
                Text("Example: E₂₁(3) (add 3 × row 1 to row 2)")
                    .font(.subheadline)
                    .bold()
                
                HStack(spacing: 30) {
                    VStack {
                        Text("E₂₁(3)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        ElementaryMatrixDisplay(matrix: [["1", "0"], ["3", "1"]])
                    }
                    
                    Text("×")
                        .font(.title2)
                    
                    VStack {
                        Text("A")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        ElementaryMatrixDisplay(matrix: [["a", "b"], ["c", "d"]])
                    }
                    
                    Text("=")
                        .font(.title2)
                    
                    VStack {
                        Text("Result")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        ElementaryMatrixDisplay(matrix: [["a", "b"], ["3a+c", "3b+d"]])
                    }
                }
                
                // Properties
                VStack(alignment: .leading, spacing: 6) {
                    Text("Properties:")
                        .font(.subheadline)
                        .bold()
                    Text("• Inverse: Eᵢⱼ(c)⁻¹ = Eᵢⱼ(-c)")
                    Text("• Determinant: det(Eᵢⱼ(c)) = 1")
                    Text("• This is the most common operation in Gaussian elimination")
                }
                .font(.caption)
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct ElementaryMatrixDisplay: View {
    let matrix: [[String]]
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<matrix.count, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(0..<matrix[row].count, id: \.self) { col in
                        Text(matrix[row][col])
                            .font(.system(.body, design: .monospaced))
                            .frame(minWidth: 30)
                    }
                }
            }
        }
        .padding(8)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(6)
        .overlay(
            HStack {
                BracketShape(left: true).stroke(Color.primary, lineWidth: 1.5).frame(width: 8)
                Spacer()
                BracketShape(left: false).stroke(Color.primary, lineWidth: 1.5).frame(width: 8)
            }
        )
    }
}
