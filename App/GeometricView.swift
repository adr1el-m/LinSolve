import SwiftUI
import simd

// MARK: - 3D Math Helpers

typealias Vec3 = SIMD3<Double>

func normalize(_ v: Vec3) -> Vec3 {
    let len = simd_length(v)
    if len < 1e-12 { return .zero }
    return v / len
}

func cross(_ a: Vec3, _ b: Vec3) -> Vec3 {
    return simd_cross(a, b)
}

func dot(_ a: Vec3, _ b: Vec3) -> Double {
    return simd_dot(a, b)
}

func add(_ a: Vec3, _ b: Vec3) -> Vec3 {
    return a + b
}

func scale(_ v: Vec3, _ s: Double) -> Vec3 {
    return v * s
}

func rotateX(_ v: Vec3, _ a: Double) -> Vec3 {
    let c = cos(a)
    let s = sin(a)
    return Vec3(v.x, v.y * c - v.z * s, v.y * s + v.z * c)
}

func rotateY(_ v: Vec3, _ a: Double) -> Vec3 {
    let c = cos(a)
    let s = sin(a)
    return Vec3(v.x * c + v.z * s, v.y, -v.x * s + v.z * c)
}

func rotateZ(_ v: Vec3, _ a: Double) -> Vec3 {
    let c = cos(a)
    let s = sin(a)
    return Vec3(v.x * c - v.y * s, v.x * s + v.y * c, v.z)
}

func applyRotation(_ v: Vec3, rx: Double, ry: Double, rz: Double) -> Vec3 {
    return rotateZ(rotateY(rotateX(v, rx), ry), rz)
}

// MARK: - Dimension Logic

func dimensionFromBasis(_ raw: [Vec3]) -> Int {
    let nonZero = raw.filter { simd_length($0) > 1e-9 }
    if nonZero.isEmpty { return 0 }
    
    let u0 = normalize(nonZero[0])
    if nonZero.count == 1 { return 1 }
    
    // Check if v1 is independent of u0
    if let v1 = nonZero.first(where: { simd_length(cross(u0, normalize($0))) > 1e-6 }) {
        let u1 = normalize(v1)
        let n = cross(u0, u1) // Normal to the plane
        
        // Check if any v2 is independent of the plane
        let uN = normalize(n)
        if nonZero.contains(where: { abs(dot(normalize($0), uN)) > 1e-6 }) {
            return 3
        }
        return 2
    }
    
    return 1
}

// MARK: - 3D Plot View

struct SubspacePlot3D: View {
    let basisVectors: [[Double]] // Input as array of doubles
    let accentColor: Color
    let originalDimension: Int
    
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
