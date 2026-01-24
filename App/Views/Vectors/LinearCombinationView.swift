import SwiftUI

struct LinearCombinationView: View {
    // We check if w is a linear combination of v1 and v2
    // w = c1*v1 + c2*v2
    
    @State private var v1: [String] = ["1", "1", "0"]
    @State private var v2: [String] = ["1", "0", "1"]
    @State private var w: [String] = ["-1", "2", "-3"] // Default: Is a linear combo (Example 8 Case 1)
    
    // Result State
    @State private var showResult: Bool = false
    @State private var isConsistent: Bool = false
    @State private var augmentedRREF: [[Fraction]] = []
    @State private var scalars: [Fraction] = []
    @State private var steps: [String] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Intro
                VStack(alignment: .leading, spacing: 10) {
                    Text("Linear Combinations")
                        .font(.largeTitle)
                        .bold()
                    Text("Span and Consistency")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("A vector w is a linear combination of vectors v₁, v₂, ... if there exist scalars c₁, c₂, ... such that:")
                        .font(.body)
                    
                    HStack {
                        Spacer()
                        Text("w = c₁v₁ + c₂v₂ + ...")
                            .font(.system(.title3, design: .serif))
                            .padding()
                            .background(Color.yellow.opacity(0.1))
                            .cornerRadius(8)
                        Spacer()
                    }
                    
                    Text("To check this computationally, we set up the vector equation as a linear system [v₁ v₂ ... | w] and solve for the scalars c using Row Reduction (RREF).")
                        .font(.body)
                        .padding(.top, 4)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Input
                VStack(alignment: .leading, spacing: 15) {
                    Text("Define Vectors").font(.headline)
                    
                    HStack(spacing: 30) {
                        VectorInputColumnSimple(label: "v₁", vector: $v1)
                        VectorInputColumnSimple(label: "v₂", vector: $v2)
                        
                        Divider().frame(height: 100)
                        
                        VectorInputColumnSimple(label: "w (Target)", vector: $w)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            // Case 1: Is a LC
                            v1 = ["1", "1", "0"]
                            v2 = ["1", "0", "1"]
                            w = ["-1", "2", "-3"]
                            showResult = false
                        }) {
                            Text("Load Example 1 (Yes)")
                                .font(.caption).bold()
                                .padding(8)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            // Case 2: Not a LC
                            v1 = ["1", "1", "0"]
                            v2 = ["1", "0", "1"]
                            w = ["2", "1", "-1"]
                            showResult = false
                        }) {
                            Text("Load Example 2 (No)")
                                .font(.caption).bold()
                                .padding(8)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    
                    Button(action: checkCombination) {
                        Text("Check if Linear Combination")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                if showResult {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Analysis").font(.title2).bold()
                        
                        if isConsistent {
                            HStack {
                                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                Text("It IS a linear combination.")
                                    .font(.headline)
                                    .foregroundColor(.green)
                            }
                        } else {
                            HStack {
                                Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                                Text("It is NOT a linear combination.")
                                    .font(.headline)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Step 1: System
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Step 1: Set up the System")
                                .font(.headline)
                            Text("We form the augmented matrix [v₁ v₂ | w]:")
                            
                            // Construct aug matrix for display
                            let aug = formAugmentedMatrix()
                            MatrixPreviewView(matrix: aug)
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                        
                        // Step 2: RREF
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Step 2: Compute RREF")
                                .font(.headline)
                            Text("Row reduce to find the solution.")
                            
                            MatrixPreviewView(matrix: augmentedRREF)
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                        
                        // Step 3: Conclusion
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Step 3: Interpret Result")
                                .font(.headline)
                            
                            if isConsistent {
                                Text("The system is consistent. We can read the scalars c₁ and c₂ directly from the RREF:")
                                HStack {
                                    Text("c₁ = \(scalars.indices.contains(0) ? scalars[0].description : "?")")
                                        .font(.system(.title3, design: .serif))
                                        .bold()
                                    Text(",")
                                    Text("c₂ = \(scalars.indices.contains(1) ? scalars[1].description : "?")")
                                        .font(.system(.title3, design: .serif))
                                        .bold()
                                }
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                                
                                Text("Thus, w = \(scalars.indices.contains(0) ? scalars[0].description : "")v₁ + \(scalars.indices.contains(1) ? scalars[1].description : "")v₂")
                                    .font(.body)
                                    .italic()
                            } else {
                                Text("The system is inconsistent.")
                                Text("Looking at the last row of the RREF, we see a pivot in the augmented column (e.g., [0 0 | 1]), which implies 0 = 1. This is a contradiction.")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                    }
                    .padding()
                    .transition(.move(edge: .bottom))
                }
                
                Spacer()
            }
        }
    }
    
    func formAugmentedMatrix() -> [[Fraction]] {
        let v1F = v1.map { Fraction(string: $0) }
        let v2F = v2.map { Fraction(string: $0) }
        let wF = w.map { Fraction(string: $0) }
        
        var aug: [[Fraction]] = []
        for i in 0..<3 {
            aug.append([v1F[i], v2F[i], wF[i]])
        }
        return aug
    }
    
    func checkCombination() {
        let aug = formAugmentedMatrix()
        
        // Compute RREF
        let rrefSteps = MatrixEngine.calculateRREF(matrix: aug)
        if let last = rrefSteps.last {
            let rref = last.matrix
            self.augmentedRREF = rref
            
            // Check consistency
            // Last column is index 2.
            // Check if any row is [0 0 | NonZero]
            var consistent = true
            var sol: [Fraction] = [Fraction.zero, Fraction.zero]
            
            // For a 3x3 augmented (3 eqs, 2 vars),
            // RREF usually looks like:
            // [1 0 | c1]
            // [0 1 | c2]
            // [0 0 | 0 ] -> Consistent
            // OR
            // [0 0 | 1 ] -> Inconsistent
            
            for r in 0..<3 {
                let c1 = rref[r][0]
                let c2 = rref[r][1]
                let b = rref[r][2]
                
                if c1 == .zero && c2 == .zero && b != .zero {
                    consistent = false
                }
                
                // Extract solution if consistent
                if consistent {
                    if c1 != .zero && c2 == .zero {
                        sol[0] = b / c1 // simple pivot case
                    } else if c1 == .zero && c2 != .zero {
                        sol[1] = b / c2
                    }
                }
            }
            
            self.isConsistent = consistent
            self.scalars = sol
        }
        
        withAnimation {
            showResult = true
        }
    }
}

struct VectorInputColumnSimple: View {
    let label: String
    @Binding var vector: [String]
    
    var body: some View {
        VStack(spacing: 8) {
            Text(label).font(.headline)
            
            VStack(spacing: 6) {
                ForEach(0..<vector.count, id: \.self) { i in
                    TextField("0", text: $vector[i])
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.center)
                        .frame(width: 50, height: 30)
                        .background(Color(uiColor: .systemBackground))
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.3)))
                }
            }
            .padding(8)
            .background(Color.black.opacity(0.05))
            .cornerRadius(8)
            .overlay(
                HStack {
                    BracketShape(left: true)
                        .stroke(Color.primary, lineWidth: 1.5)
                        .frame(width: 8)
                    Spacer()
                    BracketShape(left: false)
                        .stroke(Color.primary, lineWidth: 1.5)
                        .frame(width: 8)
                }
            )
        }
    }
}
