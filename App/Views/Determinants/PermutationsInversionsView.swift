import SwiftUI

struct PermutationsInversionsView: View {
    @State private var permutationInput: String = "3142"
    @State private var showPermutationResult: Bool = false
    @State private var permutationMapping: [(Int, Int)] = []
    
    @State private var inversionInput: String = "15324"
    @State private var showInversionResult: Bool = false
    @State private var inversions: [(Int, Int, Int, Int)] = [] // (i, j, pi_i, pi_j)
    @State private var inversionCount: Int = 0
    @State private var parity: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Permutations & Inversions")
                        .font(.largeTitle)
                        .bold()
                    Text("The Foundation of Determinants")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
**Permutations** are fundamental to understanding determinants. A permutation is simply a rearrangement of a set of elements. When we calculate a determinant, we're actually summing over all possible permutations of column (or row) indices!

**Why do permutations matter?** The sign of each term in the determinant formula depends on whether the permutation is "even" or "odd" — and this is determined by counting **inversions**.
""")
                        .font(.body)
                        .padding(.vertical, 4)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Section 1: What is a Permutation?
                VStack(alignment: .leading, spacing: 16) {
                    Text("1. What is a Permutation?")
                        .font(.title2)
                        .bold()
                    
                    Text("""
A **permutation** of a set {1, 2, 3, ..., n} is a specific arrangement or ordering of all elements. We denote a permutation as π (pi).

**Think of it as a function:** π maps each position i to a new value π(i).

**Example:** For the set {1, 2, 3, 4}, one possible permutation is π = 3142.

This means:
• Position 1 → Value 3  (π(1) = 3)
• Position 2 → Value 1  (π(2) = 1)
• Position 3 → Value 4  (π(3) = 4)
• Position 4 → Value 2  (π(4) = 2)

The notation "3142" is a compact way of writing where each position maps to.
""")
                        .font(.body)
                    
                    // Interactive Permutation Demo
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Try It: Enter a Permutation")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        HStack {
                            Text("π = ")
                                .font(.system(.body, design: .serif))
                            TextField("3142", text: $permutationInput)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 120)
                            
                            Button("Map") {
                                computePermutationMapping()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        
                        Text("Enter digits (e.g., 3142 for a 4-element permutation)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if showPermutationResult && !permutationMapping.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Mapping:")
                                    .font(.subheadline)
                                    .bold()
                                
                                ForEach(permutationMapping, id: \.0) { (pos, val) in
                                    HStack {
                                        Text("π(\(pos))")
                                            .font(.system(.body, design: .monospaced))
                                        Text("=")
                                        Text("\(val)")
                                            .font(.system(.body, design: .monospaced))
                                            .bold()
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Section 2: Counting Inversions
                VStack(alignment: .leading, spacing: 16) {
                    Text("2. Counting Inversions")
                        .font(.title2)
                        .bold()
                    
                    Text("""
An **inversion** occurs when a larger number appears before a smaller number in the permutation. More precisely:

**Definition:** An inversion is a pair (i, j) where:
• i < j (position i comes before position j), BUT
• π(i) > π(j) (the value at position i is greater than at position j)

Inversions measure how "out of order" a permutation is. The identity permutation (1234...) has zero inversions.

**Example:** For π = 15324, let's find all inversions:

We check every pair where the first position has a larger value than the second:
• Positions (2,3): π(2)=5, π(3)=3 → 5 > 3 ✓ (Inversion!)
• Positions (2,4): π(2)=5, π(4)=2 → 5 > 2 ✓ (Inversion!)
• Positions (2,5): π(2)=5, π(5)=4 → 5 > 4 ✓ (Inversion!)
• Positions (3,4): π(3)=3, π(4)=2 → 3 > 2 ✓ (Inversion!)

**Total: 4 inversions**
""")
                        .font(.body)
                    
                    // Interactive Inversion Counter
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Try It: Count Inversions")
                            .font(.headline)
                            .foregroundColor(.purple)
                        
                        HStack {
                            Text("π = ")
                                .font(.system(.body, design: .serif))
                            TextField("15324", text: $inversionInput)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 120)
                            
                            Button("Count") {
                                computeInversions()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.purple)
                        }
                        
                        if showInversionResult {
                            VStack(alignment: .leading, spacing: 12) {
                                if !inversions.isEmpty {
                                    Text("Found Inversions:")
                                        .font(.subheadline)
                                        .bold()
                                    
                                    ForEach(inversions, id: \.0) { inv in
                                        HStack {
                                            Text("(\(inv.0), \(inv.1)):")
                                                .font(.system(.body, design: .monospaced))
                                            Text("π(\(inv.0)) = \(inv.2)")
                                                .foregroundColor(.secondary)
                                            Text(">")
                                                .foregroundColor(.red)
                                            Text("π(\(inv.1)) = \(inv.3)")
                                                .foregroundColor(.secondary)
                                        }
                                        .font(.caption)
                                    }
                                }
                                
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Total Inversions: \(inversionCount)")
                                        .font(.headline)
                                    Text("→")
                                    Text(parity)
                                        .font(.headline)
                                        .foregroundColor(parity == "Even" ? .blue : .orange)
                                }
                                .padding(.top, 8)
                            }
                            .padding()
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Section 3: Parity (Even vs Odd)
                VStack(alignment: .leading, spacing: 16) {
                    Text("3. Parity: Even or Odd Permutations")
                        .font(.title2)
                        .bold()
                    
                    Text("""
The **parity** of a permutation is determined by its number of inversions:

• **Even permutation:** Has an even number of inversions (0, 2, 4, ...)
• **Odd permutation:** Has an odd number of inversions (1, 3, 5, ...)

**Why does parity matter for determinants?**

In the determinant formula, each term is multiplied by **(-1)^k** where k is the number of inversions:
• Even permutations contribute **+** to the sum
• Odd permutations contribute **−** to the sum

This is why determinants can be positive or negative!
""")
                        .font(.body)
                    
                    // Examples
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Examples:")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("π = 15324")
                                    .font(.system(.body, design: .monospaced))
                                    .bold()
                                Text("4 inversions")
                                    .font(.caption)
                                Text("Even ✓")
                                    .foregroundColor(.blue)
                                    .bold()
                                Text("Sign: +1")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("σ = 213")
                                    .font(.system(.body, design: .monospaced))
                                    .bold()
                                Text("1 inversion (2 > 1)")
                                    .font(.caption)
                                Text("Odd ✗")
                                    .foregroundColor(.orange)
                                    .bold()
                                Text("Sign: −1")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Connection to Determinants
                VStack(alignment: .leading, spacing: 16) {
                    Text("4. Connection to Determinants")
                        .font(.title2)
                        .bold()
                    
                    Text("""
The determinant of an n×n matrix A is defined using permutations:

**det(A) = Σ sign(π) · a₁,π(1) · a₂,π(2) · ... · aₙ,π(n)**

Where:
• The sum is over all n! permutations π
• sign(π) = +1 if π is even, −1 if π is odd
• aᵢ,ⱼ is the entry in row i, column j

For each permutation, we pick one element from each row, with the column given by the permutation. The sign of the term depends on the parity.

**Example (2×2 matrix):**
There are 2! = 2 permutations:
• π = 12 (identity): sign = +1 → +a₁₁·a₂₂
• π = 21: sign = −1 (one inversion) → −a₁₂·a₂₁

So det(A) = a₁₁a₂₂ − a₁₂a₂₁ ✓
""")
                        .font(.body)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: - Helper Functions
    
    func computePermutationMapping() {
        let digits = permutationInput.compactMap { Int(String($0)) }
        guard !digits.isEmpty else { return }
        
        permutationMapping = digits.enumerated().map { (index, value) in
            (index + 1, value)
        }
        
        withAnimation {
            showPermutationResult = true
        }
    }
    
    func computeInversions() {
        let digits = inversionInput.compactMap { Int(String($0)) }
        guard digits.count >= 2 else { return }
        
        inversions = []
        
        for i in 0..<digits.count {
            for j in (i+1)..<digits.count {
                if digits[i] > digits[j] {
                    inversions.append((i + 1, j + 1, digits[i], digits[j]))
                }
            }
        }
        
        inversionCount = inversions.count
        parity = inversionCount % 2 == 0 ? "Even" : "Odd"
        
        withAnimation {
            showInversionResult = true
        }
    }
}
