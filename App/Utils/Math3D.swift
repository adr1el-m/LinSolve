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
