import SwiftUI

struct LeastSquaresInconsistentView: View {
    @EnvironmentObject var matrixData: MatrixData
    @State private var vectorBValues: [String] = []
    @State private var hasComputed = false
    
    // Results
    @State private var augmentedMatrix: [[Fraction]] = []
    @State private var augmentedRREF: [[Fraction]] = []
    @State private var isInconsistent: Bool = false
    @State private var inconsistencyReason: String = ""
    
    // LS Steps
    @State private var matrixAT: [[Fraction]] = []
    @State private var matrixATA: [[Fraction]] = []
    @State private var matrixATAInv: [[Fraction]]? = nil
    @State private var matrixATb: [Fraction] = []
    @State private var resultX: [Fraction] = []
    
    // LS Error
    @State private var axHat: [Fraction] = []
    @State private var errorVector: [Fraction] = []
    @State private var errorNormString: String = ""
    @State private var errorNormValue: String = ""
    
    // Geometric Interpretation
    @State private var orthogonalityCheck: [Fraction] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Least Squares Solution for an Inconsistent System")
                    .font(.title2)
                    .bold()
                
                Text("1. Check for inconsistency using RREF([A|b]).")
                Text("2. If inconsistent, solve for x̂ using the Normal Equations: AᵀAx̂ = Aᵀb")
                    .font(.system(.body, design: .monospaced))
                
                Divider()
                
                // Input Section
                HStack(alignment: .top, spacing: 20) {
                    // Matrix A Input (Editable)
                    VStack {
                        Text("Matrix A")
                            .font(.headline)
                        
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
                                            .frame(width: 50, height: 40)
                                            .background(Color(uiColor: .secondarySystemBackground))
                                            .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                            .padding(8)
                        }
                        .frame(maxHeight: 200)
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
                    Text("Compute Least Squares Solution")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if hasComputed {
                    Divider()
                    
                    // Step 1: Inconsistency Check
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Step 1: Check for Inconsistency")
                            .font(.headline)
                        
                        Text("Augmented Matrix [A|b]:")
                        MatrixPreviewView(matrix: augmentedMatrix)
                        
                        Image(systemName: "arrow.down")
                            .frame(maxWidth: .infinity)
                        
                        Text("RREF([A|b]):")
                        MatrixPreviewView(matrix: augmentedRREF)
                        
                        if isInconsistent {
                            Text("Conclusion: The system is INCONSISTENT.")
                                .foregroundColor(.red)
                                .bold()
                            Text(inconsistencyReason)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Conclusion: The system is CONSISTENT.")
                                .foregroundColor(.green)
                                .bold()
                            Text("A Least Squares solution is not needed (exact solution exists). However, the formula still works and yields the exact solution.")
                                .font(.caption)
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(10)
                    
                    // Step 2: LS Solution
                    if isInconsistent || true { // Show anyway for educational purposes
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Step 2: Least Squares Solution")
                                .font(.headline)
                            
                            Text("Formula: x̂ = (AᵀA)⁻¹ Aᵀb")
                                .font(.system(.body, design: .monospaced))
                                .padding(.bottom, 4)
                            
                            // A^T
                            HStack {
                                Text("Aᵀ =")
                                MatrixPreviewView(matrix: matrixAT)
                            }
                            
                            // A^T A
                            HStack {
                                Text("AᵀA =")
                                MatrixPreviewView(matrix: matrixATA)
                            }
                            
                            // (A^T A)^-1
                            if let inv = matrixATAInv {
                                HStack {
                                    Text("(AᵀA)⁻¹ =")
                                    MatrixPreviewView(matrix: inv)
                                }
                            } else {
                                Text("(AᵀA) is singular, cannot invert directly. Columns of A might not be linearly independent.")
                                    .foregroundColor(.red)
                            }
                            
                            // A^T b
                            HStack {
                                Text("Aᵀb =")
                                VectorPreviewView(vector: matrixATb)
                            }
                            
                            Divider()
                            
                            // Result
                            HStack {
                                Text("x̂ =")
                                    .font(.title2)
                                    .bold()
                                VectorPreviewView(vector: resultX)
                                    .font(.title2)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                            
                            Divider()
                            
                            // Step 3: Least Squares Error
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Step 3: Least Squares Error")
                                    .font(.headline)
                                
                                Text("Formula: Error = ||b - Ax̂||")
                                    .font(.system(.body, design: .monospaced))
                                    .padding(.bottom, 4)
                                
                                // Ax_hat
                                HStack {
                                    Text("Ax̂ =")
                                    VectorPreviewView(vector: axHat)
                                }
                                
                                // b - Ax_hat calculation display
                                HStack(alignment: .center) {
                                    Text("b - Ax̂ = ")
                                    VectorPreviewView(vector: vectorBValues.map { Fraction(string: $0) })
                                    Text("-")
                                    VectorPreviewView(vector: axHat)
                                    Text("=")
                                    VectorPreviewView(vector: errorVector)
                                }
                                .padding(.vertical, 5)
                                
                                // Norm
                                HStack {
                                    Text("||b - Ax̂|| =")
                                    Text(errorNormString)
                                        .font(.system(.body, design: .serif))
                                        .bold()
                                    Text("≈ \(errorNormValue)")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(10)
                            
                            // Step 4: Geometric Interpretation (New)
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Step 4: Geometric Interpretation")
                                    .font(.headline)
                                
                                Text("The vector p = Ax̂ is the orthogonal projection of b onto the column space of A. The error vector e = b - p must be orthogonal to the columns of A.")
                                    .font(.caption)
                                    .padding(.bottom, 4)
                                
                                Text("Projection Vector p (Ax̂):")
                                    .font(.subheadline)
                                    .bold()
                                VectorPreviewView(vector: axHat)
                                    .padding(.bottom, 8)
                                
                                Text("Orthogonality Check (Aᵀe = 0):")
                                    .font(.subheadline)
                                    .bold()
                                Text("We verify that Aᵀ(b - Ax̂) is the zero vector (or very close to it).")
                                    .font(.caption)
                                
                                HStack {
                                    Text("Aᵀ * error =")
                                    VectorPreviewView(vector: orthogonalityCheck)
                                }
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(10)
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                    }
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
        
        // 1. Augmented Matrix
        var aug = matrixA
        for i in 0..<aug.count {
            aug[i].append(b[i])
        }
        self.augmentedMatrix = aug
        
        // 2. RREF
        let rrefSteps = MatrixEngine.calculateRREF(matrix: aug)
        if let last = rrefSteps.last {
            self.augmentedRREF = last.matrix
            checkForInconsistency(rref: last.matrix)
        }
        
        // 3. LS Calculation
        // A^T
        let at = MatrixEngine.transpose(matrixA)
        self.matrixAT = at
        
        // A^T A
        let ata = MatrixEngine.multiply(matrixA: at, matrixB: matrixA)
        self.matrixATA = ata
        
        // (A^T A)^-1
        self.matrixATAInv = MatrixEngine.inverse(ata)
        
        // A^T b
        // Note: MatrixEngine.multiply(matrix, vector) expects vector of size cols.
        // at is (cols x rows), b is (rows). So it matches.
        let atb = MatrixEngine.multiply(matrix: at, vector: b)
        self.matrixATb = atb
        
        // Final x_hat = inv * atb
        if let inv = self.matrixATAInv {
            self.resultX = MatrixEngine.multiply(matrix: inv, vector: atb)
            
            // LS Error Calculation
            // 1. Calculate Ax_hat
            self.axHat = MatrixEngine.multiply(matrix: matrixA, vector: self.resultX)
            
            // 2. Calculate error vector b - Ax_hat
            var err: [Fraction] = []
            for i in 0..<b.count {
                err.append(b[i] - self.axHat[i])
            }
            self.errorVector = err
            
            // 3. Calculate Norm
            self.errorNormString = MatrixEngine.formatNorm(err)
            
            let sq = MatrixEngine.normSquared(err)
            let val = sqrt(sq.asDouble)
            self.errorNormValue = String(format: "%.4f", val)
            
            // 4. Orthogonality Check: A^T * error
            // errorVector is b - Ax_hat
            // Check A^T * (b - Ax_hat)
            self.orthogonalityCheck = MatrixEngine.multiply(matrix: at, vector: self.errorVector)
            
        } else {
            self.resultX = [] // Handle error case
            self.axHat = []
            self.errorVector = []
            self.errorNormString = ""
            self.errorNormValue = ""
            self.orthogonalityCheck = []
        }
        
        withAnimation {
            hasComputed = true
        }
    }
    
    private func checkForInconsistency(rref: [[Fraction]]) {
        // Inconsistent if there is a row [0 0 ... 0 | b] where b != 0
        // The last column is the augmented column.
        let rows = rref.count
        let cols = rref[0].count
        let lastColIndex = cols - 1
        
        var inconsistent = false
        var badRow = -1
        
        for r in 0..<rows {
            var allZeroCoeffs = true
            for c in 0..<lastColIndex {
                if rref[r][c] != .zero {
                    allZeroCoeffs = false
                    break
                }
            }
            
            if allZeroCoeffs && rref[r][lastColIndex] != .zero {
                inconsistent = true
                badRow = r
                break
            }
        }
        
        self.isInconsistent = inconsistent
        if inconsistent {
            self.inconsistencyReason = "Row \(badRow + 1) of the RREF is [0 ... 0 | 1], which implies 0 = 1. Thus, no solution exists."
        } else {
            self.inconsistencyReason = ""
        }
    }
}

