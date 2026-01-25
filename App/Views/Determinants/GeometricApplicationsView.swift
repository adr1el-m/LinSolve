import SwiftUI

struct GeometricApplicationsView: View {
    // Triangle vertices
    @State private var point1: (String, String) = ("1", "2")
    @State private var point2: (String, String) = ("5", "4")
    @State private var point3: (String, String) = ("3", "6")
    @State private var showTriangleResult: Bool = false
    @State private var triangleArea: Fraction = Fraction(0)
    @State private var triangleDet: Fraction = Fraction(0)
    
    // Parallelepiped vectors
    @State private var vecA: (String, String, String) = ("1", "0", "0")
    @State private var vecB: (String, String, String) = ("0", "2", "0")
    @State private var vecC: (String, String, String) = ("0", "0", "3")
    @State private var showVolumeResult: Bool = false
    @State private var parallelepipedVolume: Fraction = Fraction(0)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Geometric Applications")
                        .font(.largeTitle)
                        .bold()
                    Text("Determinants in Geometry")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
Determinants have beautiful geometric interpretations! They can compute:

• **Areas** of triangles and parallelograms in 2D
• **Volumes** of parallelepipeds in 3D
• **Orientation** (whether points are arranged clockwise or counterclockwise)

The absolute value of the determinant gives the scaling factor, while the sign tells us the orientation.
""")
                        .font(.body)
                        .padding(.vertical, 4)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Section 1: Area of a Triangle
                VStack(alignment: .leading, spacing: 16) {
                    Text("1. Area of a Triangle")
                        .font(.title2)
                        .bold()
                    
                    Text("""
Given three vertices (x₁, y₁), (x₂, y₂), (x₃, y₃), the area of the triangle is:

**Area = ½ |det(M)|**

Where M is the matrix:
┌ x₁  y₁  1 ┐
│ x₂  y₂  1 │
└ x₃  y₃  1 ┘

The column of 1s is a standard trick that makes the formula work. We take the absolute value because area is always positive, and divide by 2 because the determinant gives the area of a parallelogram (twice the triangle).
""")
                        .font(.body)
                    
                    // Interactive Calculator
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Try It: Triangle Area")
                            .font(.headline)
                            .foregroundColor(.green)
                        
                        Text("Enter three vertices:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 8) {
                            PointInputRow(label: "P₁", x: $point1.0, y: $point1.1)
                            PointInputRow(label: "P₂", x: $point2.0, y: $point2.1)
                            PointInputRow(label: "P₃", x: $point3.0, y: $point3.1)
                        }
                        
                        Button("Calculate Area") {
                            computeTriangleArea()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        
                        if showTriangleResult {
                            TriangleResultView(
                                p1: point1, p2: point2, p3: point3,
                                det: triangleDet, area: triangleArea
                            )
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Section 2: Worked Example
                VStack(alignment: .leading, spacing: 16) {
                    Text("2. Worked Example")
                        .font(.title2)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Problem: Find the area with vertices (1,2), (5,4), (3,6)")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        Text("""
**Step 1:** Form the matrix M by placing coordinates in rows with a column of 1s:
""")
                            .font(.body)
                        
                        HStack {
                            Text("M = ")
                                .font(.system(.body, design: .monospaced))
                            VStack(spacing: 2) {
                                Text("┌ 1  2  1 ┐")
                                Text("│ 5  4  1 │")
                                Text("└ 3  6  1 ┘")
                            }
                            .font(.system(.body, design: .monospaced))
                        }
                        .padding(8)
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(6)
                        
                        Text("""
**Step 2:** Calculate det(M) using Rule of Sarrus:

Downward diagonals: (1)(4)(1) + (2)(1)(3) + (1)(5)(6) = 4 + 6 + 30 = 40
Upward diagonals: (3)(4)(1) + (6)(1)(1) + (1)(5)(2) = 12 + 6 + 10 = 28

det(M) = 40 − 28 = 12
""")
                            .font(.body)
                        
                        Text("""
**Step 3:** Apply the area formula:
""")
                            .font(.body)
                        
                        HStack(spacing: 8) {
                            Text("Area = ½ |12| =")
                                .font(.system(.body, design: .monospaced))
                            Text("6")
                                .font(.system(.title2, design: .monospaced))
                                .bold()
                                .foregroundColor(.green)
                            Text("square units")
                                .font(.body)
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Section 3: Volume of Parallelepiped
                VStack(alignment: .leading, spacing: 16) {
                    Text("3. Volume of a Parallelepiped")
                        .font(.title2)
                        .bold()
                    
                    Text("""
In 3D, the determinant computes the **volume** of a parallelepiped (a 3D parallelogram).

Given three vectors **a**, **b**, **c** as row vectors:

**Volume = |det(M)|**

Where M is the 3×3 matrix with the vectors as rows.

**Geometric interpretation:** The determinant measures how much a linear transformation stretches or compresses space. For the identity matrix (det = 1), space is unchanged. For det = 2, volumes double.
""")
                        .font(.body)
                    
                    // Interactive Calculator
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Try It: Parallelepiped Volume")
                            .font(.headline)
                            .foregroundColor(.purple)
                        
                        Text("Enter three edge vectors:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 8) {
                            Vector3InputRow(label: "a", x: $vecA.0, y: $vecA.1, z: $vecA.2)
                            Vector3InputRow(label: "b", x: $vecB.0, y: $vecB.1, z: $vecB.2)
                            Vector3InputRow(label: "c", x: $vecC.0, y: $vecC.1, z: $vecC.2)
                        }
                        
                        Button("Calculate Volume") {
                            computeVolume()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.purple)
                        
                        if showVolumeResult {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Result:")
                                    .font(.subheadline)
                                    .bold()
                                
                                HStack {
                                    Image(systemName: "cube.fill")
                                        .foregroundColor(.purple)
                                    Text("Volume = |det(M)| =")
                                        .font(.system(.body, design: .monospaced))
                                    Text(parallelepipedVolume.description)
                                        .font(.system(.title3, design: .monospaced))
                                        .bold()
                                        .foregroundColor(.purple)
                                    Text("cubic units")
                                        .font(.body)
                                }
                            }
                            .padding()
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Section 4: Special Cases
                VStack(alignment: .leading, spacing: 16) {
                    Text("4. Special Cases & Insights")
                        .font(.title2)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        SpecialCaseCard(
                            title: "Collinear Points",
                            icon: "line.diagonal",
                            color: .orange,
                            content: "If three points lie on the same line, the triangle has zero area, so det(M) = 0. This gives a test for collinearity!"
                        )
                        
                        SpecialCaseCard(
                            title: "Orientation",
                            icon: "arrow.clockwise",
                            color: .blue,
                            content: "A positive determinant means counterclockwise orientation; negative means clockwise. We take |det| for area since area is always positive."
                        )
                        
                        SpecialCaseCard(
                            title: "Parallelogram Area",
                            icon: "rectangle.portrait",
                            color: .green,
                            content: "For a parallelogram with adjacent sides as vectors u and v, the area is |det([u; v])|. No need to divide by 2!"
                        )
                        
                        SpecialCaseCard(
                            title: "Higher Dimensions",
                            icon: "cube.transparent",
                            color: .purple,
                            content: "This extends to n dimensions: the n×n determinant gives the n-dimensional volume of the parallelepiped spanned by n vectors."
                        )
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: - Computation Functions
    
    func computeTriangleArea() {
        let x1 = Fraction(string: point1.0)
        let y1 = Fraction(string: point1.1)
        let x2 = Fraction(string: point2.0)
        let y2 = Fraction(string: point2.1)
        let x3 = Fraction(string: point3.0)
        let y3 = Fraction(string: point3.1)
        
        // det = x1(y2-y3) + x2(y3-y1) + x3(y1-y2)
        // Or using Rule of Sarrus with the 3x3 matrix
        let one = Fraction(1)
        
        // Downward diagonals
        let d1 = x1 * y2 * one
        let d2 = y1 * one * x3
        let d3 = one * x2 * y3
        
        // Upward diagonals
        let u1 = x3 * y2 * one
        let u2 = y3 * one * x1
        let u3 = one * x2 * y1
        
        triangleDet = (d1 + d2 + d3) - (u1 + u2 + u3)
        
        // Area = 1/2 * |det|
        let absDet = triangleDet.numerator < 0 ? Fraction(-triangleDet.numerator, triangleDet.denominator) : triangleDet
        triangleArea = Fraction(absDet.numerator, absDet.denominator * 2)
        
        withAnimation {
            showTriangleResult = true
        }
    }
    
    func computeVolume() {
        let a1 = Fraction(string: vecA.0)
        let a2 = Fraction(string: vecA.1)
        let a3 = Fraction(string: vecA.2)
        let b1 = Fraction(string: vecB.0)
        let b2 = Fraction(string: vecB.1)
        let b3 = Fraction(string: vecB.2)
        let c1 = Fraction(string: vecC.0)
        let c2 = Fraction(string: vecC.1)
        let c3 = Fraction(string: vecC.2)
        
        // 3x3 determinant using cofactor expansion along row 1
        let minor1 = b2 * c3 - b3 * c2
        let minor2 = b1 * c3 - b3 * c1
        let minor3 = b1 * c2 - b2 * c1
        
        let det = a1 * minor1 - a2 * minor2 + a3 * minor3
        
        // Absolute value
        parallelepipedVolume = det.numerator < 0 ? Fraction(-det.numerator, det.denominator) : det
        
        withAnimation {
            showVolumeResult = true
        }
    }
}

// MARK: - Supporting Views

struct PointInputRow: View {
    let label: String
    @Binding var x: String
    @Binding var y: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(.body, design: .serif))
                .bold()
                .frame(width: 30)
            Text("(")
            TextField("x", text: $x)
                .frame(width: 40)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)
            Text(",")
            TextField("y", text: $y)
                .frame(width: 40)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)
            Text(")")
        }
    }
}

struct Vector3InputRow: View {
    let label: String
    @Binding var x: String
    @Binding var y: String
    @Binding var z: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(.body, design: .serif))
                .bold()
                .frame(width: 20)
            Text("=")
            Text("⟨")
            TextField("x", text: $x)
                .frame(width: 35)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)
            Text(",")
            TextField("y", text: $y)
                .frame(width: 35)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)
            Text(",")
            TextField("z", text: $z)
                .frame(width: 35)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)
            Text("⟩")
        }
    }
}

struct TriangleResultView: View {
    let p1: (String, String)
    let p2: (String, String)
    let p3: (String, String)
    let det: Fraction
    let area: Fraction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Calculation Steps:")
                .font(.subheadline)
                .bold()
            
            HStack(alignment: .top) {
                Text("M = ")
                    .font(.system(.body, design: .monospaced))
                VStack(spacing: 0) {
                    Text("┌ \(p1.0)  \(p1.1)  1 ┐")
                    Text("│ \(p2.0)  \(p2.1)  1 │")
                    Text("└ \(p3.0)  \(p3.1)  1 ┘")
                }
                .font(.system(.caption, design: .monospaced))
            }
            
            Text("det(M) = \(det.description)")
                .font(.system(.body, design: .monospaced))
            
            HStack {
                Text("Area = ½|\(det.description)| =")
                    .font(.system(.body, design: .monospaced))
                Text(area.description)
                    .font(.system(.title3, design: .monospaced))
                    .bold()
                    .foregroundColor(.green)
                Text("square units")
                    .font(.caption)
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
    }
}

struct SpecialCaseCard: View {
    let title: String
    let icon: String
    let color: Color
    let content: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                Text(content)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(8)
    }
}
