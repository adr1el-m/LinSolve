import Foundation

// MARK: - Problem Generator

struct ProblemGenerator {
    
    // MARK: - Main Generation Function
    
    static func generate(topic: ProblemTopic, difficulty: Difficulty) -> GeneratedProblem {
        switch topic {
        case .determinant2x2:
            return generate2x2Determinant(difficulty: difficulty)
        case .determinant3x3:
            return generate3x3Determinant(difficulty: difficulty)
        case .matrixAddition:
            return generateMatrixAddition(difficulty: difficulty)
        case .matrixMultiplication:
            return generateMatrixMultiplication(difficulty: difficulty)
        case .systemSolving:
            return generateSystemProblem(difficulty: difficulty)
        case .matrixInverse:
            return generate2x2Inverse(difficulty: difficulty)
        case .eigenvalues:
            return generateEigenvalues(difficulty: difficulty)
        }
    }
    
    // MARK: - 2x2 Determinant
    
    static func generate2x2Determinant(difficulty: Difficulty) -> GeneratedProblem {
        let range = difficulty.valueRange
        let a = Int.random(in: range)
        let b = Int.random(in: range)
        let c = Int.random(in: range)
        let d = Int.random(in: range)
        
        let det = a * d - b * c
        
        let matrix = [[a, b], [c, d]]
        
        let question = "Calculate the determinant of the 2×2 matrix."
        let hint = "Use the formula: det(A) = ad - bc"
        let solution = """
        det(A) = (\(a))(\(d)) - (\(b))(\(c))
               = \(a * d) - \(b * c)
               = \(det)
        """
        
        return GeneratedProblem(
            topic: .determinant2x2,
            difficulty: difficulty,
            questionText: question,
            matrix: matrix,
            correctAnswer: String(det),
            hint: hint,
            solution: solution
        )
    }
    
    // MARK: - 3x3 Determinant
    
    static func generate3x3Determinant(difficulty: Difficulty) -> GeneratedProblem {
        let range: ClosedRange<Int>
        switch difficulty {
        case .easy: range = -3...3
        case .medium: range = -5...5
        case .hard: range = -7...7
        }
        
        var matrix = [[Int]]()
        for _ in 0..<3 {
            matrix.append((0..<3).map { _ in Int.random(in: range) })
        }
        
        let det = calculate3x3Det(matrix)
        
        let question = "Calculate the determinant of the 3×3 matrix using any method."
        let hint = "Try the Rule of Sarrus: add the products of the three downward diagonals, then subtract the products of the three upward diagonals."
        
        let m = matrix
        let d1 = m[0][0] * m[1][1] * m[2][2]
        let d2 = m[0][1] * m[1][2] * m[2][0]
        let d3 = m[0][2] * m[1][0] * m[2][1]
        let downSum = d1 + d2 + d3
        
        let u1 = m[2][0] * m[1][1] * m[0][2]
        let u2 = m[2][1] * m[1][2] * m[0][0]
        let u3 = m[2][2] * m[1][0] * m[0][1]
        let upSum = u1 + u2 + u3
        
        let solution = """
        Using Rule of Sarrus:
        
        Downward diagonals:
        (\(m[0][0]))(\(m[1][1]))(\(m[2][2])) + (\(m[0][1]))(\(m[1][2]))(\(m[2][0])) + (\(m[0][2]))(\(m[1][0]))(\(m[2][1]))
        = \(d1) + \(d2) + \(d3) = \(downSum)
        
        Upward diagonals:
        (\(m[2][0]))(\(m[1][1]))(\(m[0][2])) + (\(m[2][1]))(\(m[1][2]))(\(m[0][0])) + (\(m[2][2]))(\(m[1][0]))(\(m[0][1]))
        = \(u1) + \(u2) + \(u3) = \(upSum)
        
        det(A) = \(downSum) - \(upSum) = \(det)
        """
        
        return GeneratedProblem(
            topic: .determinant3x3,
            difficulty: difficulty,
            questionText: question,
            matrix: matrix,
            correctAnswer: String(det),
            hint: hint,
            solution: solution
        )
    }
    
    // MARK: - Matrix Addition
    
    static func generateMatrixAddition(difficulty: Difficulty) -> GeneratedProblem {
        let range = difficulty.valueRange
        let rows = difficulty == .hard ? 3 : 2
        let cols = difficulty == .hard ? 3 : 2
        
        var matrixA = [[Int]]()
        var matrixB = [[Int]]()
        var result = [[Int]]()
        
        for _ in 0..<rows {
            var rowA = [Int]()
            var rowB = [Int]()
            var rowR = [Int]()
            for _ in 0..<cols {
                let a = Int.random(in: range)
                let b = Int.random(in: range)
                rowA.append(a)
                rowB.append(b)
                rowR.append(a + b)
            }
            matrixA.append(rowA)
            matrixB.append(rowB)
            result.append(rowR)
        }
        
        let answerStr = result.map { row in row.map { String($0) }.joined(separator: ",") }.joined(separator: ";")
        
        let question = "Calculate A + B. Enter the result matrix (row by row, comma-separated values, rows separated by semicolons)."
        let hint = "Add corresponding elements: (A + B)ᵢⱼ = Aᵢⱼ + Bᵢⱼ"
        
        var solutionLines = ["Adding element by element:"]
        for i in 0..<rows {
            var rowStr = ""
            for j in 0..<cols {
                if j > 0 { rowStr += ", " }
                rowStr += "\(matrixA[i][j]) + \(matrixB[i][j]) = \(result[i][j])"
            }
            solutionLines.append(rowStr)
        }
        solutionLines.append("\nResult: " + answerStr)
        
        return GeneratedProblem(
            topic: .matrixAddition,
            difficulty: difficulty,
            questionText: question,
            matrix: matrixA,
            matrixB: matrixB,
            correctAnswer: answerStr,
            hint: hint,
            solution: solutionLines.joined(separator: "\n")
        )
    }
    
    // MARK: - Matrix Multiplication
    
    static func generateMatrixMultiplication(difficulty: Difficulty) -> GeneratedProblem {
        // Keep it simple: 2x2 × 2x2
        let range: ClosedRange<Int>
        switch difficulty {
        case .easy: range = 0...3
        case .medium: range = -3...3
        case .hard: range = -5...5
        }
        
        let a11 = Int.random(in: range), a12 = Int.random(in: range)
        let a21 = Int.random(in: range), a22 = Int.random(in: range)
        let b11 = Int.random(in: range), b12 = Int.random(in: range)
        let b21 = Int.random(in: range), b22 = Int.random(in: range)
        
        let c11 = a11*b11 + a12*b21
        let c12 = a11*b12 + a12*b22
        let c21 = a21*b11 + a22*b21
        let c22 = a21*b12 + a22*b22
        
        let matrixA = [[a11, a12], [a21, a22]]
        let matrixB = [[b11, b12], [b21, b22]]
        
        let answerStr = "\(c11),\(c12);\(c21),\(c22)"
        
        let question = "Calculate A × B. Enter the result matrix (row by row, comma-separated values, rows separated by semicolons)."
        let hint = "Each entry Cᵢⱼ = (row i of A) · (column j of B)"
        
        let solution = """
        C₁₁ = (\(a11))(\(b11)) + (\(a12))(\(b21)) = \(a11*b11) + \(a12*b21) = \(c11)
        C₁₂ = (\(a11))(\(b12)) + (\(a12))(\(b22)) = \(a11*b12) + \(a12*b22) = \(c12)
        C₂₁ = (\(a21))(\(b11)) + (\(a22))(\(b21)) = \(a21*b11) + \(a22*b21) = \(c21)
        C₂₂ = (\(a21))(\(b12)) + (\(a22))(\(b22)) = \(a21*b12) + \(a22*b22) = \(c22)
        
        Result: \(answerStr)
        """
        
        return GeneratedProblem(
            topic: .matrixMultiplication,
            difficulty: difficulty,
            questionText: question,
            matrix: matrixA,
            matrixB: matrixB,
            correctAnswer: answerStr,
            hint: hint,
            solution: solution
        )
    }
    
    // MARK: - System Solving (2x2)
    
    static func generateSystemProblem(difficulty: Difficulty) -> GeneratedProblem {
        // Generate a system with integer solution
        let x = Int.random(in: -5...5)
        let y = Int.random(in: -5...5)
        
        var a1, b1, a2, b2: Int
        
        repeat {
            a1 = Int.random(in: 1...5)
            b1 = Int.random(in: -5...5)
            a2 = Int.random(in: -5...5)
            b2 = Int.random(in: 1...5)
        } while (a1 * b2 - a2 * b1 == 0)  // Ensure unique solution
        
        let c1 = a1 * x + b1 * y
        let c2 = a2 * x + b2 * y
        
        let matrix = [[a1, b1, c1], [a2, b2, c2]]  // Augmented matrix
        
        let question = "Solve the system:\n\(a1)x + \(b1)y = \(c1)\n\(a2)x + \(b2)y = \(c2)\n\nEnter x,y (comma-separated)."
        let hint = "Use substitution, elimination, or Cramer's rule."
        
        let det = a1 * b2 - a2 * b1
        let detX = c1 * b2 - c2 * b1
        let detY = a1 * c2 - a2 * c1
        
        let solution = """
        Using Cramer's Rule:
        
        det(A) = (\(a1))(\(b2)) - (\(a2))(\(b1)) = \(det)
        
        det(Aₓ) = (\(c1))(\(b2)) - (\(c2))(\(b1)) = \(detX)
        x = det(Aₓ)/det(A) = \(detX)/\(det) = \(x)
        
        det(Aᵧ) = (\(a1))(\(c2)) - (\(a2))(\(c1)) = \(detY)
        y = det(Aᵧ)/det(A) = \(detY)/\(det) = \(y)
        
        Solution: x = \(x), y = \(y)
        """
        
        return GeneratedProblem(
            topic: .systemSolving,
            difficulty: difficulty,
            questionText: question,
            matrix: matrix,
            correctAnswer: "\(x),\(y)",
            hint: hint,
            solution: solution
        )
    }
    
    // MARK: - 2x2 Inverse
    
    static func generate2x2Inverse(difficulty: Difficulty) -> GeneratedProblem {
        var a, b, c, d, det: Int
        
        // Ensure invertible matrix with integer-friendly inverse
        repeat {
            a = Int.random(in: -4...4)
            b = Int.random(in: -4...4)
            c = Int.random(in: -4...4)
            d = Int.random(in: -4...4)
            det = a * d - b * c
        } while det == 0 || abs(det) > 4  // Keep determinant small for nicer fractions
        
        let matrix = [[a, b], [c, d]]
        
        // Inverse = (1/det) * [[d, -b], [-c, a]]
        // We'll accept fractional answers
        let question = "Find the inverse of the matrix. Enter as: a,b;c,d (use fractions like 1/2 if needed)"
        let hint = "For a 2×2 matrix, A⁻¹ = (1/det) × [[d, -b], [-c, a]]"
        
        let solution = """
        det(A) = (\(a))(\(d)) - (\(b))(\(c)) = \(det)
        
        A⁻¹ = (1/\(det)) × ┌  \(d)  \(-b) ┐
                          └ \(-c)   \(a) ┘
        
        A⁻¹ = ┌ \(d)/\(det)  \(-b)/\(det) ┐
              └ \(-c)/\(det)  \(a)/\(det) ┘
        
        Simplified: \(simplifyFraction(d, det)),\(simplifyFraction(-b, det));\(simplifyFraction(-c, det)),\(simplifyFraction(a, det))
        """
        
        let answer = "\(simplifyFraction(d, det)),\(simplifyFraction(-b, det));\(simplifyFraction(-c, det)),\(simplifyFraction(a, det))"
        
        return GeneratedProblem(
            topic: .matrixInverse,
            difficulty: difficulty,
            questionText: question,
            matrix: matrix,
            correctAnswer: answer,
            hint: hint,
            solution: solution
        )
    }
    
    // MARK: - Eigenvalues (2x2)
    
    static func generateEigenvalues(difficulty: Difficulty) -> GeneratedProblem {
        // Create matrix with known integer eigenvalues
        let lambda1 = Int.random(in: -3...3)
        let lambda2 = Int.random(in: -3...3)
        
        // Trace = lambda1 + lambda2, Det = lambda1 * lambda2
        // For simplicity, use diagonal matrix sometimes
        let useDiagonal = Bool.random()
        
        var a, b, c, d: Int
        
        if useDiagonal || difficulty == .easy {
            a = lambda1
            b = 0
            c = 0
            d = lambda2
        } else {
            // Create a non-diagonal matrix with these eigenvalues
            // Using trace and determinant
            a = lambda1
            d = lambda2
            b = Int.random(in: 1...2)
            c = 0  // Upper triangular has diagonal as eigenvalues
        }
        
        let matrix = [[a, b], [c, d]]
        let sortedLambdas = [lambda1, lambda2].sorted()
        
        let question = "Find the eigenvalues of the matrix. Enter them comma-separated (smaller first)."
        let hint = "Eigenvalues satisfy det(A - λI) = 0. For 2×2: λ² - (trace)λ + det = 0"
        
        let trace = a + d
        let det = a * d - b * c
        
        let solution = """
        Characteristic equation: det(A - λI) = 0
        
        |(\(a) - λ)    \(b)   |
        |   \(c)    (\(d) - λ)| = 0
        
        (\(a) - λ)(\(d) - λ) - (\(b))(\(c)) = 0
        λ² - \(trace)λ + \(det) = 0
        
        Eigenvalues: λ₁ = \(sortedLambdas[0]), λ₂ = \(sortedLambdas[1])
        """
        
        return GeneratedProblem(
            topic: .eigenvalues,
            difficulty: difficulty,
            questionText: question,
            matrix: matrix,
            correctAnswer: sortedLambdas.map { String($0) }.joined(separator: ","),
            hint: hint,
            solution: solution
        )
    }
    
    // MARK: - Helper Functions
    
    static func calculate3x3Det(_ m: [[Int]]) -> Int {
        let d1 = m[0][0] * m[1][1] * m[2][2]
        let d2 = m[0][1] * m[1][2] * m[2][0]
        let d3 = m[0][2] * m[1][0] * m[2][1]
        
        let u1 = m[2][0] * m[1][1] * m[0][2]
        let u2 = m[2][1] * m[1][2] * m[0][0]
        let u3 = m[2][2] * m[1][0] * m[0][1]
        
        return (d1 + d2 + d3) - (u1 + u2 + u3)
    }
    
    static func simplifyFraction(_ num: Int, _ den: Int) -> String {
        if num == 0 { return "0" }
        if num % den == 0 { return String(num / den) }
        
        let g = gcd(abs(num), abs(den))
        let n = num / g
        let d = den / g
        
        if d < 0 {
            return "\(-n)/\(-d)"
        }
        return "\(n)/\(d)"
    }
    
    static func gcd(_ a: Int, _ b: Int) -> Int {
        return b == 0 ? a : gcd(b, a % b)
    }
}
