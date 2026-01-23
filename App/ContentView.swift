import SwiftUI
import UIKit

// MARK: - Navigation Model

enum AppSection: String, CaseIterable, Identifiable {
    case introduction = "Introduction"
    case matrixSetup = "Matrix Setup"
    case nullSpace = "Null Space"
    case columnSpace = "Column Space"
    case rowSpace = "Row Space"
    case leftNullSpace = "Left Null Space"
    case inverse = "Matrix Inverse"
    case determinant = "Determinant"
    case eigenvalues = "Eigenvalues"
    case eigenvectors = "Eigenvectors"
    case diagonalization = "Diagonalization"
    case orthogonality = "Inner Product & Orthogonality"
    case distanceHyperplane = "Distance to Hyperplane"
    case leastSquaresInconsistent = "Inconsistent System LS"
    case leastSquaresError = "Least Square Error"
    case leastSquaresInfinite = "Infinite Solutions LS"
    case linearRegression = "Linear Regression"
    case quadraticCurveFitting = "Quadratic Curve Fitting"
    case geometric = "Geometric Visualization"
    case settings = "Settings"
    
    var id: String { rawValue }
    
    var notation: String {
        switch self {
        case .nullSpace: return "N(A)"
        case .columnSpace: return "C(A)"
        case .rowSpace: return "C(Aᵀ)"
        case .leftNullSpace: return "N(Aᵀ)"
        case .inverse: return "A⁻¹"
        case .determinant: return "|A|"
        case .eigenvalues: return "λ"
        case .eigenvectors: return "v"
        case .diagonalization: return "PDP⁻¹"
        case .orthogonality: return "u·v"
        case .distanceHyperplane: return "dist"
        case .leastSquaresInconsistent: return "LS"
        case .leastSquaresError: return "E"
        case .leastSquaresInfinite: return "LS∞"
        case .linearRegression: return "y=mx+b"
        case .quadraticCurveFitting: return "y=ax²+bx+c"
        case .geometric: return "3D"
        default: return ""
        }
    }
    
    var iconName: String {
        switch self {
        case .matrixSetup: return "grid"
        case .introduction: return "book.fill"
        case .geometric: return "cube.transparent"
        case .inverse: return "1.square"
        case .determinant: return "sum"
        case .eigenvalues: return "function"
        case .eigenvectors: return "arrow.up.left.and.arrow.down.right"
        case .diagonalization: return "arrow.triangle.2.circlepath"
        case .orthogonality: return "angle"
        case .distanceHyperplane: return "arrow.up.to.line"
        case .leastSquaresInconsistent: return "exclamationmark.triangle"
        case .leastSquaresError: return "chart.bar"
        case .leastSquaresInfinite: return "infinity"
        case .linearRegression: return "chart.xyaxis.line"
        case .quadraticCurveFitting: return "chart.line.uptrend.xyaxis"
        case .settings: return "gear"
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
    @Published var pivots: [Int] = []
    @Published var hasComputed: Bool = false
    @Published var determinantValue: Fraction? = nil
    @Published var inverseMatrix: [[Fraction]]? = nil
    
    // Explanations
    @Published var columnSpaceExplanation: String = ""
    @Published var nullSpaceExplanation: String = ""
    @Published var rowSpaceExplanation: String = ""
    @Published var leftNullSpaceExplanation: String = ""
    
    init() {
        self.rows = 3
        self.cols = 3
        values[0][0] = "4"; values[0][1] = "1"; values[0][2] = "-1"
        values[1][0] = "2"; values[1][1] = "5"; values[1][2] = "-2"
        values[2][0] = "1"; values[2][1] = "1"; values[2][2] = "2"
        // Computation will happen on first view appear or manual trigger
        // We defer calling compute() here to let SwiftUI layout first, but we can't easily.
        // Instead, we will rely on onAppear or just not compute initially (user clicks Compute).
        // However, to prevent empty screens, we can run a dummy compute without animation.
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
        determinantValue = nil
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
    
    func compute() {
        let matrix = getFractionMatrix()
        
        // Compute RREF
        rrefSteps = MatrixEngine.calculateRREF(matrix: matrix)
        let transposed = MatrixEngine.transpose(matrix)
        rrefTSteps = MatrixEngine.calculateRREF(matrix: transposed)
        
        // Compute Subspaces
        if let finalStep = rrefSteps.last {
            let rref = finalStep.matrix
            let pivots = MatrixEngine.getPivotIndices(rref: rref)
            self.pivots = pivots
            
            columnSpace = MatrixEngine.getColumnSpace(originalMatrix: matrix, pivotIndices: pivots)
            rowSpace = MatrixEngine.getRowSpace(rref: rref)
            nullSpace = MatrixEngine.getNullSpace(rref: rref, pivotIndices: pivots)
            
            // Explanations
            let pivotCols = pivots.map { "Col \($0 + 1)" }.joined(separator: ", ")
            columnSpaceExplanation = "The RREF of A has pivot columns at indices: \(pivotCols). Therefore, the corresponding columns of the original matrix A form the basis for C(A)."
            
            rowSpaceExplanation = "The non-zero rows of the RREF of A form a basis for the row space. Row operations preserve the row space."
            
            let freeCount = cols - pivots.count
            if freeCount > 0 {
                nullSpaceExplanation = "There are \(freeCount) free variables. We find the basis vectors by setting each free variable to 1 (and others to 0) and solving for the pivot variables using the equations from RREF."
            } else {
                nullSpaceExplanation = "There are no free variables. The only solution to Ax=0 is the zero vector."
            }
        }
        
        leftNullSpace = MatrixEngine.getLeftNullSpace(originalMatrix: matrix)
        leftNullSpaceExplanation = "The left null space is the null space of Aᵀ. We compute RREF(Aᵀ) and find the basis for N(Aᵀ) using the same method as for the null space."
        
        // Compute Determinant (if square)
        if rows == cols {
            determinantValue = MatrixEngine.calculateDeterminantValue(matrix)
            
            // Compute Inverse
            let invSteps = MatrixEngine.calculateInverseSteps(matrix: matrix)
            if let lastStep = invSteps.last {
                let rrefAug = lastStep.matrix
                let n = rows
                
                // Check if Identity on left
                var isIdentity = true
                for i in 0..<n {
                    for j in 0..<n {
                        let val = rrefAug[i][j]
                        if i == j {
                            if val.numerator != 1 || val.denominator != 1 { isIdentity = false; break }
                        } else {
                            if val.numerator != 0 { isIdentity = false; break }
                        }
                    }
                    if !isIdentity { break }
                }
                
                if isIdentity {
                    var inv: [[Fraction]] = []
                    for i in 0..<n {
                        var row: [Fraction] = []
                        for j in n..<2*n {
                            row.append(rrefAug[i][j])
                        }
                        inv.append(row)
                    }
                    inverseMatrix = inv
                } else {
                    inverseMatrix = nil
                }
            }
        } else {
            determinantValue = nil
            inverseMatrix = nil
        }
        
        withAnimation {
            hasComputed = true
        }
    }
}

// MARK: - Main Content View

struct ContentView: View {
    @State private var selectedSection: AppSection? = .introduction
    @StateObject private var matrixData = MatrixData()
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("useSystemTheme") private var useSystemTheme: Bool = true
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedSection) {
                Section(header: Text("Topics")) {
                    // 1. Introduction
                    NavigationLink(value: AppSection.introduction) {
                        Label(AppSection.introduction.rawValue, systemImage: AppSection.introduction.iconName)
                    }
                    
                    // 2. Matrix Setup
                    NavigationLink(value: AppSection.matrixSetup) {
                        Label(AppSection.matrixSetup.rawValue, systemImage: AppSection.matrixSetup.iconName)
                    }
                    
                    // 3. Subspaces Dropdown
                    DisclosureGroup(
                        content: {
                            NavigationLink(value: AppSection.columnSpace) { Label("Column Space C(A)", systemImage: "arrow.up.right.square") }
                            NavigationLink(value: AppSection.nullSpace) { Label("Null Space N(A)", systemImage: "circle.dashed.inset.filled") }
                            NavigationLink(value: AppSection.rowSpace) { Label("Row Space C(Aᵀ)", systemImage: "tablecells") }
                            NavigationLink(value: AppSection.leftNullSpace) { Label("Left Null Space N(Aᵀ)", systemImage: "arrow.uturn.left.square") }
                        },
                        label: {
                            Label("Fundamental Subspaces", systemImage: "square.stack.3d.up")
                        }
                    )
                    
                    // 4. Matrix Inverse
                    NavigationLink(value: AppSection.inverse) {
                        Label(AppSection.inverse.rawValue, systemImage: AppSection.inverse.iconName)
                    }
                    
                    // 5. Determinant
                    NavigationLink(value: AppSection.determinant) {
                        Label(AppSection.determinant.rawValue, systemImage: AppSection.determinant.iconName)
                    }

                    // 6. Inner Product & Orthogonality
                    NavigationLink(value: AppSection.orthogonality) {
                        Label(AppSection.orthogonality.rawValue, systemImage: AppSection.orthogonality.iconName)
                    }

                    // 7. Least Squares Approximation
                    DisclosureGroup(
                        content: {
                            NavigationLink(value: AppSection.distanceHyperplane) {
                                Label("Dist to Hyperplane", systemImage: AppSection.distanceHyperplane.iconName)
                            }
                            NavigationLink(value: AppSection.leastSquaresInconsistent) {
                                Label("Inconsistent System", systemImage: AppSection.leastSquaresInconsistent.iconName)
                            }
                            NavigationLink(value: AppSection.leastSquaresError) {
                                Label("Least Square Error", systemImage: AppSection.leastSquaresError.iconName)
                            }
                            NavigationLink(value: AppSection.leastSquaresInfinite) {
                                Label("Infinitely Many Sol.", systemImage: AppSection.leastSquaresInfinite.iconName)
                            }
                            NavigationLink(value: AppSection.linearRegression) {
                                Label("Linear Regression", systemImage: AppSection.linearRegression.iconName)
                            }
                            NavigationLink(value: AppSection.quadraticCurveFitting) {
                                Label("Quadratic Curve Fit", systemImage: AppSection.quadraticCurveFitting.iconName)
                            }
                        },
                        label: {
                            Label("Least Squares", systemImage: "chart.line.uptrend.xyaxis")
                        }
                    )
                    
                    // 8. Eigenvalues and Eigenvectors
                    DisclosureGroup(
                        content: {
                            NavigationLink(value: AppSection.eigenvalues) {
                                Label("Eigenvalues", systemImage: AppSection.eigenvalues.iconName)
                            }
                            NavigationLink(value: AppSection.eigenvectors) {
                                Label("Eigenvectors", systemImage: AppSection.eigenvectors.iconName)
                            }
                        },
                        label: {
                            Label("Eigenvalues & Vectors", systemImage: "chart.xyaxis.line")
                        }
                    )

                    // 9. Diagonalization
                    NavigationLink(value: AppSection.diagonalization) {
                        Label(AppSection.diagonalization.rawValue, systemImage: AppSection.diagonalization.iconName)
                    }
                    
                    // 10. Geometric Visualization
                    NavigationLink(value: AppSection.geometric) {
                        Label(AppSection.geometric.rawValue, systemImage: AppSection.geometric.iconName)
                    }
                }
                
                Section(header: Text("App")) {
                    NavigationLink(value: AppSection.settings) {
                        Label("Settings", systemImage: "gear")
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
        .preferredColorScheme(useSystemTheme ? nil : (isDarkMode ? .dark : .light))
        .onAppear {
            if !matrixData.hasComputed {
                matrixData.compute()
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
                    NullSpaceDetailView(
                        title: "Null Space N(A)",
                        matrix: matrixData.rrefSteps.last?.matrix ?? [],
                        pivots: matrixData.pivots,
                        totalCols: matrixData.cols
                    )
                case .columnSpace:
                    ColumnSpaceDetailView(
                        title: "Column Space C(A)",
                        originalMatrix: matrixData.getFractionMatrix(),
                        pivots: matrixData.pivots
                    )
                case .rowSpace:
                    RowSpaceDetailView(
                        title: "Row Space C(Aᵀ)",
                        originalMatrix: matrixData.getFractionMatrix()
                    )
                case .leftNullSpace:
                    LeftNullSpaceDetailView(
                        title: "Left Null Space N(Aᵀ)",
                        originalMatrix: matrixData.getFractionMatrix()
                    )
                case .inverse:
                    MatrixInverseView()
                case .determinant:
                    DeterminantView()
                case .geometric:
                    GeometricVisualizationView()
                case .settings:
                    SettingsView()
                case .eigenvalues:
                    EigenvaluesView()
                case .eigenvectors:
                    EigenvectorsView()
                case .diagonalization:
                    DiagonalizationView()
                case .orthogonality:
                    OrthogonalityView()
                case .distanceHyperplane:
                    DistanceHyperplaneView()
                case .quadraticCurveFitting:
                    QuadraticCurveFitView()
                case .leastSquaresInconsistent, .leastSquaresError, .leastSquaresInfinite, .linearRegression:
                    Text("Least Squares Module Coming Soon")
                        .foregroundColor(.secondary)
                        .padding()
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
            HStack(spacing: 16) {
                HStack(spacing: 30) {
                    VStack { Text("Rows: \(matrixData.rows)").font(.headline); Stepper("", value: $matrixData.rows, in: 1...10).labelsHidden() }
                    VStack { Text("Columns: \(matrixData.cols)").font(.headline); Stepper("", value: $matrixData.cols, in: 1...10).labelsHidden() }
                }
                .padding().background(Color(uiColor: .secondarySystemBackground)).cornerRadius(12)
            }
            .fixedSize(horizontal: false, vertical: true)
            
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
                Button(action: { matrixData.compute() }) {
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
                    
                    if matrixData.rows == matrixData.cols {
                        Divider()
                        
                        // Inverse
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Matrix Inverse A⁻¹").font(.headline)
                                Spacer()
                                Button(action: { selectedSection = .inverse }) {
                                    Text("See Steps")
                                        .font(.caption).bold()
                                        .padding(6)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(6)
                                }
                            }
                            
                            if let inv = matrixData.inverseMatrix {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 0) {
                                        RoundedRectangle(cornerRadius: 2).frame(width: 2).padding(.vertical, 4)
                                        VStack(spacing: 4) {
                                            ForEach(0..<inv.count, id: \.self) { r in
                                                HStack(spacing: 8) {
                                                    ForEach(0..<inv[r].count, id: \.self) { c in
                                                        Text(inv[r][c].description)
                                                            .font(.system(.caption, design: .monospaced))
                                                            .frame(width: 60, height: 30, alignment: .center)
                                                            .minimumScaleFactor(0.4)
                                                            .lineLimit(1)
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 4)
                                        RoundedRectangle(cornerRadius: 2).frame(width: 2).padding(.vertical, 4)
                                    }
                                    .padding(8)
                                    .background(Color(uiColor: .tertiarySystemBackground))
                                    .cornerRadius(8)
                                }
                            } else {
                                Text("Matrix is Singular (No Inverse)")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                    .padding(.vertical, 4)
                            }
                            
                            Text("Calculated via Gauss-Jordan Elimination").font(.caption).foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        
                        Divider()
                        
                        // Determinant
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Determinant |A|").font(.headline)
                                if let det = matrixData.determinantValue {
                                    Text("Result: \(det.description)").font(.subheadline).bold().foregroundColor(.primary)
                                }
                                Text("Calculated via Cofactor Expansion / Sarrus").font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: { selectedSection = .determinant }) {
                                Text("See Steps")
                                    .font(.caption).bold()
                                    .padding(6)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(6)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding().background(Color(uiColor: .secondarySystemBackground)).cornerRadius(12)
            }
        }
        .padding(.bottom, 50)
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

struct IntroductionView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Hero Section
                VStack(alignment: .center, spacing: 16) {
                    Image(systemName: "cube.transparent")
                        .font(.system(size: 60))
                        .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(.bottom, 8)
                    
                    Text("VectorLens")
                        .font(.system(size: 42, weight: .bold, design: .serif))
                        .foregroundColor(.primary)
                    
                    Text("Interactive Linear Algebra")
                        .font(.system(size: 24, design: .serif))
                        .italic()
                        .foregroundColor(.secondary)
                    
                    Text("Visualize, Compute, and Understand")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(20)
                
                // Features Grid
                VStack(alignment: .leading, spacing: 24) {
                    Text("What's Inside")
                        .font(.title2)
                        .bold()
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 20) {
                        FeatureCard(
                            icon: "square.grid.3x3.fill",
                            title: "Matrix Operations",
                            description: "Perform RREF, Inverse (Gauss-Jordan), and Determinant (Cofactor & Sarrus) calculations with step-by-step explanations.",
                            color: .blue
                        )
                        
                        FeatureCard(
                            icon: "function",
                            title: "Eigen Theory",
                            description: "Find Eigenvalues via Characteristic Polynomial and Eigenvectors via Null Space basis. Diagonalize matrices (PDP⁻¹) and verify results.",
                            color: .purple
                        )
                        
                        FeatureCard(
                            icon: "angle",
                            title: "Inner Product & Orthogonality",
                            description: "Explore dot products, norms, angles, distance, and verify orthogonal sets. Visual step-by-step breakdown.",
                            color: .red
                        )
                        
                        FeatureCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Least Squares",
                            description: "Perform Quadratic Curve Fitting and calculate Distance to Hyperplanes using Least Squares and Projection methods.",
                            color: .pink
                        )
                        
                        FeatureCard(
                            icon: "square.stack.3d.up",
                            title: "Fundamental Subspaces",
                            description: "Visualize the Four Fundamental Subspaces: Column Space, Null Space, Row Space, and Left Null Space.",
                            color: .green
                        )
                        
                        FeatureCard(
                            icon: "cube.transparent",
                            title: "Geometric Visualization",
                            description: "Interactive 3D visualization of vectors and subspaces to build geometric intuition.",
                            color: .orange
                        )
                    }
                }
                
                // Getting Started
                VStack(alignment: .leading, spacing: 24) {
                    Text("Getting Started")
                        .font(.title2)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        InstructionRow(number: "1", text: "Go to 'Matrix Setup' to define your matrix A.")
                        InstructionRow(number: "2", text: "Tap 'Compute' to generate all derived properties.")
                        InstructionRow(number: "3", text: "Navigate through the topics to see detailed step-by-step derivations.")
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

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(title)
                .font(.headline)
                .bold()
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
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

// MARK: - Subspace Detail Views

struct ColumnSpaceDetailView: View {
    let title: String
    let originalMatrix: [[Fraction]]
    let pivots: [Int]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.green)
                Spacer()
                CopyButton(latex: generateLatex())
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Computation Steps")
                    .font(.headline)
                
                Text("1. Identify pivot columns in RREF.")
                    .font(.body)
                
                if pivots.isEmpty {
                    Text("No pivots found (Zero Matrix).")
                        .foregroundColor(.secondary)
                } else {
                    let pivotCols = pivots.map { "Col \($0 + 1)" }.joined(separator: ", ")
                    Text("The RREF has pivots in: \(pivotCols).")
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Text("2. Select corresponding columns from A.")
                    .font(.body)
                
                Text("The pivot columns of the original matrix form a basis for C(A).")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !pivots.isEmpty {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(pivots, id: \.self) { colIndex in
                        VStack {
                            Text("Col \(colIndex + 1)")
                                .font(.caption)
                                .bold()
                            
                            let vec = originalMatrix.map { $0[colIndex] }
                            VectorColumnView(vector: vec, color: .green)
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
            } else {
                Text("Basis: { 0 }")
                    .font(.system(.body, design: .monospaced))
                    .padding()
            }
            
            Spacer()
        }
        .padding()
    }
    
    func generateLatex() -> String {
        guard !pivots.isEmpty else { return "C(A) = \\{ \\vec{0} \\}" }
        let basisVecs = pivots.map { col -> String in
            let vec = originalMatrix.map { $0[col] }
            let rows = vec.map { $0.description }.joined(separator: "\\\\")
            return "\\begin{bmatrix} \(rows) \\end{bmatrix}"
        }.joined(separator: ", ")
        return "C(A) = \\text{span} \\left\\{ \(basisVecs) \\right\\}"
    }
}

struct NullSpaceDetailView: View {
    let title: String
    let matrix: [[Fraction]] // RREF
    let pivots: [Int]
    let totalCols: Int
    
    var body: some View {
        let freeIndices = (0..<totalCols).filter { !pivots.contains($0) }
        
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Circle().fill(Color.blue).frame(width: 10, height: 10)
                Text(title).font(.title).bold().foregroundColor(.primary)
                Spacer()
                CopyButton(latex: generateLatex(freeIndices: freeIndices))
            }
            
            // Explanation
            if freeIndices.isEmpty {
                 Text("No free variables. The only solution is the zero vector.")
                    .foregroundColor(.secondary)
            } else {
                 let freeVars = freeIndices.map { "x\(sub: $0 + 1)" }.joined(separator: ", ")
                 Text("Columns \(freeIndices.map { String($0 + 1) }.joined(separator: ", ")) are free variables (\(freeVars)), so the null space basis vectors are found by setting one free variable to 1 (others 0) and solving for the pivot variables.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
            }

            // Computation Flow
            NullSpaceComputationView(rref: matrix, pivots: pivots, totalCols: totalCols, title: "N(A)")
            
            Spacer()
        }
        .padding()
    }
    
    func generateLatex(freeIndices: [Int]) -> String {
        guard !freeIndices.isEmpty else { return "N(A) = \\{ \\vec{0} \\}" }
        let basisVecs = freeIndices.map { freeIdx -> String in
            let rows = (0..<totalCols).map { rowIdx -> String in
                if rowIdx == freeIdx { return "1" }
                if freeIndices.contains(rowIdx) { return "0" }
                if let pivotRank = pivots.firstIndex(of: rowIdx), pivotRank < matrix.count {
                    let val = matrix[pivotRank][freeIdx]
                    return (Fraction(-1) * val).description
                }
                return "0"
            }.joined(separator: "\\\\")
            return "\\begin{bmatrix} \(rows) \\end{bmatrix}"
        }.joined(separator: ", ")
        return "N(A) = \\text{span} \\left\\{ \(basisVecs) \\right\\}"
    }
}

struct RowSpaceDetailView: View {
    let title: String
    let originalMatrix: [[Fraction]]
    
    var body: some View {
        let transposed = MatrixEngine.transpose(originalMatrix)
        let rrefTSteps = MatrixEngine.calculateRREF(matrix: transposed)
        let rrefT = rrefTSteps.last?.matrix ?? []
        let pivotsT = MatrixEngine.getPivotIndices(rref: rrefT)
        
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Circle().fill(Color.orange).frame(width: 10, height: 10)
                Text(title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                Spacer()
                CopyButton(latex: generateLatex(transposed: transposed, pivotsT: pivotsT))
            }
            
            Text("Computation: R(A) = C(Aᵀ)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            RowSpaceComputationView(transposed: transposed, rrefT: rrefT, pivotsT: pivotsT)
            
            Spacer()
        }
        .padding()
    }
    
    func generateLatex(transposed: [[Fraction]], pivotsT: [Int]) -> String {
        guard !pivotsT.isEmpty else { return "C(A^T) = \\{ \\vec{0} \\}" }
        let basisVecs = pivotsT.map { col -> String in
            let vec = transposed.map { $0[col] }
            let rows = vec.map { $0.description }.joined(separator: "\\\\")
            return "\\begin{bmatrix} \(rows) \\end{bmatrix}"
        }.joined(separator: ", ")
        return "C(A^T) = \\text{span} \\left\\{ \(basisVecs) \\right\\}"
    }
}

struct RowSpaceComputationView: View {
    let transposed: [[Fraction]]
    let rrefT: [[Fraction]]
    let pivotsT: [Int]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            // Step 1: Transpose
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 1: Transpose Matrix A")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("The row space of A is the column space of Aᵀ. First, we transpose A.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                SimpleMatrixGrid(matrix: transposed, highlights: [])
                    .padding(.top, 4)
            }
            
            // Step 2: RREF
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 2: RREF(Aᵀ)")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Compute the Reduced Row Echelon Form of Aᵀ to find pivot columns.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                SimpleMatrixGrid(matrix: rrefT, highlights: pivotsT)
                
                Text("Pivots: \(pivotsT.map { "Col \($0+1)" }.joined(separator: ", "))")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            // Step 3: Basis
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 3: Basis Vectors")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("The pivot columns of Aᵀ (which correspond to rows of A) form a basis for the Row Space.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if pivotsT.isEmpty {
                     Text("{ 0 }").font(.title).bold().foregroundColor(.secondary)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(pivotsT, id: \.self) { colIndex in
                                let vec = transposed.map { $0[colIndex] }
                                VectorColumnView(vector: vec, color: .orange)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct SimpleMatrixGrid: View {
    let matrix: [[Fraction]]
    let highlights: [Int]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<matrix.count, id: \.self) { r in
                HStack(spacing: 12) {
                    ForEach(0..<matrix[0].count, id: \.self) { c in
                        Text(c < matrix[r].count ? matrix[r][c].description : "0")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(highlights.contains(c) ? .blue : .primary)
                            .frame(width: 40, height: 30)
                            .background(highlights.contains(c) ? Color.blue.opacity(0.1) : Color.clear)
                            .cornerRadius(4)
                    }
                }
            }
        }
        .padding(12)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct LeftNullSpaceDetailView: View {
    let title: String
    let originalMatrix: [[Fraction]]
    
    var body: some View {
        let transposed = MatrixEngine.transpose(originalMatrix)
        let rrefTSteps = MatrixEngine.calculateRREF(matrix: transposed)
        let rrefT = rrefTSteps.last?.matrix ?? []
        let pivotsT = MatrixEngine.getPivotIndices(rref: rrefT)
        
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Circle().fill(Color.purple).frame(width: 10, height: 10)
                Text(title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                Spacer()
                CopyButton(latex: generateLatex(rrefT: rrefT, pivotsT: pivotsT, totalCols: transposed[0].count))
            }
            
            Text("Computation: N(Aᵀ) is the Null Space of Aᵀ.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            NullSpaceComputationView(rref: rrefT, pivots: pivotsT, totalCols: transposed[0].count, title: "N(Aᵀ)")
            
            Spacer()
        }
        .padding()
    }
    
    func generateLatex(rrefT: [[Fraction]], pivotsT: [Int], totalCols: Int) -> String {
        let freeIndices = (0..<totalCols).filter { !pivotsT.contains($0) }
        guard !freeIndices.isEmpty else { return "N(A^T) = \\{ \\vec{0} \\}" }
        let basisVecs = freeIndices.map { freeIdx -> String in
            let rows = (0..<totalCols).map { rowIdx -> String in
                if rowIdx == freeIdx { return "1" }
                if freeIndices.contains(rowIdx) { return "0" }
                if let pivotRank = pivotsT.firstIndex(of: rowIdx), pivotRank < rrefT.count {
                    let val = rrefT[pivotRank][freeIdx]
                    return (Fraction(-1) * val).description
                }
                return "0"
            }.joined(separator: "\\\\")
            return "\\begin{bmatrix} \(rows) \\end{bmatrix}"
        }.joined(separator: ", ")
        return "N(A^T) = \\text{span} \\left\\{ \(basisVecs) \\right\\}"
    }
}

// MARK: - Helper Views

struct CopyButton: View {
    let latex: String
    @State private var copied = false
    
    var body: some View {
        Button(action: {
            UIPasteboard.general.string = latex
            withAnimation {
                copied = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    copied = false
                }
            }
        }) {
            HStack(spacing: 4) {
                Image(systemName: copied ? "checkmark" : "doc.on.doc")
                Text(copied ? "Copied" : "Copy LaTeX")
            }
            .font(.caption)
            .bold()
            .padding(8)
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }
    }
}



struct VectorColumnView: View {
    let vector: [Fraction]
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<vector.count, id: \.self) { i in
                Text(vector[i].description)
                    .font(.system(.body, design: .monospaced))
                    .frame(width: 30)
            }
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(color, lineWidth: 2))
    }
}

struct NullSpaceComputationView: View {
    let rref: [[Fraction]]
    let pivots: [Int]
    let totalCols: Int
    let title: String
    
    var body: some View {
        let freeIndices = (0..<totalCols).filter { !pivots.contains($0) }
        
        VStack(alignment: .leading, spacing: 32) {
            
            // Step 1: RREF
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 1: Reduced Row Echelon Form")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Identify pivot columns (basic variables) and non-pivot columns (free variables).")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                MatrixWithHeaders(matrix: rref, pivots: pivots, totalCols: totalCols)
                    .padding(.top, 4)
            }
            
            if !freeIndices.isEmpty {
                // Step 2: Parametric Equations
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 2: Parametric Vector Form")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Express the pivot variables in terms of the free variables. Free variables are equal to themselves.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        ParametricVectorBlock(rref: rref, pivots: pivots, freeIndices: freeIndices, totalCols: totalCols)
                    }
                }
                
                // Step 3: Decompose Vectors
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 3: Linear Combination")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Decompose the vector into a linear combination of vectors, one for each free variable.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LinearCombinationBlock(rref: rref, pivots: pivots, freeIndices: freeIndices, totalCols: totalCols)
                    }
                }
                
                // Step 4: Span
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 4: Basis & Span")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("The null space is the span of these basis vectors.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        SpanBlock(rref: rref, pivots: pivots, freeIndices: freeIndices, totalCols: totalCols, title: title)
                    }
                }
                
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Conclusion")
                        .font(.headline)
                    Text("Since there are no free variables, the only solution to Ax = 0 is the trivial solution.")
                        .foregroundColor(.secondary)
                    Text("{ 0 }")
                        .font(.title)
                        .bold()
                        .padding()
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct MatrixWithHeaders: View {
    let matrix: [[Fraction]]
    let pivots: [Int]
    let totalCols: Int
    
    var body: some View {
        VStack(spacing: 4) {
            // Headers
            HStack(spacing: 12) {
                ForEach(0..<totalCols, id: \.self) { c in
                    Text("x\(sub: c + 1)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(width: 40)
                }
            }
            
            // Grid
            VStack(spacing: 8) {
                ForEach(0..<matrix.count, id: \.self) { r in
                    HStack(spacing: 12) {
                        ForEach(0..<totalCols, id: \.self) { c in
                            Text(c < matrix[r].count ? matrix[r][c].description : "0")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(pivots.contains(c) ? .blue : .primary)
                                .frame(width: 40, height: 30)
                                .background(pivots.contains(c) ? Color.blue.opacity(0.1) : Color.clear)
                                .cornerRadius(4)
                        }
                    }
                }
            }
            .padding(12)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            
            // Pivot Indicator
            HStack {
                Text("Pivots: \(pivots.map { "Col \($0+1)" }.joined(separator: ", "))")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
        }
    }
}

struct ParametricVectorBlock: View {
    let rref: [[Fraction]]
    let pivots: [Int]
    let freeIndices: [Int]
    let totalCols: Int
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<totalCols, id: \.self) { rowIdx in
                // Determine content for this row
                let content: String = {
                    if freeIndices.contains(rowIdx) {
                        return "x\(sub: rowIdx + 1)"
                    } else if let pivotRank = pivots.firstIndex(of: rowIdx), pivotRank < rref.count {
                        // -Sum(coeff * free)
                        let terms = freeIndices.compactMap { freeIdx -> String? in
                             let val = rref[pivotRank][freeIdx]
                             if val == .zero { return nil }
                             let coeff = Fraction(-1) * val
                             // Format: -2x2
                             let sign = (coeff.numerator >= 0) ? "+" : "-"
                             let absCoeff = (abs(coeff.numerator) == coeff.denominator) ? "" : "\(abs(coeff.numerator))/\(coeff.denominator)"
                             return "\(sign) \(absCoeff)x\(sub: freeIdx + 1)"
                        }
                        
                        if terms.isEmpty { return "0" }
                        // Join and clean up first plus
                        var str = terms.joined(separator: " ")
                        if str.hasPrefix("+ ") { str.removeFirst(2) }
                        return str
                    } else {
                        return "0"
                    }
                }()
                
                Text(content)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.primary)
                    .padding(.vertical, 4)
                    .frame(minWidth: 60, alignment: .center)
            }
        }
        .padding(12)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
        .overlay(BracketOverlay())
    }
}

struct LinearCombinationBlock: View {
    let rref: [[Fraction]]
    let pivots: [Int]
    let freeIndices: [Int]
    let totalCols: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(freeIndices.enumerated()), id: \.offset) { index, freeIdx in
                if index > 0 {
                    Text("+").foregroundColor(.secondary)
                }
                
                Text("x\(sub: freeIdx + 1)")
                    .foregroundColor(.blue)
                    .bold()
                
                // Vector
                VStack(spacing: 2) {
                    ForEach(0..<totalCols, id: \.self) { rowIdx in
                         Text(getCoeff(for: rowIdx, freeIdx: freeIdx).description)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(rowIdx == freeIdx ? .blue : .primary)
                            .padding(.vertical, 4)
                            .frame(width: 30)
                    }
                }
                .padding(8)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(8)
                .overlay(BracketOverlay())
            }
        }
    }
    
    func getCoeff(for targetVarIdx: Int, freeIdx: Int) -> Fraction {
        if targetVarIdx == freeIdx { return .one }
        if freeIndices.contains(targetVarIdx) { return .zero }
        if let pivotRank = pivots.firstIndex(of: targetVarIdx), pivotRank < rref.count {
            let val = rref[pivotRank][freeIdx]
            return Fraction(-1) * val
        }
        return .zero
    }
}

struct SpanBlock: View {
    let rref: [[Fraction]]
    let pivots: [Int]
    let freeIndices: [Int]
    let totalCols: Int
    let title: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(title) = span").font(.headline).foregroundColor(.primary)
            
            Text("⟨").font(.title).foregroundColor(.secondary)
            
            ForEach(freeIndices, id: \.self) { freeIdx in
                VStack(spacing: 2) {
                    ForEach(0..<totalCols, id: \.self) { rowIdx in
                         Text(getCoeff(for: rowIdx, freeIdx: freeIdx).description)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(rowIdx == freeIdx ? .blue : .primary)
                            .padding(.vertical, 4)
                            .frame(width: 30)
                    }
                }
                .padding(8)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(8)
                .overlay(BracketOverlay())
            }
            
            Text("⟩").font(.title).foregroundColor(.secondary)
        }
    }
    
    func getCoeff(for targetVarIdx: Int, freeIdx: Int) -> Fraction {
        if targetVarIdx == freeIdx { return .one }
        if freeIndices.contains(targetVarIdx) { return .zero }
        if let pivotRank = pivots.firstIndex(of: targetVarIdx), pivotRank < rref.count {
            let val = rref[pivotRank][freeIdx]
            return Fraction(-1) * val
        }
        return .zero
    }
}

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

extension String.StringInterpolation {
    mutating func appendInterpolation(sub value: Int) {
        let subscriptMap: [Int: String] = [
            0: "₀", 1: "₁", 2: "₂", 3: "₃", 4: "₄",
            5: "₅", 6: "₆", 7: "₇", 8: "₈", 9: "₉"
        ]
        let str = String(value)
        let result = str.compactMap { char in
            if let intVal = Int(String(char)) {
                return subscriptMap[intVal]
            }
            return String(char)
        }.joined()
        appendLiteral(result)
    }
}



