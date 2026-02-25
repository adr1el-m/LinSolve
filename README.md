<p align="center">
  <img src="icon.png" width="200" height="200" alt="LinSolve App Icon" style="border-radius: 40px;">
</p>

<h1 align="center">LinSolve</h1>

<p align="center">
  <strong>A comprehensive linear algebra toolkit built entirely in SwiftUI</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Swift_Student_Challenge-2026-orange?style=for-the-badge&logo=swift&logoColor=white" alt="Swift Student Challenge 2026">
  <img src="https://img.shields.io/badge/SwiftUI-5.0-blue?style=for-the-badge&logo=swift&logoColor=white" alt="SwiftUI">
  <img src="https://img.shields.io/badge/Platform-iOS_16+-lightgrey?style=for-the-badge&logo=apple&logoColor=white" alt="iOS 16+">
  <img src="https://img.shields.io/badge/Swift_Playgrounds-App-purple?style=for-the-badge&logo=swift&logoColor=white" alt="Swift Playgrounds">
</p>

<p align="center">
  <em>From fundamentals to eigentheory — learn, compute, and visualize linear algebra on iPad and iPhone.</em>
</p>

---

## About

**LinSolve** is a Swift Playground App built for the **Apple Swift Student Challenge 2026**. It transforms the way students learn and interact with linear algebra by providing an all-in-one toolkit that combines step-by-step computation, interactive 3D visualization, practice problems, and timed exam simulations — all running natively on-device with zero dependencies.

The app covers the **complete undergraduate linear algebra curriculum** across 70+ topics, from basic vector arithmetic to Singular Value Decomposition, with every computation broken down into detailed, educational steps.

---

## Features

### Computation Engine
- **Exact fraction arithmetic** — all computations use rational numbers, eliminating floating-point errors
- **Step-by-step solutions** — every operation is broken down with elementary row operation notation (e.g., `R₂ → R₂ - 2R₁`)
- **1,800+ line matrix engine** — a custom-built solver supporting matrices of arbitrary dimensions

### 70+ Linear Algebra Topics

<details>
<summary><strong>Foundations</strong></summary>

- Vector Arithmetic & Linear Combinations
- Parallel Vectors & Dot Products
- Complex Vector Arithmetic
- Normalization & Scaling
- Angles Between Vectors
- Orthogonal Sets

</details>

<details>
<summary><strong>Matrix Operations</strong></summary>

- Matrix Arithmetic (Addition, Subtraction)
- Matrix Multiplication & Powers
- Transpose Operations
- Special Matrix Types (Symmetric, Diagonal, Triangular, etc.)

</details>

<details>
<summary><strong>Linear Systems</strong></summary>

- Gaussian Elimination
- REF & RREF
- Gauss-Jordan Method
- Verify Solutions

</details>

<details>
<summary><strong>Nonsingular Matrices</strong></summary>

- 2×2 Inverse Formula
- Inverse via Gauss-Jordan
- Solve with Inverse
- Elementary Matrices

</details>

<details>
<summary><strong>Determinants</strong></summary>

- Permutations & Inversions
- Basic Determinant Calculation
- Geometric Applications (Areas, Volumes)
- Determinant Properties

</details>

<details>
<summary><strong>Cofactor Expansion</strong></summary>

- Cofactor Expansion Method
- Adjugate & Inverse
- Cramer's Rule
- Orthogonal Diagonalization

</details>

<details>
<summary><strong>Vector Spaces & Subspaces</strong></summary>

- Subspace Verification & Operations
- Spanning Sets
- Linear Independence (Basic & Algorithmic)
- Finding, Verifying & Constructing Bases
- Intersections & Extensions
- Rank-Nullity Theorem

</details>

<details>
<summary><strong>Fundamental Subspaces</strong></summary>

- Null Space N(A) & Column Space C(A)
- Row Space C(Aᵀ) & Left Null Space N(Aᵀ)
- Orthogonal Complements
- Symmetric Matrix Products (AᵀA)

</details>

<details>
<summary><strong>Orthogonality & Projections</strong></summary>

- Inner Product & Orthogonality
- Verifying Orthogonal Sets
- Orthogonal Projection
- Gram-Schmidt Process & QR Factorization
- Projection Matrices
- Computing Projections & Complements

</details>

<details>
<summary><strong>Eigentheory</strong></summary>

- Eigenvalues & Eigenvectors
- Diagonalization (PDP⁻¹)
- Orthogonal Diagonalization (QᵀAQ)

</details>

<details>
<summary><strong>Transformations</strong></summary>

- Matrix Transformations & Linearity Checking
- Transformations from Basis
- Linear Isometries (Verifying, Rotations, Reflections)
- Analyzing Orthogonal Matrices
- Composition of Transformations
- Inverting Linear Operators
- Kernel and Range

</details>

<details>
<summary><strong>Advanced Applications</strong></summary>

- LU Decomposition
- Singular Value Decomposition (UΣVᵀ)
- Least Squares (Inconsistent & Infinite Solutions)
- Linear Regression & Quadratic Curve Fitting
- Distance to Hyperplane

</details>

### Interactive Visualization
- **Custom 3D subspace plotter** — built from scratch using SwiftUI Canvas and SIMD
- **2D transformation visualizer** — see how matrices transform geometric shapes in real-time
- **Gesture-driven rotation & zoom** — manipulate 3D plots with intuitive touch controls
- **Coordinate planes, tick marks, and bounding boxes** — professional-grade visual output

### Study & Practice Tools
- **Practice Problems** — auto-generated problems across 7 topic categories with 3 difficulty levels
- **Exam Mode** — timed assessments with configurable question count, topic selection, and difficulty
- **PDF Export** — generate professional solution documents with full step-by-step workings
- **Speech Synthesis** — accessibility-first design with VoiceOver-compatible spoken solutions
- **Haptic Feedback** — tactile responses for discoveries, warnings, and interactions

### Architecture
- **112 Swift files** across a modular, clean architecture
- **NavigationSplitView** with a categorized sidebar following a pedagogical learning path
- **SwiftUI-native** — no UIKit wrappers, no third-party dependencies
- **Dark mode & system theme** support via `@AppStorage`
- **iPad & iPhone** optimized with responsive layouts

---

## Project Structure

```
LinSolve/
├── Package.swift                    # Swift Playground App Package manifest
├── icon.png                         # App icon (1024×1024)
├── App/
│   ├── MyApp.swift                  # @main entry point
│   ├── ContentView.swift            # Root NavigationSplitView
│   ├── Assets.xcassets/             # Asset catalog with app icon
│   ├── Core/
│   │   ├── MatrixEngine.swift       # Fraction arithmetic & matrix solver (1,840 lines)
│   │   ├── DetailView.swift         # Central routing for 70+ sections
│   │   └── SoundManager.swift       # Haptics & speech synthesis
│   ├── Models/
│   │   ├── AppSection.swift         # Topic enum with icons & notation
│   │   ├── MatrixData.swift         # Observable matrix state
│   │   └── PracticeData.swift       # Practice/exam data models
│   ├── Utils/
│   │   ├── Extensions.swift         # Subscript string helpers
│   │   ├── Math3D.swift             # SIMD-based 3D math (rotation, projection)
│   │   ├── PDFGenerator.swift       # Solution PDF rendering
│   │   └── ProblemGenerator.swift   # Auto-generated practice problems
│   └── Views/
│       ├── BasisDimension/          # Basis construction & verification
│       ├── CofactorExpansion/       # Cofactors, adjugate, Cramer's rule
│       ├── Components/              # 14 reusable UI components
│       ├── Determinants/            # Determinant methods & properties
│       ├── Dimension/               # Spanning sets, subspace operations
│       ├── DotProducts/             # Dot products, norms, orthogonality
│       ├── Eigen/                   # Eigenvalues, eigenvectors, diagonalization
│       ├── FundamentalSpaces/       # N(A), C(A), C(Aᵀ), N(Aᵀ)
│       ├── Geometric/               # 3D plotter & 2D transformations
│       ├── Introduction/            # Welcome & getting started
│       ├── InvertibleLinearOperators/
│       ├── LeastSquares/            # Least squares & regression
│       ├── LinearIndependence/      # Independence & basis finding
│       ├── LinearIsometries/        # Isometries, rotations, reflections
│       ├── LinearSystems/           # Gaussian elimination, REF/RREF
│       ├── LinearTransformations/   # Linearity, matrix transformations
│       ├── MatrixOperations/        # Arithmetic, multiplication, powers
│       ├── MatrixOps/               # Inverse, determinant, SVD, LU, QR
│       ├── Navigation/              # Sidebar with search
│       ├── NonsingularMatrices/     # Inverse methods, elementary matrices
│       ├── Orthogonality/           # Inner products
│       ├── OrthonormalBases/        # Gram-Schmidt, orthogonal projection
│       ├── ProjectionTheorem/       # Projection matrices & complements
│       ├── Settings/                # Theme configuration
│       ├── Subspaces/               # Null, column, row space details
│       ├── Tools/                   # Exam mode, practice, PDF export
│       └── Vectors/                 # Vector arithmetic & combinations
```

---

## Requirements

| Requirement | Version |
|---|---|
| **Swift** | 5.8+ |
| **iOS** | 16.0+ |
| **Xcode** | 14.0+ |
| **Swift Playgrounds** | 4.0+ |

---

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/LinSolve.git
   ```

2. **Open in Swift Playgrounds or Xcode**
   - Double-click `Package.swift` to open in Xcode
   - Or open the `.swiftpm` package directly in Swift Playgrounds on iPad/Mac

3. **Build & Run**
   - Select an iPad or iPhone simulator (iOS 16+)
   - Press ⌘R to build and run

> **No dependencies required.** LinSolve is built entirely with Apple's native frameworks.

---

## Technologies

| Technology | Usage |
|---|---|
| **SwiftUI** | Entire UI layer — views, navigation, animations |
| **Swift Playground App Package** | Distribution format for SSC submission |
| **SIMD** | Hardware-accelerated 3D vector math |
| **Canvas** | Custom 3D rendering without SceneKit/Metal |
| **PDFKit + UIGraphicsPDFRenderer** | Solution document generation |
| **AVFoundation** | Speech synthesis for accessibility |
| **CoreHaptics** | Tactile feedback system |

---

## Design Philosophy

- **Education-first** — Every computation shows its work. No black boxes.
- **Exact arithmetic** — Fraction-based math preserves precision that floating-point cannot.
- **Zero dependencies** — Ships as a self-contained Swift Playground App.
- **Accessibility** — VoiceOver-compatible with spoken solutions and haptic feedback.
- **Pedagogical ordering** — Topics flow from foundations → systems → spaces → eigentheory → applications.

---

## Swift Student Challenge 2026

This project was created as a submission to the **Apple Swift Student Challenge 2026**. It demonstrates:

- Mastery of **SwiftUI** and modern Swift patterns
- Deep domain knowledge in **linear algebra**
- Custom **rendering engine** for 3D mathematical visualization
- Comprehensive **educational design** covering a full university course
- **Accessibility** and inclusive design principles
- Scalable, modular **software architecture** across 112 source files

---

## License

This project is submitted for the Apple Swift Student Challenge 2026.

---

<p align="center">
  Built with ❤️ and Swift
</p>
