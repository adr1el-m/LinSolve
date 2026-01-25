import SwiftUI

/// Sidebar navigation view with search and categorized topics
/// Organized to follow a pedagogically sound linear algebra learning path
struct SidebarView: View {
    @Binding var selectedSection: AppSection?
    @State private var searchText = ""
    
    // Filter sections based on search text
    var filteredSections: [AppSection] {
        if searchText.isEmpty {
            return AppSection.allCases
        } else {
            return AppSection.allCases.filter { section in
                section.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List(selection: $selectedSection) {
            if searchText.isEmpty {
                gettingStartedSection
                foundationsSection
                linearSystemsSection
                determinantsSection
                vectorSpacesSection
                orthogonalitySection
                transformationsSection
                eigentheorySection
                applicationsSection
                visualizationSection
                practiceSection
                settingsSection
                footerSection
            } else {
                // Search Results
                ForEach(filteredSections) { section in
                    NavigationLink(value: section) {
                        Label(section.rawValue, systemImage: section.iconName)
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .searchable(text: $searchText, placement: .sidebar, prompt: "Search Topics")
    }
    
    // MARK: - Getting Started
    private var gettingStartedSection: some View {
        Section(header: Text("Getting Started")) {
            NavigationLink(value: AppSection.introduction) {
                Label(AppSection.introduction.rawValue, systemImage: AppSection.introduction.iconName)
            }
            NavigationLink(value: AppSection.matrixSetup) {
                Label("Matrix Calculator", systemImage: AppSection.matrixSetup.iconName)
            }
        }
    }
    
    // MARK: - Part I: Foundations
    private var foundationsSection: some View {
        Section(header: Text("Part I: Foundations")) {
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.vectorArithmetic) {
                        Label("Vector Addition & Subtraction", systemImage: AppSection.vectorArithmetic.iconName)
                    }
                    NavigationLink(value: AppSection.normalizationScaling) {
                        Label("Scalar Multiplication & Norms", systemImage: AppSection.normalizationScaling.iconName)
                    }
                    NavigationLink(value: AppSection.linearCombinations) {
                        Label("Linear Combinations", systemImage: AppSection.linearCombinations.iconName)
                    }
                    NavigationLink(value: AppSection.parallelVectors) {
                        Label("Parallel & Collinear Vectors", systemImage: AppSection.parallelVectors.iconName)
                    }
                },
                label: {
                    Label("1. Vectors", systemImage: "arrow.up.right")
                }
            )
            
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.matrixArithmetic) {
                        Label("Matrix Addition & Subtraction", systemImage: AppSection.matrixArithmetic.iconName)
                    }
                    NavigationLink(value: AppSection.matrixMultiplication) {
                        Label("Matrix Multiplication", systemImage: AppSection.matrixMultiplication.iconName)
                    }
                    NavigationLink(value: AppSection.transposeOperations) {
                        Label("Transpose Operations", systemImage: AppSection.transposeOperations.iconName)
                    }
                    NavigationLink(value: AppSection.matrixExponents) {
                        Label("Matrix Powers", systemImage: AppSection.matrixExponents.iconName)
                    }
                    NavigationLink(value: AppSection.specialMatrixTypes) {
                        Label("Special Matrix Types", systemImage: AppSection.specialMatrixTypes.iconName)
                    }
                },
                label: {
                    Label("2. Matrix Operations", systemImage: "square.grid.3x3")
                }
            )
        }
    }
    
    // MARK: - Part II: Linear Systems
    private var linearSystemsSection: some View {
        Section(header: Text("Part II: Linear Systems")) {
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.verifySolutions) {
                        Label("Understanding Solutions", systemImage: AppSection.verifySolutions.iconName)
                    }
                    NavigationLink(value: AppSection.gaussianElimination) {
                        Label("Gaussian Elimination", systemImage: AppSection.gaussianElimination.iconName)
                    }
                    NavigationLink(value: AppSection.refRref) {
                        Label("Row Echelon Forms", systemImage: AppSection.refRref.iconName)
                    }
                    NavigationLink(value: AppSection.gaussJordan) {
                        Label("Gauss-Jordan Method", systemImage: AppSection.gaussJordan.iconName)
                    }
                    NavigationLink(value: AppSection.rankNullity) {
                        Label("Rank-Nullity Theorem", systemImage: AppSection.rankNullity.iconName)
                    }
                },
                label: {
                    Label("3. Solving Systems", systemImage: "equal.square")
                }
            )
            
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.inverse2x2Formula) {
                        Label("2×2 Inverse Formula", systemImage: AppSection.inverse2x2Formula.iconName)
                    }
                    NavigationLink(value: AppSection.inverseGaussJordan) {
                        Label("Inverse via Gauss-Jordan", systemImage: AppSection.inverseGaussJordan.iconName)
                    }
                    NavigationLink(value: AppSection.solveWithInverse) {
                        Label("Solving Ax = b", systemImage: AppSection.solveWithInverse.iconName)
                    }
                    NavigationLink(value: AppSection.elementaryMatrices) {
                        Label("Elementary Matrices", systemImage: AppSection.elementaryMatrices.iconName)
                    }
                },
                label: {
                    Label("4. Matrix Inverses", systemImage: "arrow.uturn.backward.square")
                }
            )
        }
    }
    
    // MARK: - Part III: Determinants
    private var determinantsSection: some View {
        Section(header: Text("Part III: Determinants")) {
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.basicDeterminantCalc) {
                        Label("Computing Determinants", systemImage: AppSection.basicDeterminantCalc.iconName)
                    }
                    NavigationLink(value: AppSection.determinantProperties) {
                        Label("Properties", systemImage: AppSection.determinantProperties.iconName)
                    }
                    NavigationLink(value: AppSection.permutationsInversions) {
                        Label("Permutations & Sign", systemImage: AppSection.permutationsInversions.iconName)
                    }
                    NavigationLink(value: AppSection.geometricApplications) {
                        Label("Geometric Meaning", systemImage: AppSection.geometricApplications.iconName)
                    }
                },
                label: {
                    Label("5. Determinant Basics", systemImage: "sum")
                }
            )
            
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.cofactorExpansionMethod) {
                        Label("Cofactor Expansion", systemImage: AppSection.cofactorExpansionMethod.iconName)
                    }
                    NavigationLink(value: AppSection.adjugateInverse) {
                        Label("Adjugate & Inverse", systemImage: AppSection.adjugateInverse.iconName)
                    }
                    NavigationLink(value: AppSection.cramersRule) {
                        Label("Cramer's Rule", systemImage: AppSection.cramersRule.iconName)
                    }
                },
                label: {
                    Label("6. Advanced Methods", systemImage: "rectangle.split.3x3")
                }
            )
        }
    }
    
    // MARK: - Part IV: Vector Spaces
    private var vectorSpacesSection: some View {
        Section(header: Text("Part IV: Vector Spaces")) {
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.subspaceVerification) {
                        Label("What is a Subspace?", systemImage: AppSection.subspaceVerification.iconName)
                    }
                    NavigationLink(value: AppSection.subspaceOperations) {
                        Label("Subspace Operations", systemImage: AppSection.subspaceOperations.iconName)
                    }
                    NavigationLink(value: AppSection.spanningSets) {
                        Label("Spanning Sets", systemImage: AppSection.spanningSets.iconName)
                    }
                },
                label: {
                    Label("7. Subspaces", systemImage: "rectangle.stack")
                }
            )
            
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.linearIndependenceBasic) {
                        Label("Definition & Testing", systemImage: AppSection.linearIndependenceBasic.iconName)
                    }
                    NavigationLink(value: AppSection.linearIndependenceAlgorithms) {
                        Label("Algorithms", systemImage: AppSection.linearIndependenceAlgorithms.iconName)
                    }
                },
                label: {
                    Label("8. Linear Independence", systemImage: "line.3.horizontal.decrease.circle")
                }
            )
            
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.basisVerification) {
                        Label("What is a Basis?", systemImage: AppSection.basisVerification.iconName)
                    }
                    NavigationLink(value: AppSection.findingBases) {
                        Label("Finding Bases", systemImage: AppSection.findingBases.iconName)
                    }
                    NavigationLink(value: AppSection.constructingBases) {
                        Label("Constructing Bases", systemImage: AppSection.constructingBases.iconName)
                    }
                    NavigationLink(value: AppSection.intersectionsExtensions) {
                        Label("Intersections & Extensions", systemImage: AppSection.intersectionsExtensions.iconName)
                    }
                },
                label: {
                    Label("9. Basis & Dimension", systemImage: "cube")
                }
            )
            
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.columnSpace) {
                        Label("Column Space C(A)", systemImage: "arrow.up.right.square")
                    }
                    NavigationLink(value: AppSection.nullSpace) {
                        Label("Null Space N(A)", systemImage: "circle.dashed.inset.filled")
                    }
                    NavigationLink(value: AppSection.rowSpace) {
                        Label("Row Space C(Aᵀ)", systemImage: "tablecells")
                    }
                    NavigationLink(value: AppSection.leftNullSpace) {
                        Label("Left Null Space N(Aᵀ)", systemImage: "arrow.uturn.left.square")
                    }
                    NavigationLink(value: AppSection.fundamentalSubspaces) {
                        Label("The Big Picture", systemImage: AppSection.fundamentalSubspaces.iconName)
                    }
                },
                label: {
                    Label("10. Fundamental Subspaces", systemImage: "square.stack.3d.up")
                }
            )
        }
    }
    
    // MARK: - Part V: Orthogonality
    private var orthogonalitySection: some View {
        Section(header: Text("Part V: Orthogonality")) {
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.dotProductApplication) {
                        Label("The Dot Product", systemImage: AppSection.dotProductApplication.iconName)
                    }
                    NavigationLink(value: AppSection.anglesBetweenVectors) {
                        Label("Angles Between Vectors", systemImage: AppSection.anglesBetweenVectors.iconName)
                    }
                    NavigationLink(value: AppSection.orthogonalSets) {
                        Label("Orthogonal Sets", systemImage: AppSection.orthogonalSets.iconName)
                    }
                    NavigationLink(value: AppSection.verifyingOrthogonalSets) {
                        Label("Verifying Orthogonality", systemImage: AppSection.verifyingOrthogonalSets.iconName)
                    }
                },
                label: {
                    Label("11. Inner Products", systemImage: "circle.grid.cross")
                }
            )
            
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.orthogonalProjection) {
                        Label("Orthogonal Projection", systemImage: AppSection.orthogonalProjection.iconName)
                    }
                    NavigationLink(value: AppSection.gramSchmidtProcess) {
                        Label("Gram-Schmidt Process", systemImage: AppSection.gramSchmidtProcess.iconName)
                    }
                    NavigationLink(value: AppSection.orthogonalComplements) {
                        Label("Orthogonal Complements", systemImage: AppSection.orthogonalComplements.iconName)
                    }
                },
                label: {
                    Label("12. Orthogonal Bases", systemImage: "dot.circle.and.hand.point.up.left.fill")
                }
            )
            
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.projectionMatrices) {
                        Label("Projection Matrices", systemImage: AppSection.projectionMatrices.iconName)
                    }
                    NavigationLink(value: AppSection.computingProjections) {
                        Label("Computing Projections", systemImage: AppSection.computingProjections.iconName)
                    }
                    NavigationLink(value: AppSection.projectionOrthogonalComplement) {
                        Label("Projection to Complement", systemImage: AppSection.projectionOrthogonalComplement.iconName)
                    }
                },
                label: {
                    Label("13. Projection Theorem", systemImage: "arrow.up.and.down.square.fill")
                }
            )
        }
    }
    
    // MARK: - Part VI: Transformations
    private var transformationsSection: some View {
        Section(header: Text("Part VI: Transformations")) {
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.matrixTransformations) {
                        Label("Matrices as Transformations", systemImage: AppSection.matrixTransformations.iconName)
                    }
                    NavigationLink(value: AppSection.checkingLinearity) {
                        Label("Checking Linearity", systemImage: AppSection.checkingLinearity.iconName)
                    }
                    NavigationLink(value: AppSection.transformationsFromBasis) {
                        Label("Finding the Matrix", systemImage: AppSection.transformationsFromBasis.iconName)
                    }
                    NavigationLink(value: AppSection.kernelAndRange) {
                        Label("Kernel and Range", systemImage: AppSection.kernelAndRange.iconName)
                    }
                },
                label: {
                    Label("14. Linear Transformations", systemImage: "arrow.forward.square")
                }
            )
            
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.compositionOfTransformations) {
                        Label("Composition", systemImage: AppSection.compositionOfTransformations.iconName)
                    }
                    NavigationLink(value: AppSection.invertingLinearOperators) {
                        Label("Invertible Operators", systemImage: AppSection.invertingLinearOperators.iconName)
                    }
                },
                label: {
                    Label("15. Composition & Inverses", systemImage: "arrow.2.squarepath")
                }
            )
            
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.verifyingIsometries) {
                        Label("What is an Isometry?", systemImage: AppSection.verifyingIsometries.iconName)
                    }
                    NavigationLink(value: AppSection.rotationsReflections) {
                        Label("Rotations & Reflections", systemImage: AppSection.rotationsReflections.iconName)
                    }
                    NavigationLink(value: AppSection.analyzingOrthogonalMatrices) {
                        Label("Orthogonal Matrices", systemImage: AppSection.analyzingOrthogonalMatrices.iconName)
                    }
                },
                label: {
                    Label("16. Isometries", systemImage: "rotate.right")
                }
            )
        }
    }
    
    // MARK: - Part VII: Eigentheory
    private var eigentheorySection: some View {
        Section(header: Text("Part VII: Eigentheory")) {
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.eigenvalues) {
                        Label("Finding Eigenvalues", systemImage: AppSection.eigenvalues.iconName)
                    }
                    NavigationLink(value: AppSection.eigenvectors) {
                        Label("Finding Eigenvectors", systemImage: AppSection.eigenvectors.iconName)
                    }
                },
                label: {
                    Label("17. Eigenvalues & Eigenvectors", systemImage: "function")
                }
            )
            
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.diagonalization) {
                        Label("Diagonalizing Matrices", systemImage: AppSection.diagonalization.iconName)
                    }
                    NavigationLink(value: AppSection.orthogonalDiagonalization) {
                        Label("Orthogonal Diagonalization", systemImage: AppSection.orthogonalDiagonalization.iconName)
                    }
                },
                label: {
                    Label("18. Diagonalization", systemImage: "arrow.triangle.2.circlepath")
                }
            )
        }
    }
    
    // MARK: - Part VIII: Applications
    private var applicationsSection: some View {
        Section(header: Text("Part VIII: Applications")) {
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.distanceHyperplane) {
                        Label("Distance to Hyperplane", systemImage: AppSection.distanceHyperplane.iconName)
                    }
                    NavigationLink(value: AppSection.leastSquaresInconsistent) {
                        Label("Inconsistent Systems", systemImage: AppSection.leastSquaresInconsistent.iconName)
                    }
                    NavigationLink(value: AppSection.leastSquaresInfinite) {
                        Label("Infinite Solutions", systemImage: AppSection.leastSquaresInfinite.iconName)
                    }
                    NavigationLink(value: AppSection.linearRegression) {
                        Label("Linear Regression", systemImage: AppSection.linearRegression.iconName)
                    }
                    NavigationLink(value: AppSection.quadraticCurveFitting) {
                        Label("Curve Fitting", systemImage: AppSection.quadraticCurveFitting.iconName)
                    }
                },
                label: {
                    Label("19. Least Squares", systemImage: "chart.line.uptrend.xyaxis")
                }
            )
            
            DisclosureGroup(
                content: {
                    NavigationLink(value: AppSection.gramSchmidt) {
                        Label("QR Factorization", systemImage: AppSection.gramSchmidt.iconName)
                    }
                    NavigationLink(value: AppSection.luDecomposition) {
                        Label("LU Decomposition", systemImage: AppSection.luDecomposition.iconName)
                    }
                    NavigationLink(value: AppSection.svd) {
                        Label("SVD (Advanced)", systemImage: AppSection.svd.iconName)
                    }
                },
                label: {
                    Label("20. Matrix Factorizations", systemImage: "square.stack.3d.forward.dottedline")
                }
            )
        }
    }
    
    // MARK: - Visualization
    private var visualizationSection: some View {
        Section(header: Text("Visualization")) {
            NavigationLink(value: AppSection.geometric) {
                Label("3D Vector Visualization", systemImage: AppSection.geometric.iconName)
            }
            NavigationLink(value: AppSection.transformation2D) {
                Label("2D Transformations", systemImage: AppSection.transformation2D.iconName)
            }
        }
    }
    
    // MARK: - Practice & Tools
    private var practiceSection: some View {
        Section(header: Text("Practice & Tools")) {
            NavigationLink(value: AppSection.practiceProblems) {
                Label("Practice Problems", systemImage: AppSection.practiceProblems.iconName)
            }
            NavigationLink(value: AppSection.examMode) {
                Label("Exam Mode", systemImage: AppSection.examMode.iconName)
            }
            NavigationLink(value: AppSection.pdfExport) {
                Label("Export Solutions", systemImage: AppSection.pdfExport.iconName)
            }
        }
    }
    
    // MARK: - Settings
    private var settingsSection: some View {
        Section {
            NavigationLink(value: AppSection.settings) {
                Label("Settings", systemImage: "gear")
            }
        }
    }
    
    // MARK: - Footer
    private var footerSection: some View {
        Section {
            VStack(spacing: 8) {
                Image(systemName: "graduationcap.fill")
                    .font(.title2)
                    .foregroundColor(.accentColor)
                Text("LinSolve")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("A comprehensive linear algebra learning companion")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                Divider()
                    .padding(.vertical, 4)
                Text("Created by Adriel Magalona")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text("Swift Student Challenge 2026")
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.accentColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .listRowBackground(Color.clear)
        }
    }
}
