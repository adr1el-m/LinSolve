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
                    
                    // 4. Subspaces Dropdown
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
                    
                    // 4. Matrix Inverse
                    NavigationLink(value: AppSection.inverse) {
                        Label(AppSection.inverse.rawValue, systemImage: AppSection.inverse.iconName)
                    }
                    
                    // 5. Determinant
                    NavigationLink(value: AppSection.determinant) {
                        Label(AppSection.determinant.rawValue, systemImage: AppSection.determinant.iconName)
                    }

                    // 6. Inner Product & Orthogonality
                    NavigationLink(value: AppSection.orthogonality) {
                        Label(AppSection.orthogonality.rawValue, systemImage: AppSection.orthogonality.iconName)
                    }

                    // 7. Least Squares Approximation
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
                    
                    // 8. Eigenvalues and Eigenvectors
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

                    // 9. Diagonalization
                    NavigationLink(value: AppSection.diagonalization) {
                        Label(AppSection.diagonalization.rawValue, systemImage: AppSection.diagonalization.iconName)
                    }
                    
                    // 10. Geometric Visualization
                    NavigationLink(value: AppSection.geometric) {
                        Label(AppSection.geometric.rawValue, systemImage: AppSection.geometric.iconName)
                    }
                }
                
                Section(header: Text("App")) {
                    NavigationLink(value: AppSection.settings) {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
            .navigationTitle("LinSolve")
            .listStyle(.sidebar)
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 4) {
                    Text("This Swift Playgrounds app project and activities within it are written by Adriel Magalona.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Text("Swift Student Challenge 2026")
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 12)
                .background(Color(uiColor: .systemBackground).opacity(0.8))
            }
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
