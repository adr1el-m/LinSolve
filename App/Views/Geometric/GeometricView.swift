import SwiftUI
import simd



// MARK: - 3D Plot View

struct SubspacePlot3D: View {
    let basisVectors: [[Double]] // Input as array of doubles
    let accentColor: Color
    let originalDimension: Int
    
    var mode: String = "Subspace"
    var inputVector: Vec3 = .zero
    var matrix: [[Double]] = []
    
    @State private var rotation: (rx: Double, ry: Double, rz: Double) = (-0.55, 0.75, 0)
    @State private var zoom: Double = 1.0
    @State private var lastZoom: Double = 1.0
    @State private var showBox: Bool = true
    @State private var showCoordPlanes: Bool = false
    @State private var showTicks: Bool = true
    
    // Gesture State
    @State private var lastDragValue: DragGesture.Value?
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.9).ignoresSafeArea()
            
            // Canvas
            Canvas { context, size in
                let width = size.width
                let height = size.height
                let cx = width / 2
                let cy = height / 2
                
                // Convert basis to Vec3
                let basis3 = basisVectors.map { Vec3($0[0], $0[1], $0.count > 2 ? $0[2] : 0) }
                let nonZero = basis3.filter { simd_length($0) > 1e-9 }
                let dim = dimensionFromBasis(basis3)
                
                // Determine Scale
                let maxAbs = max(1.0, nonZero.flatMap { [$0.x, $0.y, $0.z] }.map { abs($0) }.max() ?? 1.0)
                let baseScale = min(width, height) * 0.35 / maxAbs
                let scalePx = baseScale * zoom
                
                // Units for box
                let units = min(9.0, max(4.0, ceil(maxAbs * 1.4)))
                
                // Helper: Project 3D -> 2D
                func project(_ v: Vec3) -> (point: CGPoint, z: Double) {
                    let vr = applyRotation(v, rx: rotation.rx, ry: rotation.ry, rz: rotation.rz)
                    return (CGPoint(x: cx + vr.x * scalePx, y: cy - vr.y * scalePx), vr.z)
                }
                
                // Helper: Draw Line
                func drawLine(_ a: Vec3, _ b: Vec3, color: Color, width: Double, dash: [CGFloat] = []) {
                    let pa = project(a).point
                    let pb = project(b).point
                    var path = Path()
                    path.move(to: pa)
                    path.addLine(to: pb)
                    context.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: width, lineCap: .round, dash: dash))
                }
                
                // Helper: Clip Segment to Box
                func clipSegmentToBox(_ a: Vec3, _ b: Vec3, limit: Double) -> (Vec3, Vec3)? {
                    var t0 = 0.0
                    var t1 = 1.0
                    let d = b - a
                    
                    func update(_ p: Double, _ q: Double) -> Bool {
                        if abs(p) < 1e-12 { return q >= 0 }
                        let r = q / p
                        if p < 0 {
                            if r > t1 { return false }
                            if r > t0 { t0 = r }
                        } else {
                            if r < t0 { return false }
                            if r < t1 { t1 = r }
                        }
                        return true
                    }
                    
                    if !update(-d.x, a.x + limit) { return nil }
                    if !update(d.x, limit - a.x) { return nil }
                    if !update(-d.y, a.y + limit) { return nil }
                    if !update(d.y, limit - a.y) { return nil }
                    if !update(-d.z, a.z + limit) { return nil }
                    if !update(d.z, limit - a.z) { return nil }
                    
                    if t1 < t0 { return nil }
                    
                    return (a + d * t0, a + d * t1)
                }
                
                // Helper: Intersect Plane with Box
                func getPlaneBoxIntersection(normal: Vec3, limit: Double) -> [Vec3] {
                    var points: [Vec3] = []
                    let l = limit
                    
                    // Check intersection with all 12 edges of the box [-l, l]
                    // Edges parallel to Z: (+/- l, +/- l, z)
                    for x in [-l, l] {
                        for y in [-l, l] {
                            // Line: P = (x, y, 0) + t(0, 0, 1) -> (x, y, z)
                            // n.P = 0 => n.x*x + n.y*y + n.z*z = 0
                            // z = -(n.x*x + n.y*y) / n.z
                            if abs(normal.z) > 1e-9 {
                                let z = -(normal.x * x + normal.y * y) / normal.z
                                if z >= -l - 1e-9 && z <= l + 1e-9 {
                                    points.append(Vec3(x, y, max(-l, min(l, z))))
                                }
                            }
                        }
                    }
                    
                    // Edges parallel to Y: (+/- l, y, +/- l)
                    for x in [-l, l] {
                        for z in [-l, l] {
                            if abs(normal.y) > 1e-9 {
                                let y = -(normal.x * x + normal.z * z) / normal.y
                                if y >= -l - 1e-9 && y <= l + 1e-9 {
                                    points.append(Vec3(x, max(-l, min(l, y)), z))
                                }
                            }
                        }
                    }
                    
                    // Edges parallel to X: (x, +/- l, +/- l)
                    for y in [-l, l] {
                        for z in [-l, l] {
                            if abs(normal.x) > 1e-9 {
                                let x = -(normal.y * y + normal.z * z) / normal.x
                                if x >= -l - 1e-9 && x <= l + 1e-9 {
                                    points.append(Vec3(max(-l, min(l, x)), y, z))
                                }
                            }
                        }
                    }
                    
                    // Remove duplicates
                    var uniquePoints: [Vec3] = []
                    for p in points {
                        if !uniquePoints.contains(where: { simd_distance($0, p) < 1e-5 }) {
                            uniquePoints.append(p)
                        }
                    }
                    
                    return uniquePoints
                }
                
                // Helper: Draw Line with Depth Fading and Clipping
                func drawLineDepthClipped(_ a: Vec3, _ b: Vec3, color: Color, width: Double, dash: [CGFloat] = []) {
                    guard let (c0, c1) = clipSegmentToBox(a, b, limit: units) else { return }
                    
                    let ar = applyRotation(c0, rx: rotation.rx, ry: rotation.ry, rz: rotation.rz)
                    let br = applyRotation(c1, rx: rotation.rx, ry: rotation.ry, rz: rotation.rz)
                    let zMid = (ar.z + br.z) * 0.5
                    let t = max(0.0, min(1.0, (zMid + units) / (2 * units)))
                    let alphaFactor = 1.0 - t * 0.55
                    
                    drawLine(c0, c1, color: color.opacity(alphaFactor), width: width, dash: dash)
                }
                
                // Helper: Draw Arrow
                func drawArrowClipped(_ a: Vec3, _ b: Vec3, color: Color, width: Double, headPx: Double) {
                     guard let (c0, c1) = clipSegmentToBox(a, b, limit: units) else { return }
                    
                    drawLine(c0, c1, color: color, width: width)
                    
                    let pa = project(c0).point
                    let pb = project(c1).point
                    let dx = pb.x - pa.x
                    let dy = pb.y - pa.y
                    let len = hypot(dx, dy)
                    if len < 1e-6 { return }
                    
                    let ux = dx / len
                    let uy = dy / len
                    let nx = -uy
                    let ny = ux
                    
                    let tip = pb
                    let backX = tip.x - ux * headPx
                    let backY = tip.y - uy * headPx
                    
                    var headPath = Path()
                    headPath.move(to: tip)
                    headPath.addLine(to: CGPoint(x: backX + nx * headPx * 0.55, y: backY + ny * headPx * 0.55))
                    headPath.addLine(to: CGPoint(x: backX - nx * headPx * 0.55, y: backY - ny * headPx * 0.55))
                    headPath.closeSubpath()
                    context.fill(headPath, with: .color(color))
                }
                
                // Helper: Draw Text
                func drawText(_ p: Vec3, _ text: String, color: Color) {
                    let pp = project(p).point
                    
                    let font = Font.system(size: 12, design: .monospaced)
                    let padding: CGFloat = 4
                    
                    let textObj = Text(text).font(font).foregroundColor(color)
                    let resolvedText = context.resolve(textObj)
                    let textSize = resolvedText.measure(in: CGSize(width: 500, height: 100))
                    
                    let bgRect = CGRect(
                        x: pp.x + 10,
                        y: pp.y - textSize.height / 2 - padding,
                        width: textSize.width + padding * 2,
                        height: textSize.height + padding * 2
                    )
                    
                    let bgPath = Path(roundedRect: bgRect, cornerRadius: 4)
                    context.fill(bgPath, with: .color(.black.opacity(0.7)))
                    
                    context.draw(resolvedText, in: bgRect.insetBy(dx: padding, dy: padding))
                }
                
                // Helper: Draw Tick Label
                func drawTickLabel(_ p: Vec3, _ text: String) {
                    let pp = project(p).point
                    let textObj = Text(text).font(.system(size: 10)).foregroundColor(.white.opacity(0.8))
                    let resolvedText = context.resolve(textObj)
                    context.draw(resolvedText, at: pp)
                }
                
                // --- Drawing Logic Ported from TS ---
                
                // 1. Coordinate Planes
                if showCoordPlanes {
                    // Simplified: just draw grids on XY, XZ, YZ
                    let gridColor = Color.white.opacity(0.1)
                    // XY
                    for i in stride(from: -units, through: units, by: units <= 6 ? 1 : 2) {
                        drawLineDepthClipped(Vec3(-units, i, 0), Vec3(units, i, 0), color: gridColor, width: 1)
                        drawLineDepthClipped(Vec3(i, -units, 0), Vec3(i, units, 0), color: gridColor, width: 1)
                    }
                }
                
                // 2. Box
                if showBox {
                    let faintBorder = Color.white.opacity(0.22)
                    let faintGrid = Color.white.opacity(0.10)
                    let corners: [Vec3] = [
                        Vec3(-units, -units, -units), Vec3(units, -units, -units), Vec3(units, units, -units), Vec3(-units, units, -units),
                        Vec3(-units, -units, units), Vec3(units, -units, units), Vec3(units, units, units), Vec3(-units, units, units)
                    ]
                    let edges: [(Int, Int)] = [
                        (0,1), (1,2), (2,3), (3,0),
                        (4,5), (5,6), (6,7), (7,4),
                        (0,4), (1,5), (2,6), (3,7)
                    ]
                    for (i, j) in edges {
                        drawLineDepthClipped(corners[i], corners[j], color: faintBorder, width: 1.5)
                    }
                    
                    // Box Grids (Simplified for all faces)
                    let step = units <= 6 ? 1.0 : 2.0
                    // Draw grids on back faces (approximate by just drawing all valid grids clipped)
                    for t in stride(from: -units, through: units, by: step) {
                        // Constant X
                        drawLineDepthClipped(Vec3(-units, -units, t), Vec3(-units, units, t), color: faintGrid, width: 1)
                        drawLineDepthClipped(Vec3(-units, t, -units), Vec3(-units, t, units), color: faintGrid, width: 1)
                         drawLineDepthClipped(Vec3(units, -units, t), Vec3(units, units, t), color: faintGrid, width: 1)
                        drawLineDepthClipped(Vec3(units, t, -units), Vec3(units, t, units), color: faintGrid, width: 1)
                        
                        // Constant Y ... (omitted for brevity, keeping main box look)
                    }
                }
                
                // 3. Axes
                let axesLen = maxAbs * 1.2
                drawArrowClipped(Vec3(-axesLen, 0, 0), Vec3(axesLen, 0, 0), color: Color(red: 1.0, green: 0.26, blue: 0.42), width: 2.2, headPx: 10)
                drawArrowClipped(Vec3(0, -axesLen, 0), Vec3(0, axesLen, 0), color: Color(red: 0.22, green: 1.0, blue: 0.42), width: 2.2, headPx: 10)
                drawArrowClipped(Vec3(0, 0, -axesLen), Vec3(0, 0, axesLen), color: Color(red: 0.47, green: 0.63, blue: 1.0), width: 2.2, headPx: 10)
                
                drawText(Vec3(axesLen, 0, 0), "x", color: Color(red: 1.0, green: 0.26, blue: 0.42))
                drawText(Vec3(0, axesLen, 0), "y", color: Color(red: 0.22, green: 1.0, blue: 0.42))
                drawText(Vec3(0, 0, axesLen), "z", color: Color(red: 0.47, green: 0.63, blue: 1.0))
                
                // 4. Ticks
                if showTicks {
                    let tickColor = Color.white.opacity(0.75)
                    let small = max(0.15, units * 0.04)
                    let labelEvery = units <= 6 ? 1.0 : 2.0
                    
                    for i in stride(from: -units, through: units, by: labelEvery) {
                        if abs(i) < 0.01 { continue }
                        let label = String(format: "%.0f", i)
                        
                        // X Ticks
                        drawLineDepthClipped(Vec3(i, -small, 0), Vec3(i, small, 0), color: tickColor, width: 1)
                        if showTicks { drawTickLabel(Vec3(i, -small * 2.5, 0), label) }
                        
                        // Y Ticks
                        drawLineDepthClipped(Vec3(-small, i, 0), Vec3(small, i, 0), color: tickColor, width: 1)
                        if showTicks { drawTickLabel(Vec3(-small * 2.5, i, 0), label) }
                        
                        // Z Ticks
                        drawLineDepthClipped(Vec3(0, -small, i), Vec3(0, small, i), color: tickColor, width: 1)
                        if showTicks { drawTickLabel(Vec3(0, -small * 2.5, i), label) }
                    }
                }
                
                // 5. Subspace Visualization
                
                if mode == "Transformation" {
                    drawArrowClipped(Vec3(0,0,0), inputVector, color: .blue, width: 3, headPx: 10)
                    let xLabel = String(format: "x(%.1f, %.1f, %.1f)", inputVector.x, inputVector.y, inputVector.z)
                    drawText(inputVector, xLabel, color: .blue)
                    
                    if !matrix.isEmpty {
                        let r = matrix.count
                        let c = matrix[0].count
                        let x = inputVector.x, y = inputVector.y, z = inputVector.z
                        
                        let ax = (c > 0 ? matrix[0][0]*x : 0) + (c > 1 ? matrix[0][1]*y : 0) + (c > 2 ? matrix[0][2]*z : 0)
                        let ay = r > 1 ? ((c > 0 ? matrix[1][0]*x : 0) + (c > 1 ? matrix[1][1]*y : 0) + (c > 2 ? matrix[1][2]*z : 0)) : 0
                        let az = r > 2 ? ((c > 0 ? matrix[2][0]*x : 0) + (c > 1 ? matrix[2][1]*y : 0) + (c > 2 ? matrix[2][2]*z : 0)) : 0
                        
                        let Ax = Vec3(ax, ay, az)
                        drawArrowClipped(Vec3(0,0,0), Ax, color: .red, width: 3, headPx: 10)
                        let axLabel = String(format: "Ax(%.1f, %.1f, %.1f)", ax, ay, az)
                        drawText(Ax, axLabel, color: .red)
                    }
                }
                
                // Plane (Dim 2)
                if dim == 2 && nonZero.count >= 2 {
                    let u0 = normalize(nonZero[0])
                    let v1 = nonZero.first(where: { simd_length(cross(u0, normalize($0))) > 1e-6 })
                    if let v1 = v1 {
                        let u1raw = normalize(v1)
                        let e0 = normalize(u0)
                        let u1proj = u1raw + e0 * -dot(u1raw, e0)
                        let e1 = normalize(u1proj)
                        
                        // Draw Translucent Plane Clipped to Box
                        let normal = normalize(cross(u0, e1))
                        let polyPoints = getPlaneBoxIntersection(normal: normal, limit: units)
                        
                        if polyPoints.count >= 3 {
                            // Sort points angularly around origin (0,0,0) on the plane
                            // To do this, project points to the 2D plane basis (e0, e1)
                            let sortedPoints = polyPoints.sorted { p1, p2 in
                                let x1 = dot(p1, e0)
                                let y1 = dot(p1, e1)
                                let x2 = dot(p2, e0)
                                let y2 = dot(p2, e1)
                                return atan2(y1, x1) < atan2(y2, x2)
                            }
                            
                            var planePath = Path()
                            if let first = sortedPoints.first {
                                planePath.move(to: project(first).point)
                                for p in sortedPoints.dropFirst() {
                                    planePath.addLine(to: project(p).point)
                                }
                                planePath.closeSubpath()
                                
                                // Use accent color with very low opacity for translucent look
                                context.fill(planePath, with: .color(accentColor.opacity(0.15)))
                            }
                        }
                        
                        // Draw grid on the plane
                        let gridStroke = Color.white.opacity(0.3)
                        let extent = units * 3
                        let step = units <= 6 ? 1.0 : 2.0
                        
                        for k in stride(from: -units, through: units, by: step) {
                             let offset1 = e1 * k
                             drawLineDepthClipped(offset1 + e0 * -extent, offset1 + e0 * extent, color: gridStroke, width: 1)
                             let offset0 = e0 * k
                             drawLineDepthClipped(offset0 + e1 * -extent, offset0 + e1 * extent, color: gridStroke, width: 1)
                        }
                    }
                }
                
                // Line (Dim 1)
                if dim == 1 && !nonZero.isEmpty {
                    let v = normalize(nonZero[0])
                    let ext = units * 2
                    
                    // Draw thick translucent line (simulated with multiple lines or just wide stroke)
                    drawLineDepthClipped(v * -ext, v * ext, color: accentColor.opacity(0.2), width: 12)
                    drawLineDepthClipped(v * -ext, v * ext, color: accentColor.opacity(0.9), width: 2, dash: [6, 6])
                }
                
                // Point (Dim 0)
                if dim == 0 {
                    let origin = project(Vec3(0,0,0)).point
                    let p = Path(ellipseIn: CGRect(x: origin.x - 4, y: origin.y - 4, width: 8, height: 8))
                    context.fill(p, with: .color(accentColor))
                }
                
                // 6. Basis Vectors
                for (i, v) in nonZero.prefix(3).enumerated() {
                    let color = i == 0 ? accentColor : (i == 1 ? Color(red: 0, green: 0.9, blue: 1) : Color(red: 1, green: 0.25, blue: 1))
                    drawArrowClipped(Vec3(0,0,0), v, color: color, width: 3, headPx: 10)
                    
                    let label = String(format: "v%d (%.0f, %.0f, %.0f)", i+1, v.x, v.y, v.z)
                    drawText(v, label, color: color)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if let last = lastDragValue {
                            let dx = value.location.x - last.location.x
                            let dy = value.location.y - last.location.y
                            rotation.rx += dy * 0.01
                            rotation.ry += dx * 0.01
                        }
                        lastDragValue = value
                    }
                    .onEnded { _ in
                        lastDragValue = nil
                    }
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { val in
                        zoom = max(0.2, min(5.0, lastZoom * val))
                    }
                    .onEnded { _ in
                        lastZoom = zoom
                    }
            )
            
            // UI Overlay
            VStack {
                if originalDimension > 3 {
                    Text("⚠️ Viewing 3D projection of a \(originalDimension)D space")
                        .font(.caption)
                        .bold()
                        .padding(8)
                        .background(Color.yellow.opacity(0.8))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .padding(.top, 40)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack { Circle().fill(Color(red: 1.0, green: 0.26, blue: 0.42)).frame(width: 8, height: 8); Text("x").font(.caption).foregroundColor(.white) }
                        HStack { Circle().fill(Color(red: 0.22, green: 1.0, blue: 0.42)).frame(width: 8, height: 8); Text("y").font(.caption).foregroundColor(.white) }
                        HStack { Circle().fill(Color(red: 0.47, green: 0.63, blue: 1.0)).frame(width: 8, height: 8); Text("z").font(.caption).foregroundColor(.white) }
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Button(action: { rotation = (-0.55, 0.75, 0); zoom = 1.0; lastZoom = 1.0 }) { Text("R").bold().padding(8).background(Color.black.opacity(0.6)).foregroundColor(.white).cornerRadius(8) }
                    }
                }
                Spacer()
                HStack {
                    ToggleBtn(title: "Box", isOn: $showBox)
                    ToggleBtn(title: "Planes", isOn: $showCoordPlanes)
                    ToggleBtn(title: "Ticks", isOn: $showTicks)
                }
            }
            .padding()
        }
    }
}

struct ToggleBtn: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: { isOn.toggle() }) {
            Text(title)
                .font(.caption).bold()
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(isOn ? Color.white.opacity(0.2) : Color.clear)
                .foregroundColor(isOn ? .white : .white.opacity(0.6))
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.white.opacity(0.2)))
        }
    }
}

struct GeometricVisualizationView: View {
    @EnvironmentObject var matrixData: MatrixData
    @State private var selectedSubspace: String = "Column Space"
    
    // Transformation Mode State
    @State private var inputVector: Vec3 = Vec3(1, 1, 0)
    @State private var isNullSpaceFound: Bool = false
    
    var basisVectors: [[Double]] {
        let basis: [[Fraction]]
        switch selectedSubspace {
        case "Column Space": basis = matrixData.columnSpace
        case "Null Space": basis = matrixData.nullSpace
        case "Row Space": basis = matrixData.rowSpace
        case "Left Null Space": basis = matrixData.leftNullSpace
        case "Transformation": return []
        default: basis = []
        }
        return basis.map { vec in vec.map { $0.asDouble } }
    }
    
    func checkNullSpace() {
        let matrix = matrixData.getFractionMatrix().map { row in row.map { $0.asDouble } }
        let r = matrix.count
        let c = matrix.isEmpty ? 0 : matrix[0].count
        let x = inputVector.x, y = inputVector.y, z = inputVector.z
        
        let ax = (c > 0 ? matrix[0][0]*x : 0) + (c > 1 ? matrix[0][1]*y : 0) + (c > 2 ? matrix[0][2]*z : 0)
        let ay = r > 1 ? ((c > 0 ? matrix[1][0]*x : 0) + (c > 1 ? matrix[1][1]*y : 0) + (c > 2 ? matrix[1][2]*z : 0)) : 0
        let az = r > 2 ? ((c > 0 ? matrix[2][0]*x : 0) + (c > 1 ? matrix[2][1]*y : 0) + (c > 2 ? matrix[2][2]*z : 0)) : 0
        
        let outputLen = sqrt(ax*ax + ay*ay + az*az)
        let inputLen = sqrt(x*x + y*y + z*z)
        
        // Null space detection: input is non-zero, output is near zero
        if inputLen > 0.1 && outputLen < 0.2 {
            if !isNullSpaceFound {
                SoundManager.shared.playNullSpaceDiscovery()
                isNullSpaceFound = true
            }
        } else {
            isNullSpaceFound = false
        }
    }
    
    func colorForSubspace(_ name: String) -> Color {
        switch name {
        case "Column Space": return .green
        case "Null Space": return .blue
        case "Row Space": return .orange
        case "Left Null Space": return .purple
        case "Transformation": return .white
        default: return .white
        }
    }
    
    // Computed property for output vector
    var outputVector: Vec3 {
        let matrix = matrixData.getFractionMatrix().map { row in row.map { $0.asDouble } }
        let r = matrix.count
        let c = matrix.isEmpty ? 0 : matrix[0].count
        let x = inputVector.x, y = inputVector.y, z = inputVector.z
        
        let ax = (c > 0 ? matrix[0][0]*x : 0) + (c > 1 ? matrix[0][1]*y : 0) + (c > 2 ? matrix[0][2]*z : 0)
        let ay = r > 1 ? ((c > 0 ? matrix[1][0]*x : 0) + (c > 1 ? matrix[1][1]*y : 0) + (c > 2 ? matrix[1][2]*z : 0)) : 0
        let az = r > 2 ? ((c > 0 ? matrix[2][0]*x : 0) + (c > 1 ? matrix[2][1]*y : 0) + (c > 2 ? matrix[2][2]*z : 0)) : 0
        
        return Vec3(ax, ay, az)
    }
    
    var modeTitle: String {
        switch selectedSubspace {
        case "Transformation": return "Vector Transformation"
        case "Column Space": return "Column Space C(A)"
        case "Null Space": return "Null Space N(A)"
        case "Row Space": return "Row Space C(Aᵀ)"
        case "Left Null Space": return "Left Null Space N(Aᵀ)"
        default: return "3D Visualization"
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with Title and Mode Menu
            HStack {
                Text(modeTitle)
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Menu {
                    Picker("Mode", selection: $selectedSubspace) {
                        Label("Transformation", systemImage: "arrow.right.arrow.left").tag("Transformation")
                        Divider()
                        Label("Column Space", systemImage: "arrow.up.and.down").tag("Column Space")
                        Label("Null Space", systemImage: "circle.slash").tag("Null Space")
                        Label("Row Space", systemImage: "arrow.left.and.right").tag("Row Space")
                        Label("Left Null Space", systemImage: "arrow.up.left.and.arrow.down.right").tag("Left Null Space")
                    }
                } label: {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text("Mode")
                    }
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            if matrixData.hasComputed {
                ZStack(alignment: .bottomTrailing) {
                    SubspacePlot3D(
                        basisVectors: basisVectors,
                        accentColor: colorForSubspace(selectedSubspace),
                        originalDimension: matrixData.rows,
                        mode: selectedSubspace,
                        inputVector: inputVector,
                        matrix: matrixData.getFractionMatrix().map { row in row.map { $0.asDouble } }
                    )
                    .frame(height: 500)
                    .cornerRadius(16)
                    .padding()
                    
                    if selectedSubspace == "Transformation" {
                        // Vector Values HUD
                        HStack(spacing: 16) {
                            VectorValueView(title: "Input x", vector: inputVector, color: .blue)
                            Image(systemName: "arrow.right").foregroundColor(.white.opacity(0.6))
                            VectorValueView(title: "Output Ax", vector: outputVector, color: .red)
                        }
                        .padding(12)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                        .padding(24)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        
                        // Legend
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack { Circle().fill(Color.blue).frame(width: 8, height: 8); Text("Input x").font(.caption).foregroundColor(.white) }
                            HStack { Circle().fill(Color.red).frame(width: 8, height: 8); Text("Output Ax").font(.caption).foregroundColor(.white) }
                        }
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                        .padding(24)
                    }
                }
                
                if selectedSubspace == "Transformation" {
                    VStack(spacing: 12) {
                        Text("Transform Vector x")
                            .font(.headline)
                        
                        HStack {
                            Text("x₁").bold().frame(width: 25)
                            Slider(value: $inputVector.x, in: -3...3)
                                .onChange(of: inputVector.x) { _ in checkNullSpace() }
                            Text(String(format: "%.1f", inputVector.x)).monospacedDigit().frame(width: 35)
                        }
                        HStack {
                            Text("x₂").bold().frame(width: 25)
                            Slider(value: $inputVector.y, in: -3...3)
                                .onChange(of: inputVector.y) { _ in checkNullSpace() }
                            Text(String(format: "%.1f", inputVector.y)).monospacedDigit().frame(width: 35)
                        }
                        if matrixData.cols > 2 {
                            HStack {
                                Text("x₃").bold().frame(width: 25)
                                Slider(value: $inputVector.z, in: -3...3)
                                    .onChange(of: inputVector.z) { _ in checkNullSpace() }
                                Text(String(format: "%.1f", inputVector.z)).monospacedDigit().frame(width: 35)
                            }
                        }
                        
                        if isNullSpaceFound {
                            Text("Null Space Found! Ax ≈ 0")
                                .font(.caption).bold()
                                .foregroundColor(.green)
                                .padding(8)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                                .transition(.scale)
                        } else {
                            Text("Drag x to explore.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                } else {
                    Text("Showing basis for \(selectedSubspace)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Enter a matrix to visualize.")
                    .foregroundColor(.secondary)
            }
        }
    }
}
