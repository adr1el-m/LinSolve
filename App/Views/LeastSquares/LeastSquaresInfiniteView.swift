import SwiftUI

struct LeastSquaresInfiniteView: View {
    @EnvironmentObject var matrixData: MatrixData
    @State private var vectorBValues: [String] = []
    @State private var hasComputed = false
    
    // Inconsistency Check
    @State private var augmentedMatrix: [[Fraction]] = []
    @State private var augmentedRREF: [[Fraction]] = []
    @State private var isInconsistent: Bool = false
    @State private var inconsistencyReason: String = ""
    @State private var isFullColumnRank: Bool = true
    
    // Normal Equations
    @State private var matrixAT: [[Fraction]] = []
    @State private var matrixATA: [[Fraction]] = []
    @State private var matrixATb: [Fraction] = []
    @State private var normalAugmented: [[Fraction]] = []
    @State private var normalRREF: [[Fraction]] = []
    
    // Solution
    @State private var particularSol: [Fraction] = []
    @State private var homogeneousSols: [[Fraction]] = [] // Basis vectors for null space of ATA
    @State private var freeVarIndices: [Int] = []
    @State private var solutionLatex: String = ""
    
    // Error
    @State private var axHat: [Fraction] = []
    @State private var errorVector: [Fraction] = []
    @State private var errorNormString: String = ""
    @State private var errorNormValue: String = ""
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Least Squares with Infinitely Many Solutions")
                    .font(.title2)
                    .bold()
                
                Text("1. Check for inconsistency and column rank.")
                Text("2. If not full column rank, solve AᵀAx̂ = Aᵀb using RREF.")
                Text("3. Express the general solution and find the LS error.")
                    .font(.system(.body, design: .monospaced))
                
                Divider()
                
                // Input Section
                HStack(alignment: .top, spacing: 20) {
                    // Matrix A Display
                    VStack {
                        Text("Matrix A")
                            .font(.headline)
                        MatrixPreviewView(matrix: matrixData.getFractionMatrix())
                    }
                    
                    // Vector b Input
                    VStack {
                        Text("Vector b")
                            .font(.headline)
                        
                        VStack(spacing: 10) {
                            ForEach(0..<matrixData.rows, id: \.self) { r in
                                TextField("b\(r+1)", text: binding(for: r))
                                    .keyboardType(.numbersAndPunctuation)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 60, height: 40)
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                Button(action: compute) {
                    Text("Compute Infinite LS Solution")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if hasComputed {
                    Divider()
                    
                    // Step 1: Inconsistency & Rank Check
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Step 1: Analyze the System")
                            .font(.headline)
                        
                        Text("We first form the augmented matrix [A|b] and compute its RREF to determine if the system is consistent and to find the rank of A.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text("Augmented [A|b] RREF:")
                            MatrixPreviewView(matrix: augmentedRREF)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            if isInconsistent {
                                Text("• The system is INCONSISTENT (pivot in the last column).")
                                    .foregroundColor(.orange)
                                    .bold()
                                Text("  This means no exact solution exists, so we must find a Least Squares solution.")
                                    .font(.caption)
                            } else {
                                Text("• The system is CONSISTENT.")
                                    .foregroundColor(.green)
                                    .bold()
                                Text("  An exact solution exists (Error = 0).")
                                    .font(.caption)
                            }
                            
                            if !isFullColumnRank {
                                Text("• Matrix A does NOT have full column rank.")
                                    .foregroundColor(.blue)
                                    .bold()
                                Text("  The columns of A are linearly dependent (free variables exist).")
                                    .font(.caption)
                                Text("  This implies AᵀA is singular (not invertible).")
                                    .font(.caption)
                                Text("  Therefore, there are INFINITELY MANY least-squares solutions.")
                                    .font(.caption)
                                    .padding(.top, 2)
                            } else {
                                Text("• Matrix A HAS full column rank.")
                                    .foregroundColor(.secondary)
                                Text("  A unique least-squares solution exists.")
                            }
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(10)
                    
                    // Step 2: Normal Equations
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Step 2: Solve Normal Equations")
                            .font(.headline)
                        
                        Text("Since AᵀA is not invertible, we cannot use x̂ = (AᵀA)⁻¹Aᵀb.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        Text("Instead, we solve the system AᵀAx̂ = Aᵀb directly using Gaussian elimination.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        // A^T A
                        HStack {
                            Text("AᵀA =")
                            MatrixPreviewView(matrix: matrixATA)
                        }
                        
                        // A^T b
                        HStack {
                            Text("Aᵀb =")
                            VectorPreviewView(vector: matrixATb)
                        }
                        
                        Text("Form the augmented matrix for the normal equations:")
                            .padding(.top, 5)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            
                        MatrixPreviewView(matrix: normalAugmented)
                        
                        Image(systemName: "arrow.down")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.secondary)
                        
                        Text("Compute RREF of [AᵀA | Aᵀb]:")
                        MatrixPreviewView(matrix: normalRREF)
                        
                        Divider()
                        
                        Text("General Solution Structure")
                            .font(.headline)
                        Text("The general solution is x̂ = x̂_p + x̂_h, where:")
                        Text("• x̂_p is a particular solution (free variables = 0)")
                        Text("• x̂_h is the homogeneous solution (null space of AᵀA)")
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .center, spacing: 8) {
                                Text("x̂ =")
                                    .font(.title2)
                                    .bold()
                                
                                VStack {
                                    VectorPreviewView(vector: particularSol)
                                        .padding(8)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(8)
                                    Text("Particular")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                
                                ForEach(Array(homogeneousSols.enumerated()), id: \.offset) { index, vec in
                                    Text("+")
                                    
                                    let param = (index < 5) ? ["r", "s", "t", "u", "v"][index] : "c\(index)"
                                    Text(param)
                                        .italic()
                                        .font(.title3)
                                    
                                    VStack {
                                        VectorPreviewView(vector: vec)
                                            .padding(8)
                                            .background(Color.orange.opacity(0.1))
                                            .cornerRadius(8)
                                        Text("Null Basis \(index + 1)")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                if !homogeneousSols.isEmpty {
                                    Text(", where parameters ∈ ℝ")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                        }
                        
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(10)
                    
                    // Step 3: Error
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Step 3: Least Squares Error")
                            .font(.headline)
                        
                        Text("The projection p = Ax̂ is unique, even though x̂ is not.")
                            .font(.body)
                        Text("Thus, the error ||b - Ax̂|| is the same for ANY solution in the general set.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("We compute the error using the particular solution x̂_p:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 4)
                        
                        HStack {
                            Text("x̂_p =")
                            VectorPreviewView(vector: particularSol)
                        }
                        
                        HStack {
                            Text("Ax̂_p =")
                            VectorPreviewView(vector: axHat)
                        }
                        
                        HStack {
                            Text("b - Ax̂_p =")
                            VectorPreviewView(vector: errorVector)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Least Squares Error = ||b - Ax̂_p|| =")
                            Text(errorNormString)
                                .font(.system(.title3, design: .serif))
                                .bold()
                            Text("≈ \(errorNormValue)")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            initializeVectorB()
        }
        .onChange(of: matrixData.rows) { _ in
            initializeVectorB()
            hasComputed = false
        }
    }
    
    private func binding(for index: Int) -> Binding<String> {
        return Binding(
            get: {
                if index < vectorBValues.count {
                    return vectorBValues[index]
                }
                return "0"
            },
            set: { newValue in
                if index < vectorBValues.count {
                    vectorBValues[index] = newValue
                }
            }
        )
    }
    
    private func initializeVectorB() {
        if vectorBValues.count != matrixData.rows {
            vectorBValues = Array(repeating: "0", count: matrixData.rows)
        }
    }
    
    private func compute() {
        let matrixA = matrixData.getFractionMatrix()
        let b = vectorBValues.map { Fraction(string: $0) }
        
        // 1. Inconsistency Check (A|b)
        var aug = matrixA
        for i in 0..<aug.count {
            aug[i].append(b[i])
        }
        self.augmentedMatrix = aug
        
        let rrefSteps = MatrixEngine.calculateRREF(matrix: aug)
        if let last = rrefSteps.last {
            self.augmentedRREF = last.matrix
            checkInconsistencyAndRank(rref: last.matrix)
        }
        
        // 2. Normal Equations: A^T A x = A^T b
        let at = MatrixEngine.transpose(matrixA)
        self.matrixAT = at
        
        let ata = MatrixEngine.multiply(matrixA: at, matrixB: matrixA)
        self.matrixATA = ata
        
        let atb = MatrixEngine.multiply(matrix: at, vector: b)
        self.matrixATb = atb
        
        // Solve (ATA)x = ATb
        var normAug = ata
        for i in 0..<normAug.count {
            normAug[i].append(atb[i])
        }
        self.normalAugmented = normAug
        
        let normRrefSteps = MatrixEngine.calculateRREF(matrix: normAug)
        if let last = normRrefSteps.last {
            self.normalRREF = last.matrix
            solveFromRREF(rref: last.matrix)
        }
        
        // 3. Error
        // Use particular solution
        if !particularSol.isEmpty {
            self.axHat = MatrixEngine.multiply(matrix: matrixA, vector: particularSol)
            var err: [Fraction] = []
            for i in 0..<b.count {
                err.append(b[i] - self.axHat[i])
            }
            self.errorVector = err
            self.errorNormString = MatrixEngine.formatNorm(err)
            
            let sq = MatrixEngine.normSquared(err)
            let val = sqrt(sq.asDouble)
            self.errorNormValue = String(format: "%.4f", val)
        }
        
        withAnimation {
            hasComputed = true
        }
    }
    
    private func checkInconsistencyAndRank(rref: [[Fraction]]) {
        let rows = rref.count
        let cols = rref[0].count
        let lastColIndex = cols - 1
        
        var inconsistent = false
        var pivotCols = 0
        
        // Check pivots in A part (0..<lastColIndex)
        // Also check if pivot in lastColIndex (inconsistency)
        
        for r in 0..<rows {
            var foundPivot = false
            for c in 0..<cols {
                if rref[r][c] != .zero {
                    if c == lastColIndex {
                        // Pivot in last column -> Inconsistent
                        inconsistent = true
                    } else {
                        // Pivot in A
                        pivotCols += 1
                    }
                    foundPivot = true
                    break
                }
            }
            if !foundPivot { continue }
        }
        
        self.isInconsistent = inconsistent
        // Full column rank if pivotCols == columns of A
        // columns of A is cols - 1
        self.isFullColumnRank = (pivotCols == (cols - 1))
    }
    
    private func solveFromRREF(rref: [[Fraction]]) {
        let rows = rref.count
        let cols = rref[0].count
        let numVars = cols - 1 // Last col is RHS
        
        // Identify pivots
        var pivotIndices: [Int] = []
        var freeIndices: [Int] = []
        
        // Map row to pivot col
        var rowToPivotCol: [Int: Int] = [:]
        
        for r in 0..<rows {
            for c in 0..<numVars {
                if rref[r][c] != .zero {
                    pivotIndices.append(c)
                    rowToPivotCol[r] = c
                    break
                }
            }
        }
        
        for c in 0..<numVars {
            if !pivotIndices.contains(c) {
                freeIndices.append(c)
            }
        }
        
        self.freeVarIndices = freeIndices
        
        // Particular Solution (set free vars to 0)
        var xp = Array(repeating: Fraction.zero, count: numVars)
        
        // Back substitution for particular
        // x_pivot = rhs - sum(coeff * x_free)
        // If free vars are 0, then x_pivot = rhs (assuming coeff of pivot is 1, which RREF ensures)
        
        for r in (0..<rows).reversed() {
            if let pivotCol = rowToPivotCol[r] {
                let rhs = rref[r][cols-1] // Augmented column value
                xp[pivotCol] = rhs
            }
        }
        self.particularSol = xp
        
        // Homogeneous Solutions (Null Space Basis)
        // For each free variable x_f, create a vector where x_f=1 and other free vars=0
        var homoSols: [[Fraction]] = []
        
        for freeIdx in freeIndices {
            var v = Array(repeating: Fraction.zero, count: numVars)
            v[freeIdx] = Fraction.one
            
            // Solve for pivot variables
            // x_pivot + ... + c * x_free + ... = 0
            // x_pivot = -c * x_free = -c * 1 = -c
            
            for r in (0..<rows).reversed() {
                if let pivotCol = rowToPivotCol[r] {
                    // coeff of freeIdx in this row
                    let coeff = rref[r][freeIdx]
                    v[pivotCol] = Fraction.zero - coeff
                }
            }
            homoSols.append(v)
        }
        self.homogeneousSols = homoSols
        
        // Format LaTeX string
        // x = [xp] + r[v1] + s[v2] ...
        var str = "x̂ = "
        str += vectorToLatex(xp)
        
        let params = ["r", "s", "t", "u", "v"] // Simple parameter names
        
        for (i, h) in homoSols.enumerated() {
            let pName = (i < params.count) ? params[i] : "r_\(i+1)"
            str += " + \(pName)"
            str += vectorToLatex(h)
        }
        
        self.solutionLatex = str
    }
    
    private func vectorToLatex(_ v: [Fraction]) -> String {
        var s = "\\begin{bmatrix} "
        for (i, val) in v.enumerated() {
            s += val.description
            if i < v.count - 1 { s += " \\\\ " }
        }
        s += " \\end{bmatrix}"
        
        // Convert typical latex replacements for display
        s = s.replacingOccurrences(of: "\\begin{bmatrix}", with: "[")
        s = s.replacingOccurrences(of: "\\end{bmatrix}", with: "]")
        s = s.replacingOccurrences(of: " \\\\ ", with: ", ")
        s = s.replacingOccurrences(of: " ", with: "")
        
        // Actually, let's just use the vertical display style logic if I can.
        // But for a single string line, [a, b, c]^T style or vertical block style is hard in simple Text.
        // Let's use a multi-line string approach or just rely on the formatting logic I used in "MatrixPreviewView" but inline?
        // Wait, the "solutionLatex" in my code is displayed in a Text view. 
        // Simple multiline string representation is better for SwiftUI Text.
        
        // Let's retry:
        // [ 1 ]
        // [ 2 ]
        // This is hard to layout inline with "+ r".
        // Better to format as column vectors in a horizontal stack in the View, rather than a single string.
        
        return s
    }
}
