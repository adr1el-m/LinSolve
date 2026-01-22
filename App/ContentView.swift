import SwiftUI

// MARK: - Navigation Model

enum AppSection: String, CaseIterable, Identifiable {
    case matrixSetup = "Matrix Setup"
    case introduction = "Introduction"
    case nullSpace = "Null Space"
    case columnSpace = "Column Space"
    case rowSpace = "Row Space"
    case leftNullSpace = "Left Null Space"
    case geometric = "Geometric Visualization"
    
    var id: String { rawValue }
    
    var notation: String {
        switch self {
        case .nullSpace: return "N(A)"
        case .columnSpace: return "C(A)"
        case .rowSpace: return "C(Aᵀ)"
        case .leftNullSpace: return "N(Aᵀ)"
        case .geometric: return "3D"
        default: return ""
        }
    }
    
    var iconName: String {
        switch self {
        case .matrixSetup: return "grid"
        case .introduction: return "book.fill"
        case .geometric: return "cube.transparent"
        default: return "" // Custom icon for subspaces
        }
    }
}

// MARK: - Matrix Data Store

class MatrixData: ObservableObject {
    @Published var rows: Int = 3
    @Published var cols: Int = 3
    @Published var values: [[String]] = Array(repeating: Array(repeating: "0", count: 10), count: 10)
    
    // Computed Results
    @Published var rrefSteps: [MatrixStep] = []
    @Published var rrefTSteps: [MatrixStep] = []
    @Published var columnSpace: [[Fraction]] = []
    @Published var rowSpace: [[Fraction]] = []
    @Published var nullSpace: [[Fraction]] = []
    @Published var leftNullSpace: [[Fraction]] = []
    @Published var hasComputed: Bool = false
    
    // Explanations
    @Published var columnSpaceExplanation: String = ""
    @Published var nullSpaceExplanation: String = ""
    @Published var rowSpaceExplanation: String = ""
    @Published var leftNullSpaceExplanation: String = ""
    
    init() {
        self.rows = 2
        self.cols = 3
        values[0][0] = "1"; values[0][1] = "2"; values[0][2] = "-1"
        values[1][0] = "2"; values[1][1] = "4"; values[1][2] = "-2"
    }
    
    func reset() {
        values = Array(repeating: Array(repeating: "0", count: 10), count: 10)
        for i in 0..<min(rows, cols) { values[i][i] = "1" }
        hasComputed = false
        rrefSteps = []
        rrefTSteps = []
        columnSpace = []
        rowSpace = []
        nullSpace = []
        leftNullSpace = []
    }
    
    func getFractionMatrix() -> [[Fraction]] {
        var res: [[Fraction]] = []
        for r in 0..<rows {
            var row: [Fraction] = []
            for c in 0..<cols {
                row.append(Fraction(string: values[r][c]))
            }
            res.append(row)
        }
        return res
    }
}

// MARK: - Main Content View

struct ContentView: View {
    @State private var selectedSection: AppSection? = .introduction
    @StateObject private var matrixData = MatrixData()
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedSection) {
                Section(header: Text("Topics")) {
                    ForEach(AppSection.allCases) { section in
                        NavigationLink(value: section) {
                            HStack {
                                if !section.iconName.isEmpty {
                                    Image(systemName: section.iconName)
                                        .frame(width: 24)
                                } else {
                                    // Custom Notation Icon
                                    Text(section.notation)
                                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                                        .padding(4)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(4)
                                        .frame(width: 34, height: 24) // Fixed width for alignment
                                }
                                Text(section.rawValue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("LinSolve")
            .listStyle(.sidebar)
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 4) {
                    Text("This Swift Playgrounds app project and activities within it are written by Adriel Magalona.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Text("Swift Student Challenge 2026")
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 12)
                .background(Color(uiColor: .systemBackground).opacity(0.8))
            }
        } detail: {
            if let section = selectedSection {
                DetailView(section: section, selectedSection: $selectedSection)
                    .environmentObject(matrixData)
            } else {
                Text("Select a topic")
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct DetailView: View {
    let section: AppSection
    @Binding var selectedSection: AppSection?
    @EnvironmentObject var matrixData: MatrixData
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    if !section.iconName.isEmpty {
                        Image(systemName: section.iconName).font(.title)
                    } else {
                        Text(section.notation)
                            .font(.system(.title, design: .monospaced))
                            .bold()
                            .padding(6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    Text(section.rawValue)
                        .font(.largeTitle)
                        .bold()
                }
                
                switch section {
                case .matrixSetup:
                    MatrixSetupView(selectedSection: $selectedSection)
                case .introduction:
                    IntroductionView()
                case .nullSpace:
                    SubspaceDetailView(
                        title: "Null Space N(A)",
                        basis: matrixData.nullSpace,
                        explanation: matrixData.nullSpaceExplanation,
                        matrix: matrixData.rrefSteps.last?.matrix ?? []
                    )
                case .columnSpace:
                    SubspaceDetailView(
                        title: "Column Space C(A)",
                        basis: matrixData.columnSpace,
                        explanation: matrixData.columnSpaceExplanation,
                        matrix: matrixData.getFractionMatrix()
                    )
                case .rowSpace:
                    SubspaceDetailView(
                        title: "Row Space C(Aᵀ)",
                        basis: matrixData.rowSpace,
                        explanation: matrixData.rowSpaceExplanation,
                        matrix: matrixData.rrefSteps.last?.matrix ?? []
                    )
                case .leftNullSpace:
                    SubspaceDetailView(
                        title: "Left Null Space N(Aᵀ)",
                        basis: matrixData.leftNullSpace,
                        explanation: matrixData.leftNullSpaceExplanation,
                        matrix: matrixData.rrefTSteps.last?.matrix ?? []
                    )
                case .geometric:
                    GeometricVisualizationView()
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Matrix Setup View

struct MatrixSetupView: View {
    @EnvironmentObject var matrixData: MatrixData
    @Binding var selectedSection: AppSection?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Configure your matrix A.")
                .foregroundColor(.secondary)
            
            // Dimensions
            HStack(spacing: 40) {
                VStack { Text("Rows: \(matrixData.rows)").font(.headline); Stepper("", value: $matrixData.rows, in: 1...10).labelsHidden() }
                VStack { Text("Columns: \(matrixData.cols)").font(.headline); Stepper("", value: $matrixData.cols, in: 1...10).labelsHidden() }
            }
            .padding().background(Color(uiColor: .secondarySystemBackground)).cornerRadius(12)
            
            Divider()
            
            // Grid
            ScrollView([.horizontal, .vertical]) {
                VStack(spacing: 10) {
                    ForEach(0..<matrixData.rows, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(0..<matrixData.cols, id: \.self) { col in
                                TextField("0", text: Binding(
                                    get: { matrixData.values[row][col] },
                                    set: { matrixData.values[row][col] = $0 }
                                ))
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.center)
                                .frame(width: 60, height: 40)
                                .background(Color(uiColor: .systemBackground))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding().background(Color(uiColor: .tertiarySystemBackground)).cornerRadius(12)
            }
            
            // Actions
            HStack(spacing: 20) {
                Button(action: compute) {
                    Text("Compute").font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding().background(Color.blue).cornerRadius(10)
                }
                Button(action: { matrixData.reset() }) {
                    Text("Reset").font(.headline).foregroundColor(.red).frame(maxWidth: .infinity).padding().background(Color.red.opacity(0.1)).cornerRadius(10)
                }
            }
            
            if matrixData.hasComputed {
                Divider()
                
                // RREF A
                VStack(alignment: .leading, spacing: 10) {
                    Text("RREF Process (A)").font(.headline)
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 0) {
                            ForEach(matrixData.rrefSteps) { step in StepView(step: step) }
                        }
                        .padding()
                    }
                    .background(Color(uiColor: .secondarySystemBackground)).cornerRadius(12)
                }
                
                // RREF A^T
                VStack(alignment: .leading, spacing: 10) {
                    Text("RREF Process (Aᵀ)").font(.headline)
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 0) {
                            ForEach(matrixData.rrefTSteps) { step in StepView(step: step) }
                        }
                        .padding()
                    }
                    .background(Color(uiColor: .secondarySystemBackground)).cornerRadius(12)
                }
                
                // Results with "See Computation" Buttons
                VStack(alignment: .leading, spacing: 20) {
                    Text("Fundamental Subspaces").font(.title2).bold()
                    
                    SubspaceSummaryRow(title: "Column Space C(A)", basis: matrixData.columnSpace, action: { selectedSection = .columnSpace })
                    SubspaceSummaryRow(title: "Null Space N(A)", basis: matrixData.nullSpace, action: { selectedSection = .nullSpace })
                    SubspaceSummaryRow(title: "Row Space C(Aᵀ)", basis: matrixData.rowSpace, action: { selectedSection = .rowSpace })
                    SubspaceSummaryRow(title: "Left Null Space N(Aᵀ)", basis: matrixData.leftNullSpace, action: { selectedSection = .leftNullSpace })
                }
                .padding().background(Color(uiColor: .secondarySystemBackground)).cornerRadius(12)
            }
        }
        .padding(.bottom, 50)
    }
    
    func compute() {
        let matrix = matrixData.getFractionMatrix()
        
        // Compute RREF
        matrixData.rrefSteps = MatrixEngine.calculateRREF(matrix: matrix)
        let transposed = MatrixEngine.transpose(matrix)
        matrixData.rrefTSteps = MatrixEngine.calculateRREF(matrix: transposed)
        
        // Compute Subspaces
        if let finalStep = matrixData.rrefSteps.last {
            let rref = finalStep.matrix
            let pivots = MatrixEngine.getPivotIndices(rref: rref)
            
            matrixData.columnSpace = MatrixEngine.getColumnSpace(originalMatrix: matrix, pivotIndices: pivots)
            matrixData.rowSpace = MatrixEngine.getRowSpace(rref: rref)
            matrixData.nullSpace = MatrixEngine.getNullSpace(rref: rref, pivotIndices: pivots)
            
            // Explanations
            let pivotCols = pivots.map { "Col \($0 + 1)" }.joined(separator: ", ")
            matrixData.columnSpaceExplanation = "The RREF of A has pivot columns at indices: \(pivotCols). Therefore, the corresponding columns of the original matrix A form the basis for C(A)."
            
            matrixData.rowSpaceExplanation = "The non-zero rows of the RREF of A form a basis for the row space. Row operations preserve the row space."
            
            let freeCount = matrixData.cols - pivots.count
            if freeCount > 0 {
                matrixData.nullSpaceExplanation = "There are \(freeCount) free variables. We find the basis vectors by setting each free variable to 1 (and others to 0) and solving for the pivot variables using the equations from RREF."
            } else {
                matrixData.nullSpaceExplanation = "There are no free variables. The only solution to Ax=0 is the zero vector."
            }
        }
        
        matrixData.leftNullSpace = MatrixEngine.getLeftNullSpace(originalMatrix: matrix)
        matrixData.leftNullSpaceExplanation = "The left null space is the null space of Aᵀ. We compute RREF(Aᵀ) and find the basis for N(Aᵀ) using the same method as for the null space."
        
        withAnimation {
            matrixData.hasComputed = true
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

struct SubspaceDetailView: View {
    let title: String
    let basis: [[Fraction]]
    let explanation: String
    let matrix: [[Fraction]] // Relevant matrix (RREF or Original)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(explanation)
                .font(.body)
                .padding()
                .background(Color.blue.opacity(0.05))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue.opacity(0.2)))
            
            Text("Relevant Matrix State")
                .font(.headline)
            MatrixGridView(matrix: matrix)
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(12)
            
            Text("Resulting Basis")
                .font(.headline)
            BasisView(title: "Basis Vectors", vectors: basis)
        }
    }
}

struct GeometricVisualizationView: View {
    @EnvironmentObject var matrixData: MatrixData
    @State private var selectedSubspace: String = "Column Space"
    
    var basisVectors: [[Double]] {
        let basis: [[Fraction]]
        switch selectedSubspace {
        case "Column Space": basis = matrixData.columnSpace
        case "Null Space": basis = matrixData.nullSpace
        case "Row Space": basis = matrixData.rowSpace
        case "Left Null Space": basis = matrixData.leftNullSpace
        default: basis = []
        }
        return basis.map { vec in vec.map { $0.asDouble } }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Picker("Subspace", selection: $selectedSubspace) {
                Text("Column Space").tag("Column Space")
                Text("Null Space").tag("Null Space")
                Text("Row Space").tag("Row Space")
                Text("Left Null Space").tag("Left Null Space")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            if matrixData.hasComputed {
                SubspacePlot3D(basisVectors: basisVectors, accentColor: colorForSubspace(selectedSubspace), originalDimension: matrixData.rows)
                    .frame(height: 750)
                    .cornerRadius(16)
                    .padding()
                
                Text("Showing basis for \(selectedSubspace)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                VStack {
                    Image(systemName: "cube.transparent")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("Please compute a matrix first in Matrix Setup.")
                        .foregroundColor(.secondary)
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
    
    func colorForSubspace(_ name: String) -> Color {
        switch name {
        case "Column Space": return .green
        case "Null Space": return .blue
        case "Row Space": return .orange
        case "Left Null Space": return .purple
        default: return .white
        }
    }
}

// MARK: - Reusable Views

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
                                        .frame(minWidth: 20, alignment: .center)
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
                            .frame(width: 40, height: 30)
                            .minimumScaleFactor(0.5)
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

struct IntroductionView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Hero Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("The Four Fundamental Subspaces")
                        .font(.system(size: 48, weight: .bold, design: .serif))
                        .foregroundColor(.primary)
                        .padding(.top, 20)
                    
                    Text("Unveiling the geometry of Linear Algebra")
                        .font(.system(size: 24, design: .serif))
                        .italic()
                        .foregroundColor(.secondary)
                    
                    // Fundamental Theorem Visual
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                            )
                        
                        VStack(spacing: 20) {
                            Text("The Fundamental Theorem of Linear Algebra")
                                .font(.system(size: 20, weight: .semibold, design: .serif))
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 40) {
                                VStack {
                                    MathText(text: "C(A)", size: 32, color: .green)
                                    MathText(text: "dim = r", size: 16, color: .secondary)
                                }
                                
                                Image(systemName: "arrow.left.and.right")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                
                                VStack {
                                    MathText(text: "C(Aᵀ)", size: 32, color: .orange)
                                    MathText(text: "dim = r", size: 16, color: .secondary)
                                }
                            }
                            
                            Divider().padding(.horizontal, 40)
                            
                            HStack(spacing: 40) {
                                VStack {
                                    MathText(text: "N(A)", size: 32, color: .blue)
                                    MathText(text: "dim = n - r", size: 16, color: .secondary)
                                }
                                
                                Text("⊥")
                                    .font(.system(size: 32, weight: .bold, design: .serif))
                                    .foregroundColor(.secondary)
                                
                                VStack {
                                    MathText(text: "C(Aᵀ)", size: 32, color: .orange)
                                    MathText(text: "Row Space", size: 14, color: .secondary)
                                }
                            }
                            
                            Text("Orthogonal Complements in Rⁿ")
                                .font(.system(size: 14, design: .serif))
                                .italic()
                                .foregroundColor(.secondary)
                        }
                        .padding(30)
                    }
                }
                
                Text("Explore the Subspaces")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .padding(.top, 10)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 20)], spacing: 20) {
                    SubspaceCard(
                        symbol: "C(A)",
                        name: "Column Space",
                        description: "The space spanned by the columns of A. Represents all possible outputs of the transformation.",
                        color: .green,
                        icon: "arrow.up.right.square.fill"
                    )
                    
                    SubspaceCard(
                        symbol: "N(A)",
                        name: "Null Space",
                        description: "The set of all vectors x such that Ax = 0. Represents the kernel of the transformation.",
                        color: .blue,
                        icon: "circle.dashed.inset.filled"
                    )
                    
                    SubspaceCard(
                        symbol: "C(Aᵀ)",
                        name: "Row Space",
                        description: "The space spanned by the rows of A. It is the orthogonal complement of the Null Space.",
                        color: .orange,
                        icon: "tablecells.fill"
                    )
                    
                    SubspaceCard(
                        symbol: "N(Aᵀ)",
                        name: "Left Null Space",
                        description: "The null space of Aᵀ. It is the orthogonal complement of the Column Space.",
                        color: .purple,
                        icon: "arrow.uturn.left.square.fill"
                    )
                }
                
                // Instructions
                VStack(alignment: .leading, spacing: 20) {
                    Text("How to use this app")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                    
                    VStack(alignment: .leading, spacing: 16) {
                        InstructionRow(number: "1", text: "Go to 'Matrix Setup' to define your matrix dimensions and values.")
                        InstructionRow(number: "2", text: "Tap 'Compute' to calculate the RREF and derived subspaces.")
                        InstructionRow(number: "3", text: "Explore each subspace detail view to see the basis vectors and mathematical derivation.")
                        InstructionRow(number: "4", text: "Visit 'Geometric Visualization' to see these spaces in 3D (for 3x3 matrices).")
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(16)
                }
                
                Spacer(minLength: 50)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 20)
        }
    }
}

struct MathText: View {
    let text: String
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: size, weight: .medium, design: .serif))
            .foregroundColor(color)
    }
}

struct SubspaceCard: View {
    let symbol: String
    let name: String
    let description: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                Spacer()
                Text(symbol)
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundColor(color)
            }
            
            Text(name)
                .font(.system(size: 20, weight: .bold, design: .serif))
                .foregroundColor(.primary)
            
            Text(description)
                .font(.system(size: 16, design: .serif))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(3)
        }
        .padding(24)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct InstructionRow: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(number)
                .font(.system(size: 16, weight: .bold, design: .serif))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Circle().fill(Color.blue))
            
            Text(text)
                .font(.system(size: 18, design: .serif))
                .foregroundColor(.primary)
        }
    }
}
