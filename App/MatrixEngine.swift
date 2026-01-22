import Foundation

struct Fraction: Equatable, CustomStringConvertible, Comparable {
    let numerator: Int
    let denominator: Int
    
    static let zero = Fraction(0)
    static let one = Fraction(1)
    
    init(_ n: Int, _ d: Int = 1) {
        if d == 0 { fatalError("Denominator cannot be zero") }
        let common = gcd(abs(n), abs(d))
        let sign = (n < 0) == (d < 0) ? 1 : -1
        self.numerator = sign * abs(n) / common
        self.denominator = abs(d) / common
    }
    
    init(string: String) {
        let parts = string.components(separatedBy: "/")
        if parts.count == 2, let n = Int(parts[0]), let d = Int(parts[1]) {
            self.init(n, d)
        } else if let n = Int(string) {
            self.init(n, 1)
        } else if let d = Double(string) {
            // Best effort for decimals
            // This is a simplification for the UI input "0.5" -> 1/2
            // For now, let's assume users enter fractions or ints as requested, 
            // but if they enter 0.5 we can try to handle it.
            let n = Int(d * 10000)
            self.init(n, 10000)
        } else {
            self.init(0)
        }
    }
    
    var description: String {
        if denominator == 1 { return "\(numerator)" }
        return "\(numerator)/\(denominator)"
    }
    
    static func + (lhs: Fraction, rhs: Fraction) -> Fraction {
        return Fraction(lhs.numerator * rhs.denominator + rhs.numerator * lhs.denominator, lhs.denominator * rhs.denominator)
    }
    
    static func - (lhs: Fraction, rhs: Fraction) -> Fraction {
        return Fraction(lhs.numerator * rhs.denominator - rhs.numerator * lhs.denominator, lhs.denominator * rhs.denominator)
    }
    
    static func * (lhs: Fraction, rhs: Fraction) -> Fraction {
        return Fraction(lhs.numerator * rhs.numerator, lhs.denominator * rhs.denominator)
    }
    
    static func / (lhs: Fraction, rhs: Fraction) -> Fraction {
        return Fraction(lhs.numerator * rhs.denominator, lhs.denominator * rhs.numerator)
    }
    
    static func < (lhs: Fraction, rhs: Fraction) -> Bool {
        return Double(lhs.numerator)/Double(lhs.denominator) < Double(rhs.numerator)/Double(rhs.denominator)
    }
    
    var asDouble: Double {
        return Double(numerator) / Double(denominator)
    }
}

func gcd(_ a: Int, _ b: Int) -> Int {
    let r = a % b
    return r != 0 ? gcd(b, r) : b
}

struct MatrixStep: Identifiable {
    let id = UUID()
    let matrix: [[Fraction]]
    let operation: String // e.g., "E21(-2)"
    let description: String // e.g., "R2 -> R2 - 2R1"
    let isFinal: Bool
}

class MatrixEngine {
    
    static func transpose(_ matrix: [[Fraction]]) -> [[Fraction]] {
        guard !matrix.isEmpty else { return [] }
        let rows = matrix.count
        let cols = matrix[0].count
        var result = Array(repeating: Array(repeating: Fraction(0), count: rows), count: cols)
        
        for r in 0..<rows {
            for c in 0..<cols {
                result[c][r] = matrix[r][c]
            }
        }
        return result
    }
    
    static func calculateRREF(matrix: [[Fraction]]) -> [MatrixStep] {
        var m = matrix
        var steps: [MatrixStep] = []
        let rows = m.count
        guard rows > 0 else { return [] }
        let cols = m[0].count
        
        // Initial state
        steps.append(MatrixStep(matrix: m, operation: "Start", description: "Initial Matrix", isFinal: false))
        
        var lead = 0
        for r in 0..<rows {
            if cols <= lead { break }
            var i = r
            while m[i][lead] == .zero {
                i += 1
                if rows == i {
                    i = r
                    lead += 1
                    if cols == lead { return steps }
                }
            }
            
            // Swap rows if needed
            if i != r {
                m.swapAt(i, r)
                steps.append(MatrixStep(matrix: m, operation: "P\(r+1)\(i+1)", description: "Swap Row \(r+1) and Row \(i+1) to bring a non-zero pivot to the current position.", isFinal: false))
            }
            
            // Scale row to make pivot 1
            let pivot = m[r][lead]
            if pivot != .one {
                let scalar = Fraction(1) / pivot
                for c in 0..<cols {
                    m[r][c] = m[r][c] * scalar
                }
                steps.append(MatrixStep(matrix: m, operation: "M\(r+1)(\(scalar))", description: "Scale Row \(r+1) by \(scalar) to make the pivot element 1.", isFinal: false))
            }
            
            // Eliminate other rows
            for i in 0..<rows {
                if i != r {
                    let val = m[i][lead]
                    if val != .zero {
                        let scalar = Fraction(-1) * val
                        for c in 0..<cols {
                            m[i][c] = m[i][c] + (scalar * m[r][c])
                        }
                        // Format: E_target_source(scalar)
                        // e.g. E21(-2) means add -2*Row1 to Row2
                        steps.append(MatrixStep(matrix: m, operation: "E\(i+1)\(r+1)(\(scalar))", description: "Add \(scalar) times Row \(r+1) to Row \(i+1) to eliminate the value in the pivot column.", isFinal: false))
                    }
                }
            }
            lead += 1
        }
        
        // Mark last step as final
        if let last = steps.last {
            steps[steps.count - 1] = MatrixStep(matrix: last.matrix, operation: last.operation, description: last.description, isFinal: true)
        }
        
        return steps
    }
    
    // MARK: - Subspace Calculations
    
    static func getPivotIndices(rref: [[Fraction]]) -> [Int] {
        let rows = rref.count
        guard rows > 0 else { return [] }
        let cols = rref[0].count
        var pivots: [Int] = []
        
        for r in 0..<rows {
            for c in 0..<cols {
                if rref[r][c] != .zero {
                    pivots.append(c)
                    break
                }
            }
        }
        return pivots.sorted()
    }
    
    static func getColumnSpace(originalMatrix: [[Fraction]], pivotIndices: [Int]) -> [[Fraction]] {
        guard !originalMatrix.isEmpty else { return [] }
        var basis: [[Fraction]] = []
        
        for colIndex in pivotIndices {
            var colVec: [Fraction] = []
            for r in 0..<originalMatrix.count {
                colVec.append(originalMatrix[r][colIndex])
            }
            basis.append(colVec)
        }
        return basis
    }
    
    static func getRowSpace(rref: [[Fraction]]) -> [[Fraction]] {
        return rref.filter { row in
            row.contains { $0 != .zero }
        }
    }
    
    static func getNullSpace(rref: [[Fraction]], pivotIndices: [Int]) -> [[Fraction]] {
        let rows = rref.count
        guard rows > 0 else { return [] }
        let cols = rref[0].count
        var basis: [[Fraction]] = []
        
        let pivotSet = Set(pivotIndices)
        let freeIndices = (0..<cols).filter { !pivotSet.contains($0) }
        
        for freeIndex in freeIndices {
            var vector = Array(repeating: Fraction.zero, count: cols)
            vector[freeIndex] = .one
            
            for (rowIndex, colIndex) in pivotIndices.enumerated() {
                // Safe check if rowIndex is within bounds, though in RREF pivot i is in row i
                if rowIndex < rows {
                    let val = rref[rowIndex][freeIndex]
                    vector[colIndex] = Fraction(-1) * val
                }
            }
            basis.append(vector)
        }
        
        return basis
    }
    
    static func getLeftNullSpace(originalMatrix: [[Fraction]]) -> [[Fraction]] {
        let transposed = transpose(originalMatrix)
        let rrefTSteps = calculateRREF(matrix: transposed)
        guard let finalStep = rrefTSteps.last else { return [] }
        let rrefT = finalStep.matrix
        let pivotsT = getPivotIndices(rref: rrefT)
        return getNullSpace(rref: rrefT, pivotIndices: pivotsT)
    }
}
