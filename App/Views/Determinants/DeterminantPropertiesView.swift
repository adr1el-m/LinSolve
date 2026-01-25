import SwiftUI

struct DeterminantPropertiesView: View {
    @State private var selectedProperty: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Determinant Properties")
                        .font(.largeTitle)
                        .bold()
                    Text("Row Operations & Simplification Techniques")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("""
Understanding how determinants behave under various operations is crucial for efficient calculations. These properties allow us to simplify matrices before computing the determinant, often turning a tedious calculation into a simple one.

**Key insight:** We can use row operations to transform a matrix into triangular form, where the determinant is just the product of diagonal entries!
""")
                        .font(.body)
                        .padding(.vertical, 4)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Property Navigator
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        PropertyTabButton(title: "Row/Col Swap", icon: "arrow.left.arrow.right", isSelected: selectedProperty == 0) {
                            selectedProperty = 0
                        }
                        PropertyTabButton(title: "Scalar Multiple", icon: "multiply.circle", isSelected: selectedProperty == 1) {
                            selectedProperty = 1
                        }
                        PropertyTabButton(title: "Row Addition", icon: "plus.circle", isSelected: selectedProperty == 2) {
                            selectedProperty = 2
                        }
                        PropertyTabButton(title: "Triangular Form", icon: "triangle", isSelected: selectedProperty == 3) {
                            selectedProperty = 3
                        }
                        PropertyTabButton(title: "Zero Determinant", icon: "0.circle", isSelected: selectedProperty == 4) {
                            selectedProperty = 4
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Content based on selection
                switch selectedProperty {
                case 0:
                    RowColSwapSection()
                case 1:
                    ScalarMultipleSection()
                case 2:
                    RowAdditionSection()
                case 3:
                    TriangularFormSection()
                case 4:
                    ZeroDeterminantSection()
                default:
                    EmptyView()
                }
                
                // Vandermonde Determinant Section (always visible)
                VandermondeDeterminantSection()
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Property Tab Button

struct PropertyTabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color(uiColor: .tertiarySystemBackground))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

// MARK: - Property Sections

struct RowColSwapSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Property 1: Row or Column Swap")
                .font(.title2)
                .bold()
            
            Text("""
**Swapping two rows (or columns) multiplies the determinant by −1.**

This is why we track sign changes when doing row operations!

**Mathematical statement:**
If B is obtained from A by swapping two rows, then:
det(B) = −det(A)
""")
                .font(.body)
            
            // Worked Example
            VStack(alignment: .leading, spacing: 12) {
                Text("Example: Simplifying via Row/Column Swaps")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text("""
Consider the matrix:
┌ 0  0  5  2 ┐
│ 1  0  0  0 │
│ 0  4  0  0 │
└ 0  0  3  0 ┘

This sparse matrix can be simplified by swapping rows and columns to get zeros below the diagonal.
""")
                    .font(.body)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Operations:")
                        .font(.subheadline)
                        .bold()
                    
                    HStack {
                        Image(systemName: "1.circle.fill")
                            .foregroundColor(.blue)
                        Text("Swap columns 2 ↔ 4")
                        Text("(Sign: −)")
                            .foregroundColor(.red)
                    }
                    .font(.caption)
                    
                    HStack {
                        Image(systemName: "2.circle.fill")
                            .foregroundColor(.blue)
                        Text("Swap rows 1 ↔ 2")
                        Text("(Sign: − × − = +)")
                            .foregroundColor(.green)
                    }
                    .font(.caption)
                    
                    HStack {
                        Image(systemName: "3.circle.fill")
                            .foregroundColor(.blue)
                        Text("Swap rows 3 ↔ 4")
                        Text("(Sign: + × − = −)")
                            .foregroundColor(.red)
                    }
                    .font(.caption)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                
                Text("""
After operations, we get an upper triangular matrix with diagonal: 1, 2, 3, 4

**Result:** det = −(1 · 2 · 3 · 4) = **−24**
""")
                    .font(.body)
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("det(A) =")
                        .font(.system(.body, design: .monospaced))
                    Text("−24")
                        .font(.system(.title3, design: .monospaced))
                        .bold()
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(10)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct ScalarMultipleSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Property 2: Scalar Multiplication")
                .font(.title2)
                .bold()
            
            Text("""
**Multiplying a row by scalar c multiplies the determinant by c.**

**Key formulas:**
• If one row is multiplied by c: det(new) = c · det(original)
• If entire matrix is multiplied by c: det(cA) = cⁿ · det(A) for n×n matrix

**Useful corollary:** We can factor out common factors from rows to simplify calculations.
""")
                .font(.body)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Example: Factoring Out Constants")
                    .font(.headline)
                    .foregroundColor(.purple)
                
                Text("""
If a row has a common factor, factor it out:

┌ 6  12  18 ┐       ┌ 1  2  3 ┐
│ 1   2   3 │ = 6 · │ 1  2  3 │
└ 4   5   6 ┘       └ 4  5  6 ┘

The second matrix has two identical rows, so its determinant is 0!

**Result:** det = 6 · 0 = **0**
""")
                    .font(.body)
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(10)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct RowAdditionSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Property 3: Adding Rows")
                .font(.title2)
                .bold()
            
            Text("""
**Adding a multiple of one row to another row does NOT change the determinant!**

This is the key property that makes Gaussian elimination work for determinant calculation.

**Mathematical statement:**
Rᵢ → Rᵢ + cRⱼ preserves the determinant.

This is why we can zero out entries below pivots without tracking any sign or factor changes.
""")
                .font(.body)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Why This Works")
                    .font(.headline)
                    .foregroundColor(.orange)
                
                Text("""
Row operations of the form Rᵢ + cRⱼ are equivalent to multiplying by an elementary matrix with determinant 1. Since det(EA) = det(E)·det(A) = 1·det(A), the determinant is unchanged.

**Application:** We can freely add multiples of rows to create zeros, making the matrix easier to work with.
""")
                    .font(.body)
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(10)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct TriangularFormSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Property 4: Triangular Form")
                .font(.title2)
                .bold()
            
            Text("""
**For a triangular matrix (upper or lower), the determinant equals the product of diagonal entries.**

This is why we perform row reduction! Transform to triangular form, then multiply the diagonal.

**Key insight:** Combine with Property 3 to reduce any matrix to triangular form without changing the determinant (just track row swaps).
""")
                .font(.body)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Example: Full Gaussian Elimination")
                    .font(.headline)
                    .foregroundColor(.teal)
                
                Text("""
Evaluate the determinant of:
┌ 1  −1   2   3 ┐
│ 2   2   0   2 │
│ 1   2   3   0 │
└ 5   3   2  −1 ┘
""")
                    .font(.body)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 1: Eliminate column 1 using R₁")
                        .font(.subheadline)
                        .bold()
                    Text("R₂ → R₂ − 2R₁,  R₃ → R₃ − R₁,  R₄ → R₄ − 5R₁")
                        .font(.system(.caption, design: .monospaced))
                    
                    Text("Step 2: Scale R₂ by 1/4")
                        .font(.subheadline)
                        .bold()
                    Text("This multiplies det by 1/4, so we multiply final result by 4")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Step 3: Eliminate column 2 using R₂")
                        .font(.subheadline)
                        .bold()
                    
                    Text("Final upper triangular form has diagonal: 1, 1, 4, −8")
                        .font(.system(.caption, design: .monospaced))
                }
                .padding()
                .background(Color.teal.opacity(0.1))
                .cornerRadius(8)
                
                Text("""
**Calculation:**
det = 4 × (1 · 1 · 4 · (−8)) = 4 × (−32) = **−128**

(The factor 4 comes from scaling R₂ by 1/4 earlier)
""")
                    .font(.body)
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("det(A) =")
                        .font(.system(.body, design: .monospaced))
                    Text("−128")
                        .font(.system(.title3, design: .monospaced))
                        .bold()
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(10)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct ZeroDeterminantSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Property 5: Zero Determinant")
                .font(.title2)
                .bold()
            
            Text("""
**The determinant is zero if and only if the matrix is singular (non-invertible).**

This happens when:
• Two rows (or columns) are identical
• A row is a scalar multiple of another
• A row is a linear combination of other rows
• The matrix has a row or column of all zeros
""")
                .font(.body)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Example: Proportional Rows")
                    .font(.headline)
                    .foregroundColor(.red)
                
                Text("""
Consider matrix A with rows:
R₁ = [1, −2, 1]  and  R₃ = [−2, 4, −2]

Notice that R₃ = −2R₁. This means the rows are linearly dependent!

**Method:** Factor out −2 from R₃:
┌  1  −2   1 ┐          ┌ 1  −2  1 ┐
│  a   b   c │ = (−2) · │ a   b  c │
└ −2   4  −2 ┘          └ 1  −2  1 ┘

The new matrix has identical rows 1 and 3 → det = 0

**Result:** det(A) = (−2) · 0 = **0**
""")
                    .font(.body)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quick Tests for det = 0:")
                        .font(.subheadline)
                        .bold()
                    
                    HStack {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                        Text("Any row/column is all zeros")
                    }
                    .font(.caption)
                    
                    HStack {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                        Text("Two rows/columns are identical")
                    }
                    .font(.caption)
                    
                    HStack {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                        Text("One row is a multiple of another")
                    }
                    .font(.caption)
                    
                    HStack {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                        Text("Rows are linearly dependent")
                    }
                    .font(.caption)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(10)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct VandermondeDeterminantSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Special: Vandermonde Determinant")
                .font(.title2)
                .bold()
            
            Text("""
The **Vandermonde matrix** appears frequently in polynomial interpolation. It has a beautiful closed-form determinant formula.

**Structure:**
┌ 1  a  a² ┐
│ 1  b  b² │
└ 1  c  c² ┘

**Formula:** det(V) = (b−a)(c−a)(c−b)

More generally, the n×n Vandermonde determinant is the product of all (xⱼ − xᵢ) for j > i.
""")
                .font(.body)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Computing via Row Reduction")
                    .font(.headline)
                    .foregroundColor(.indigo)
                
                Text("""
**Step 1:** Subtract Row 1 from Rows 2 and 3:
┌ 1    a      a²    ┐
│ 0   b−a   b²−a²   │
└ 0   c−a   c²−a²   ┘

**Step 2:** Factor:
b²−a² = (b−a)(b+a) and c²−a² = (c−a)(c+a)

Factor (b−a) from Row 2 and (c−a) from Row 3.

**Step 3:** The remaining 2×2 determinant gives (c−b).

**Final result:** (b−a)(c−a)(c−b)
""")
                    .font(.body)
                
                HStack {
                    Image(systemName: "function")
                        .foregroundColor(.indigo)
                    Text("det(V) = (b−a)(c−a)(c−b)")
                        .font(.system(.body, design: .serif))
                        .italic()
                }
                .padding()
                .background(Color.indigo.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(10)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}
