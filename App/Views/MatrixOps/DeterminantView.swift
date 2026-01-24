import SwiftUI

struct DeterminantView: View {
    @EnvironmentObject var matrixData: MatrixData
    @State private var cofactorSteps: [MatrixEngine.DetStep] = []
    @State private var sarrusSteps: [MatrixEngine.DetStep] = []
    @State private var selectedMethod: String = "Cofactor Expansion"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Determinant")
                        .font(.largeTitle)
                        .bold()
                    Text("Calculating det(A)")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                if matrixData.rows != matrixData.cols {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        Text("Determinant is only defined for square matrices.")
                            .multilineTextAlignment(.center)
                        Text("Current dimensions: \(matrixData.rows) × \(matrixData.cols)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    .padding()
                } else {
                    // Method Picker (only if 3x3)
                    if matrixData.rows == 3 {
                        Picker("Method", selection: $selectedMethod) {
                            Text("Cofactor Expansion").tag("Cofactor Expansion")
                            Text("Rule of Sarrus (Diagonal)").tag("Rule of Sarrus")
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                    }
                    
                    // Steps
                    let steps = (selectedMethod == "Rule of Sarrus" && matrixData.rows == 3) ? sarrusSteps : cofactorSteps
                    
                    if steps.isEmpty {
                         ProgressView("Computing...")
                             .onAppear { calculate() }
                    } else {
                        ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                            if selectedMethod == "Rule of Sarrus" && matrixData.rows == 3 {
                                SarrusStepCard(step: step, index: index, matrix: matrixData.getFractionMatrix())
                            } else {
                                DetStepCard(step: step, index: index)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 40)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            calculate()
        }
        .onChange(of: matrixData.values) { _ in
            calculate()
        }
    }
    
    func calculate() {
        let matrix = matrixData.getFractionMatrix()
        if matrixData.rows == matrixData.cols {
            cofactorSteps = MatrixEngine.calculateCofactorSteps(matrix: matrix)
            if matrixData.rows == 3 {
                sarrusSteps = MatrixEngine.calculateSarrusSteps(matrix: matrix)
            }
        }
    }
}

struct DetStepCard: View {
    let step: MatrixEngine.DetStep
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(step.title)
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Text("Step \(index + 1)")
                    .font(.caption)
                    .padding(4)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Text(step.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            if let matrix = step.matrix {
                Divider()
                Text("Relevant Submatrix / Matrix:")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.secondary)
                
                MatrixGridView(matrix: matrix)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            if let math = step.math {
                Divider()
                Text(math)
                    .font(.system(.title3, design: .monospaced))
                    .bold()
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct SarrusStepCard: View {
    let step: MatrixEngine.DetStep
    let index: Int
    let matrix: [[Fraction]]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(step.title)
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Text("Step \(index + 1)")
                    .font(.caption)
                    .padding(4)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Text(step.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            // Visual
            Divider()
            
            let phase: SarrusPhase = {
                if step.title.contains("Forward") { return .forward }
                if step.title.contains("Backward") { return .backward }
                if step.title.contains("Final") { return .final }
                return .intro
            }()
            
            SarrusVisualView(matrix: matrix, phase: phase)
                .frame(height: 220)
                .frame(maxWidth: .infinity)
            
            if let math = step.math {
                Divider()
                Text(math)
                    .font(.system(.caption, design: .monospaced)) // Smaller font for long equations
                    .bold()
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

enum SarrusPhase {
    case intro, forward, backward, final
}

struct SarrusVisualView: View {
    let matrix: [[Fraction]]
    let phase: SarrusPhase
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            
            // Layout: 5 columns (3 original + 2 repeated)
            // Cell width approx w / 5.5
            let cellW = w / 6
            let cellH = h / 4
            let startX = (w - (cellW * 5)) / 2
            let startY = (h - (cellH * 3)) / 2
            
            ZStack {
                // Diagonals Layer
                if phase == .forward || phase == .final {
                    // Forward diagonals (Red)
                    // (0,0)->(1,1)->(2,2)
                    // (0,1)->(1,2)->(2,3)
                    // (0,2)->(1,3)->(2,4)
                    Path { path in
                        for i in 0..<3 {
                            let x1 = startX + CGFloat(i) * cellW + cellW/2
                            let y1 = startY + cellH/2
                            let x2 = startX + CGFloat(i+2) * cellW + cellW/2
                            let y2 = startY + 2 * cellH + cellH/2
                            path.move(to: CGPoint(x: x1, y: y1))
                            path.addLine(to: CGPoint(x: x2, y: y2))
                        }
                    }
                    .stroke(Color.red.opacity(0.5), lineWidth: 4)
                }
                
                if phase == .backward || phase == .final {
                    // Backward diagonals (Blue)
                    // Standard Sarrus Backward:
                    // (0,2)->(1,1)->(2,0)
                    // (0,3)->(1,2)->(2,1)
                    // (0,4)->(1,3)->(2,2)
                    
                    Path { path in
                        for i in 0..<3 {
                            let x1 = startX + CGFloat(i+2) * cellW + cellW/2
                            let y1 = startY + cellH/2
                            let x2 = startX + CGFloat(i) * cellW + cellW/2
                            let y2 = startY + 2 * cellH + cellH/2
                            path.move(to: CGPoint(x: x1, y: y1))
                            path.addLine(to: CGPoint(x: x2, y: y2))
                        }
                    }
                    .stroke(Color.blue.opacity(0.8), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                }
                
                // Matrix Grid Layer
                ForEach(0..<3, id: \.self) { r in
                    ForEach(0..<5, id: \.self) { c in
                        // Map 5 cols to 3 original cols
                        let val = matrix[r][c % 3]
                        let isRepeated = c >= 3
                        
                        Text(val.description)
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(isRepeated ? .secondary : .primary)
                            .frame(width: cellW, height: cellH)
                            .background(isRepeated ? Color.gray.opacity(0.1) : Color.white)
                            .cornerRadius(8)
                            .position(
                                x: startX + CGFloat(c) * cellW + cellW/2,
                                y: startY + CGFloat(r) * cellH + cellH/2
                            )
                            .zIndex(1) // Ensure text is above lines
                    }
                }
                
                // Vertical Divider between original and repeated
                Path { path in
                    let x = startX + 3 * cellW
                    path.move(to: CGPoint(x: x, y: startY))
                    path.addLine(to: CGPoint(x: x, y: startY + 3 * cellH))
                }
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.secondary)
            }
        }
    }
}
