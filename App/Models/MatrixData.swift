import SwiftUI

/// Observable data model for matrix computations and derived properties
/// Manages matrix dimensions, values, and all computed subspaces
class MatrixData: ObservableObject {
    // MARK: - Matrix Configuration
    
    @Published var rows: Int = 3
    @Published var cols: Int = 3
    @Published var values: [[String]] = Array(repeating: Array(repeating: "0", count: 10), count: 10)
    
    // MARK: - Computed Results
    
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
    
    // MARK: - Explanations
    
    @Published var columnSpaceExplanation: String = ""
    @Published var nullSpaceExplanation: String = ""
    @Published var rowSpaceExplanation: String = ""
    @Published var leftNullSpaceExplanation: String = ""
    
    // MARK: - Initialization
    
    /// Initializes with a sample 3x3 matrix for demonstration
    init() {
        self.rows = 3
        self.cols = 3
        // Initialize with a well-conditioned example matrix
        values[0][0] = "4"; values[0][1] = "1"; values[0][2] = "-1"
        values[1][0] = "2"; values[1][1] = "5"; values[1][2] = "-2"
        values[2][0] = "1"; values[2][1] = "1"; values[2][2] = "2"
    }
    
    // MARK: - Public Methods
    
    /// Resets all matrix values to identity matrix and clears computed results
    func reset() {
        values = Array(repeating: Array(repeating: "0", count: 10), count: 10)
        // Set diagonal to 1
        for i in 0..<min(rows, cols) {
            values[i][i] = "1"
        }
        clearComputedResults()
    }
    
    /// Converts string matrix values to Fraction matrix
    /// - Returns: A 2D array of Fraction values
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
    
    /// Computes all matrix properties and derived subspaces
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
    
    // MARK: - Private Methods
    
    /// Clears all computed results
    private func clearComputedResults() {
        hasComputed = false
        rrefSteps = []
        rrefTSteps = []
        columnSpace = []
        rowSpace = []
        nullSpace = []
        leftNullSpace = []
        pivots = []
        determinantValue = nil
        inverseMatrix = nil
    }
}
