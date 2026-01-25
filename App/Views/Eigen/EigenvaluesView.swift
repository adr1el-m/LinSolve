import SwiftUI

struct EigenvaluesView: View {
    @EnvironmentObject var matrixData: MatrixData
    @State private var steps: [MatrixEngine.EigenStep] = []
    @State private var roots: [Double] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with beginner-friendly explanation
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "function")
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                        Text("Finding Eigenvalues")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("The Characteristic Polynomial Method")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("What is an Eigenvalue?")
                        .font(.headline)
                    
                    Text("""
**Eigenvalues** are special numbers associated with a matrix. When a matrix A multiplies certain vectors (called eigenvectors), it simply **scales** those vectors without changing their direction. The scaling factor is the eigenvalue.

**In symbols:** If Av = λv, then:
• **v** is an eigenvector
• **λ** (lambda) is the corresponding eigenvalue

**Why do eigenvalues matter?**
• They reveal the "natural frequencies" of a system
• They determine if a matrix is invertible (no zero eigenvalue = invertible)
• They're essential for diagonalization, stability analysis, and PCA
• Every vibrating system, from bridges to molecules, has eigenvalues
""")
                        .font(.body)
                    
                    // How to find them
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How to Find Eigenvalues")
                            .font(.subheadline)
                            .bold()
                        
                        Text("""
1. Form the matrix **(λI − A)** where I is the identity matrix and λ is unknown
2. Compute the **characteristic polynomial**: det(λI − A)
3. Set the polynomial equal to zero and **solve for λ**
4. The solutions are the eigenvalues!
""")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                if matrixData.rows != matrixData.cols {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                        Text("Eigenvalues are only defined for **square matrices**.\n\nPlease set up a square matrix (same number of rows and columns) in the Matrix Calculator.")
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                } else if matrixData.rows > 3 {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                        Text("Step-by-step visualization is available for 2×2 and 3×3 matrices.\n\nFor larger matrices, the characteristic polynomial becomes too complex for hand calculation.")
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                } else {
                    // Steps
                    ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                        EigenStepCard(step: step, index: index)
                    }
                    
                    // Roots Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Eigenvalues (Spectrum)")
                            .font(.headline)
                        
                        if roots.isEmpty {
                            if steps.isEmpty {
                                Text("Calculating...")
                            } else {
                                VStack(spacing: 8) {
                                    Text("No real eigenvalues found.")
                                        .foregroundColor(.secondary)
                                    Text("This matrix may have complex eigenvalues (involving √-1).")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("The eigenvalues are the values of λ that satisfy the characteristic equation:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                HStack(spacing: 20) {
                                    ForEach(Array(roots.enumerated()), id: \.offset) { index, root in
                                        VStack {
                                            Text("λ\(index + 1) = \(formatRoot(root))")
                                                .font(.title2)
                                                .bold()
                                                .foregroundColor(.purple)
                                        }
                                        .padding()
                                        .frame(minWidth: 80)
                                        .background(Color(uiColor: .systemBackground))
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                                    }
                                }
                                
                                Text("Next step: Find the eigenvectors for each eigenvalue in the Eigenvectors section!")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                }
            }
            .padding()
            .padding(.bottom, 40)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            calculate()
        }
        .onChange(of: matrixData.values) { _ in
            calculate()
        }
    }
    
    func calculate() {
        let res = MatrixEngine.calculateCharacteristicPolynomialDetailed(matrix: matrixData.getFractionMatrix())
        steps = res.steps
        roots = res.roots
    }
    
    func formatRoot(_ val: Double) -> String {
        if abs(val - round(val)) < 1e-9 {
            return "\(Int(round(val)))"
        }
        return String(format: "%.2f", val)
    }
}

struct EigenStepCard: View {
    let step: MatrixEngine.EigenStep
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(step.title)
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Text("Step \(index + 1)")
                    .font(.caption)
                    .padding(4)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Text(step.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            if !step.latex.isEmpty {
                Divider()
                MathText(latex: step.latex)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct MathText: View {
    let latex: String
    
    var body: some View {
        if latex.contains("\\begin{bmatrix}") || latex.contains("\\begin{vmatrix}") {
            // Complex layout with matrix
            let parts = parseLatex(latex)
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0..<parts.count, id: \.self) { i in
                    let part = parts[i]
                    if part.isMatrix {
                        PolynomialMatrixView(rows: part.matrixRows, style: part.style)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        if !part.text.trimmingCharacters(in: .whitespaces).isEmpty {
                            Text(formatMath(part.text))
                                .font(.system(.body, design: .serif))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding(12)
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(12)
        } else {
            // Simple inline math
            Text(formatMath(latex))
                .font(.system(.body, design: .serif))
                .multilineTextAlignment(.leading)
                .padding(12)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(12)
        }
    }
    
    struct MathPart {
        let isMatrix: Bool
        let text: String
        let matrixRows: [[String]]
        let style: PolynomialMatrixView.MatrixStyle
    }
    
    func parseLatex(_ latex: String) -> [MathPart] {
        var parts: [MathPart] = []
        
        // We scan the string and look for matrix blocks
        // Simple parser assuming non-nested matrices for this specific use case
        
        let scanner = Scanner(string: latex)
        scanner.charactersToBeSkipped = nil
        
        while !scanner.isAtEnd {
            // Check for matrix start
            if let matrixStart = scanForMatrixStart(scanner) {
                // We found a matrix start
                let style = matrixStart.style
                let endTag = matrixStart.endTag
                
                // Scan until end tag
                if let matrixContent = scanner.scanUpToString(endTag) {
                    let rows = parseMatrixContent(matrixContent)
                    parts.append(MathPart(isMatrix: true, text: "", matrixRows: rows, style: style))
                    _ = scanner.scanString(endTag) // Consume end tag
                }
            } else {
                // Scan text until next matrix start or end of string
                // We need to find the next occurrence of \begin{bmatrix} or \begin{vmatrix}
                // Scanner doesn't have "scanUpToAny", so we do it manually or simply scan up to \begin
                
                if let text = scanner.scanUpToString("\\begin{") {
                    parts.append(MathPart(isMatrix: false, text: text, matrixRows: [], style: .brackets))
                } else {
                    // Rest of the string
                    if let text = scanner.scanUpToCharacters(from: .newlines) { // fallback
                         parts.append(MathPart(isMatrix: false, text: text, matrixRows: [], style: .brackets))
                    } else {
                         // consume remaining if any
                         let remaining = String(latex[scanner.currentIndex...])
                         if !remaining.isEmpty {
                             parts.append(MathPart(isMatrix: false, text: remaining, matrixRows: [], style: .brackets))
                             scanner.currentIndex = latex.endIndex // move to end
                         }
                    }
                }
            }
        }
        
        return parts
    }
    
    struct MatrixStartInfo {
        let style: PolynomialMatrixView.MatrixStyle
        let endTag: String
    }
    
    func scanForMatrixStart(_ scanner: Scanner) -> MatrixStartInfo? {
        let location = scanner.currentIndex
        
        if scanner.scanString("\\begin{bmatrix}") != nil {
            return MatrixStartInfo(style: .brackets, endTag: "\\end{bmatrix}")
        }
        
        scanner.currentIndex = location // reset if failed
        
        if scanner.scanString("\\begin{vmatrix}") != nil {
            return MatrixStartInfo(style: .bars, endTag: "\\end{vmatrix}")
        }
        
        scanner.currentIndex = location // reset
        return nil
    }
    
    func parseMatrixContent(_ content: String) -> [[String]] {
        // Split by row delimiter \\
        // Note: Logic might be fragile if \\ is used elsewhere, but for this app it's fine
        let rows = content.components(separatedBy: "\\\\")
        return rows.map { row in
            row.components(separatedBy: "&").map { $0.trimmingCharacters(in: .whitespaces) }
        }
    }
    
    func formatMath(_ latex: String) -> String {
        return MatrixEngine.formatLatex(latex)
    }
}

struct PolynomialMatrixView: View {
    let rows: [[String]]
    var style: MatrixStyle = .brackets
    
    enum MatrixStyle {
        case brackets
        case bars
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text(style == .brackets ? "[" : "|")
                .font(.system(size: 60, weight: .ultraLight))
                .scaleEffect(y: 1.2)
                .foregroundColor(.primary)
            
            if #available(iOS 16.0, macOS 13.0, *) {
                Grid(horizontalSpacing: 20, verticalSpacing: 10) {
                    ForEach(0..<rows.count, id: \.self) { r in
                        GridRow {
                            ForEach(0..<rows[r].count, id: \.self) { c in
                                Text(formatCell(rows[r][c]))
                                    .font(.system(.body, design: .monospaced))
                                    .minimumScaleFactor(0.4)
                                    .lineLimit(1)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                    .gridColumnAlignment(.center)
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
            } else {
                // Fallback for older versions
                VStack(spacing: 10) {
                    ForEach(0..<rows.count, id: \.self) { r in
                        HStack(spacing: 20) {
                            ForEach(0..<rows[r].count, id: \.self) { c in
                                Text(formatCell(rows[r][c]))
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                    .frame(minWidth: 40) // Attempt to align by minWidth
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            
            Text(style == .brackets ? "]" : "|")
                .font(.system(size: 60, weight: .ultraLight))
                .scaleEffect(y: 1.2)
                .foregroundColor(.primary)
        }
    }
    
    func formatCell(_ text: String) -> String {
        return MatrixEngine.formatLatex(text)
    }
}
