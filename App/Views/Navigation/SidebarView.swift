import SwiftUI

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
                // Topic Sections
                Group {
                    Section(header: Text("Topics")) {
                        // 1. Introduction
                        NavigationLink(value: AppSection.introduction) {
                            Label(AppSection.introduction.rawValue, systemImage: AppSection.introduction.iconName)
                        }
                        
                        // 2. Matrix Setup
                        NavigationLink(value: AppSection.matrixSetup) {
                            Label(AppSection.matrixSetup.rawValue, systemImage: AppSection.matrixSetup.iconName)
                        }
                        
                        // 3. Vectors and Matrices
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.vectorArithmetic) {
                                    Label("Basic Vector Arithmetic", systemImage: AppSection.vectorArithmetic.iconName)
                                }
                                NavigationLink(value: AppSection.linearCombinations) {
                                    Label("Linear Combinations", systemImage: AppSection.linearCombinations.iconName)
                                }
                                NavigationLink(value: AppSection.parallelVectors) {
                                    Label("Parallel Vectors", systemImage: AppSection.parallelVectors.iconName)
                                }
                            },
                            label: {
                                Label("Vectors and Matrices", systemImage: "arrow.up.left.and.arrow.down.right")
                            }
                        )
                        
                        // 4. Matrix Operations
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.matrixArithmetic) {
                                    Label("Matrix Arithmetic", systemImage: AppSection.matrixArithmetic.iconName)
                                }
                                NavigationLink(value: AppSection.matrixMultiplication) {
                                    Label("Matrix Multiplication", systemImage: AppSection.matrixMultiplication.iconName)
                                }
                                NavigationLink(value: AppSection.matrixExponents) {
                                    Label("Matrix Powers", systemImage: AppSection.matrixExponents.iconName)
                                }
                                NavigationLink(value: AppSection.transposeOperations) {
                                    Label("Transpose Operations", systemImage: AppSection.transposeOperations.iconName)
                                }
                                NavigationLink(value: AppSection.specialMatrixTypes) {
                                    Label("Special Matrix Types", systemImage: AppSection.specialMatrixTypes.iconName)
                                }
                            },
                            label: {
                                Label("Matrix Operations", systemImage: "square.grid.3x3")
                            }
                        )
                        
                        // 5. Linear Systems & Determinants
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.verifySolutions) {
                                    Label("Verify Solutions", systemImage: AppSection.verifySolutions.iconName)
                                }
                                NavigationLink(value: AppSection.gaussianElimination) {
                                    Label("Gaussian Elimination", systemImage: AppSection.gaussianElimination.iconName)
                                }
                                NavigationLink(value: AppSection.refRref) {
                                    Label("REF & RREF", systemImage: AppSection.refRref.iconName)
                                }
                                NavigationLink(value: AppSection.gaussJordan) {
                                    Label("Gauss-Jordan Method", systemImage: AppSection.gaussJordan.iconName)
                                }
                            },
                            label: {
                                Label("Linear Systems", systemImage: "equal.square")
                            }
                        )
                        
                        // 6. Determinants
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.permutationsInversions) {
                                    Label("Permutations & Inversions", systemImage: AppSection.permutationsInversions.iconName)
                                }
                                NavigationLink(value: AppSection.basicDeterminantCalc) {
                                    Label("Determinant Calculation", systemImage: AppSection.basicDeterminantCalc.iconName)
                                }
                                NavigationLink(value: AppSection.geometricApplications) {
                                    Label("Geometric Applications", systemImage: AppSection.geometricApplications.iconName)
                                }
                                NavigationLink(value: AppSection.determinantProperties) {
                                    Label("Determinant Properties", systemImage: AppSection.determinantProperties.iconName)
                                }
                            },
                            label: {
                                Label("Determinants", systemImage: "sum")
                            }
                        )
                        
                        // 6b. Cofactor Expansion
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
                                NavigationLink(value: AppSection.orthogonalDiagonalization) {
                                    Label("Orthogonal Diagonalization", systemImage: AppSection.orthogonalDiagonalization.iconName)
                                }
                            },
                            label: {
                                Label("Cofactor Expansion", systemImage: "rectangle.split.3x3")
                            }
                        )
                    }
                    
                    Section {
                        // 6c. Dimension
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.subspaceVerification) {
                                    Label("Subspace Verification", systemImage: AppSection.subspaceVerification.iconName)
                                }
                                NavigationLink(value: AppSection.subspaceOperations) {
                                    Label("Subspace Operations", systemImage: AppSection.subspaceOperations.iconName)
                                }
                                NavigationLink(value: AppSection.spanningSets) {
                                    Label("Spanning Sets", systemImage: AppSection.spanningSets.iconName)
                                }
                            },
                            label: {
                                Label("Dimension", systemImage: "ruler")
                            }
                        )
                        
                        // 6d. Linear Independence
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.linearIndependenceBasic) {
                                    Label("Basic Definition Testing", systemImage: AppSection.linearIndependenceBasic.iconName)
                                }
                                NavigationLink(value: AppSection.linearIndependenceAlgorithms) {
                                    Label("Systematic Algorithms", systemImage: AppSection.linearIndependenceAlgorithms.iconName)
                                }
                                NavigationLink(value: AppSection.findingBases) {
                                    Label("Finding Bases", systemImage: AppSection.findingBases.iconName)
                                }
                            },
                            label: {
                                Label("Linear Independence", systemImage: "line.3.horizontal.decrease.circle")
                            }
                        )
                        
                        
                        // 6e. Basis and Dimension
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.basisVerification) {
                                    Label("Verifying a Basis", systemImage: AppSection.basisVerification.iconName)
                                }
                                NavigationLink(value: AppSection.constructingBases) {
                                    Label("Constructing Bases", systemImage: AppSection.constructingBases.iconName)
                                }
                                NavigationLink(value: AppSection.intersectionsExtensions) {
                                    Label("Intersections & Extensions", systemImage: AppSection.intersectionsExtensions.iconName)
                                }
                            },
                            label: {
                                Label("Basis and Dimension", systemImage: "square.dashed.inset.filled")
                            }
                        )
                        
                        // 6f. Orthonormal Bases
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.verifyingOrthogonalSets) {
                                    Label("Verifying Orthogonal Sets", systemImage: AppSection.verifyingOrthogonalSets.iconName)
                                }
                                NavigationLink(value: AppSection.orthogonalProjection) {
                                    Label("Orthogonal Projection", systemImage: AppSection.orthogonalProjection.iconName)
                                }
                                NavigationLink(value: AppSection.gramSchmidtProcess) {
                                    Label("Gram-Schmidt Process", systemImage: AppSection.gramSchmidtProcess.iconName)
                                }
                            },
                            label: {
                                Label("Orthonormal Bases", systemImage: "dot.circle.and.hand.point.up.left.fill")
                            }
                        )
                        
                        // 6g. Linear Transformations
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.matrixTransformations) {
                                    Label("Matrix Transformations", systemImage: AppSection.matrixTransformations.iconName)
                                }
                                NavigationLink(value: AppSection.checkingLinearity) {
                                    Label("Checking Linearity", systemImage: AppSection.checkingLinearity.iconName)
                                }
                                NavigationLink(value: AppSection.transformationsFromBasis) {
                                    Label("Transformations from Basis", systemImage: AppSection.transformationsFromBasis.iconName)
                                }
                            },
                            label: {
                                Label("Linear Transformations", systemImage: "arrow.forward.square")
                            }
                        )
                        
                        // 6h. Linear Isometries
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.verifyingIsometries) {
                                    Label("Verifying Isometries", systemImage: AppSection.verifyingIsometries.iconName)
                                }
                                NavigationLink(value: AppSection.rotationsReflections) {
                                    Label("Rotations & Reflections", systemImage: AppSection.rotationsReflections.iconName)
                                }
                                NavigationLink(value: AppSection.analyzingOrthogonalMatrices) {
                                    Label("Analyzing Orthogonal Matrices", systemImage: AppSection.analyzingOrthogonalMatrices.iconName)
                                }
                            },
                            label: {
                                Label("Linear Isometries", systemImage: "dot.squareshape.split.2x2")
                            }
                        )
                        
                        // 6i. Invertible Linear Operators
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.compositionOfTransformations) {
                                    Label("Composition of Transformations", systemImage: AppSection.compositionOfTransformations.iconName)
                                }
                                NavigationLink(value: AppSection.invertingLinearOperators) {
                                    Label("Inverting Linear Operators", systemImage: AppSection.invertingLinearOperators.iconName)
                                }
                                NavigationLink(value: AppSection.kernelAndRange) {
                                    Label("Kernel and Range", systemImage: AppSection.kernelAndRange.iconName)
                                }
                            },
                            label: {
                                Label("Invertible Linear Operators", systemImage: "arrow.2.squarepath")
                            }
                        )
                        
                        // 6j. Fundamental Spaces of a Matrix
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.fundamentalSubspaces) {
                                    Label("Fundamental Subspaces", systemImage: AppSection.fundamentalSubspaces.iconName)
                                }
                                NavigationLink(value: AppSection.orthogonalComplements) {
                                    Label("Orthogonal Complements", systemImage: AppSection.orthogonalComplements.iconName)
                                }
                                NavigationLink(value: AppSection.symmetricMatrixProducts) {
                                    Label("Symmetric Matrix Products", systemImage: AppSection.symmetricMatrixProducts.iconName)
                                }
                            },
                            label: {
                                Label("Fundamental Spaces", systemImage: "square.stack.3d.down.right.fill")
                            }
                        )
                        
                        // 6k. The Projection Theorem
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
                                Label("The Projection Theorem", systemImage: "arrow.up.and.down.square.fill")
                            }
                        )
                        
                        // 7. Nonsingular Matrices
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.inverse2x2Formula) {
                                    Label("2×2 Inverse Formula", systemImage: AppSection.inverse2x2Formula.iconName)
                                }
                                NavigationLink(value: AppSection.inverseGaussJordan) {
                                    Label("Inverse via Gauss-Jordan", systemImage: AppSection.inverseGaussJordan.iconName)
                                }
                                NavigationLink(value: AppSection.solveWithInverse) {
                                    Label("Solve with Inverse", systemImage: AppSection.solveWithInverse.iconName)
                                }
                                NavigationLink(value: AppSection.elementaryMatrices) {
                                    Label("Elementary Matrices", systemImage: AppSection.elementaryMatrices.iconName)
                                }
                            },
                            label: {
                                Label("Nonsingular Matrices", systemImage: "square.fill.on.square.fill")
                            }
                        )
                        
                        // 7. Dot Products and Orthogonality
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.dotProductApplication) {
                                    Label("Dot Product Application", systemImage: AppSection.dotProductApplication.iconName)
                                }
                                NavigationLink(value: AppSection.complexVectorArithmetic) {
                                    Label("Complex Arithmetic", systemImage: AppSection.complexVectorArithmetic.iconName)
                                }
                                NavigationLink(value: AppSection.normalizationScaling) {
                                    Label("Normalization & Scaling", systemImage: AppSection.normalizationScaling.iconName)
                                }
                                NavigationLink(value: AppSection.anglesBetweenVectors) {
                                    Label("Angles Between Vectors", systemImage: AppSection.anglesBetweenVectors.iconName)
                                }
                                NavigationLink(value: AppSection.orthogonalSets) {
                                    Label("Orthogonal Sets", systemImage: AppSection.orthogonalSets.iconName)
                                }
                            },
                            label: {
                                Label("Dot Products & Orthogonality", systemImage: "circle.grid.cross")
                            }
                        )
                    }
                    
                    Section {
                        // 6. Fundamental Subspaces
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.columnSpace) { Label("Column Space C(A)", systemImage: "arrow.up.right.square") }
                                NavigationLink(value: AppSection.nullSpace) { Label("Null Space N(A)", systemImage: "circle.dashed.inset.filled") }
                                NavigationLink(value: AppSection.rowSpace) { Label("Row Space C(Aᵀ)", systemImage: "tablecells") }
                                NavigationLink(value: AppSection.leftNullSpace) { Label("Left Null Space N(Aᵀ)", systemImage: "arrow.uturn.left.square") }
                            },
                            label: {
                                Label("Fundamental Subspaces", systemImage: "square.stack.3d.up")
                            }
                        )
                        
                        // 7. Determinant
                        NavigationLink(value: AppSection.determinant) {
                            Label(AppSection.determinant.rawValue, systemImage: AppSection.determinant.iconName)
                        }
                        
                        // 8. Matrix Inverse
                        NavigationLink(value: AppSection.inverse) {
                            Label(AppSection.inverse.rawValue, systemImage: AppSection.inverse.iconName)
                        }
                        
                        // 9. Eigenvalues and Eigenvectors
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.eigenvalues) {
                                    Label("Eigenvalues", systemImage: AppSection.eigenvalues.iconName)
                                }
                                NavigationLink(value: AppSection.eigenvectors) {
                                    Label("Eigenvectors", systemImage: AppSection.eigenvectors.iconName)
                                }
                            },
                            label: {
                                Label("Eigenvalues & Vectors", systemImage: "chart.xyaxis.line")
                            }
                        )
                        
                        // 10. Diagonalization
                        NavigationLink(value: AppSection.diagonalization) {
                            Label(AppSection.diagonalization.rawValue, systemImage: AppSection.diagonalization.iconName)
                        }
                        
                        // 11. Inner Product & Orthogonality
                        NavigationLink(value: AppSection.orthogonality) {
                            Label(AppSection.orthogonality.rawValue, systemImage: AppSection.orthogonality.iconName)
                        }
                        
                        // 12. Least Squares Approximation
                        DisclosureGroup(
                            content: {
                                NavigationLink(value: AppSection.distanceHyperplane) {
                                    Label("Dist to Hyperplane", systemImage: AppSection.distanceHyperplane.iconName)
                                }
                                NavigationLink(value: AppSection.leastSquaresInconsistent) {
                                    Label("Inconsistent System", systemImage: AppSection.leastSquaresInconsistent.iconName)
                                }
                                NavigationLink(value: AppSection.leastSquaresInfinite) {
                                    Label("Infinitely Many Sol.", systemImage: AppSection.leastSquaresInfinite.iconName)
                                }
                                NavigationLink(value: AppSection.linearRegression) {
                                    Label("Linear Regression", systemImage: AppSection.linearRegression.iconName)
                                }
                                NavigationLink(value: AppSection.quadraticCurveFitting) {
                                    Label("Quadratic Curve Fit", systemImage: AppSection.quadraticCurveFitting.iconName)
                                }
                            },
                            label: {
                                Label("Least Squares", systemImage: "chart.line.uptrend.xyaxis")
                            }
                        )
                        
                        // 13. Geometric Visualization
                        NavigationLink(value: AppSection.geometric) {
                            Label(AppSection.geometric.rawValue, systemImage: AppSection.geometric.iconName)
                        }
                    }
                    
                    Section(header: Text("Tools")) {
                        NavigationLink(value: AppSection.pdfExport) {
                            Label("Solution Export", systemImage: AppSection.pdfExport.iconName)
                        }
                        NavigationLink(value: AppSection.practiceProblems) {
                            Label("Practice Problems", systemImage: AppSection.practiceProblems.iconName)
                        }
                        NavigationLink(value: AppSection.examMode) {
                            Label("Exam Mode", systemImage: AppSection.examMode.iconName)
                        }
                    }
                    
                    Section(header: Text("App")) {
                        NavigationLink(value: AppSection.settings) {
                            Label("Settings", systemImage: "gear")
                        }
                    }
                    
                    // Footer
                    Section {
                        VStack(spacing: 4) {
                            Text("This Swift Playgrounds app project and activities within it are written by Adriel Magalona.")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            Text("Swift Student Challenge 2026")
                                .font(.caption2)
                                .bold()
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                    }
                }
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
}
