import SwiftUI

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
    case vectorArithmetic = "Vector Arithmetic"
    case linearCombinations = "Linear Combinations"
    case parallelVectors = "Parallel Vectors"
    case leastSquaresInconsistent = "Inconsistent System LS"
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
        case .vectorArithmetic: return "u+v"
        case .linearCombinations: return "c₁v₁"
        case .parallelVectors: return "u||v"
        case .distanceHyperplane: return "dist"
        case .leastSquaresInconsistent: return "LS"
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
        case .vectorArithmetic: return "plus.forwardslash.minus"
        case .linearCombinations: return "arrow.triangle.branch"
        case .parallelVectors: return "equal"
        case .distanceHyperplane: return "arrow.up.to.line"
        case .leastSquaresInconsistent: return "exclamationmark.triangle"
        case .leastSquaresInfinite: return "infinity"
        case .linearRegression: return "chart.xyaxis.line"
        case .quadraticCurveFitting: return "chart.line.uptrend.xyaxis"
        case .settings: return "gear"
        default: return "" // Custom icon for subspaces
        }
    }
}
