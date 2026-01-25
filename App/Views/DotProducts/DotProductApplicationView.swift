import SwiftUI

struct DotProductApplicationView: View {
    // Default example: Unit prices and quantities
    @State private var priceVec: [String] = ["50", "30", "20"]
    @State private var quantityVec: [String] = ["3", "2", "6"]
    @State private var labels: [String] = ["Rice", "Soap", "Sardines"]
    
    @State private var showSteps: Bool = false
    @State private var dotProductResult: Fraction = Fraction(0)
    @State private var componentProducts: [Fraction] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("The Dot Product")
                        .font(.largeTitle)
                        .bold()
                    Text("The Most Fundamental Operation Between Vectors")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("What is the Dot Product?")
                            .font(.headline)
                        
                        Text("""
The **dot product** (also called the **inner product** or **scalar product**) is one of the most important operations in all of mathematics. It takes two vectors of the same size and produces a single number.

**Why is it so important?** The dot product appears everywhere:
• **Geometry:** It measures the angle between vectors
• **Physics:** Work = Force · Displacement (literally a dot product!)
• **Machine Learning:** Similarity between data points
• **Graphics:** Lighting calculations and projections
• **Economics:** Total cost = prices · quantities

**The Magic:** The sign of the dot product tells you about direction:
• **Positive** → vectors point in roughly the same direction (angle < 90°)
• **Zero** → vectors are perpendicular (exactly 90°)
• **Negative** → vectors point in roughly opposite directions (angle > 90°)
""")
                            .font(.body)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Formula Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("The Dot Product Formula")
                        .font(.headline)
                    
                    Text("For two vectors **p** = [p₁, p₂, ..., pₙ] and **q** = [q₁, q₂, ..., qₙ], the dot product is:")
                        .font(.body)
                    
                    Text("p · q = p₁q₁ + p₂q₂ + ... + pₙqₙ = Σᵢ pᵢqᵢ")
                        .font(.system(.title2, design: .serif))
                        .italic()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text("**Key Properties:**")
                        .font(.subheadline)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("• Both vectors must have the **same dimension**")
                        Text("• The result is always a **scalar** (single number)")
                        Text("• Order doesn't matter: **p · q = q · p** (commutative)")
                    }
                    .font(.body)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                // Input Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Define Your Vectors")
                        .font(.headline)
                    
                    Text("Enter unit prices and quantities for each item:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Table-like input
                    VStack(spacing: 8) {
                        // Header
                        HStack {
                            Text("Item")
                                .bold()
                                .frame(width: 80, alignment: .leading)
                            Text("Price (p)")
                                .bold()
                                .frame(width: 70)
                            Text("Qty (q)")
                                .bold()
                                .frame(width: 70)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                        
                        Divider()
                        
                        ForEach(0..<3, id: \.self) { i in
                            HStack {
                                TextField("Item", text: $labels[i])
                                    .frame(width: 80)
                                    .textFieldStyle(.roundedBorder)
                                
                                TextField("0", text: $priceVec[i])
                                    .keyboardType(.numbersAndPunctuation)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 70)
                                    .textFieldStyle(.roundedBorder)
                                
                                TextField("0", text: $quantityVec[i])
                                    .keyboardType(.numbersAndPunctuation)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 70)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(8)
                    
                    // Vector display
                    HStack(spacing: 30) {
                        VStack {
                            Text("Price Vector **p**")
                                .font(.caption)
                                .bold()
                            VectorDisplay(values: priceVec, color: .blue)
                        }
                        
                        Text("·")
                            .font(.largeTitle)
                        
                        VStack {
                            Text("Quantity Vector **q**")
                                .font(.caption)
                                .bold()
                            VectorDisplay(values: quantityVec, color: .green)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                    Button(action: compute) {
                        Text("Calculate Total Cost")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                // Solution Steps
                if showSteps {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Step-by-Step Solution")
                            .font(.title2)
                            .bold()
                        
                        // Step 1: Component-wise multiplication
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Step 1: Multiply Each Price by Its Quantity")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Text("The dot product multiplies corresponding components together. For each item, we calculate **price × quantity**:")
                                .font(.body)
                            
                            VStack(spacing: 8) {
                                ForEach(0..<3, id: \.self) { i in
                                    HStack {
                                        Text(labels[i])
                                            .frame(width: 80, alignment: .leading)
                                            .foregroundColor(.secondary)
                                        
                                        Text("\(priceVec[i]) × \(quantityVec[i])")
                                            .font(.system(.body, design: .monospaced))
                                        
                                        Spacer()
                                        
                                        Text("= \(componentProducts[i].description)")
                                            .font(.system(.body, design: .monospaced))
                                            .bold()
                                    }
                                    .padding(8)
                                    .background(Color.yellow.opacity(0.1))
                                    .cornerRadius(6)
                                }
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        // Step 2: Sum all products
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Step 2: Sum All Products")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Text("Now we add all the component products together to get the total:")
                                .font(.body)
                            
                            let productStrings = componentProducts.map { $0.description }
                            
                            VStack(spacing: 8) {
                                Text("p · q = \(productStrings.joined(separator: " + "))")
                                    .font(.system(.body, design: .monospaced))
                                
                                Text("p · q = \(dotProductResult.description)")
                                    .font(.system(.title3, design: .monospaced))
                                    .bold()
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        // Final Result
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Final Result")
                                .font(.headline)
                            
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title)
                                
                                VStack(alignment: .leading) {
                                    Text("Total Cost = ₱\(dotProductResult.description)")
                                        .font(.title2)
                                        .bold()
                                    
                                    Text("The dot product p · q gives us the total price for all items.")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        // Why It Works
                        VStack(alignment: .leading, spacing: 8) {
                            Text("💡 Why This Works")
                                .font(.headline)
                            
                            Text("""
The dot product naturally models situations where you need to combine **paired quantities**. Each component of one vector "matches" with the corresponding component of the other vector.

In this example:
• p₁ × q₁ = cost of \(labels[0])
• p₂ × q₂ = cost of \(labels[1])
• p₃ × q₃ = cost of \(labels[2])

The sum gives the **total** cost. This same pattern appears in physics (work = force · displacement), statistics (weighted averages), and machine learning (neural network computations).
""")
                                .font(.body)
                        }
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding()
                    .transition(.opacity)
                }
                
                Spacer()
            }
        }
    }
    
    func compute() {
        let prices = priceVec.map { Fraction(string: $0) }
        let quantities = quantityVec.map { Fraction(string: $0) }
        
        // Component-wise products
        componentProducts = zip(prices, quantities).map { $0 * $1 }
        
        // Sum for dot product
        dotProductResult = componentProducts.reduce(Fraction(0), +)
        
        withAnimation {
            showSteps = true
        }
    }
}

// Helper view for displaying a vector
struct VectorDisplay: View {
    let values: [String]
    var color: Color = .primary
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(values, id: \.self) { val in
                Text(val)
                    .font(.system(.body, design: .monospaced))
                    .frame(minWidth: 40)
                    .foregroundColor(color)
            }
        }
        .padding(8)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(8)
        .overlay(
            HStack {
                BracketShape(left: true)
                    .stroke(color, lineWidth: 1.5)
                    .frame(width: 8)
                Spacer()
                BracketShape(left: false)
                    .stroke(color, lineWidth: 1.5)
                    .frame(width: 8)
            }
        )
    }
}
