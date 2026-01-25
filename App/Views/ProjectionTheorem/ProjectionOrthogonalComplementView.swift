import SwiftUI

struct ProjectionOrthogonalComplementView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "arrow.up.and.down.circle")
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                        Text("Projection to Complement")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Finding P_W⊥ using the Identity Matrix")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Concept
                VStack(alignment: .leading, spacing: 12) {
                    Text("The Projection Theorem")
                        .font(.headline)
                    
                    Text("Any vector x can be uniquely decomposed into two orthogonal parts:")
                        .font(.body)
                    
                    Text("x = x_W + x_W⊥")
                        .font(.system(.title2, design: .monospaced))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text("This implies the relationship between projection matrices:")
                        .font(.body)
                    
                    Text("P_W⊥ = I - P_W")
                        .font(.system(.title2, design: .monospaced))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                        Text("Why is this useful? Often easier to find P for a line (dim 1) and subtract from I, than to find P for a plane (dim 2) directly!")
                            .font(.caption)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Example 279
                ComplementProjectionExample()
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Example 279
struct ComplementProjectionExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: Projection onto W⊥")
                .font(.headline)
            
            Text("Input: Projection matrix P for W (from Ex 277)")
                .font(.body)
            
            Text("""
                    ┌ 13/14   1/7  -3/14 ┐
                P = │  1/7    5/7    3/7  │
                    └ -3/14   3/7    5/14 ┘
            """)
                .font(.system(.caption, design: .monospaced))
                .padding(8)
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(6)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Operation: Compute I₃ - P")
                    .font(.subheadline)
                    .bold()
                
                HStack(alignment: .center, spacing: 4) {
                    Text("""
                    ┌ 1 0 0 ┐
                    │ 0 1 0 │
                    └ 0 0 1 ┘
                    """)
                    .font(.system(.caption2, design: .monospaced))
                    
                    Text("-")
                    
                    Text("""
                    ┌ 13/14 ... ┐
                    │  ...  ... │
                    └  ...  ... ┘
                    """)
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundColor(.secondary)
                }
                .padding()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Result: P_W⊥")
                    .font(.headline)
                
                Text("""
                         ┌  1/14  -1/7   3/14 ┐
                    P⊥ = │ -1/7    2/7  -3/7  │
                         └  3/14  -3/7   9/14 ┘
                """)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(8)
                
                Text("Context: This matrix projects vectors onto the NORMAL line spanned by a = [1, -2, 3]ᵀ.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}
