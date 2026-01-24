import SwiftUI

struct VectorArithmeticView: View {
    // State for inputs
    // Example uses 3D vectors
    @State private var xVec: [String] = ["1", "-2", "1"]
    @State private var yVec: [String] = ["-1", "1", "0"]
    @State private var zVec: [String] = ["3", "1", "-2"]
    
    @State private var scalarA: String = "2"
    @State private var scalarB: String = "3"
    @State private var scalarC: String = "-1" // Represents -z as + (-1)z
    
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
                    Text("Basic Vector Arithmetic")
                        .font(.largeTitle)
                        .bold()
                    Text("Addition, Subtraction, and Scalar Multiplication")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("We can combine scalar multiplication with vector addition. Given vectors x, y, z and scalars a, b, c, we calculate the linear combination: ax + by + cz.")
                        .font(.body)
                        .padding(.vertical, 4)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Input Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Define Vectors and Scalars").font(.headline)
                    
                    HStack(spacing: 20) {
                        VectorInputColumn(label: "x", vector: $xVec, scalar: $scalarA)
                        Text("+").font(.title)
                        VectorInputColumn(label: "y", vector: $yVec, scalar: $scalarB)
                        Text("+").font(.title)
                        VectorInputColumn(label: "z", vector: $zVec, scalar: $scalarC)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    
                    Text("Note: Use a negative scalar for subtraction (e.g., -z is scalar -1).")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
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
                        
                        // Step 1: Scalar Multiplication
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Step 1: Perform Scalar Multiplication")
                                .font(.headline)
                            Text("Multiply each component of the vectors by their respective scalars.")
                                .font(.body)
                            
                            HStack(spacing: 10) {
                                // ax
                                VStack {
                                    Text("\(scalarA)x =")
                                    VectorPreviewView(vector: scaledX)
                                }
                                Text("+")
                                // by
                                VStack {
                                    Text("\(scalarB)y =")
                                    VectorPreviewView(vector: scaledY)
                                }
                                Text("+")
                                // cz
                                VStack {
                                    Text("\(scalarC)z =")
                                    VectorPreviewView(vector: scaledZ)
                                }
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        // Step 2: Component-wise Addition
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Step 2: Add Components")
                                .font(.headline)
                            Text("Add the corresponding components from each scaled vector.")
                                .font(.body)
                            
                            // Show the arithmetic for each row
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(0..<3, id: \.self) { i in
                                    Text("Row \(i+1): \(scaledX[i].description) + \(scaledY[i].description) + \(scaledZ[i].description) = \(finalResult[i].description)")
                                        .font(.system(.body, design: .monospaced))
                                        .padding(4)
                                        .background(Color.yellow.opacity(0.1))
                                        .cornerRadius(4)
                                }
                            }
                        }
                        
                        // Step 3: Final Result
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
    }
    
    func compute() {
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
        
        withAnimation {
            showSteps = true
        }
    }
}

struct VectorInputColumn: View {
    let label: String
    @Binding var vector: [String]
    @Binding var scalar: String
    
    var body: some View {
        VStack(spacing: 8) {
            // Scalar Input
            TextField("s", text: $scalar)
                .keyboardType(.numbersAndPunctuation)
                .multilineTextAlignment(.center)
                .frame(width: 40, height: 30)
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(6)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.3)))
            
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
                    Spacer()
                    BracketShape(left: false)
                }
            )
        }
    }
}

// Helper for bracket visualization
struct BracketShape: Shape {
    let left: Bool
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let arm: CGFloat = 6
        
        if left {
            path.move(to: CGPoint(x: arm, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: h))
            path.addLine(to: CGPoint(x: arm, y: h))
        } else {
            path.move(to: CGPoint(x: w - arm, y: 0))
            path.addLine(to: CGPoint(x: w, y: 0))
            path.addLine(to: CGPoint(x: w, y: h))
            path.addLine(to: CGPoint(x: w - arm, y: h))
        }
        return path
    }
}
