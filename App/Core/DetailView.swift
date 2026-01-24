import SwiftUI

struct DetailView: View {
    let section: AppSection
    @Binding var selectedSection: AppSection?
    @EnvironmentObject var matrixData: MatrixData
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    if !section.iconName.isEmpty {
                        Image(systemName: section.iconName).font(.title)
                    } else {
                        Text(section.notation)
                            .font(.system(.title, design: .monospaced))
                            .bold()
                            .padding(6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    Text(section.rawValue)
                        .font(.largeTitle)
                        .bold()
                }
                
                switch section {
                case .matrixSetup:
                    MatrixSetupView(selectedSection: $selectedSection)
                case .introduction:
                    IntroductionView()
                case .nullSpace:
                    NullSpaceDetailView(
                        title: "Null Space N(A)",
                        matrix: matrixData.rrefSteps.last?.matrix ?? [],
                        pivots: matrixData.pivots,
                        totalCols: matrixData.cols
                    )
                case .columnSpace:
                    ColumnSpaceDetailView(
                        title: "Column Space C(A)",
                        originalMatrix: matrixData.getFractionMatrix(),
                        pivots: matrixData.pivots
                    )
                case .rowSpace:
                    RowSpaceDetailView(
                        title: "Row Space C(Aᵀ)",
                        originalMatrix: matrixData.getFractionMatrix()
                    )
                case .leftNullSpace:
                    LeftNullSpaceDetailView(
                        title: "Left Null Space N(Aᵀ)",
                        originalMatrix: matrixData.getFractionMatrix()
                    )
                case .inverse:
                    MatrixInverseView()
                case .determinant:
                    DeterminantView()
                case .geometric:
                    GeometricVisualizationView()
                case .transformation2D:
                    Transformation2DView()
                case .rankNullity:
                    RankNullityView()
                case .settings:
                    SettingsView()
                case .eigenvalues:
                    EigenvaluesView()
                case .eigenvectors:
                    EigenvectorsView()
                case .diagonalization:
                    DiagonalizationView()
                case .gramSchmidt:
                    GramSchmidtView()
                case .luDecomposition:
                    LUDecompositionView()
                case .svd:
                    SVDView()
                case .orthogonality:
                    OrthogonalityView()
                case .distanceHyperplane:
                    DistanceHyperplaneView()
                case .quadraticCurveFitting:
                    QuadraticCurveFitView()
                case .leastSquaresInconsistent:
                    LeastSquaresInconsistentView()
                case .leastSquaresInfinite:
                    LeastSquaresInfiniteView()
                case .linearRegression:
                    LinearRegressionView()
                case .vectorArithmetic:
                    VectorArithmeticView()
                case .linearCombinations:
                    LinearCombinationView()
                case .parallelVectors:
                    ParallelVectorsView()
                case .dotProductApplication:
                    DotProductApplicationView()
                case .complexVectorArithmetic:
                    ComplexVectorArithmeticView()
                case .normalizationScaling:
                    NormalizationScalingView()
                case .anglesBetweenVectors:
                    AnglesBetweenVectorsView()
                case .orthogonalSets:
                    OrthogonalSetsView()
                case .matrixArithmetic:
                    MatrixArithmeticView()
                case .matrixMultiplication:
                    MatrixMultiplicationView()
                case .matrixExponents:
                    MatrixExponentsView()
                case .transposeOperations:
                    TransposeOperationsView()
                case .specialMatrixTypes:
                    SpecialMatrixTypesView()
                case .verifySolutions:
                    VerifySolutionsView()
                case .gaussianElimination:
                    GaussianEliminationView()
                case .refRref:
                    RefRrefView()
                case .gaussJordan:
                    GaussJordanView()
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
