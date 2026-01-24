import SwiftUI

struct MatrixSetupView: View {
    @EnvironmentObject var matrixData: MatrixData
    @Binding var selectedSection: AppSection?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Configure your matrix A.")
                .foregroundColor(.secondary)
            
            // Dimensions
            HStack(spacing: 16) {
                HStack(spacing: 30) {
                    VStack { Text("Rows: \(matrixData.rows)").font(.headline); Stepper("", value: $matrixData.rows, in: 1...10).labelsHidden() }
                    VStack { Text("Columns: \(matrixData.cols)").font(.headline); Stepper("", value: $matrixData.cols, in: 1...10).labelsHidden() }
                }
                .padding().background(Color(uiColor: .secondarySystemBackground)).cornerRadius(12)
            }
            .fixedSize(horizontal: false, vertical: true)
            
            Divider()
            
            // Grid
            ScrollView([.horizontal, .vertical]) {
                VStack(spacing: 10) {
                    ForEach(0..<matrixData.rows, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(0..<matrixData.cols, id: \.self) { col in
                                TextField("0", text: Binding(
                                    get: { matrixData.values[row][col] },
                                    set: { matrixData.values[row][col] = $0 }
                                ))
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.center)
                                .frame(width: 60, height: 40)
                                .background(Color(uiColor: .systemBackground))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding().background(Color(uiColor: .tertiarySystemBackground)).cornerRadius(12)
            }
            
            // Actions
            HStack(spacing: 20) {
                Button(action: { matrixData.compute() }) {
                    Text("Compute").font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding().background(Color.blue).cornerRadius(10)
                }
                Button(action: { matrixData.reset() }) {
                    Text("Reset").font(.headline).foregroundColor(.red).frame(maxWidth: .infinity).padding().background(Color.red.opacity(0.1)).cornerRadius(10)
                }
            }
            
            if matrixData.hasComputed {
                Divider()
                
                // RREF A
                VStack(alignment: .leading, spacing: 10) {
                    Text("RREF Process (A)").font(.headline)
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 0) {
                            ForEach(matrixData.rrefSteps) { step in StepView(step: step) }
                        }
                        .padding()
                    }
                    .background(Color(uiColor: .secondarySystemBackground)).cornerRadius(12)
                }
                
                // RREF A^T
                VStack(alignment: .leading, spacing: 10) {
                    Text("RREF Process (Aᵀ)").font(.headline)
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 0) {
                            ForEach(matrixData.rrefTSteps) { step in StepView(step: step) }
                        }
                        .padding()
                    }
                    .background(Color(uiColor: .secondarySystemBackground)).cornerRadius(12)
                }
                
                // Results with "See Computation" Buttons
                VStack(alignment: .leading, spacing: 20) {
                    Text("Fundamental Subspaces").font(.title2).bold()
                    
                    SubspaceSummaryRow(title: "Column Space C(A)", basis: matrixData.columnSpace, action: { selectedSection = .columnSpace })
                    SubspaceSummaryRow(title: "Null Space N(A)", basis: matrixData.nullSpace, action: { selectedSection = .nullSpace })
                    SubspaceSummaryRow(title: "Row Space C(Aᵀ)", basis: matrixData.rowSpace, action: { selectedSection = .rowSpace })
                    SubspaceSummaryRow(title: "Left Null Space N(Aᵀ)", basis: matrixData.leftNullSpace, action: { selectedSection = .leftNullSpace })
                    
                    if matrixData.rows == matrixData.cols {
                        Divider()
                        
                        // Inverse
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Matrix Inverse A⁻¹").font(.headline)
                                Spacer()
                                Button(action: { selectedSection = .inverse }) {
                                    Text("See Steps")
                                        .font(.caption).bold()
                                        .padding(6)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(6)
                                }
                            }
                            
                            if let inv = matrixData.inverseMatrix {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 0) {
                                        RoundedRectangle(cornerRadius: 2).frame(width: 2).padding(.vertical, 4)
                                        VStack(spacing: 4) {
                                            ForEach(0..<inv.count, id: \.self) { r in
                                                HStack(spacing: 8) {
                                                    ForEach(0..<inv[r].count, id: \.self) { c in
                                                        Text(inv[r][c].description)
                                                            .font(.system(.caption, design: .monospaced))
                                                            .frame(width: 60, height: 30, alignment: .center)
                                                            .minimumScaleFactor(0.4)
                                                            .lineLimit(1)
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 4)
                                        RoundedRectangle(cornerRadius: 2).frame(width: 2).padding(.vertical, 4)
                                    }
                                    .padding(8)
                                    .background(Color(uiColor: .tertiarySystemBackground))
                                    .cornerRadius(8)
                                }
                            } else {
                                Text("Matrix is Singular (No Inverse)")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                    .padding(.vertical, 4)
                            }
                            
                            Text("Calculated via Gauss-Jordan Elimination").font(.caption).foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        
                        Divider()
                        
                        // Determinant
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Determinant |A|").font(.headline)
                                if let det = matrixData.determinantValue {
                                    Text("Result: \(det.description)").font(.subheadline).bold().foregroundColor(.primary)
                                }
                                Text("Calculated via Cofactor Expansion / Sarrus").font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: { selectedSection = .determinant }) {
                                Text("See Steps")
                                    .font(.caption).bold()
                                    .padding(6)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(6)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding().background(Color(uiColor: .secondarySystemBackground)).cornerRadius(12)
            }
        }
        .padding(.bottom, 50)
    }
}
