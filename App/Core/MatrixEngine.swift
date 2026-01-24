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
    
    static func multiply(matrix: [[Fraction]], vector: [Fraction]) -> [Fraction] {
        let rows = matrix.count
        guard rows > 0 else { return [] }
        let cols = matrix[0].count
        guard vector.count == cols else { return [] }
        
        var result: [Fraction] = []
        for r in 0..<rows {
            var sum = Fraction.zero
            for c in 0..<cols {
                sum = sum + (matrix[r][c] * vector[c])
            }
            result.append(sum)
        }
        return result
    }
    
    static func multiply(matrixA: [[Fraction]], matrixB: [[Fraction]]) -> [[Fraction]] {
        let rowsA = matrixA.count
        guard rowsA > 0 else { return [] }
        let colsA = matrixA[0].count
        let rowsB = matrixB.count
        guard rowsB > 0 else { return [] }
        let colsB = matrixB[0].count
        
        guard colsA == rowsB else { return [] }
        
        var result: [[Fraction]] = []
        for r in 0..<rowsA {
            var row: [Fraction] = []
            for c in 0..<colsB {
                var sum = Fraction.zero
                for k in 0..<colsA {
                    sum = sum + (matrixA[r][k] * matrixB[k][c])
                }
                row.append(sum)
            }
            result.append(row)
        }
        return result
    }
    
    static func inverse(_ matrix: [[Fraction]]) -> [[Fraction]]? {
        let invSteps = calculateInverseSteps(matrix: matrix)
        guard let lastStep = invSteps.last else { return nil }
        let rrefAug = lastStep.matrix
        let n = matrix.count
        
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
            return inv
        } else {
            return nil
        }
    }
    
    // MARK: - Vector Operations (6.1 - 6.2)
    
    struct VectorStep: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let latex: String
    }
    
    static func dotProduct(_ u: [Fraction], _ v: [Fraction]) -> Fraction {
        guard u.count == v.count else { return .zero }
        var sum = Fraction.zero
        for i in 0..<u.count {
            sum = sum + (u[i] * v[i])
        }
        return sum
    }
    
    static func normSquared(_ v: [Fraction]) -> Fraction {
        return dotProduct(v, v)
    }
    
    // Returns latex string, e.g. "\sqrt{30}" or "5"
    static func formatNorm(_ v: [Fraction]) -> String {
        let sq = normSquared(v)
        // Check if perfect square
        let val = sq.asDouble
        let root = sqrt(val)
        if abs(root - round(root)) < 1e-9 {
            return "\(Int(round(root)))"
        }
        
        if sq.denominator == 1 {
            return "\\sqrt{\(sq.numerator)}"
        } else {
            return "\\sqrt{\(sq.description)}"
        }
    }
    
    static func analyzeOrthogonality(u: [Fraction], v: [Fraction]) -> [VectorStep] {
        var steps: [VectorStep] = []
        guard u.count == v.count else {
            steps.append(VectorStep(title: "Error", description: "Vectors must have the same dimension.", latex: ""))
            return steps
        }
        
        // 1. Inner Product
        let dot = dotProduct(u, v)
        
        var dotTerms: [String] = []
        for i in 0..<u.count {
            dotTerms.append("(\(u[i]))(\\cdot)(\(v[i]))")
        }
        let dotCalc = dotTerms.joined(separator: " + ")
        
        steps.append(VectorStep(
            title: "1. Inner Product (Dot Product)",
            description: "Compute u · v by summing the products of corresponding entries.",
            latex: "u \\cdot v = \(dotCalc) = \(dot)"
        ))
        
        // 2. Norms
        let normU = formatNorm(u)
        let normV = formatNorm(v)
        
        let uSq = normSquared(u)
        let vSq = normSquared(v)
        
        steps.append(VectorStep(
            title: "2. Vector Lengths (Norms)",
            description: "Compute the length of each vector: ||v|| = √(v · v).",
            latex: "\\begin{aligned} ||u|| &= \\sqrt{\(uSq)} = \(normU) \\\\ ||v|| &= \\sqrt{\(vSq)} = \(normV) \\end{aligned}"
        ))
        
        // 3. Distance
        // dist(u, v) = ||u - v||
        var diffVec: [Fraction] = []
        for i in 0..<u.count {
            diffVec.append(u[i] - v[i])
        }
        let distSq = normSquared(diffVec)
        let distStr = formatNorm(diffVec)
        
        steps.append(VectorStep(
            title: "3. Distance",
            description: "Distance between u and v is ||u - v||.",
            latex: "dist(u, v) = ||u - v|| = \\sqrt{\(distSq)} = \(distStr)"
        ))
        
        // 4. Orthogonality Check
        let isOrthogonal = dot == .zero
        let orthResult = isOrthogonal ? "\\text{Orthogonal}" : "\\text{Not Orthogonal}"
        steps.append(VectorStep(
            title: "4. Orthogonality",
            description: "Two vectors are orthogonal if their dot product is zero.",
            latex: "u \\cdot v = \(dot) \\implies \(orthResult)"
        ))
        
        // 5. Angle (if not zero vectors)
        if uSq != .zero && vSq != .zero {
            let cosTheta = dot.asDouble / (sqrt(uSq.asDouble) * sqrt(vSq.asDouble))
            // Clamp for safety
            let clamped = max(-1.0, min(1.0, cosTheta))
            let angleRad = acos(clamped)
            let angleDeg = angleRad * 180.0 / .pi
            
            steps.append(VectorStep(
                title: "5. Angle",
                description: "Calculate the angle θ between u and v using cos(θ) = (u · v) / (||u|| ||v||).",
                latex: "\\theta \\approx \(String(format: "%.2f", angleDeg))^\\circ"
            ))
        }
        
        return steps
    }

    static func checkOrthogonalSet(matrix: [[Fraction]]) -> [VectorStep] {
        var steps: [VectorStep] = []
        let rows = matrix.count
        guard rows > 0 else { return [] }
        let cols = matrix[0].count
        guard cols >= 2 else { return [] }
        
        var allOrthogonal = true
        var pairCalcs: [String] = []
        
        for i in 0..<cols {
            for j in (i+1)..<cols {
                var u: [Fraction] = []
                var v: [Fraction] = []
                for r in 0..<rows {
                    u.append(matrix[r][i])
                    v.append(matrix[r][j])
                }
                
                let dot = dotProduct(u, v)
                let isZero = dot == .zero
                if !isZero { allOrthogonal = false }
                
                pairCalcs.append("u_\(i+1) \\cdot u_\(j+1) = \(dot) \\quad \(isZero ? "(\\checkmark)" : "(\\times)")")
            }
        }
        
        let description = "A set of vectors {u₁, ..., u_p} is an orthogonal set if each pair of distinct vectors is orthogonal."
        let latex = pairCalcs.joined(separator: "\\\\ ")
        
        steps.append(VectorStep(
            title: "Orthogonal Set Check",
            description: description,
            latex: latex
        ))
        
        if allOrthogonal {
            steps.append(VectorStep(
                title: "Conclusion",
                description: "All pairs are orthogonal.",
                latex: "\\implies \\text{The columns form an orthogonal set.}"
            ))
        } else {
            steps.append(VectorStep(
                title: "Conclusion",
                description: "Not all pairs are orthogonal.",
                latex: "\\implies \\text{The columns DO NOT form an orthogonal set.}"
            ))
        }
        
        return steps
    }

    // MARK: - Eigenvalue & Eigenvector Logic
    
    struct EigenStep: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let latex: String
    }
    
    // Old simple method, kept for reference if needed, but replaced by detailed version
    static func getCharacteristicPolynomial(matrix: [[Fraction]]) -> (latex: String, roots: [Double]) {
        let res = calculateCharacteristicPolynomialDetailed(matrix: matrix)
        let polyLatex = res.steps.last?.latex ?? ""
        return (polyLatex, res.roots)
    }

    static func calculateCharacteristicPolynomialDetailed(matrix: [[Fraction]]) -> (steps: [EigenStep], roots: [Double]) {
        var steps: [EigenStep] = []
        let rows = matrix.count
        guard rows == matrix[0].count else { return ([], []) }
        
        let variable = "x"
        
        // 1. Setup Characteristic Matrix (xI - A)
        var polyMatrix: [[Polynomial]] = []
        for r in 0..<rows {
            var row: [Polynomial] = []
            for c in 0..<rows {
                let val = matrix[r][c].asDouble
                if r == c {
                    // x - val
                    row.append(Polynomial(coeffs: [-val, 1]))
                } else {
                    // -val
                    row.append(Polynomial(coeffs: [-val]))
                }
            }
            polyMatrix.append(row)
        }
        
        let matrixLatex = matrixToLatex(polyMatrix, variable: variable)
        
        steps.append(EigenStep(
            title: "Characteristic Matrix",
            description: "Note that \(variable)I_\(rows) - A = ",
            latex: "\\begin{bmatrix} " + matrixLatex + " \\end{bmatrix}"
        ))
        
        // 2. Determinant Setup
        let detLatex = "\\begin{vmatrix} " + matrixLatex + " \\end{vmatrix}"
        steps.append(EigenStep(
            title: "Characteristic Polynomial Setup",
            description: "Thus, p(\(variable)) = det(\(variable)I_\(rows) - A) =",
            latex: "p(\(variable)) = " + detLatex
        ))
        
        // 3. Compute Determinant
        let (detSteps, finalPoly) = calculatePolyDetSteps(polyMatrix, variable: variable)
        steps.append(contentsOf: detSteps)
        
        // 4. Roots
        let roots = findRoots(finalPoly)
        let rootsStr = roots.map { formatRoot($0) }.joined(separator: ", ")
        let spectrumStr = "\\sigma(A) = \\{" + rootsStr + "\\}"
        
        steps.append(EigenStep(
            title: "Roots",
            description: "Setting p(\(variable)) = 0 and solving for \(variable) gives \(variable) = \(rootsStr.replacingOccurrences(of: ", ", with: " or ")). Therefore,",
            latex: spectrumStr
        ))
        
        return (steps, roots)
    }
    
    static func formatLatex(_ text: String) -> String {
        var s = text
        
        // Remove LaTeX environments
        s = s.replacingOccurrences(of: "\\begin{aligned}", with: "")
        s = s.replacingOccurrences(of: "\\end{aligned}", with: "")
        s = s.replacingOccurrences(of: "\\text", with: "") // Remove \text command but keep content (braces removed later)
        s = s.replacingOccurrences(of: "\\left", with: "")
        s = s.replacingOccurrences(of: "\\right", with: "")
        
        // Greek
        s = s.replacingOccurrences(of: "\\lambda", with: "λ")
        s = s.replacingOccurrences(of: "\\sigma", with: "σ")
        s = s.replacingOccurrences(of: "\\theta", with: "θ")
        s = s.replacingOccurrences(of: "\\pi", with: "π")
        
        // Symbols
        s = s.replacingOccurrences(of: "\\cdot", with: "·")
        s = s.replacingOccurrences(of: "\\det", with: "det")
        s = s.replacingOccurrences(of: "\\implies", with: "⇒")
        s = s.replacingOccurrences(of: "\\rightarrow", with: "→")
        s = s.replacingOccurrences(of: "\\quad", with: "   ")
        s = s.replacingOccurrences(of: "\\sum", with: "∑")
        s = s.replacingOccurrences(of: "\\infty", with: "∞")
        s = s.replacingOccurrences(of: "\\sqrt", with: "√")
        s = s.replacingOccurrences(of: "\\approx", with: "≈")
        s = s.replacingOccurrences(of: "\\circ", with: "°")
        s = s.replacingOccurrences(of: "\\times", with: "×")
        s = s.replacingOccurrences(of: "\\neq", with: "≠")
        s = s.replacingOccurrences(of: "\\in", with: "∈")
        s = s.replacingOccurrences(of: "\\mathbb{R}", with: "ℝ")
        
        // Newlines for aligned blocks
        s = s.replacingOccurrences(of: "\\\\", with: "\n")
        
        // Superscripts Map
        let supers: [String: String] = [
            "0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴",
            "5": "⁵", "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹",
            "+": "⁺", "-": "⁻", "=": "⁼", "(": "⁽", ")": "⁾",
            "n": "ⁿ", "i": "ⁱ", "x": "ˣ", "T": "ᵀ", "-1": "⁻¹"
        ]
        
        // Specific common ones
        s = s.replacingOccurrences(of: "^-1", with: "⁻¹")
        s = s.replacingOccurrences(of: "^{-1}", with: "⁻¹")
        s = s.replacingOccurrences(of: "^T", with: "ᵀ")
        s = s.replacingOccurrences(of: "^\\circ", with: "°")
        
        // Regex for ^{...}
        // Swift regex replacement is verbose, let's use a simple loop for single digits first
        for (k, v) in supers {
            s = s.replacingOccurrences(of: "^{\(k)}", with: v)
            s = s.replacingOccurrences(of: "^\(k)", with: v)
        }
        
        // Subscripts
        let subs = ["0":"₀", "1":"₁", "2":"₂", "3":"₃", "4":"₄", "5":"₅", "6":"₆", "7":"₇", "8":"₈", "9":"₉"]
        for (k, v) in subs {
            s = s.replacingOccurrences(of: "_{\(k)}", with: v)
            s = s.replacingOccurrences(of: "_\(k)", with: v)
        }
        
        // Cleanup braces
        s = s.replacingOccurrences(of: "{", with: "")
        s = s.replacingOccurrences(of: "}", with: "")
        s = s.replacingOccurrences(of: "\\", with: "") // Remove remaining backslashes
        s = s.replacingOccurrences(of: "^", with: "") // Remove remaining carats
        
        return s.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func formatRoot(_ val: Double) -> String {
        if abs(val - round(val)) < 1e-9 {
            return "\(Int(round(val)))"
        }
        return String(format: "%.2f", val)
    }
    
    static func calculatePolyDetSteps(_ m: [[Polynomial]], variable: String) -> ([EigenStep], Polynomial) {
        let rows = m.count
        if rows == 1 {
            return ([], m[0][0])
        }
        
        if rows == 2 {
            // ad - bc
            let p1 = m[0][0] * m[1][1]
            let p2 = m[0][1] * m[1][0]
            let res = p1 - p2
            
            let term1 = m[0][0].toLatex(variable: variable)
            let term2 = m[1][1].toLatex(variable: variable)
            let term3 = m[0][1].toLatex(variable: variable)
            let term4 = m[1][0].toLatex(variable: variable)
            
            // Format: = (x-1)(x-2) - (2)(3)
            let latex = "= (" + term1 + ")(" + term2 + ") - (" + term3 + ")(" + term4 + ")"
            let latex2 = "= " + res.toLatex(variable: variable)
            
            // If it's a 2x2 matrix step (not recursive), we might want more detail, but for now this is good.
            // Check if this is a sub-step or main. If rows==2 implies it was a 2x2 matrix input.
            // If it's recursive from 3x3, this function is called but we discard the steps in the 3x3 handler below.
            // Wait, I am calling this recursively.
            
            return ([EigenStep(title: "Determinant Calculation", description: "Using ad - bc:", latex: latex), EigenStep(title: "Simplification", description: "Simplify the expression:", latex: latex2)], res)
        }
        
        // 3x3: Cofactor Expansion along first row
        var steps: [EigenStep] = []
        var finalPoly = Polynomial.zero
        var formulaParts: [String] = []
        
        let r = 0 // Expand along row 0
        
        for c in 0..<rows {
            let term = m[r][c]
            // We include even zero terms to show the expansion if desired, but usually skipping zeros is better for "easy understanding"
            // The image shows zeros being skipped or implicit.
            if term.isZero { continue }
            
            let sign = ((r + c) % 2 == 0) ? "+" : "-"
            let termLatex = term.toLatex(variable: variable)
            
            // Submatrix
            var sub: [[Polynomial]] = []
            for i in 0..<rows {
                if i == r { continue }
                var row: [Polynomial] = []
                for j in 0..<rows {
                    if j == c { continue }
                    row.append(m[i][j])
                }
                sub.append(row)
            }
            
            let subMatrixLatex = "\\begin{vmatrix} " + matrixToLatex(sub, variable: variable) + " \\end{vmatrix}"
            
            // Calculate sub-poly for the accumulation
            let (_, subPoly) = calculatePolyDetSteps(sub, variable: variable)
            
            let signVal = (sign == "+") ? 1.0 : -1.0
            let termPoly = term * Polynomial(value: signVal)
            let contribution = termPoly * subPoly
            finalPoly = finalPoly + contribution
            
            // Construct Latex
            // If it's the first term and positive, don't show +
            var part = ""
            if formulaParts.isEmpty {
                if sign == "-" { part = "- (\(termLatex))" }
                else { part = "(\(termLatex))" }
            } else {
                part = " \(sign) (\(termLatex))"
            }
            part += subMatrixLatex
            formulaParts.append(part)
        }
        
        let fullExpansion = formulaParts.joined(separator: " ")
        steps.append(EigenStep(
            title: "Cofactor Expansion",
            description: "Using cofactor expansion along the first row, we get:",
            latex: "= " + fullExpansion
        ))
        
        // Show the result
        // We could show intermediate: = (x-1)[(x-1)^2 - 1] ...
        // But for now, jumping to the expanded form is acceptable or we can try to show the factored form if simple.
        // Since we don't have a CAS to keep it factored, we show the expanded form.
        
        steps.append(EigenStep(
            title: "Polynomial Expansion",
            description: "Expanding the terms:",
            latex: "= " + finalPoly.toLatex(variable: variable)
        ))
        
        // Try to show factored form if we can find integer roots
        let roots = findRoots(finalPoly)
        let integerRoots = roots.filter { abs($0 - round($0)) < 1e-9 }
        if integerRoots.count == finalPoly.degree {
            // We can show the factored form!
            let factors = integerRoots.map { r -> String in
                let val = Int(round(r))
                if val == 0 { return variable }
                if val > 0 { return "(\(variable) - \(val))" }
                return "(\(variable) + \(-val))"
            }.joined()
            
            steps.append(EigenStep(
                title: "Factoring",
                description: "Factoring the polynomial:",
                latex: "= " + factors
            ))
        }
        
        return (steps, finalPoly)
    }
    
    static func matrixToLatex(_ m: [[Polynomial]], variable: String = "\\lambda") -> String {
        let content = m.map { row in
            row.map { $0.toLatex(variable: variable) }.joined(separator: " & ")
        }.joined(separator: " \\\\ ")
        return content
    }

    static func findRoots(_ poly: Polynomial) -> [Double] {
        // Only handling up to degree 3 for now
        let coeffs = poly.coeffs
        if coeffs.count < 2 { return [] } // Constant
        
        if coeffs.count == 2 {
            // ax + b = 0 => x = -b/a
            return [-coeffs[0] / coeffs[1]]
        }
        
        if coeffs.count == 3 {
             // Quadratic formula
             let c = coeffs[0]
             let b = coeffs[1]
             let a = coeffs[2]
             let delta = b*b - 4*a*c
             if delta < 0 { return [] }
             let r1 = (-b + sqrt(delta)) / (2*a)
             let r2 = (-b - sqrt(delta)) / (2*a)
             return Array(Set([r1, r2])).sorted()
        }
        
        // For cubic, use integer search + Newton or just search range
        // Since this is educational, integer roots are likely.
        var roots: [Double] = []
        for i in -20...20 {
            let x = Double(i)
            if abs(poly.evaluate(x)) < 1e-4 {
                roots.append(x)
            }
        }
        
        // Refine with Newton
        // ... (Simplified for now)
        
        return Array(Set(roots)).sorted()
    }
    
    static func formatPolyTerm(_ coeff: Double, power: Int, variable: String = "\\lambda") -> String {
        if abs(coeff) < 1e-9 { return "" }
        
        let sign = coeff >= 0 ? "+" : "-"
        let val = abs(coeff)
        
        // Check if integer
        let isInt = abs(val - round(val)) < 1e-9
        let valStr = isInt ? "\(Int(round(val)))" : String(format: "%.2f", val)
        
        // Don't show coefficient 1 if there's a variable, unless it's the constant term
        let coeffStr = (valStr == "1" && power > 0) ? "" : valStr
        
        var term = ""
        if power == 0 { term = valStr }
        else if power == 1 { term = "\(coeffStr)\(variable)" }
        else { term = "\(coeffStr)\(variable)^\(power)" }
        
        return "\(sign) \(term)"
    }
    
    // Calculate Null Space Basis for (lambda*I - A)
    static func calculateEigenBasis(matrix: [[Fraction]], eigenvalue: Double) -> (steps: [MatrixStep], basis: [String], basisVectors: [[Fraction]]) {
        let rows = matrix.count
        let lambda = Fraction(Int(round(eigenvalue))) // Assuming integer eigenvalue for fraction math
        
        // M = lambda*I - A
        var m = [[Fraction]]()
        for r in 0..<rows {
            var row = [Fraction]()
            for c in 0..<rows {
                if r == c {
                    row.append(lambda - matrix[r][c])
                } else {
                    row.append(Fraction(-1) * matrix[r][c])
                }
            }
            m.append(row)
        }
        
        var steps = calculateRREF(matrix: m)
        guard let finalMatrix = steps.last?.matrix else { return ([], [], []) }
        
        // Identify Pivots and Free Variables
        var pivots = [Int]()
        for r in 0..<rows {
            if let c = finalMatrix[r].firstIndex(where: { $0.numerator != 0 }) {
                if c < rows { pivots.append(c) }
            }
        }
        
        let freeIndices = (0..<rows).filter { !pivots.contains($0) }
        
        // Add step for parameterization
        var paramDesc = "Identify pivot variables (cols \(pivots.map{String($0+1)}.joined(separator: ", "))) and free variables (cols \(freeIndices.map{String($0+1)}.joined(separator: ", "))).\n"
        paramDesc += "Express pivot variables in terms of free variables:\n"
        
        var paramMath = ""
        for r in 0..<pivots.count {
            let pIdx = pivots[r]
            var eqn = "x_\(pIdx+1) = "
            var terms: [String] = []
            for fIdx in freeIndices {
                if fIdx > pIdx { // Upper triangular part of RREF usually
                    let val = finalMatrix[r][fIdx]
                    if val != .zero {
                        let coef = Fraction(-1) * val
                        terms.append("\(coef)x_\(fIdx+1)")
                    }
                }
            }
            if terms.isEmpty { eqn += "0" }
            else { eqn += terms.joined(separator: " + ") }
            paramMath += eqn + "\n"
        }
        
        steps.append(MatrixStep(
            matrix: finalMatrix,
            operation: "Parameterization",
            description: paramDesc + paramMath,
            isFinal: false
        ))
        
        var basisVecs: [String] = []
        var rawVecs: [[Fraction]] = []
        
        for freeIdx in freeIndices {
            var vec = [String]()
            var rawVec = [Fraction]()
            for r in 0..<rows {
                if r == freeIdx { 
                    vec.append("1")
                    rawVec.append(.one)
                } else if freeIndices.contains(r) { 
                    vec.append("0") 
                    rawVec.append(.zero)
                } else if let pivotRow = pivots.firstIndex(of: r) {
                     let val = finalMatrix[pivotRow][freeIdx]
                     let fVal = Fraction(-1) * val
                     vec.append(fVal.description)
                     rawVec.append(fVal)
                } else {
                    vec.append("0")
                    rawVec.append(.zero)
                }
            }
            basisVecs.append("\\begin{bmatrix} " + vec.joined(separator: "\\\\") + " \\end{bmatrix}")
            rawVecs.append(rawVec)
        }
        
        return (steps, basisVecs, rawVecs)
    }
    
    static func calculateInverseSteps(matrix: [[Fraction]]) -> [MatrixStep] {
        let rows = matrix.count
        guard rows > 0 else { return [] }
        let cols = matrix[0].count
        // Inverse only exists for square matrices
        guard rows == cols else { return [] }
        
        // 1. Create Augmented Matrix [A | I]
        var augmented: [[Fraction]] = []
        for r in 0..<rows {
            var newRow = matrix[r]
            for c in 0..<cols {
                newRow.append(r == c ? .one : .zero)
            }
            augmented.append(newRow)
        }
        
        var steps: [MatrixStep] = []
        steps.append(MatrixStep(
            matrix: augmented,
            operation: "Start",
            description: "Augment the matrix with the Identity Matrix [A | I].",
            isFinal: false
        ))
        
        // 2. Perform Gauss-Jordan Elimination
        var m = augmented
        let totalCols = 2 * cols
        var lead = 0
        
        for r in 0..<rows {
            if totalCols <= lead { break }
            var i = r
            while m[i][lead] == .zero {
                i += 1
                if rows == i {
                    i = r
                    lead += 1
                    if totalCols == lead { return steps }
                }
            }
            
            // Swap rows
            if i != r {
                m.swapAt(i, r)
                steps.append(MatrixStep(
                    matrix: m,
                    operation: "P\(r+1)\(i+1)",
                    description: "Pivot Issue: The element at the pivot position (\(r+1),\(r+1)) is zero. To proceed with Gaussian elimination, we need a non-zero value here. Solution: Swap Row \(r+1) with Row \(i+1), which puts a non-zero value into the pivot spot.",
                    isFinal: false
                ))
            }
            
            // Scale row
            let pivot = m[r][lead]
            if pivot != .one {
                let scalar = Fraction(1) / pivot
                for c in 0..<totalCols {
                    m[r][c] = m[r][c] * scalar
                }
                steps.append(MatrixStep(
                    matrix: m,
                    operation: "M\(r+1)(\(scalar))",
                    description: "Normalization: We want the pivot at (\(r+1),\(r+1)) to be exactly 1 (a 'leading one'). Currently, it is \(pivot). We multiply the entire Row \(r+1) by its reciprocal, \(scalar). This simplifies the math for the next steps.",
                    isFinal: false
                ))
            }
            
            // Eliminate column
            for i in 0..<rows {
                if i != r {
                    let val = m[i][lead]
                    if val != .zero {
                        let scalar = Fraction(-1) * val
                        for c in 0..<totalCols {
                            m[i][c] = m[i][c] + (scalar * m[r][c])
                        }
                        steps.append(MatrixStep(
                            matrix: m,
                            operation: "E\(i+1)\(r+1)(\(scalar))",
                            description: "Elimination: We need to clear out the value \(val) at position (\(i+1),\(r+1)) to form the Identity matrix structure. We do this by adding \(scalar) times the pivot row (Row \(r+1)) to Row \(i+1). This makes the entry at (\(i+1),\(r+1)) become zero.",
                            isFinal: false
                        ))
                    }
                }
            }
            lead += 1
        }
        
        // 3. Check if inverse was found (Identity on the left)
        var isIdentity = true
        for r in 0..<rows {
            for c in 0..<cols {
                if r == c {
                    if m[r][c] != .one { isIdentity = false }
                } else {
                    if m[r][c] != .zero { isIdentity = false }
                }
            }
        }
        
        if isIdentity {
            steps.append(MatrixStep(
                matrix: m,
                operation: "Result",
                description: "The left side is now the Identity Matrix. The right side is the Inverse Matrix A⁻¹.",
                isFinal: true
            ))
        } else {
            steps.append(MatrixStep(
                matrix: m,
                operation: "Singular",
                description: "The matrix could not be reduced to Identity. It is Singular (non-invertible).",
                isFinal: true
            ))
        }
        
        return steps
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
    

    // MARK: - Diagonalization
    
    struct DiagonalizationStep: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let latex: String?
        let matrix: [[Fraction]]?
    }
    
    struct DiagonalizationResult {
        let isDiagonalizable: Bool
        let P: [[Fraction]]?
        let D: [[Fraction]]?
        let AP: [[Fraction]]?
        let PD: [[Fraction]]?
        let steps: [DiagonalizationStep]
    }
    
    static func calculateDiagonalization(matrix: [[Fraction]]) -> DiagonalizationResult {
        let rows = matrix.count
        guard rows > 0 && rows == matrix[0].count else {
            return DiagonalizationResult(isDiagonalizable: false, P: nil, D: nil, AP: nil, PD: nil, steps: [
                DiagonalizationStep(title: "Error", description: "Matrix must be square.", latex: nil, matrix: nil)
            ])
        }
        
        var steps: [DiagonalizationStep] = []
        
        // 1. Get Eigenvalues
        steps.append(DiagonalizationStep(title: "1. Get Eigenvalues", description: "First, we find the eigenvalues by solving det(xI - A) = 0.", latex: nil, matrix: nil))
        
        let polyRes = getCharacteristicPolynomial(matrix: matrix)
        let roots = polyRes.roots.sorted(by: >) // Sort descending for consistency
        
        let rootsStr = roots.map { formatPolyTerm($0, power: 0).trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "+ ", with: "") }.joined(separator: ", ")
        steps.append(DiagonalizationStep(title: "Eigenvalues Found", description: "The eigenvalues are: \(rootsStr)", latex: "\\sigma(A) = \\{\(rootsStr)\\}", matrix: nil))
        
        // 2. Get Eigenvectors and form P
        var allEigenvectors: [([Fraction], Double)] = [] // (Vector, Eigenvalue)
        var pStepsDesc = ""
        
        for root in roots {
            let res = calculateEigenBasis(matrix: matrix, eigenvalue: root)
            let vectors = res.basisVectors
            
            pStepsDesc += "For x = \(Int(round(root))):\n"
            if vectors.isEmpty {
                pStepsDesc += "No eigenvectors found.\n"
            } else {
                for (_, vec) in vectors.enumerated() {
                    allEigenvectors.append((vec, root))
                    let vecStr = vec.map { $0.description }.joined(separator: ", ")
                    pStepsDesc += "v_\(allEigenvectors.count) = [\(vecStr)]^T\n"
                }
            }
        }
        
        steps.append(DiagonalizationStep(title: "2. Get Eigenvectors", description: "We find the eigenvectors for each eigenvalue.", latex: nil, matrix: nil))
        
        // Check Diagonalizability
        if allEigenvectors.count < rows {
            steps.append(DiagonalizationStep(title: "Not Diagonalizable", description: "We found only \(allEigenvectors.count) linearly independent eigenvectors, but we need \(rows) (the dimension of the matrix). Therefore, A is not diagonalizable.", latex: nil, matrix: nil))
            return DiagonalizationResult(isDiagonalizable: false, P: nil, D: nil, AP: nil, PD: nil, steps: steps)
        }
        
        // Form P
        var P: [[Fraction]] = Array(repeating: Array(repeating: .zero, count: rows), count: rows)
        var D: [[Fraction]] = Array(repeating: Array(repeating: .zero, count: rows), count: rows)
        
        for c in 0..<rows {
            let (vec, lambda) = allEigenvectors[c]
            // Set column c of P
            for r in 0..<rows {
                P[r][c] = vec[r]
            }
            // Set diagonal c,c of D
            D[c][c] = Fraction(Int(round(lambda)))
        }
        
        steps.append(DiagonalizationStep(title: "3. Form Matrix P", description: "Construct matrix P using the eigenvectors as columns.", latex: "P = [v_1 | v_2 | ... | v_n]", matrix: P))
        
        // Form D
        steps.append(DiagonalizationStep(title: "4. Form Matrix D", description: "Construct diagonal matrix D using the corresponding eigenvalues.", latex: "D = diag(\\lambda_1, \\lambda_2, ..., \\lambda_n)", matrix: D))
        
        // Compute AP and PD
        let AP = multiply(matrixA: matrix, matrixB: P)
        let PD = multiply(matrixA: P, matrixB: D)
        
        steps.append(DiagonalizationStep(title: "5. Verify AP = PD", description: "Compute AP (Original Matrix × Eigenvector Matrix).", latex: "AP", matrix: AP))
        
        steps.append(DiagonalizationStep(title: "Compute PD", description: "Compute PD (Eigenvector Matrix × Diagonal Matrix).", latex: "PD", matrix: PD))
        
        // Check equality
        var isEqual = true
        for r in 0..<rows {
            for c in 0..<rows {
                if AP[r][c] != PD[r][c] { isEqual = false }
            }
        }
        
        if isEqual {
            steps.append(DiagonalizationStep(title: "Conclusion", description: "Since AP = PD, we have confirmed the diagonalization. This implies P⁻¹AP = D.", latex: "P^{-1}AP = D", matrix: nil))
        } else {
            steps.append(DiagonalizationStep(title: "Error", description: "Verification failed. AP != PD.", latex: "AP \\neq PD", matrix: nil))
        }
        
        return DiagonalizationResult(isDiagonalizable: true, P: P, D: D, AP: AP, PD: PD, steps: steps)
    }

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
    
    // MARK: - Determinant Calculations
    
    struct DetStep: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let matrix: [[Fraction]]?
        let math: String?
    }

    static func calculateCofactorSteps(matrix: [[Fraction]]) -> [DetStep] {
        var steps: [DetStep] = []
        let rows = matrix.count
        guard rows > 0, rows == matrix[0].count else { return [] }
        
        steps.append(DetStep(title: "Initial Matrix", description: "Start with the given square matrix.", matrix: matrix, math: "det(A)"))
        
        if rows == 1 {
            steps.append(DetStep(title: "1x1 Determinant", description: "The determinant of a 1x1 matrix is the value itself.", matrix: nil, math: "= \(matrix[0][0])"))
            return steps
        }
        
        if rows == 2 {
            let a = matrix[0][0]
            let b = matrix[0][1]
            let c = matrix[1][0]
            let d = matrix[1][1]
            let det = a * d - b * c
            
            steps.append(DetStep(
                title: "2x2 Formula",
                description: "Use the formula ad - bc.",
                matrix: nil,
                math: "= (\(a))(\(d)) - (\(b))(\(c))\n= \(a*d) - \(b*c)\n= \(det)"
            ))
            return steps
        }
        
        // For larger matrices, show expansion along first row
        var mathParts: [String] = []
        var finalVal = Fraction.zero
        
        steps.append(DetStep(title: "Cofactor Expansion", description: "Expand along the first row.", matrix: nil, math: nil))
        
        for c in 0..<rows {
            let val = matrix[0][c]
            if val == .zero { continue }
            
            let sign = (c % 2 == 0) ? Fraction(1) : Fraction(-1)
            let signStr = (c % 2 == 0) ? "+" : "-"
            
            let sub = getSubmatrix(matrix, removingRow: 0, removingCol: c)
            let subDet = calculateDeterminantValue(sub)
            let term = sign * val * subDet
            finalVal = finalVal + term
            
            steps.append(DetStep(
                title: "Term 1,\(c+1)",
                description: "Element a₁,\(c+1) is \(val). Sign is \(signStr). Minor is the determinant of the submatrix remaining after removing Row 1 and Col \(c+1).",
                matrix: sub,
                math: "\(signStr) (\(val)) * det(M₁,\(c+1))"
            ))
            
            mathParts.append("\(signStr) (\(val))(\(subDet))")
        }
        
        steps.append(DetStep(
            title: "Summation",
            description: "Sum up all the terms.",
            matrix: nil,
            math: "det(A) = " + mathParts.joined(separator: " ") + "\n= \(finalVal)"
        ))
        
        return steps
    }

    static func calculateSarrusSteps(matrix: [[Fraction]]) -> [DetStep] {
        var steps: [DetStep] = []
        guard matrix.count == 3 && matrix[0].count == 3 else { return [] }
        
        steps.append(DetStep(title: "Initial Matrix", description: "Start with the 3x3 matrix.", matrix: matrix, math: "det(A)"))
        
        let a = matrix[0][0], b = matrix[0][1], c = matrix[0][2]
        let d = matrix[1][0], e = matrix[1][1], f = matrix[1][2]
        let g = matrix[2][0], h = matrix[2][1], i = matrix[2][2]
        
        // Forward diagonals
        steps.append(DetStep(
            title: "Forward Diagonals (Red)",
            description: "Multiply terms along the three diagonals from top-left to bottom-right.",
            matrix: matrix,
            math: nil
        ))
        
        let d1 = a * e * i
        steps.append(DetStep(
            title: "Diagonal 1",
            description: "First diagonal: (\(a)) × (\(e)) × (\(i))",
            matrix: nil,
            math: "= \(d1)"
        ))
        
        let d2 = b * f * g
        steps.append(DetStep(
            title: "Diagonal 2",
            description: "Second diagonal: (\(b)) × (\(f)) × (\(g))",
            matrix: nil,
            math: "= \(d2)"
        ))
        
        let d3 = c * d * h
        steps.append(DetStep(
            title: "Diagonal 3",
            description: "Third diagonal: (\(c)) × (\(d)) × (\(h))",
            matrix: nil,
            math: "= \(d3)"
        ))
        
        let sumFwd = d1 + d2 + d3
        steps.append(DetStep(
            title: "Sum of Forward Diagonals",
            description: "Add the results of the three forward diagonals.",
            matrix: nil,
            math: "\(d1) + \(d2) + \(d3) = \(sumFwd)"
        ))
        
        // Backward diagonals
        steps.append(DetStep(
            title: "Backward Diagonals (Blue)",
            description: "Multiply terms along the three diagonals from bottom-left to top-right.",
            matrix: nil,
            math: nil
        ))
        
        let a1 = g * e * c
        steps.append(DetStep(
            title: "Anti-Diagonal 1",
            description: "First anti-diagonal: (\(g)) × (\(e)) × (\(c))",
            matrix: nil,
            math: "= \(a1)"
        ))
        
        let a2 = h * f * a
        steps.append(DetStep(
            title: "Anti-Diagonal 2",
            description: "Second anti-diagonal: (\(h)) × (\(f)) × (\(a))",
            matrix: nil,
            math: "= \(a2)"
        ))
        
        let a3 = i * d * b
        steps.append(DetStep(
            title: "Anti-Diagonal 3",
            description: "Third anti-diagonal: (\(i)) × (\(d)) × (\(b))",
            matrix: nil,
            math: "= \(a3)"
        ))
        
        let sumBack = a1 + a2 + a3
        steps.append(DetStep(
            title: "Sum of Backward Diagonals",
            description: "Add the results of the three backward diagonals.",
            matrix: nil,
            math: "\(a1) + \(a2) + \(a3) = \(sumBack)"
        ))
        
        let det = sumFwd - sumBack
        
        steps.append(DetStep(
            title: "Final Calculation",
            description: "Subtract the backward sum from the forward sum.",
            matrix: nil,
            math: "det(A) = (\(sumFwd)) - (\(sumBack)) = \(det)"
        ))
        
        return steps
    }
    
    static func getSubmatrix(_ matrix: [[Fraction]], removingRow r: Int, removingCol c: Int) -> [[Fraction]] {
        var sub: [[Fraction]] = []
        for i in 0..<matrix.count {
            if i == r { continue }
            var row: [Fraction] = []
            for j in 0..<matrix.count {
                if j == c { continue }
                row.append(matrix[i][j])
            }
            sub.append(row)
        }
        return sub
    }
    
    static func calculateDeterminantValue(_ matrix: [[Fraction]]) -> Fraction {
        let rows = matrix.count
        guard rows > 0, rows == matrix[0].count else { return .zero }
        
        if rows == 1 { return matrix[0][0] }
        if rows == 2 {
            return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
        }
        
        var det = Fraction.zero
        // Expand along first row
        for c in 0..<rows {
            let sign = (c % 2 == 0) ? Fraction(1) : Fraction(-1)
            let sub = getSubmatrix(matrix, removingRow: 0, removingCol: c)
            det = det + sign * matrix[0][c] * calculateDeterminantValue(sub)
        }
        return det
    }

    // MARK: - Polynomial Logic
    
    struct Polynomial: Equatable, CustomStringConvertible {
        // Coefficients in ascending order: coeffs[i] is coefficient of x^i
        var coeffs: [Double]
        
        var degree: Int {
            return coeffs.count - 1
        }
        
        static let zero = Polynomial(coeffs: [0])
        static let one = Polynomial(coeffs: [1])
        static let lambda = Polynomial(coeffs: [0, 1])
        
        init(coeffs: [Double]) {
            self.coeffs = coeffs
            trim()
        }
        
        init(value: Double) {
            self.coeffs = [value]
        }
        
        mutating func trim() {
            while coeffs.count > 1 && abs(coeffs.last!) < 1e-9 {
                coeffs.removeLast()
            }
        }
        
        var description: String {
            return toLatex(variable: "x")
        }
        
        var isZero: Bool {
            return coeffs.count == 1 && abs(coeffs[0]) < 1e-9
        }
        
        func toLatex(variable: String = "\\lambda") -> String {
            if isZero { return "0" }
            if coeffs.count == 1 {
                return MatrixEngine.formatPolyTerm(coeffs[0], power: 0, variable: variable).trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "+", with: "")
            }
            
            var str = ""
            for i in (0..<coeffs.count).reversed() {
                let term = MatrixEngine.formatPolyTerm(coeffs[i], power: i, variable: variable)
                str += term + " "
            }
            // Clean up leading +
            str = str.trimmingCharacters(in: .whitespaces)
            if str.hasPrefix("+") {
                str.removeFirst()
            }
            return str.trimmingCharacters(in: .whitespaces)
        }
        
        func evaluate(_ x: Double) -> Double {
            var res = 0.0
            var p = 1.0
            for c in coeffs {
                res += c * p
                p *= x
            }
            return res
        }
        
        static func + (lhs: Polynomial, rhs: Polynomial) -> Polynomial {
            let n = max(lhs.coeffs.count, rhs.coeffs.count)
            var newCoeffs = [Double](repeating: 0, count: n)
            for i in 0..<n {
                let a = i < lhs.coeffs.count ? lhs.coeffs[i] : 0
                let b = i < rhs.coeffs.count ? rhs.coeffs[i] : 0
                newCoeffs[i] = a + b
            }
            return Polynomial(coeffs: newCoeffs)
        }
        
        static func - (lhs: Polynomial, rhs: Polynomial) -> Polynomial {
            let n = max(lhs.coeffs.count, rhs.coeffs.count)
            var newCoeffs = [Double](repeating: 0, count: n)
            for i in 0..<n {
                let a = i < lhs.coeffs.count ? lhs.coeffs[i] : 0
                let b = i < rhs.coeffs.count ? rhs.coeffs[i] : 0
                newCoeffs[i] = a - b
            }
            return Polynomial(coeffs: newCoeffs)
        }
        
        static func * (lhs: Polynomial, rhs: Polynomial) -> Polynomial {
            if lhs.isZero || rhs.isZero { return .zero }
            let n = lhs.coeffs.count + rhs.coeffs.count - 1
            var newCoeffs = [Double](repeating: 0, count: n)
            
            for i in 0..<lhs.coeffs.count {
                for j in 0..<rhs.coeffs.count {
                    newCoeffs[i+j] += lhs.coeffs[i] * rhs.coeffs[j]
                }
            }
            return Polynomial(coeffs: newCoeffs)
        }

        static func * (lhs: Polynomial, rhs: Double) -> Polynomial {
            return Polynomial(coeffs: lhs.coeffs.map { $0 * rhs })
        }
        
        static func * (lhs: Double, rhs: Polynomial) -> Polynomial {
            return rhs * lhs
        }
    }
    
    // MARK: - Gram-Schmidt & QR
    
    struct GramSchmidtStep: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let latex: String
    }
    
    static func calculateGramSchmidt(matrix: [[Fraction]]) -> (steps: [GramSchmidtStep], Q: [[String]], R: [[String]], orthogonalBasis: [[Fraction]]) {
        var steps: [GramSchmidtStep] = []
        let rows = matrix.count
        guard rows > 0 else { return ([], [], [], []) }
        let cols = matrix[0].count
        
        // Convert columns to vectors
        var As: [[Fraction]] = []
        for c in 0..<cols {
            var col: [Fraction] = []
            for r in 0..<rows {
                col.append(matrix[r][c])
            }
            As.append(col)
        }
        
        var Us: [[Fraction]] = []
        
        steps.append(GramSchmidtStep(title: "Start", description: "We start with columns \(cols) vectors.", latex: "A = [a_1, \\dots, a_\(cols)]"))
        
        for i in 0..<cols {
            let ai = As[i]
            var ui = ai
            var stepLatex = "u_\(i+1) = a_\(i+1)"
            var desc = "Initialize u_\(i+1) as a_\(i+1)."
            
            if i > 0 {
                desc += " Subtract projections onto previous orthogonal vectors."
                for j in 0..<i {
                    let uj = Us[j]
                    let num = dotProduct(uj, ai)
                    let den = dotProduct(uj, uj) // |uj|^2
                    
                    if den != .zero {
                        let coeff = num / den
                        // ui = ui - coeff * uj
                        var proj: [Fraction] = []
                        for k in 0..<rows {
                            proj.append(coeff * uj[k])
                        }
                        
                        var newUi: [Fraction] = []
                        for k in 0..<rows {
                            newUi.append(ui[k] - proj[k])
                        }
                        ui = newUi
                        
                        stepLatex += " - \\frac{\(num)}{\(den)} u_\(j+1)"
                    }
                }
            }
            
            Us.append(ui)
            
            // Format the result vector
            let vecStr = "\\begin{bmatrix} " + ui.map{$0.description}.joined(separator: "\\\\") + " \\end{bmatrix}"
            steps.append(GramSchmidtStep(title: "Step \(i+1)", description: desc, latex: stepLatex + " = " + vecStr))
        }
        
        // Normalize for Q (Symbolic)
        var Q: [[String]] = []
        // Initialize Q with empty strings
        for _ in 0..<rows {
            Q.append(Array(repeating: "", count: cols))
        }
        
        for j in 0..<cols {
            let uj = Us[j]
            let normSq = normSquared(uj)
            let normStr = formatNorm(uj)
            
            // If norm is 1, just copy
            if normSq == .one {
                for r in 0..<rows {
                    Q[r][j] = uj[r].description
                }
            } else if normSq == .zero {
                 for r in 0..<rows {
                    Q[r][j] = "0"
                }
            } else {
                // 1/sqrt(...) * val
                for r in 0..<rows {
                    let val = uj[r]
                    if val == .zero {
                        Q[r][j] = "0"
                    } else {
                        // "val / norm"
                        Q[r][j] = "\\frac{\(val)}{\(normStr)}"
                    }
                }
            }
        }
        
        // Calculate R (Symbolic)
        // R_ji = q_j . a_i
        // But since we use unnormalized Us in steps, R_ji is defined such that A = QR
        // a_i = sum (a_i . q_j) q_j
        // So R_ji = a_i . q_j
        
        var R: [[String]] = []
        for r in 0..<cols {
            var row: [String] = []
            for c in 0..<cols {
                if r > c {
                    row.append("0")
                } else {
                    // Compute dot(a_c, q_r)
                    // a_c is As[c]
                    // q_r is Us[r] / ||Us[r]||
                    let ac = As[c]
                    let ur = Us[r]
                    let dot = dotProduct(ac, ur)
                    let normSq = normSquared(ur)
                    let normStr = formatNorm(ur)
                    
                    if dot == .zero {
                        row.append("0")
                    } else if normSq == .one {
                        row.append(dot.description)
                    } else {
                        // dot / norm
                        row.append("\\frac{\(dot)}{\(normStr)}")
                    }
                }
            }
            R.append(row)
        }
        
        return (steps, Q, R, Us)
    }
    
    // MARK: - LU Decomposition
    
    struct LUStep: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let latex: String
        let matrixL: [[Fraction]]
        let matrixU: [[Fraction]]
    }
    
    static func calculateLUDecomposition(matrix: [[Fraction]]) -> (steps: [LUStep], L: [[Fraction]], U: [[Fraction]]) {
        var steps: [LUStep] = []
        let n = matrix.count
        guard n > 0 && n == matrix[0].count else { return ([], [], []) }
        
        var L = Array(repeating: Array(repeating: Fraction.zero, count: n), count: n)
        var U = matrix
        
        // Helper to format matrix for latex
        func matLatex(_ mat: [[Fraction]]) -> String {
            return "\\begin{bmatrix} " + mat.map { row in row.map { $0.description }.joined(separator: " & ") }.joined(separator: "\\\\ ") + " \\end{bmatrix}"
        }
        
        // Initialize L diagonal to 1
        for i in 0..<n { L[i][i] = .one }
        
        steps.append(LUStep(title: "Start", description: "Initialize L = I and U = A.", latex: "L = " + matLatex(L) + ", \\quad U = " + matLatex(U), matrixL: L, matrixU: U))
        
        for k in 0..<n-1 {
            // Pivot U[k][k]
            let pivot = U[k][k]
            if pivot == .zero {
                // Handle zero pivot (Basic implementation: just stop or skip)
                steps.append(LUStep(title: "Zero Pivot", description: "Pivot at (\(k+1),\(k+1)) is zero. LU decomposition without permutation requires non-zero pivots.", latex: "\\text{Zero pivot encountered at } (" + String(k+1) + "," + String(k+1) + ")", matrixL: L, matrixU: U))
                return (steps, L, U)
            }
            
            for i in k+1..<n {
                let val = U[i][k]
                if val != .zero {
                    let multiplier = val / pivot
                    L[i][k] = multiplier
                    
                    // Row operation on U: R_i = R_i - multiplier * R_k
                    for j in k..<n {
                        U[i][j] = U[i][j] - (multiplier * U[k][j])
                    }
                    
                    steps.append(LUStep(
                        title: "Eliminate (\(i+1), \(k+1))",
                        description: "Multiplier m = \(val)/\(pivot) = \(multiplier). Set L[\(i+1)][\(k+1)] = \(multiplier). Update U Row \(i+1) = Row \(i+1) - (\(multiplier)) * Row \(k+1).",
                        latex: "L = " + matLatex(L) + ", \\quad U = " + matLatex(U),
                        matrixL: L,
                        matrixU: U
                    ))
                }
            }
        }
        
        steps.append(LUStep(title: "Result", description: "LU Decomposition complete.", latex: "L = " + matLatex(L) + ", \\quad U = " + matLatex(U), matrixL: L, matrixU: U))
        return (steps, L, U)
    }
    
    // MARK: - Rank-Nullity
    
    static func calculateRankNullity(matrix: [[Fraction]]) -> (rank: Int, nullity: Int, dimensions: String, theoremCheck: String) {
        let rows = matrix.count
        guard rows > 0 else { return (0, 0, "Empty", "") }
        let cols = matrix[0].count
        
        let rrefSteps = calculateRREF(matrix: matrix)
        guard let finalStep = rrefSteps.last else { return (0, 0, "", "") }
        let rref = finalStep.matrix
        
        let pivots = getPivotIndices(rref: rref)
        let rank = pivots.count
        let nullity = cols - rank
        
        let dimStr = "\(rows) × \(cols)"
        let check = "\(rank) + \(nullity) = \(cols)"
        
        return (rank, nullity, dimStr, check)
    }

    // MARK: - SVD
    
    struct SVDStep: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let latex: String
    }
    
    static func calculateSVD(matrix: [[Fraction]]) -> (steps: [SVDStep], U: [[String]], Sigma: [String], V: [[String]]) {
        var steps: [SVDStep] = []
        let m = matrix.count
        guard m > 0 else { return ([], [], [], []) }
        let n = matrix[0].count
        
        // 1. Compute A^T A
        let AT = transpose(matrix)
        let ATA = multiply(matrixA: AT, matrixB: matrix)
        
        // Helper to format matrix for latex
        func matLatex(_ mat: [[Fraction]]) -> String {
            return "\\begin{bmatrix} " + mat.map { row in row.map { $0.description }.joined(separator: " & ") }.joined(separator: "\\\\ ") + " \\end{bmatrix}"
        }
        
        steps.append(SVDStep(title: "1. Compute AᵀA", description: "Compute the symmetric matrix AᵀA.", latex: "A^TA = " + matLatex(ATA)))
        
        // 2. Eigenvalues
        let polyRes = getCharacteristicPolynomial(matrix: ATA)
        let roots = polyRes.roots.sorted(by: >)
        // Filter out small errors/negatives
        let sigmas = roots.map { sqrt(max(0, $0)) }
        
        let rootsStr = roots.map { formatRoot($0) }.joined(separator: ", ")
        steps.append(SVDStep(title: "2. Eigenvalues of AᵀA", description: "Find eigenvalues. These are σ².", latex: "\\lambda = \\{ \(rootsStr) \\}"))
        
        let sigmaStr = sigmas.map { formatRoot($0) }.joined(separator: ", ")
        steps.append(SVDStep(title: "3. Singular Values", description: "σ = √λ.", latex: "\\sigma = \\{ \(sigmaStr) \\}"))
        
        // 3. V (Eigenvectors of A^T A)
        var V_cols: [([Fraction], String)] = [] // Vector and its norm string
        
        // Group roots to handle multiplicity
        var grouped: [Double: [Double]] = [:]
        for r in roots {
            let key = round(r * 1000) / 1000
            grouped[key, default: []].append(r)
        }
        let sortedKeys = grouped.keys.sorted(by: >)
        
        for key in sortedKeys {
            let val = grouped[key]![0] // Representative
            let res = calculateEigenBasis(matrix: ATA, eigenvalue: val)
            var basis = res.basisVectors // Row vectors in logic, but represent columns
            
            // If dimension > 1, Gram Schmidt
            if basis.count > 1 {
                 let cols = transpose(basis)
                 let gs = calculateGramSchmidt(matrix: cols)
                 let orthoCols = gs.orthogonalBasis
                 basis = transpose(orthoCols)
            }
            
            for vec in basis {
                // Calculate norm string
                let normStr = formatNorm(vec)
                V_cols.append((vec, normStr))
            }
        }
        
        // Format V
        var V_str: [[String]] = Array(repeating: Array(repeating: "", count: n), count: n)
        for j in 0..<min(V_cols.count, n) {
            let (vec, normStr) = V_cols[j]
            for i in 0..<n {
                if vec[i] == .zero {
                    V_str[i][j] = "0"
                } else {
                    if normStr == "1" {
                        V_str[i][j] = vec[i].description
                    } else {
                        V_str[i][j] = "\\frac{\(vec[i].description)}{\(normStr)}"
                    }
                }
            }
        }
        
        steps.append(SVDStep(title: "4. Construct V", description: "Normalize eigenvectors of AᵀA to get columns of V.", latex: "V = [v_1 \\dots v_n]"))
        
        // 4. U
        // u_i = (1/sigma_i) A v_i
        var U_str: [[String]] = Array(repeating: Array(repeating: "?", count: min(m, n)), count: m)
        
        for j in 0..<min(m, n) {
            if j < sigmas.count && sigmas[j] > 1e-5 {
                let sigma = sigmas[j]
                let sigmaStr = formatRoot(sigma)
                let v = V_cols[j].0
                let vNormStr = V_cols[j].1
                
                let Av = multiply(matrix: matrix, vector: v)
                
                for i in 0..<m {
                    let val = Av[i]
                    if val == .zero {
                        U_str[i][j] = "0"
                    } else {
                        // val / (sigma * vNorm)
                        // Simplified display
                        let num = val.description
                        let den = (vNormStr == "1") ? sigmaStr : "\(sigmaStr)\\sqrt{\(vNormStr.replacingOccurrences(of: "\\sqrt", with: "").replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: ""))}"
                         U_str[i][j] = "\\frac{\(num)}{\(den)}"
                    }
                }
            } else {
                for i in 0..<m { U_str[i][j] = "0" }
            }
        }
        
        steps.append(SVDStep(title: "5. Construct U", description: "Compute u_i = (1/σ_i)Av_i.", latex: "U = [u_1 \\dots u_r]"))

        let Sigma_str = sigmas.map { formatRoot($0) }
        
        return (steps, U_str, Sigma_str, V_str)
    }
}
