import SwiftUI

struct OrthogonalDiagonalizationView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "square.on.square.dashed")
                            .font(.largeTitle)
                            .foregroundColor(.indigo)
                        Text("Orthogonal Diagonalization")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Symmetric Matrices and Their Special Properties")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Introduction
                VStack(alignment: .leading, spacing: 16) {
                    Text("What is Orthogonal Diagonalization?")
                        .font(.headline)
                    
                    Text("Orthogonal diagonalization is a special type of diagonalization that applies to symmetric matrices. A matrix A can be orthogonally diagonalized if there exists an orthogonal matrix Q such that:")
                        .font(.body)
                    
                    Text("A = QDQᵀ")
                        .font(.system(.title2, design: .monospaced))
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.indigo.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text("where D is diagonal and Q is orthogonal (meaning Qᵀ = Q⁻¹).")
                        .font(.body)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Key Concepts
                VStack(alignment: .leading, spacing: 16) {
                    Text("Key Concepts")
                        .font(.headline)
                    
                    // Symmetric Matrix
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "arrow.left.and.right")
                                .foregroundColor(.blue)
                            Text("Symmetric Matrix")
                                .font(.subheadline)
                                .bold()
                        }
                        
                        Text("A = Aᵀ")
                            .font(.system(.body, design: .monospaced))
                            .padding(8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(6)
                        
                        Text("A matrix where the entry at row i, column j equals the entry at row j, column i. The matrix is \"symmetric\" about its main diagonal.")
                            .font(.caption)
                    }
                    
                    // Orthogonal Matrix
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(.purple)
                            Text("Orthogonal Matrix")
                                .font(.subheadline)
                                .bold()
                        }
                        
                        Text("QᵀQ = QQᵀ = I")
                            .font(.system(.body, design: .monospaced))
                            .padding(8)
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(6)
                        
                        Text("A square matrix whose columns (and rows) form an orthonormal set. The inverse equals the transpose: Q⁻¹ = Qᵀ")
                            .font(.caption)
                    }
                    
                    // Orthonormal Set
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "line.3.crossed.swirl.circle")
                                .foregroundColor(.green)
                            Text("Orthonormal Set")
                                .font(.subheadline)
                                .bold()
                        }
                        
                        Text("A set of vectors where each vector has length 1 (normalized) and any two distinct vectors are perpendicular (orthogonal): vᵢ · vⱼ = 0 for i ≠ j")
                            .font(.caption)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // The Spectral Theorem
                VStack(alignment: .leading, spacing: 16) {
                    Text("🌟 The Spectral Theorem")
                        .font(.headline)
                    
                    Text("This is one of the most beautiful results in linear algebra:")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("A matrix A is orthogonally diagonalizable if and only if A is symmetric.")
                            .font(.body)
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.indigo.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("This means:")
                            .font(.subheadline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top) {
                                Image(systemName: "1.circle.fill")
                                    .foregroundColor(.indigo)
                                Text("Every symmetric matrix has all REAL eigenvalues")
                            }
                            HStack(alignment: .top) {
                                Image(systemName: "2.circle.fill")
                                    .foregroundColor(.indigo)
                                Text("Eigenvectors from different eigenspaces are orthogonal")
                            }
                            HStack(alignment: .top) {
                                Image(systemName: "3.circle.fill")
                                    .foregroundColor(.indigo)
                                Text("We can always find an orthonormal basis of eigenvectors")
                            }
                        }
                        .font(.body)
                    }
                }
                .padding()
                .background(Color.indigo.opacity(0.05))
                .cornerRadius(12)
                
                // Tab Selection for Examples
                Picker("Example", selection: $selectedTab) {
                    Text("Symmetry Check").tag(0)
                    Text("Eigenvector Orthogonality").tag(1)
                    Text("Full Diagonalization").tag(2)
                }
                .pickerStyle(.segmented)
                
                // Examples
                switch selectedTab {
                case 0:
                    SymmetryCheckExample()
                case 1:
                    EigenvectorOrthogonalityExample()
                case 2:
                    FullDiagonalizationExample()
                default:
                    EmptyView()
                }
                
                // Process Summary
                VStack(alignment: .leading, spacing: 16) {
                    Text("📋 Orthogonal Diagonalization Process")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        ProcessStepView(step: 1, title: "Check Symmetry", text: "Verify that A = Aᵀ. If not symmetric, A cannot be orthogonally diagonalized.", color: .indigo)
                        
                        ProcessStepView(step: 2, title: "Find Eigenvalues", text: "Solve det(A - λI) = 0. For symmetric matrices, all eigenvalues are real.", color: .indigo)
                        
                        ProcessStepView(step: 3, title: "Find Eigenvectors", text: "For each eigenvalue, find a basis for the eigenspace by solving (A - λI)x = 0.", color: .indigo)
                        
                        ProcessStepView(step: 4, title: "Orthogonalize (if needed)", text: "Within each eigenspace, use Gram-Schmidt to get orthonormal eigenvectors.", color: .indigo)
                        
                        ProcessStepView(step: 5, title: "Form Q and D", text: "Q = matrix with orthonormal eigenvectors as columns. D = diagonal matrix with eigenvalues.", color: .indigo)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Symmetry Check Example (Example 344)

struct SymmetryCheckExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Checking for Symmetry")
                .font(.headline)
            
            Text("Determine if the following matrix is symmetric (and thus orthogonally diagonalizable):")
                .font(.body)
            
            Text("""
                    ┌ 1   2 ┐
                A = │       │
                    └ 0  -1 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Step 1: Compute the Transpose")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("To find Aᵀ, swap rows and columns:")
                    .font(.body)
                
                Text("""
                     ┌ 1   0 ┐
                Aᵀ = │       │
                     └ 2  -1 ┘
                """)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                Text("Step 2: Compare A and Aᵀ")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                HStack(spacing: 40) {
                    VStack {
                        Text("A")
                            .font(.headline)
                        Text("┌ 1   2 ┐")
                            .font(.system(.caption, design: .monospaced))
                        Text("└ 0  -1 ┘")
                            .font(.system(.caption, design: .monospaced))
                    }
                    
                    Text("vs")
                        .font(.headline)
                    
                    VStack {
                        Text("Aᵀ")
                            .font(.headline)
                        Text("┌ 1   0 ┐")
                            .font(.system(.caption, design: .monospaced))
                        Text("└ 2  -1 ┘")
                            .font(.system(.caption, design: .monospaced))
                    }
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
                
                Text("Step 3: Conclusion")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Looking at position (1,2):")
                        .font(.body)
                    Text("• In A: a₁₂ = 2")
                        .font(.caption)
                    Text("• In Aᵀ: (aᵀ)₁₂ = 0")
                        .font(.caption)
                    Text("These are NOT equal, so A ≠ Aᵀ")
                        .font(.body)
                        .foregroundColor(.red)
                }
                
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    Text("A is NOT symmetric, so it is NOT orthogonally diagonalizable")
                        .font(.body)
                        .bold()
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
                
                // Important note
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                        Text("Note")
                            .font(.subheadline)
                            .bold()
                    }
                    
                    Text("This matrix may still be diagonalizable (in the regular sense), just not ORTHOGONALLY diagonalizable. The Spectral Theorem specifically applies to symmetric matrices.")
                        .font(.caption)
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

// MARK: - Eigenvector Orthogonality Example (Example 346)

struct EigenvectorOrthogonalityExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Eigenvector Orthogonality")
                .font(.headline)
            
            Text("For the symmetric matrix A, verify that eigenvectors from different eigenspaces are orthogonal:")
                .font(.body)
            
            Text("""
                    ┌ 3  0  3 ┐
                A = │ 0  3  0 │
                    └ 3  0  3 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Step 1: Verify Symmetry")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("A = Aᵀ ✓ (you can verify by checking a₁₃ = a₃₁ = 3, etc.)")
                    .font(.body)
                    .foregroundColor(.green)
                
                Text("Step 2: Find Eigenvalues")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Solving det(A - λI) = 0 gives:")
                    .font(.body)
                
                Text("σ(A) = {0, 3, 6}")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(6)
                
                Text("Three distinct real eigenvalues (as guaranteed for symmetric matrices).")
                    .font(.caption)
                
                Text("Step 3: Find Eigenvectors")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("For λ = 0:")
                            .font(.subheadline)
                            .bold()
                        Text("v₁ = [-1, 0, 1]ᵀ")
                            .font(.system(.body, design: .monospaced))
                    }
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("For λ = 3:")
                            .font(.subheadline)
                            .bold()
                        Text("v₂ = [0, 1, 0]ᵀ")
                            .font(.system(.body, design: .monospaced))
                    }
                    .padding(8)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(6)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("For λ = 6:")
                            .font(.subheadline)
                            .bold()
                        Text("v₃ = [1, 0, 1]ᵀ")
                            .font(.system(.body, design: .monospaced))
                    }
                    .padding(8)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(6)
                }
                
                Text("Step 4: Verify Orthogonality")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Two vectors are orthogonal if their dot product is zero:")
                    .font(.body)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("v₁ · v₂ = (-1)(0) + (0)(1) + (1)(0) = 0")
                            .font(.system(.caption, design: .monospaced))
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("v₁ · v₃ = (-1)(1) + (0)(0) + (1)(1) = -1 + 1 = 0")
                            .font(.system(.caption, design: .monospaced))
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("v₂ · v₃ = (0)(1) + (1)(0) + (0)(1) = 0")
                            .font(.system(.caption, design: .monospaced))
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    Text("All pairs of distinct eigenvectors are orthogonal!")
                        .font(.body)
                        .bold()
                }
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
                
                // Why this matters
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                        Text("Why This Matters")
                            .font(.subheadline)
                            .bold()
                    }
                    
                    Text("This is a consequence of the Spectral Theorem! For symmetric matrices, eigenvectors corresponding to DIFFERENT eigenvalues are AUTOMATICALLY orthogonal. You don't need to construct them that way—it's a guaranteed property.")
                        .font(.caption)
                }
                .padding()
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Full Diagonalization Example

struct FullDiagonalizationExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Complete Orthogonal Diagonalization")
                .font(.headline)
            
            Text("Orthogonally diagonalize the symmetric matrix:")
                .font(.body)
            
            Text("""
                    ┌ 3  0  3 ┐
                A = │ 0  3  0 │
                    └ 3  0  3 ┘
            """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("We know: λ₁ = 0, λ₂ = 3, λ₃ = 6")
                    .font(.body)
                
                Text("Step 1: Normalize the Eigenvectors")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("To form an orthonormal basis, we need unit vectors:")
                    .font(.body)
                
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("For v₁ = [-1, 0, 1]ᵀ:")
                            .font(.caption)
                            .bold()
                        Text("||v₁|| = √(1 + 0 + 1) = √2")
                            .font(.system(.caption, design: .monospaced))
                        Text("q₁ = v₁/||v₁|| = [-1/√2, 0, 1/√2]ᵀ")
                            .font(.system(.caption, design: .monospaced))
                    }
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("For v₂ = [0, 1, 0]ᵀ:")
                            .font(.caption)
                            .bold()
                        Text("||v₂|| = 1 (already unit)")
                            .font(.system(.caption, design: .monospaced))
                        Text("q₂ = [0, 1, 0]ᵀ")
                            .font(.system(.caption, design: .monospaced))
                    }
                    .padding(8)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(6)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("For v₃ = [1, 0, 1]ᵀ:")
                            .font(.caption)
                            .bold()
                        Text("||v₃|| = √(1 + 0 + 1) = √2")
                            .font(.system(.caption, design: .monospaced))
                        Text("q₃ = v₃/||v₃|| = [1/√2, 0, 1/√2]ᵀ")
                            .font(.system(.caption, design: .monospaced))
                    }
                    .padding(8)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(6)
                }
                
                Text("Step 2: Form Q and D")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Q (orthonormal eigenvectors as columns):")
                        .font(.caption)
                        .bold()
                    
                    Text("""
                            ┌ -1/√2   0   1/√2 ┐
                        Q = │   0     1    0   │
                            └  1/√2   0   1/√2 ┘
                    """)
                        .font(.system(.caption, design: .monospaced))
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("D (eigenvalues on diagonal):")
                        .font(.caption)
                        .bold()
                    
                    Text("""
                            ┌ 0  0  0 ┐
                        D = │ 0  3  0 │
                            └ 0  0  6 ┘
                    """)
                        .font(.system(.caption, design: .monospaced))
                }
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(8)
                
                Text("Step 3: The Diagonalization")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("A = QDQᵀ")
                    .font(.system(.title3, design: .monospaced))
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
                
                Text("Or equivalently: D = QᵀAQ")
                    .font(.body)
                
                // Verification note
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                        Text("Verification")
                            .font(.subheadline)
                            .bold()
                    }
                    
                    Text("You can verify QᵀQ = I (orthogonality) and QDQᵀ = A by multiplying the matrices.")
                        .font(.caption)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Interactive Symmetry Checker

struct SymmetryChecker: View {
    @Binding var matrix: [[String]]
    @Binding var showResult: Bool
    
    var m: [[Double]] {
        matrix.map { row in row.map { Double($0) ?? 0 } }
    }
    
    var isSymmetric: Bool {
        for i in 0..<matrix.count {
            for j in 0..<matrix.count {
                if abs(m[i][j] - m[j][i]) > 0.0001 {
                    return false
                }
            }
        }
        return true
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🧮 Symmetry Checker")
                .font(.headline)
            
            Text("Enter a matrix to check if it's symmetric:")
                .font(.body)
            
            VStack(spacing: 6) {
                ForEach(0..<matrix.count, id: \.self) { row in
                    HStack(spacing: 6) {
                        ForEach(0..<matrix.count, id: \.self) { col in
                            TextField("0", text: $matrix[row][col])
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.center)
                                .frame(width: 50, height: 40)
                                .background(Color(uiColor: .systemBackground))
                                .cornerRadius(6)
                                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.indigo.opacity(0.3)))
                        }
                    }
                }
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(10)
            
            Button(action: { showResult.toggle() }) {
                HStack {
                    Image(systemName: showResult ? "eye.slash" : "eye")
                    Text(showResult ? "Hide Result" : "Check Symmetry")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.indigo)
                .cornerRadius(10)
            }
            
            if showResult {
                HStack {
                    Image(systemName: isSymmetric ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isSymmetric ? .green : .red)
                    Text(isSymmetric ? "Matrix IS symmetric (A = Aᵀ)" : "Matrix is NOT symmetric")
                        .font(.body)
                        .bold()
                }
                .padding()
                .background(isSymmetric ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                .cornerRadius(8)
                
                if isSymmetric {
                    Text("This matrix can be orthogonally diagonalized!")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Text("This matrix cannot be orthogonally diagonalized.")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}
