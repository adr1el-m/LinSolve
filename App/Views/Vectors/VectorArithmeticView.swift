import SwiftUI

struct VectorArithmeticView: View {
    enum OperationMode: String, CaseIterable {
        case linearCombination = "Linear Combination"
        case subtraction = "Vector Subtraction"
    }
    
    @State private var mode: OperationMode = .linearCombination
    
    // State for inputs
    // Example uses 3D vectors
    @State private var xVec: [String] = ["1", "-2", "1"]
    @State private var yVec: [String] = ["-1", "1", "0"]
    @State private var zVec: [String] = ["3", "1", "-2"]
    
    @State private var scalarA: String = "2"
    @State private var scalarB: String = "3"
    @State private var scalarC: String = "-1" // Represents -z as + (-1)z
    
    // Subtraction specific state
    @State private var subVecA: [String] = ["4", "2", "1"]
    @State private var subVecB: [String] = ["1", "5", "-1"]
    
    // Computation state
    @State private var showSteps: Bool = false
    @State private var scaledX: [Fraction] = []
    @State private var scaledY: [Fraction] = []
    @State private var scaledZ: [Fraction] = []
    @State private var finalResult: [Fraction] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Intro
                VStack(alignment: .leading, spacing: 10) {
                    Text("Vector Arithmetic")
                        .font(.largeTitle)
                        .bold()
                    Text("Addition, Subtraction, and Scalar Multiplication")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Picker("Operation", selection: $mode) {
                        ForEach(OperationMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical)
                    
                    if mode == .linearCombination {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("What is a Linear Combination?")
                                .font(.headline)
                            
                            Text("""
A **linear combination** is one of the most fundamental concepts in linear algebra. It answers the question: "What new vectors can I create by scaling and adding existing vectors?"

**The Two Building Blocks:**
1. **Scalar Multiplication**: Multiply each component of a vector by the same number (called a "scalar"). This stretches or shrinks the vector.
2. **Vector Addition**: Add vectors component by component. This combines their effects.

**Example:** If you walk 2 blocks east (vector x) and then 3 blocks north (vector y), your total displacement is the linear combination 2x + 3y.

Below, we compute: **a·x + b·y + c·z** where a, b, c are scalars and x, y, z are vectors.
""")
                                .font(.body)
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("What is Vector Subtraction?")
                                .font(.headline)
                            
                            Text("""
**Vector Subtraction** is simply adding the negative of a vector:

**u - v = u + (-1)·v**

When you subtract v from u, you're asking: "What vector do I need to add to v to get u?" The answer is the difference vector (u - v).

**Geometric Meaning:** If u and v are position vectors (pointing from the origin to points U and V), then u - v points from V to U.

**How it works:** Subtract the corresponding components:
• (u₁ - v₁, u₂ - v₂, u₃ - v₃, ...)
""")
                                .font(.body)
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Input Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Define Vectors").font(.headline)
                    
                    if mode == .linearCombination {
                        HStack(spacing: 20) {
                            VectorInputColumn(label: "x", vector: $xVec, scalar: $scalarA)
                            Text("+").font(.title)
                            VectorInputColumn(label: "y", vector: $yVec, scalar: $scalarB)
                            Text("+").font(.title)
                            VectorInputColumn(label: "z", vector: $zVec, scalar: $scalarC)
                        }
                    } else {
                        HStack(spacing: 20) {
                            VectorInputColumn(label: "u", vector: $subVecA, scalar: .constant("1"), showScalar: false)
                            Text("-").font(.title)
                            VectorInputColumn(label: "v", vector: $subVecB, scalar: .constant("1"), showScalar: false)
                        }
                    }
                    
                    if mode == .linearCombination {
                        Text("Note: Use a negative scalar for subtraction (e.g., -z is scalar -1).")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: compute) {
                        Text("Calculate Result")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                if showSteps {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Step-by-Step Solution").font(.title2).bold()
                        
                        if mode == .linearCombination {
                            linearCombinationSteps
                        } else {
                            subtractionSteps
                        }
                        
                        // Step 3: Final Result (Common UI)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Final Result")
                                .font(.headline)
                            
                            HStack {
                                Text("Result =")
                                VectorPreviewView(vector: finalResult)
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .transition(.opacity)
                }
                
                Spacer()
            }
        }
        .onChange(of: mode) { _ in
            showSteps = false
        }
    }
    
    var linearCombinationSteps: some View {
        Group {
            // Step 1: Scalar Multiplication
            VStack(alignment: .leading, spacing: 15) {
                Text("Step 1: Perform Scalar Multiplication")
                    .font(.headline)
                Text("First, we multiply each vector by its corresponding scalar. This is done by distributing the scalar value to every component within the vector.")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                // Detailed breakdown for each vector
                VStack(alignment: .leading, spacing: 20) {
                    // Vector X
                    ScalarMultiplicationStep(
                        label: "x",
                        scalar: scalarA,
                        originalVector: xVec,
                        resultVector: scaledX
                    )
                    
                    Divider()
                    
                    // Vector Y
                    ScalarMultiplicationStep(
                        label: "y",
                        scalar: scalarB,
                        originalVector: yVec,
                        resultVector: scaledY
                    )
                    
                    Divider()
                    
                    // Vector Z
                    ScalarMultiplicationStep(
                        label: "z",
                        scalar: scalarC,
                        originalVector: zVec,
                        resultVector: scaledZ
                    )
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
            }
            
            // Step 2: Component-wise Addition
            VStack(alignment: .leading, spacing: 15) {
                Text("Step 2: Add Components")
                    .font(.headline)
                Text("Now that we have scaled the vectors, we add them together. Vector addition is performed component-wise: we sum the first components together, then the second components, and so on.")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 12) {
                    // Header
                    HStack {
                        Text("Component")
                            .bold()
                            .frame(width: 80, alignment: .leading)
                        Text("Calculation")
                            .bold()
                        Spacer()
                        Text("Result")
                            .bold()
                            .frame(width: 50, alignment: .trailing)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 4)
                    
                    ForEach(0..<3, id: \.self) { i in
                        HStack(alignment: .top) {
                            Text("Row \(i+1)")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.secondary)
                                .frame(width: 80, alignment: .leading)
                            
                            Text("\(scaledX[i].description) + \(scaledY[i].description) + \(scaledZ[i].description)")
                                .font(.system(.body, design: .monospaced))
                            
                            Spacer()
                            
                            Text("= \(finalResult[i].description)")
                                .font(.system(.body, design: .monospaced))
                                .bold()
                                .frame(width: 50, alignment: .trailing)
                        }
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground).opacity(0.5))
                .cornerRadius(8)
            }
        }
    }
    
    var subtractionSteps: some View {
        Group {
            Text("To subtract v from u, we calculate u - v component by component.")
                .font(.body)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Component")
                        .bold()
                        .frame(width: 80, alignment: .leading)
                    Text("Calculation (u - v)")
                        .bold()
                    Spacer()
                    Text("Result")
                        .bold()
                        .frame(width: 50, alignment: .trailing)
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                ForEach(0..<3, id: \.self) { i in
                    HStack(alignment: .top) {
                        Text("Row \(i+1)")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.secondary)
                            .frame(width: 80, alignment: .leading)
                        
                        Text("\(subVecA[i]) - (\(subVecB[i]))")
                            .font(.system(.body, design: .monospaced))
                        
                        Spacer()
                        
                        Text("= \(finalResult[i].description)")
                            .font(.system(.body, design: .monospaced))
                            .bold()
                            .frame(width: 50, alignment: .trailing)
                    }
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground).opacity(0.5))
            .cornerRadius(8)
        }
    }
    
    func compute() {
        if mode == .linearCombination {
            // Parse inputs
            let a = Fraction(string: scalarA)
            let b = Fraction(string: scalarB)
            let c = Fraction(string: scalarC)
            
            let x = xVec.map { Fraction(string: $0) }
            let y = yVec.map { Fraction(string: $0) }
            let z = zVec.map { Fraction(string: $0) }
            
            // Scalar Mult
            let ax = x.map { $0 * a }
            let by = y.map { $0 * b }
            let cz = z.map { $0 * c }
            
            self.scaledX = ax
            self.scaledY = by
            self.scaledZ = cz
            
            // Sum
            var res: [Fraction] = []
            for i in 0..<3 {
                res.append(ax[i] + by[i] + cz[i])
            }
            self.finalResult = res
        } else {
            // Subtraction
            let u = subVecA.map { Fraction(string: $0) }
            let v = subVecB.map { Fraction(string: $0) }
            
            var res: [Fraction] = []
            for i in 0..<3 {
                res.append(u[i] - v[i])
            }
            self.finalResult = res
        }
        
        withAnimation {
            showSteps = true
        }
    }
}

struct VectorInputColumn: View {
    let label: String
    @Binding var vector: [String]
    @Binding var scalar: String
    var showScalar: Bool = true
    
    var body: some View {
        VStack(spacing: 8) {
            // Scalar Input
            if showScalar {
                TextField("s", text: $scalar)
                    .keyboardType(.numbersAndPunctuation)
                    .multilineTextAlignment(.center)
                    .frame(width: 40, height: 30)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(6)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.3)))
            } else {
                Color.clear.frame(width: 40, height: 30)
            }
            
            Text(label).font(.headline)
            
            // Vector Input
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
            .background(Color.black.opacity(0.05)) // Brackets background simulation
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



struct ScalarMultiplicationStep: View {
    let label: String
    let scalar: String
    let originalVector: [String]
    let resultVector: [Fraction]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 10) {
                // Label: 2 * x
                Text("\(scalar) · \(label)")
                    .font(.headline)
                    .frame(width: 50, alignment: .leading)
                
                // Original Vector
                VectorStringPreview(vector: originalVector)
                
                Text("=")
                    .font(.title2)
                
                // Expanded Calculation
                VStack(spacing: 4) {
                    ForEach(0..<originalVector.count, id: \.self) { i in
                         Text("\(scalar) · (\(originalVector[i]))")
                            .font(.system(.body, design: .monospaced))
                            .padding(.vertical, 2)
                            .padding(.horizontal, 4)
                            .background(Color.yellow.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                .padding(8)
                .background(Color(uiColor: .systemBackground))
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
                
                Text("=")
                    .font(.title2)
                
                // Result Vector
                VectorPreviewView(vector: resultVector)
            }
            .padding(.horizontal, 4)
        }
    }
}

struct VectorStringPreview: View {
    let vector: [String]
    var body: some View {
        VStack(spacing: 4) {
            ForEach(vector, id: \.self) { val in
                Text(val)
                    .font(.system(.body, design: .monospaced))
                    .frame(minWidth: 20)
            }
        }
        .padding(8)
        .background(Color(uiColor: .tertiarySystemBackground))
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
