import SwiftUI

struct Transformation2DView: View {
    @State private var m11: Double = 1.0
    @State private var m12: Double = 0.0
    @State private var m21: Double = 0.0
    @State private var m22: Double = 1.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("2D Linear Transformation")
                    .font(.title2)
                    .bold()
                
                Text("Visualize how the matrix A transforms the grid and the basis vectors i (Red) and j (Green).")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Matrix Input
                VStack {
                    Text("Matrix A")
                        .font(.headline)
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(String(format: "%.1f", m11))")
                            Slider(value: $m11, in: -2...2, step: 0.1)
                        }
                        VStack {
                            Text("\(String(format: "%.1f", m12))")
                            Slider(value: $m12, in: -2...2, step: 0.1)
                        }
                    }
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(String(format: "%.1f", m21))")
                            Slider(value: $m21, in: -2...2, step: 0.1)
                        }
                        VStack {
                            Text("\(String(format: "%.1f", m22))")
                            Slider(value: $m22, in: -2...2, step: 0.1)
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Visualization
                ZStack {
                    Color.white
                    
                    // Transformed Grid
                    TransformedGridShape(m11: m11, m12: m12, m21: m21, m22: m22)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    
                    // Basis Vectors
                    BasisVectorShape(m11: m11, m12: m12, m21: m21, m22: m22, isI: true)
                        .stroke(Color.red, lineWidth: 3)
                    BasisVectorShape(m11: m11, m12: m12, m21: m21, m22: m22, isI: false)
                        .stroke(Color.green, lineWidth: 3)
                        
                    // Origin
                    Circle()
                        .fill(Color.black)
                        .frame(width: 6, height: 6)
                }
                .frame(height: 300)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2)))
                .shadow(radius: 2)
                
                // Info
                VStack(alignment: .leading, spacing: 8) {
                    Text("Properties")
                        .font(.headline)
                    let det = m11 * m22 - m12 * m21
                    Text("Determinant: \(String(format: "%.2f", det))")
                    Text("Area Scale Factor: \(String(format: "%.2f", abs(det)))")
                    
                    if abs(det) < 0.01 {
                        Text("Singular (Collapses dimension)")
                            .foregroundColor(.red)
                            .bold()
                    } else if det < 0 {
                        Text("Orientation Reverted")
                            .foregroundColor(.orange)
                            .bold()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.blue.opacity(0.05))
                .cornerRadius(12)
            }
            .padding()
        }
    }
}

struct TransformedGridShape: Shape {
    let m11: Double, m12: Double, m21: Double, m22: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let scale: CGFloat = 40.0 // Pixels per unit
        
        func transform(_ x: Double, _ y: Double) -> CGPoint {
            let tx = m11 * x + m12 * y
            let ty = m21 * x + m22 * y
            // Screen Y is down, Math Y is up.
            return CGPoint(x: center.x + tx * scale, y: center.y - ty * scale)
        }
        
        for i in -10...10 {
            let val = Double(i)
            // Vertical lines (x = val)
            path.move(to: transform(val, -10))
            path.addLine(to: transform(val, 10))
            // Horizontal lines (y = val)
            path.move(to: transform(-10, val))
            path.addLine(to: transform(10, val))
        }
        return path
    }
}

struct BasisVectorShape: Shape {
    let m11: Double, m12: Double, m21: Double, m22: Double
    let isI: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let scale: CGFloat = 40.0
        
        func transform(_ x: Double, _ y: Double) -> CGPoint {
            let tx = m11 * x + m12 * y
            let ty = m21 * x + m22 * y
            return CGPoint(x: center.x + tx * scale, y: center.y - ty * scale)
        }
        
        let end = isI ? transform(1, 0) : transform(0, 1)
        
        path.move(to: center)
        path.addLine(to: end)
        
        // Arrowhead
        let angle = atan2(end.y - center.y, end.x - center.x)
        let arrowLength: CGFloat = 10.0
        let arrowAngle: CGFloat = .pi / 6 // 30 degrees
        
        let p1 = CGPoint(
            x: end.x - arrowLength * cos(angle - arrowAngle),
            y: end.y - arrowLength * sin(angle - arrowAngle)
        )
        let p2 = CGPoint(
            x: end.x - arrowLength * cos(angle + arrowAngle),
            y: end.y - arrowLength * sin(angle + arrowAngle)
        )
        
        path.move(to: end)
        path.addLine(to: p1)
        path.move(to: end)
        path.addLine(to: p2)
        
        return path
    }
}
