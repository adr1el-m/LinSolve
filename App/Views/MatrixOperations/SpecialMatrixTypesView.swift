import SwiftUI

struct SpecialMatrixTypesView: View {
    @State private var selectedType: MatrixType = .upperTriangular
    @State private var exampleMatrix: [[Fraction]] = []
    
    enum MatrixType: String, CaseIterable {
        case upperTriangular = "Upper Triangular"
        case lowerTriangular = "Lower Triangular"
        case diagonal = "Diagonal"
        case symmetric = "Symmetric"
        case skewSymmetric = "Skew-Symmetric"
        case identity = "Identity"
        case zero = "Zero"
        
        var icon: String {
            switch self {
            case .upperTriangular: return "triangle.fill"
            case .lowerTriangular: return "triangle.bottomhalf.filled"
            case .diagonal: return "line.diagonal"
            case .symmetric: return "arrow.left.and.right"
            case .skewSymmetric: return "arrow.left.arrow.right"
            case .identity: return "1.square"
            case .zero: return "0.square"
            }
        }
        
        var color: Color {
            switch self {
            case .upperTriangular: return .blue
            case .lowerTriangular: return .green
            case .diagonal: return .orange
            case .symmetric: return .purple
            case .skewSymmetric: return .pink
            case .identity: return .cyan
            case .zero: return .gray
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Special Matrix Types")
                        .font(.largeTitle)
                        .bold()
                    Text("Common Matrix Forms and Their Properties")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
Certain matrices have special structures that give them useful properties. These special forms appear frequently in applications and often allow for more efficient computation.

Understanding these matrix types is essential for:
• **Solving systems efficiently** (triangular systems are easy to solve)
• **Numerical stability** (symmetric matrices have real eigenvalues)
• **Data compression** (sparse and diagonal matrices save storage)
""")
                        .font(.body)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Type Selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Matrix Type")
                        .font(.headline)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 10) {
                        ForEach(MatrixType.allCases, id: \.self) { type in
                            Button(action: { 
                                selectedType = type
                                updateExample()
                            }) {
                                HStack {
                                    Image(systemName: type.icon)
                                        .foregroundColor(selectedType == type ? .white : type.color)
                                    Text(type.rawValue)
                                        .font(.caption)
                                        .foregroundColor(selectedType == type ? .white : .primary)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(selectedType == type ? type.color : Color(uiColor: .tertiarySystemBackground))
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
                
                // Selected Type Detail
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: selectedType.icon)
                            .font(.title)
                            .foregroundColor(selectedType.color)
                        Text(selectedType.rawValue)
                            .font(.title2)
                            .bold()
                    }
                    
                    // Description
                    matrixTypeDescription
                    
                    // Example Matrix
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Example")
                            .font(.headline)
                        
                        if !exampleMatrix.isEmpty {
                            SpecialMatrixDisplay(matrix: exampleMatrix, type: selectedType)
                        }
                    }
                    
                    // Properties
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Key Properties")
                            .font(.headline)
                        
                        matrixTypeProperties
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Comparison Table
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Reference")
                        .font(.headline)
                    
                    VStack(spacing: 0) {
                        ComparisonRow(name: "Upper Triangular", condition: "aᵢⱼ = 0 for i > j", example: "Entries below diagonal = 0")
                        Divider()
                        ComparisonRow(name: "Lower Triangular", condition: "aᵢⱼ = 0 for i < j", example: "Entries above diagonal = 0")
                        Divider()
                        ComparisonRow(name: "Diagonal", condition: "aᵢⱼ = 0 for i ≠ j", example: "Only diagonal entries non-zero")
                        Divider()
                        ComparisonRow(name: "Symmetric", condition: "Aᵀ = A", example: "aᵢⱼ = aⱼᵢ")
                        Divider()
                        ComparisonRow(name: "Skew-Symmetric", condition: "Aᵀ = -A", example: "aᵢⱼ = -aⱼᵢ, diagonal = 0")
                    }
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
        }
        .onAppear {
            updateExample()
        }
    }
    
    @ViewBuilder
    var matrixTypeDescription: some View {
        switch selectedType {
        case .upperTriangular:
            Text("""
An **upper triangular matrix** has all entries below the main diagonal equal to zero. The non-zero entries form a "triangle" in the upper-right portion.

**Condition:** aᵢⱼ = 0  whenever  i > j

Upper triangular systems can be solved by **back substitution**, starting from the last equation and working upward.
""")
                .font(.body)
            
        case .lowerTriangular:
            Text("""
A **lower triangular matrix** has all entries above the main diagonal equal to zero. The non-zero entries form a "triangle" in the lower-left portion.

**Condition:** aᵢⱼ = 0  whenever  i < j

Lower triangular systems can be solved by **forward substitution**, starting from the first equation and working downward. This form appears in LU decomposition.
""")
                .font(.body)
            
        case .diagonal:
            Text("""
A **diagonal matrix** has non-zero entries only on the main diagonal. All off-diagonal entries are zero.

**Condition:** aᵢⱼ = 0  whenever  i ≠ j

Diagonal matrices are both upper and lower triangular. They are easy to invert (just reciprocate the diagonal), and their eigenvalues are simply the diagonal entries.
""")
                .font(.body)
            
        case .symmetric:
            Text("""
A **symmetric matrix** equals its own transpose. It is "mirrored" across the main diagonal.

**Condition:** Aᵀ = A  (equivalently, aᵢⱼ = aⱼᵢ)

Symmetric matrices have many special properties:
• All eigenvalues are **real**
• Eigenvectors can be chosen to be **orthogonal**
• They are always **diagonalizable**
""")
                .font(.body)
            
        case .skewSymmetric:
            Text("""
A **skew-symmetric** (or anti-symmetric) matrix satisfies Aᵀ = -A. The transpose negates the matrix.

**Condition:** aᵢⱼ = -aⱼᵢ  and  aᵢᵢ = 0

The diagonal entries must be zero (since aᵢᵢ = -aᵢᵢ implies aᵢᵢ = 0). Skew-symmetric matrices have pure imaginary eigenvalues.
""")
                .font(.body)
            
        case .identity:
            Text("""
The **identity matrix** I has 1's on the diagonal and 0's everywhere else. It is the multiplicative identity for matrices.

**Properties:**
• AI = IA = A for any compatible matrix A
• I⁻¹ = I
• Iⁿ = I for all n ≥ 0
• All eigenvalues equal 1
""")
                .font(.body)
            
        case .zero:
            Text("""
The **zero matrix** O has all entries equal to zero. It is the additive identity for matrices.

**Properties:**
• A + O = O + A = A
• AO = OA = O (if dimensions allow)
• Not invertible (singular)
• Only eigenvalue is 0
""")
                .font(.body)
        }
    }
    
    @ViewBuilder
    var matrixTypeProperties: some View {
        switch selectedType {
        case .upperTriangular, .lowerTriangular:
            VStack(alignment: .leading, spacing: 4) {
                Text("• det(A) = product of diagonal entries")
                Text("• Eigenvalues = diagonal entries")
                Text("• Product of triangular matrices (same type) = triangular")
                Text("• Inverse (if exists) is also triangular")
            }
            .font(.body)
            
        case .diagonal:
            VStack(alignment: .leading, spacing: 4) {
                Text("• det(A) = product of diagonal entries")
                Text("• A⁻¹ has reciprocals on diagonal (if all non-zero)")
                Text("• Aⁿ has n-th powers on diagonal")
                Text("• Product of diagonals = diagonal")
            }
            .font(.body)
            
        case .symmetric:
            VStack(alignment: .leading, spacing: 4) {
                Text("• All eigenvalues are real")
                Text("• Orthogonally diagonalizable: A = QDQᵀ")
                Text("• Positive definite if all eigenvalues > 0")
                Text("• A + Aᵀ is always symmetric")
            }
            .font(.body)
            
        case .skewSymmetric:
            VStack(alignment: .leading, spacing: 4) {
                Text("• Eigenvalues are pure imaginary or zero")
                Text("• Diagonal entries must be zero")
                Text("• A - Aᵀ is always skew-symmetric")
                Text("• exp(A) is orthogonal for skew-symmetric A")
            }
            .font(.body)
            
        case .identity:
            VStack(alignment: .leading, spacing: 4) {
                Text("• AI = IA = A")
                Text("• det(I) = 1")
                Text("• All eigenvalues = 1")
                Text("• Is orthogonal, symmetric, and diagonal")
            }
            .font(.body)
            
        case .zero:
            VStack(alignment: .leading, spacing: 4) {
                Text("• A + O = A")
                Text("• AO = OA = O")
                Text("• det(O) = 0")
                Text("• Rank = 0")
            }
            .font(.body)
        }
    }
    
    func updateExample() {
        switch selectedType {
        case .upperTriangular:
            exampleMatrix = [
                [Fraction(2), Fraction(1), Fraction(0), Fraction(0), Fraction(0)],
                [Fraction(0), Fraction(2), Fraction(1), Fraction(0), Fraction(0)],
                [Fraction(0), Fraction(0), Fraction(2), Fraction(0), Fraction(0)],
                [Fraction(0), Fraction(0), Fraction(0), Fraction(-1), Fraction(1)],
                [Fraction(0), Fraction(0), Fraction(0), Fraction(0), Fraction(-1)]
            ]
        case .lowerTriangular:
            exampleMatrix = [
                [Fraction(0), Fraction(0), Fraction(0)],
                [Fraction(-1), Fraction(1), Fraction(0)],
                [Fraction(2), Fraction(-2), Fraction(3)]
            ]
        case .diagonal:
            exampleMatrix = [
                [Fraction(9), Fraction(0)],
                [Fraction(0), Fraction(-1)]
            ]
        case .symmetric:
            exampleMatrix = [
                [Fraction(1), Fraction(2), Fraction(3)],
                [Fraction(2), Fraction(-2), Fraction(4)],
                [Fraction(3), Fraction(4), Fraction(10)]
            ]
        case .skewSymmetric:
            exampleMatrix = [
                [Fraction(0), Fraction(-1)],
                [Fraction(1), Fraction(0)]
            ]
        case .identity:
            exampleMatrix = [
                [Fraction(1), Fraction(0), Fraction(0)],
                [Fraction(0), Fraction(1), Fraction(0)],
                [Fraction(0), Fraction(0), Fraction(1)]
            ]
        case .zero:
            exampleMatrix = [
                [Fraction(0), Fraction(0)],
                [Fraction(0), Fraction(0)]
            ]
        }
    }
}

struct SpecialMatrixDisplay: View {
    let matrix: [[Fraction]]
    let type: SpecialMatrixTypesView.MatrixType
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<matrix.count, id: \.self) { r in
                HStack(spacing: 8) {
                    ForEach(0..<matrix[r].count, id: \.self) { c in
                        Text(matrix[r][c].description)
                            .font(.system(.body, design: .monospaced))
                            .frame(minWidth: 30)
                            .foregroundColor(cellColor(row: r, col: c))
                    }
                }
            }
        }
        .padding(12)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(8)
        .overlay(
            HStack {
                BracketShape(left: true).stroke(type.color, lineWidth: 2).frame(width: 10)
                Spacer()
                BracketShape(left: false).stroke(type.color, lineWidth: 2).frame(width: 10)
            }
        )
    }
    
    func cellColor(row: Int, col: Int) -> Color {
        switch type {
        case .upperTriangular:
            return row > col ? .secondary : type.color
        case .lowerTriangular:
            return row < col ? .secondary : type.color
        case .diagonal:
            return row == col ? type.color : .secondary
        case .symmetric, .skewSymmetric:
            return row == col ? type.color : (row < col ? .blue : .green)
        case .identity:
            return row == col ? type.color : .secondary
        case .zero:
            return .secondary
        }
    }
}

struct ComparisonRow: View {
    let name: String
    let condition: String
    let example: String
    
    var body: some View {
        HStack {
            Text(name)
                .font(.caption)
                .bold()
                .frame(width: 100, alignment: .leading)
            
            Text(condition)
                .font(.system(.caption, design: .serif))
                .italic()
                .frame(width: 100)
            
            Text(example)
                .font(.caption2)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
    }
}
