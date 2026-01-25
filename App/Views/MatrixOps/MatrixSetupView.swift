import SwiftUI

/// View for configuring matrix dimensions and entering values
struct MatrixSetupView: View {
    @EnvironmentObject var matrixData: MatrixData
    @Binding var selectedSection: AppSection?
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Configure your matrix A.")
                    .foregroundColor(.secondary)
                
                dimensionsSection
                
                Divider()
                
                matrixGridSection
                
                actionsSection
                
                if matrixData.hasComputed {
                    resultsSection
                }
            }
            .padding(.bottom, 50)
        }
    }
    
    // MARK: - View Components
    
    private var dimensionsSection: some View {
        HStack(spacing: 16) {
            HStack(spacing: 30) {
                    VStack {
                        Text("Rows: \(matrixData.rows)")
                            .font(.headline)
                        Stepper("Number of rows", value: $matrixData.rows, in: 1...10)
                            .labelsHidden()
                            .accessibilityLabel("Rows: \(matrixData.rows)")
                    }
                    VStack {
                        Text("Columns: \(matrixData.cols)")
                            .font(.headline)
                        Stepper("Number of columns", value: $matrixData.cols, in: 1...10)
                            .labelsHidden()
                            .accessibilityLabel("Columns: \(matrixData.cols)")
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
            }
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private var matrixGridSection: some View {
        ScrollView([.horizontal, .vertical]) {
            VStack(spacing: 10) {
                ForEach(0..<matrixData.rows, id: \.self) { row in
                    matrixRow(row: row)
                }
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(12)
        }
    }
    
    private func matrixRow(row: Int) -> some View {
        HStack(spacing: 10) {
            ForEach(0..<matrixData.cols, id: \.self) { col in
                matrixCell(row: row, col: col)
            }
        }
    }
    
    private func matrixCell(row: Int, col: Int) -> some View {
        TextField("0", text: Binding(
            get: { matrixData.values[row][col] },
            set: { validateAndSet($0, row: row, col: col) }
        ))
        .keyboardType(.numbersAndPunctuation)
        .multilineTextAlignment(.center)
        .frame(width: 60, height: 40)
        .background(Color(uiColor: .systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(8)
        .accessibilityLabel("Row \(row + 1), Column \(col + 1)")
        .accessibilityValue(matrixData.values[row][col])
    }
    
    private var actionsSection: some View {
        HStack(spacing: 20) {
                Button(action: { matrixData.compute() }) {
                    Text("Compute")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Button(action: { matrixData.reset() }) {
                    Text("Reset")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                }
            }
    }
    
    private var resultsSection: some View {
        VStack(spacing: 16) {
            Divider()
            
            // Quick Summary Card
            quickSummarySection
            
            rrefASection
            
            rrefATSection
            
            // Eigenanalysis for square matrices
            if matrixData.rows == matrixData.cols {
                eigenSection
            }
            
            // Explore More Section (categorized)
            exploreMoreSection
        }
    }
    
    private var quickSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.doc.horizontal")
                    .foregroundColor(.blue)
                Text("Matrix Properties Summary")
                    .font(.headline)
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                PropertyCard(
                    title: "Size",
                    value: "\(matrixData.rows) × \(matrixData.cols)",
                    icon: "square.grid.3x3",
                    color: .blue
                )
                
                PropertyCard(
                    title: "Rank",
                    value: "\(matrixData.pivots.count)",
                    icon: "number",
                    color: .green
                )
                
                PropertyCard(
                    title: "Nullity",
                    value: "\(matrixData.cols - matrixData.pivots.count)",
                    icon: "circle.dashed",
                    color: .orange
                )
                
                if matrixData.rows == matrixData.cols {
                    PropertyCard(
                        title: "Determinant",
                        value: matrixData.determinantValue?.description ?? "N/A",
                        icon: "sum",
                        color: .purple
                    )
                } else {
                    PropertyCard(
                        title: "Type",
                        value: matrixData.rows > matrixData.cols ? "Tall" : "Wide",
                        icon: "rectangle.portrait.and.arrow.right",
                        color: .gray
                    )
                }
            }
            
            // Rank-Nullity verification
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                Text("Rank-Nullity Theorem: \(matrixData.pivots.count) + \(matrixData.cols - matrixData.pivots.count) = \(matrixData.cols) ✓")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var rrefASection: some View {
        VStack(alignment: .leading, spacing: 10) {
                    Text("RREF Process (A)")
                        .font(.headline)
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 0) {
                            ForEach(matrixData.rrefSteps) { step in StepView(step: step) }
                        }
                        .padding()
                    }
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
        }
    }
    
    private var rrefATSection: some View {
        VStack(alignment: .leading, spacing: 10) {
                    Text("RREF Process (Aᵀ)")
                        .font(.headline)
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 0) {
                            ForEach(matrixData.rrefTSteps) { step in StepView(step: step) }
                        }
                        .padding()
                    }
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
        }
    }
    
    private var fundamentalSubspacesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
                    Text("Fundamental Subspaces")
                        .font(.title2)
                        .bold()
                    
                    SubspaceSummaryRow(title: "Column Space C(A)", basis: matrixData.columnSpace, action: { selectedSection = .columnSpace })
                    SubspaceSummaryRow(title: "Null Space N(A)", basis: matrixData.nullSpace, action: { selectedSection = .nullSpace })
                    SubspaceSummaryRow(title: "Row Space C(Aᵀ)", basis: matrixData.rowSpace, action: { selectedSection = .rowSpace })
                    SubspaceSummaryRow(title: "Left Null Space N(Aᵀ)", basis: matrixData.leftNullSpace, action: { selectedSection = .leftNullSpace })
            
            if matrixData.rows == matrixData.cols {
                squareMatrixSection
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var squareMatrixSection: some View {
        Group {
            Divider()
            
            inverseSection
            
            Divider()
            
            determinantSection
        }
    }
    
    private var inverseSection: some View {
        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Matrix Inverse A⁻¹")
                                    .font(.headline)
                                Spacer()
                                Button(action: { selectedSection = .inverse }) {
                                    Text("See Steps")
                                        .font(.caption)
                                        .bold()
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
                            
                            Text("Calculated via Gauss-Jordan Elimination")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
    }
    
    private var determinantSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Determinant |A|")
                    .font(.headline)
                if let det = matrixData.determinantValue {
                    Text("Result: \(det.description)")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.primary)
                }
                Text("Calculated via Cofactor Expansion / Sarrus")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: { selectedSection = .determinant }) {
                Text("See Steps")
                    .font(.caption)
                    .bold()
                    .padding(6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var eigenSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "function")
                    .foregroundColor(.purple)
                Text("Eigenanalysis")
                    .font(.headline)
            }
            
            if matrixData.rows <= 3 {
                // Compute eigenvalues for display
                let eigenResult = MatrixEngine.calculateCharacteristicPolynomialDetailed(matrix: matrixData.getFractionMatrix())
                
                if eigenResult.roots.isEmpty {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.orange)
                        Text("No real eigenvalues (complex roots)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Eigenvalues:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 12) {
                            ForEach(Array(eigenResult.roots.enumerated()), id: \.offset) { index, root in
                                VStack {
                                    Text("λ\(index + 1)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(formatEigenvalue(root))
                                        .font(.system(.body, design: .monospaced))
                                        .bold()
                                        .foregroundColor(.purple)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.purple.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                
                HStack(spacing: 12) {
                    Button(action: { selectedSection = .eigenvalues }) {
                        HStack {
                            Image(systemName: "arrow.right.circle")
                            Text("Eigenvalues")
                        }
                        .font(.caption)
                        .bold()
                        .padding(8)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(6)
                    }
                    
                    Button(action: { selectedSection = .eigenvectors }) {
                        HStack {
                            Image(systemName: "arrow.right.circle")
                            Text("Eigenvectors")
                        }
                        .font(.caption)
                        .bold()
                        .padding(8)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(6)
                    }
                    
                    Button(action: { selectedSection = .diagonalization }) {
                        HStack {
                            Image(systemName: "arrow.right.circle")
                            Text("Diagonalization")
                        }
                        .font(.caption)
                        .bold()
                        .padding(8)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(6)
                    }
                }
                .padding(.top, 4)
            } else {
                Text("Eigenanalysis available for matrices up to 3×3")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var exploreMoreSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.orange)
                Text("Explore More with This Matrix")
                    .font(.headline)
            }
            
            Text("Your matrix is saved. Navigate to any topic to see step-by-step computations using your matrix A.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Fundamental Subspaces Category
            ExploreCategoryView(
                title: "Fundamental Subspaces",
                icon: "square.stack.3d.up",
                color: .green,
                buttons: [
                    ("Column Space C(A)", "arrow.up.right.square", AppSection.columnSpace),
                    ("Null Space N(A)", "circle.dashed", AppSection.nullSpace),
                    ("Row Space C(Aᵀ)", "tablecells", AppSection.rowSpace),
                    ("Left Null N(Aᵀ)", "arrow.uturn.left.square", AppSection.leftNullSpace)
                ],
                selectedSection: $selectedSection
            )
            
            // Square Matrix Operations (only for square matrices)
            if matrixData.rows == matrixData.cols {
                ExploreCategoryView(
                    title: "Square Matrix Operations",
                    icon: "square.fill",
                    color: .blue,
                    buttons: [
                        ("Inverse A⁻¹", "arrow.uturn.backward", AppSection.inverse),
                        ("Determinant", "sum", AppSection.determinant),
                        ("Cofactor Expansion", "rectangle.split.3x3", AppSection.cofactorExpansionMethod),
                        ("Cramer's Rule", "equal.square", AppSection.cramersRule)
                    ],
                    selectedSection: $selectedSection
                )
            }
            
            // Matrix Operations Category
            ExploreCategoryView(
                title: "Matrix Operations",
                icon: "square.grid.3x3",
                color: .purple,
                buttons: [
                    ("Transpose Aᵀ", "arrow.up.arrow.down", AppSection.transposeOperations),
                    ("Matrix Powers", "multiply.square", AppSection.matrixExponents),
                    ("Special Types", "star.square", AppSection.specialMatrixTypes),
                    ("Rank & Nullity", "number.square", AppSection.rankNullity)
                ],
                selectedSection: $selectedSection
            )
            
            // Visualization Category
            ExploreCategoryView(
                title: "Visualization & Tools",
                icon: "eye",
                color: .orange,
                buttons: [
                    ("3D Vectors", "cube.transparent", AppSection.geometric),
                    ("2D Transform", "arrow.up.left.and.arrow.down.right", AppSection.transformation2D),
                    ("Export PDF", "doc.richtext", AppSection.pdfExport)
                ],
                selectedSection: $selectedSection
            )
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private func formatEigenvalue(_ val: Double) -> String {
        if abs(val - round(val)) < 1e-9 {
            return "\(Int(round(val)))"
        }
        return String(format: "%.3f", val)
    }
    
    // MARK: - Private Methods
    
    /// Validates input and sets matrix value
    /// - Parameters:
    ///   - value: Input string to validate
    ///   - row: Row index
    ///   - col: Column index
    private func validateAndSet(_ value: String, row: Int, col: Int) {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        
        // Allow empty, numbers, fractions, and negative signs
        if trimmed.isEmpty || isValidMatrixEntry(trimmed) {
            matrixData.values[row][col] = trimmed
            showError = false
        } else {
            errorMessage = "Invalid input. Use numbers, fractions (e.g., 1/2), or decimals."
            showError = true
        }
    }
    
    /// Validates if a string is a valid matrix entry
    /// - Parameter value: String to validate
    /// - Returns: True if valid
    private func isValidMatrixEntry(_ value: String) -> Bool {
        // Check for valid number, fraction, or decimal
        if Int(value) != nil || Double(value) != nil {
            return true
        }
        
        // Check for fraction format
        let parts = value.components(separatedBy: "/")
        if parts.count == 2,
           Int(parts[0]) != nil,
           let denominator = Int(parts[1]),
           denominator != 0 {
            return true
        }
        
        return false
    }
}

// MARK: - Supporting Views

struct PropertyCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(color)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.system(.title3, design: .monospaced))
                .bold()
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

struct ExploreButton: View {
    let title: String
    let icon: String
    let section: AppSection
    @Binding var selectedSection: AppSection?
    
    var body: some View {
        Button(action: { selectedSection = section }) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(10)
        }
    }
}

struct ExploreCategoryView: View {
    let title: String
    let icon: String
    let color: Color
    let buttons: [(String, String, AppSection)]
    @Binding var selectedSection: AppSection?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(color)
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(buttons, id: \.0) { button in
                    Button(action: { selectedSection = button.2 }) {
                        HStack(spacing: 8) {
                            Image(systemName: button.1)
                                .font(.caption)
                                .foregroundColor(color)
                                .frame(width: 20)
                            Text(button.0)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .background(color.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(12)
    }
}
