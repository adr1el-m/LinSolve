import SwiftUI

struct CheckingLinearityView: View {
    @State private var selectedExample: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "questionmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("Checking Linearity")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Testing Additivity and Homogeneity")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Two Conditions
                VStack(alignment: .leading, spacing: 16) {
                    Text("The Two Requirements for Linearity")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        LinearityConditionBox(
                            number: 1,
                            name: "Additivity",
                            formula: "T(x + y) = T(x) + T(y)",
                            description: "The image of a sum equals the sum of images",
                            color: .blue
                        )
                        
                        LinearityConditionBox(
                            number: 2,
                            name: "Homogeneity",
                            formula: "T(cx) = cT(x)",
                            description: "Scaling before or after gives the same result",
                            color: .purple
                        )
                    }
                    
                    Text("**Tip:** To prove something is NOT linear, you only need ONE counterexample that violates either condition.")
                        .font(.caption)
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Picker("Example", selection: $selectedExample) {
                    Text("Linear Examples").tag(0)
                    Text("Non-Linear: Squares").tag(1)
                    Text("Non-Linear: Translation").tag(2)
                }
                .pickerStyle(.segmented)
                
                if selectedExample == 0 {
                    LinearExamplesView()
                } else if selectedExample == 1 {
                    NonLinearSquaresExample()
                } else {
                    NonLinearTranslationExample()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct LinearityConditionBox: View {
    let number: Int
    let name: String
    let formula: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.caption)
                .bold()
                .frame(width: 24, height: 24)
                .background(color)
                .foregroundColor(.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                Text(formula)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(color)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Linear Examples (213, 214)
struct LinearExamplesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Classic Linear Transformations")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 16) {
                // Zero Map
                VStack(alignment: .leading, spacing: 8) {
                    Text("Zero Map: ζ(x) = 0")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.gray)
                    
                    Text("• ζ(x + y) = 0 = 0 + 0 = ζ(x) + ζ(y) ✓")
                        .font(.caption)
                    Text("• ζ(cx) = 0 = c·0 = cζ(x) ✓")
                        .font(.caption)
                    
                    Text("Always linear (though not very useful!)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
                
                // Identity Map
                VStack(alignment: .leading, spacing: 8) {
                    Text("Identity Map: id(x) = x")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.blue)
                    
                    Text("• id(x + y) = x + y = id(x) + id(y) ✓")
                        .font(.caption)
                    Text("• id(cx) = cx = c·id(x) ✓")
                        .font(.caption)
                    
                    Text("Trivially linear — nothing changes!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                
                // Dilation
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dilation: d_λ(x) = λx")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.green)
                    
                    Text("• d_λ(x + y) = λ(x + y) = λx + λy = d_λ(x) + d_λ(y) ✓")
                        .font(.caption)
                    Text("• d_λ(cx) = λ(cx) = c(λx) = c·d_λ(x) ✓")
                        .font(.caption)
                    
                    Text("Scaling is always linear — it's just matrix λI")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Non-Linear: Squares (Example 216.1)
struct NonLinearSquaresExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Non-Linear: Squares and Products")
                .font(.headline)
            
            Text("Map: f([x, y, z]ᵀ) = [x² + y² + z², xy + z]ᵀ")
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Counterexample (Additivity)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.red)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Let u = [1, 1, 1]ᵀ and v = [-1, -1, -1]ᵀ")
                        .font(.caption)
                    
                    HStack(alignment: .top, spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("f(u) + f(v):")
                                .font(.caption2).bold()
                            Text("f([1,1,1]) = [3, 2]ᵀ")
                                .font(.system(.caption2, design: .monospaced))
                            Text("f([-1,-1,-1]) = [3, 2]ᵀ")
                                .font(.system(.caption2, design: .monospaced))
                            Text("Sum = [6, 4]ᵀ")
                                .font(.system(.caption, design: .monospaced))
                                .bold()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("f(u + v):")
                                .font(.caption2).bold()
                            Text("u + v = [0, 0, 0]ᵀ")
                                .font(.system(.caption2, design: .monospaced))
                            Text("f([0,0,0]) = [0, 0]ᵀ")
                                .font(.system(.caption, design: .monospaced))
                                .bold()
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            }
            
            HStack {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                Text("[6, 4]ᵀ ≠ [0, 0]ᵀ → f is NOT linear")
                    .font(.body)
                    .bold()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.red.opacity(0.1))
            .cornerRadius(8)
            
            Text("**Why?** Squaring and multiplying are nonlinear operations. (x+y)² ≠ x² + y²")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Non-Linear: Translation (Example 216.2)
struct NonLinearTranslationExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Non-Linear: Translation")
                .font(.headline)
            
            Text("Map: g([x, y]ᵀ) = [2x + 3, y - 4]ᵀ")
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            
            Text("This looks almost linear, but the constants (+3, -4) are the problem!")
                .font(.caption)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Counterexample (Homogeneity)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.red)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Let u = [1, 1]ᵀ and c = 2")
                        .font(.caption)
                    
                    HStack(alignment: .top, spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("g(cu) = g(2u):")
                                .font(.caption2).bold()
                            Text("g([2, 2]) = [7, -2]ᵀ")
                                .font(.system(.caption, design: .monospaced))
                                .bold()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("c·g(u) = 2·g(u):")
                                .font(.caption2).bold()
                            Text("g([1, 1]) = [5, -3]ᵀ")
                                .font(.system(.caption2, design: .monospaced))
                            Text("2·[5, -3] = [10, -6]ᵀ")
                                .font(.system(.caption, design: .monospaced))
                                .bold()
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            }
            
            HStack {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                Text("[7, -2]ᵀ ≠ [10, -6]ᵀ → g is NOT linear")
                    .font(.body)
                    .bold()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.red.opacity(0.1))
            .cornerRadius(8)
            
            Text("**Key insight:** Linear maps must send 0 to 0. Here, g(0) = [3, -4] ≠ 0. Translations shift the origin!")
                .font(.caption)
                .padding()
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}
