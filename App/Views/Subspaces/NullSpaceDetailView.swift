import SwiftUI

struct NullSpaceDetailView: View {
    let title: String
    let matrix: [[Fraction]] // RREF
    let pivots: [Int]
    let totalCols: Int
    
    var body: some View {
        let freeIndices = (0..<totalCols).filter { !pivots.contains($0) }
        
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Circle().fill(Color.blue).frame(width: 10, height: 10)
                Text(title).font(.title).bold().foregroundColor(.primary)
                Spacer()
                CopyButton(latex: generateLatex(freeIndices: freeIndices))
            }
            
            // Explanation
            if freeIndices.isEmpty {
                 Text("No free variables. The only solution is the zero vector.")
                    .foregroundColor(.secondary)
            } else {
                 let freeVars = freeIndices.map { "x\(sub: $0 + 1)" }.joined(separator: ", ")
                 Text("Columns \(freeIndices.map { String($0 + 1) }.joined(separator: ", ")) are free variables (\(freeVars)), so the null space basis vectors are found by setting one free variable to 1 (others 0) and solving for the pivot variables.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
            }

            // Computation Flow
            NullSpaceComputationView(rref: matrix, pivots: pivots, totalCols: totalCols, title: "N(A)")
            
            Spacer()
        }
        .padding()
    }
    
    func generateLatex(freeIndices: [Int]) -> String {
        guard !freeIndices.isEmpty else { return "N(A) = \\{ \\vec{0} \\}" }
        let basisVecs = freeIndices.map { freeIdx -> String in
            let rows = (0..<totalCols).map { rowIdx -> String in
                if rowIdx == freeIdx { return "1" }
                if freeIndices.contains(rowIdx) { return "0" }
                if let pivotRank = pivots.firstIndex(of: rowIdx), pivotRank < matrix.count {
                    let val = matrix[pivotRank][freeIdx]
                    return (Fraction(-1) * val).description
                }
                return "0"
            }.joined(separator: "\\\\")
            return "\\begin{bmatrix} \(rows) \\end{bmatrix}"
        }.joined(separator: ", ")
        return "N(A) = \\text{span} \\left\\{ \(basisVecs) \\right\\}"
    }
}

struct NullSpaceComputationView: View {
    let rref: [[Fraction]]
    let pivots: [Int]
    let totalCols: Int
    let title: String
    
    var body: some View {
        let freeIndices = (0..<totalCols).filter { !pivots.contains($0) }
        
        VStack(alignment: .leading, spacing: 32) {
            
            // Step 1: RREF
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 1: Reduced Row Echelon Form")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Identify pivot columns (basic variables) and non-pivot columns (free variables).")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                MatrixWithHeaders(matrix: rref, pivots: pivots, totalCols: totalCols)
                    .padding(.top, 4)
            }
            
            if !freeIndices.isEmpty {
                // Step 2: Parametric Equations
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 2: Parametric Vector Form")
                    .font(.headline)
                    .foregroundColor(.primary)
                    Text("Express the pivot variables in terms of the free variables. Free variables are equal to themselves.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        ParametricVectorBlock(rref: rref, pivots: pivots, freeIndices: freeIndices, totalCols: totalCols)
                    }
                }
                
                // Step 3: Decompose Vectors
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 3: Linear Combination")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Decompose the vector into a linear combination of vectors, one for each free variable.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LinearCombinationBlock(rref: rref, pivots: pivots, freeIndices: freeIndices, totalCols: totalCols)
                    }
                }
                
                // Step 4: Span
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 4: Basis & Span")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("The null space is the span of these basis vectors.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        SpanBlock(rref: rref, pivots: pivots, freeIndices: freeIndices, totalCols: totalCols, title: title)
                    }
                }
                
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Conclusion")
                        .font(.headline)
                    Text("Since there are no free variables, the only solution to Ax = 0 is the trivial solution.")
                        .foregroundColor(.secondary)
                    Text("{ 0 }")
                        .font(.title)
                        .bold()
                        .padding()
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct MatrixWithHeaders: View {
    let matrix: [[Fraction]]
    let pivots: [Int]
    let totalCols: Int
    
    var body: some View {
        VStack(spacing: 4) {
            // Headers
            HStack(spacing: 12) {
                ForEach(0..<totalCols, id: \.self) { c in
                    Text("x\(sub: c + 1)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(width: 40)
                }
            }
            
            // Grid
            VStack(spacing: 8) {
                ForEach(0..<matrix.count, id: \.self) { r in
                    HStack(spacing: 12) {
                        ForEach(0..<totalCols, id: \.self) { c in
                            Text(c < matrix[r].count ? matrix[r][c].description : "0")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(pivots.contains(c) ? .blue : .primary)
                                .frame(width: 40, height: 30)
                                .background(pivots.contains(c) ? Color.blue.opacity(0.1) : Color.clear)
                                .cornerRadius(4)
                        }
                    }
                }
            }
            .padding(12)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            
            // Pivot Indicator
            HStack {
                Text("Pivots: \(pivots.map { "Col \($0+1)" }.joined(separator: ", "))")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
        }
    }
}

struct ParametricVectorBlock: View {
    let rref: [[Fraction]]
    let pivots: [Int]
    let freeIndices: [Int]
    let totalCols: Int
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<totalCols, id: \.self) { rowIdx in
                // Determine content for this row
                let content: String = {
                    if freeIndices.contains(rowIdx) {
                        return "x\(sub: rowIdx + 1)"
                    } else if let pivotRank = pivots.firstIndex(of: rowIdx), pivotRank < rref.count {
                        // -Sum(coeff * free)
                        let terms = freeIndices.compactMap { freeIdx -> String? in
                             let val = rref[pivotRank][freeIdx]
                             if val == .zero { return nil }
                             let coeff = Fraction(-1) * val
                             // Format: -2x2
                             let sign = (coeff.numerator >= 0) ? "+" : "-"
                             let absCoeff = (abs(coeff.numerator) == coeff.denominator) ? "" : "\(abs(coeff.numerator))/\(coeff.denominator)"
                             return "\(sign) \(absCoeff)x\(sub: freeIdx + 1)"
                        }
                        
                        if terms.isEmpty { return "0" }
                        // Join and clean up first plus
                        var str = terms.joined(separator: " ")
                        if str.hasPrefix("+ ") { str.removeFirst(2) }
                        return str
                    } else {
                        return "0"
                    }
                }()
                
                Text(content)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.primary)
                    .padding(.vertical, 4)
                    .frame(minWidth: 60, alignment: .center)
            }
        }
        .padding(12)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
        .overlay(BracketOverlay())
    }
}

struct LinearCombinationBlock: View {
    let rref: [[Fraction]]
    let pivots: [Int]
    let freeIndices: [Int]
    let totalCols: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(freeIndices.enumerated()), id: \.offset) { index, freeIdx in
                if index > 0 {
                    Text("+").foregroundColor(.secondary)
                }
                
                Text("x\(sub: freeIdx + 1)")
                    .foregroundColor(.blue)
                    .bold()
                
                // Vector
                VStack(spacing: 2) {
                    ForEach(0..<totalCols, id: \.self) { rowIdx in
                         Text(getCoeff(for: rowIdx, freeIdx: freeIdx).description)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(rowIdx == freeIdx ? .blue : .primary)
                            .padding(.vertical, 4)
                            .frame(width: 30)
                    }
                }
                .padding(8)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(8)
                .overlay(BracketOverlay())
            }
        }
    }
    
    func getCoeff(for targetVarIdx: Int, freeIdx: Int) -> Fraction {
        if targetVarIdx == freeIdx { return .one }
        if freeIndices.contains(targetVarIdx) { return .zero }
        if let pivotRank = pivots.firstIndex(of: targetVarIdx), pivotRank < rref.count {
            let val = rref[pivotRank][freeIdx]
            return Fraction(-1) * val
        }
        return .zero
    }
}

struct SpanBlock: View {
    let rref: [[Fraction]]
    let pivots: [Int]
    let freeIndices: [Int]
    let totalCols: Int
    let title: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(title) = span").font(.headline).foregroundColor(.primary)
            
            Text("⟨").font(.title).foregroundColor(.secondary)
            
            ForEach(freeIndices, id: \.self) { freeIdx in
                VStack(spacing: 2) {
                    ForEach(0..<totalCols, id: \.self) { rowIdx in
                         Text(getCoeff(for: rowIdx, freeIdx: freeIdx).description)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(rowIdx == freeIdx ? .blue : .primary)
                            .padding(.vertical, 4)
                            .frame(width: 30)
                    }
                }
                .padding(8)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(8)
                .overlay(BracketOverlay())
            }
            
            Text("⟩").font(.title).foregroundColor(.secondary)
        }
    }
    
    func getCoeff(for targetVarIdx: Int, freeIdx: Int) -> Fraction {
        if targetVarIdx == freeIdx { return .one }
        if freeIndices.contains(targetVarIdx) { return .zero }
        if let pivotRank = pivots.firstIndex(of: targetVarIdx), pivotRank < rref.count {
            let val = rref[pivotRank][freeIdx]
            return Fraction(-1) * val
        }
        return .zero
    }
}

struct BracketOverlay: View {
    var body: some View {
        HStack {
            Rectangle().frame(width: 2).padding(.vertical, 4)
            Spacer()
            Rectangle().frame(width: 2).padding(.vertical, 4)
        }
        .foregroundColor(.primary.opacity(0.3))
    }
}
