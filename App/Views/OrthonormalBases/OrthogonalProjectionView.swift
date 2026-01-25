import SwiftUI

struct OrthogonalProjectionView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "arrow.down.to.line")
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                        Text("Orthogonal Projection")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Decomposing Vectors Using an Orthogonal Basis")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Formula Box
                VStack(alignment: .leading, spacing: 12) {
                    Text("The Projection Formula")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("To project vector v onto a basis vector u:")
                            .font(.body)
                        
                        Text("projᵤv = (v · u / ||u||²) · u")
                            .font(.system(.title3, design: .monospaced))
                            .bold()
                            .foregroundColor(.purple)
                            .padding()
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("This gives the \"shadow\" of v in the direction of u.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    Text("For an orthogonal basis {v₁, ..., vₙ}, any vector can be written as:")
                        .font(.body)
                    
                    Text("v = projᵥ₁v + projᵥ₂v + ... + projᵥₙv")
                        .font(.system(.body, design: .monospaced))
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Picker("Example", selection: $selectedTab) {
                    Text("Single Projection").tag(0)
                    Text("Decomposition").tag(1)
                    Text("Fourier Coefficients").tag(2)
                }
                .pickerStyle(.segmented)
                
                if selectedTab == 0 {
                    SingleProjectionExample()
                } else if selectedTab == 1 {
                    DecompositionExample()
                } else {
                    FourierCoefficientsExample()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Single Projection (Example 201)
struct SingleProjectionExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Orthogonal Projection Calculation")
                .font(.headline)
            
            Text("Input: v = [1, 2, 3]ᵀ and basis vector v₁ = [1, 1, 0]ᵀ")
                .font(.body)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                ProjectionStepView(
                    step: 1,
                    title: "Compute Dot Product v · v₁",
                    calculation: "1(1) + 2(1) + 3(0) = 1 + 2 + 0",
                    result: "= 3"
                )
                
                ProjectionStepView(
                    step: 2,
                    title: "Compute ||v₁||²",
                    calculation: "1² + 1² + 0²",
                    result: "= 2"
                )
                
                ProjectionStepView(
                    step: 3,
                    title: "Apply Formula",
                    calculation: "(3/2) · [1, 1, 0]ᵀ",
                    result: "= [3/2, 3/2, 0]ᵀ"
                )
            }
            
            HStack {
                Image(systemName: "arrow.down.to.line")
                    .foregroundColor(.purple)
                VStack(alignment: .leading) {
                    Text("Result")
                        .font(.headline)
                    Text("projᵥ₁v = [1.5, 1.5, 0]ᵀ")
                        .font(.system(.body, design: .monospaced))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.purple.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Orthogonal Basis Decomposition (Example 201 continued)
struct DecompositionExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Orthogonal Basis Decomposition")
                .font(.headline)
            
            Text("Input: v = [1, 2, 3]ᵀ and orthogonal basis B = {v₁, v₂, v₃}")
                .font(.body)
            
            Divider()
            
            Text("Calculate projection onto EACH basis vector:")
                .font(.subheadline)
                .bold()
            
            VStack(alignment: .leading, spacing: 10) {
                DecompositionRow(
                    basis: "projᵥ₁v",
                    result: "[3/2, 3/2, 0]ᵀ",
                    note: "(calculated above)"
                )
                
                DecompositionRow(
                    basis: "projᵥ₂v",
                    result: "[-10/9, 10/9, 5/9]ᵀ",
                    note: "coefficient = (2-4-3)/9 = -5/9"
                )
                
                DecompositionRow(
                    basis: "projᵥ₃v",
                    result: "[11/18, -11/18, 22/9]ᵀ",
                    note: "coefficient = (1-2+12)/18 = 11/18"
                )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Result: Sum of Projections")
                    .font(.headline)
                
                Text("v = projᵥ₁v + projᵥ₂v + projᵥ₃v")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(6)
                
                Text("This works because the basis is orthogonal — there's no \"overlap\" between projections.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Fourier Coefficients (Example 199)
struct FourierCoefficientsExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Finding Fourier Coefficients")
                .font(.headline)
            
            Text("Goal: Find coefficients c₁, c₂, c₃ such that:")
                .font(.body)
            
            Text("v = c₁v₁ + c₂v₂ + c₃v₃")
                .font(.system(.body, design: .monospaced))
                .padding(8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(6)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("The Formula")
                    .font(.subheadline)
                    .bold()
                
                Text("cᵢ = (v · vᵢ) / ||vᵢ||²")
                    .font(.system(.title3, design: .monospaced))
                    .foregroundColor(.orange)
                
                Text("This is simply the projection coefficient!")
                    .font(.caption)
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Calculation")
                    .font(.subheadline)
                    .bold()
                
                FourierRow(coeff: "c₁", calculation: "(v · v₁)/||v₁||²", result: "3/2")
                FourierRow(coeff: "c₂", calculation: "(v · v₂)/||v₂||²", result: "-5/9")
                FourierRow(coeff: "c₃", calculation: "(v · v₃)/||v₃||²", result: "11/18")
            }
            
            HStack {
                Image(systemName: "function")
                    .foregroundColor(.orange)
                Text("These are called Fourier coefficients because they're analogous to Fourier series in signal processing.")
                    .font(.caption)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct ProjectionStepView: View {
    let step: Int
    let title: String
    let calculation: String
    let result: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(step)")
                .font(.caption)
                .bold()
                .frame(width: 24, height: 24)
                .background(Color.purple)
                .foregroundColor(.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                HStack {
                    Text(calculation)
                        .font(.system(.caption, design: .monospaced))
                    Text(result)
                        .font(.system(.caption, design: .monospaced))
                        .bold()
                        .foregroundColor(.purple)
                }
            }
        }
        .padding(8)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(6)
    }
}

struct DecompositionRow: View {
    let basis: String
    let result: String
    let note: String
    
    var body: some View {
        HStack {
            Text(basis)
                .font(.system(.subheadline, design: .monospaced))
                .bold()
            Spacer()
            VStack(alignment: .trailing) {
                Text(result)
                    .font(.system(.caption, design: .monospaced))
                Text(note)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(8)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(6)
    }
}

struct FourierRow: View {
    let coeff: String
    let calculation: String
    let result: String
    
    var body: some View {
        HStack {
            Text(coeff)
                .font(.headline)
                .foregroundColor(.orange)
            Text("=")
            Text(calculation)
                .font(.system(.caption, design: .monospaced))
            Spacer()
            Text("= " + result)
                .font(.system(.body, design: .monospaced))
                .bold()
        }
        .padding(6)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(6)
    }
}
