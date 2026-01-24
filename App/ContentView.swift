import SwiftUI

struct ContentView: View {
    @State private var selectedSection: AppSection? = .introduction
    @StateObject private var matrixData = MatrixData()
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("useSystemTheme") private var useSystemTheme: Bool = true
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedSection) {
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
                    
                    // 6. Dot Products and Orthogonality
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
                
                Section(header: Text("App")) {
                    NavigationLink(value: AppSection.settings) {
                        Label("Settings", systemImage: "gear")
                    }
                }
                
                // Footer - scrolls with content, not sticky
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
            .navigationTitle("LinSolve")
            .listStyle(.sidebar)
        } detail: {
            if let section = selectedSection {
                DetailView(section: section, selectedSection: $selectedSection)
                    .environmentObject(matrixData)
            } else {
                Text("Select a topic")
                    .foregroundColor(.secondary)
            }
        }
        .preferredColorScheme(useSystemTheme ? nil : (isDarkMode ? .dark : .light))
        .onAppear {
            if !matrixData.hasComputed {
                matrixData.compute()
            }
        }
    }
}
