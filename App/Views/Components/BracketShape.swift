import SwiftUI

struct BracketShape: Shape {
    let left: Bool
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        // Use full width for the arm if small, or limit it?
        // In MatrixPreviewView we used w. In VectorArithmeticView we used 6.
        // Let's use w but maybe clamp it if needed. 
        // For consistency with the MatrixPreviewView which looked good:
        let arm: CGFloat = w 
        
        if left {
            path.move(to: CGPoint(x: arm, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: h))
            path.addLine(to: CGPoint(x: arm, y: h))
        } else {
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: w, y: 0))
            path.addLine(to: CGPoint(x: w, y: h))
            path.addLine(to: CGPoint(x: 0, y: h))
        }
        return path
    }
}
