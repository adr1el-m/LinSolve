import SwiftUI

struct VectorPreviewView: View {
    let vector: [Fraction]
    
    var body: some View {
        MatrixPreviewView(matrix: vector.map { [$0] })
    }
}
