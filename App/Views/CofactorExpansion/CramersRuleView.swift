import SwiftUI

struct CramersRuleView: View {
    @State private var selectedTab: Int = 0
    
    // 2x2 system example
    @State private var system2x2: [[String]] = [
        ["2", "3", "2"],
        ["1", "2", "0"]
    ]
    @State private var show2x2Solution: Bool = false
    
    // 3x3 system example
    @State private var system3x3: [[String]] = [
        ["2", "1", "1", "6"],
        ["3", "2", "-2", "-2"],
        ["1", "1", "2", "-4"]
    ]
    @State private var show3x3Solution: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "x.squareroot")
                            .font(.largeTitle)
                            .foregroundColor(.teal)
                        Text("Cramer's Rule")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text("Solving Linear Systems Using Determinants")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Introduction
                VStack(alignment: .leading, spacing: 16) {
                    Text("What is Cramer's Rule?")
                        .font(.headline)
                    
                    Text("Cramer's Rule is a method for solving a system of linear equations Ax = b when the coefficient matrix A is invertible (det A ≠ 0). It expresses each variable as a ratio of two determinants.")
                        .font(.body)
                    
                    Text("Named after Swiss mathematician Gabriel Cramer (1704-1752), this rule gives an explicit formula for the solution without requiring row reduction.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // The Formula
                VStack(alignment: .leading, spacing: 16) {
                    Text("Cramer's Rule Formula")
                        .font(.headline)
                    
                    Text("For a system Ax = b with n equations and n unknowns:")
                        .font(.body)
                    
                    VStack(spacing: 12) {
                        Text("xᵢ = det(Aᵢ) / det(A)")
                            .font(.system(.title2, design: .monospaced))
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("Where Aᵢ is the matrix A with column i replaced by the vector b.")
                            .font(.body)
                    }
                    
                    // Visual explanation
                    VStack(alignment: .leading, spacing: 12) {
                        Text("For a 2×2 system:")
                            .font(.subheadline)
                            .bold()
                        
                        HStack(spacing: 4) {
                            Text("a₁x + b₁y = c₁")
                            Spacer()
                        }
                        HStack(spacing: 4) {
                            Text("a₂x + b₂y = c₂")
                            Spacer()
                        }
                        
                        HStack(spacing: 20) {
                            VStack {
                                Text("x = |c₁ b₁|")
                                    .font(.system(.caption, design: .monospaced))
                                Text("    |c₂ b₂|")
                                    .font(.system(.caption, design: .monospaced))
                                Text("    ―――――")
                                    .font(.system(.caption, design: .monospaced))
                                Text("    |a₁ b₁|")
                                    .font(.system(.caption, design: .monospaced))
                                Text("    |a₂ b₂|")
                                    .font(.system(.caption, design: .monospaced))
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                            
                            VStack {
                                Text("y = |a₁ c₁|")
                                    .font(.system(.caption, design: .monospaced))
                                Text("    |a₂ c₂|")
                                    .font(.system(.caption, design: .monospaced))
                                Text("    ―――――")
                                    .font(.system(.caption, design: .monospaced))
                                Text("    |a₁ b₁|")
                                    .font(.system(.caption, design: .monospaced))
                                Text("    |a₂ b₂|")
                                    .font(.system(.caption, design: .monospaced))
                            }
                            .padding()
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Requirements
                VStack(alignment: .leading, spacing: 12) {
                    Text("⚠️ When Can We Use Cramer's Rule?")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("The system must have the SAME number of equations as unknowns (n×n coefficient matrix)")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("The coefficient matrix A must be invertible (det A ≠ 0)")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("If det A = 0, the system either has no solution or infinitely many solutions")
                        }
                    }
                    .font(.body)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
                
                // Tab Selection for Examples
                Picker("Example", selection: $selectedTab) {
                    Text("2×2 System").tag(0)
                    Text("3×3 System").tag(1)
                }
                .pickerStyle(.segmented)
                
                // Examples
                if selectedTab == 0 {
                    Example2x2SystemView()
                } else {
                    Example3x3SystemView()
                }
                
                // Interactive Calculator
                if selectedTab == 0 {
                    Cramer2x2Calculator(system: $system2x2, showSolution: $show2x2Solution)
                } else {
                    Cramer3x3Calculator(system: $system3x3, showSolution: $show3x3Solution)
                }
                
                // Pros and Cons
                VStack(alignment: .leading, spacing: 16) {
                    Text("When to Use Cramer's Rule")
                        .font(.headline)
                    
                    HStack(alignment: .top, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("✅ Advantages")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.green)
                            
                            Text("• Gives explicit formula for each variable")
                                .font(.caption)
                            Text("• Good for symbolic/theoretical work")
                                .font(.caption)
                            Text("• Each variable can be found independently")
                                .font(.caption)
                            Text("• Great for 2×2 and 3×3 systems")
                                .font(.caption)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("❌ Disadvantages")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.red)
                            
                            Text("• Computationally expensive for large n")
                                .font(.caption)
                            Text("• Requires n+1 determinant calculations")
                                .font(.caption)
                            Text("• Only works for n×n invertible systems")
                                .font(.caption)
                            Text("• Row reduction is faster for large systems")
                                .font(.caption)
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - 2x2 System Example (Example 145)

struct Example2x2SystemView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: 2×2 System")
                .font(.headline)
            
            Text("Solve the system:")
                .font(.body)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("2x + 3y = 2")
                Text(" x + 2y = 0")
            }
            .font(.system(.body, design: .monospaced))
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Step 1: Calculate det(A)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("The coefficient matrix is:")
                    .font(.body)
                
                Text("""
                        |2  3|
                    A = |1  2|
                """)
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(6)
                
                Text("det(A) = 2(2) - 3(1) = 4 - 3 = 1")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                
                Text("Since det(A) = 1 ≠ 0, the system has a unique solution!")
                    .font(.caption)
                    .foregroundColor(.green)
                
                Text("Step 2: Calculate det(Aₓ)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Replace column 1 of A with b = [2, 0]:")
                    .font(.body)
                
                Text("""
                         |2  3|
                    Aₓ = |0  2|
                """)
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(6)
                
                Text("det(Aₓ) = 2(2) - 3(0) = 4 - 0 = 4")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(6)
                
                Text("Step 3: Calculate det(Aᵧ)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Replace column 2 of A with b = [2, 0]:")
                    .font(.body)
                
                Text("""
                         |2  2|
                    Aᵧ = |1  0|
                """)
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(6)
                
                Text("det(Aᵧ) = 2(0) - 2(1) = 0 - 2 = -2")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(6)
                
                Text("Step 4: Apply Cramer's Rule")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("x = det(Aₓ)/det(A) = 4/1 = 4")
                        .font(.system(.body, design: .monospaced))
                    Text("y = det(Aᵧ)/det(A) = -2/1 = -2")
                        .font(.system(.body, design: .monospaced))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
                
                // Verification
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                        Text("Verification")
                            .font(.subheadline)
                            .bold()
                    }
                    
                    Text("2(4) + 3(-2) = 8 - 6 = 2 ✓")
                        .font(.system(.caption, design: .monospaced))
                    Text("1(4) + 2(-2) = 4 - 4 = 0 ✓")
                        .font(.system(.caption, design: .monospaced))
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

// MARK: - 3x3 System Example (Example 146)

struct Example3x3SystemView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example: 3×3 System")
                .font(.headline)
            
            Text("Solve the system:")
                .font(.body)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("2x +  y +  z =  6")
                Text("3x + 2y - 2z = -2")
                Text(" x +  y + 2z = -4")
            }
            .font(.system(.body, design: .monospaced))
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(8)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Step 1: Calculate det(A)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Using cofactor expansion along row 1:")
                    .font(.body)
                
                Text("det(A) = 2|2 -2| - 1|3 -2| + 1|3 2|")
                    .font(.system(.caption, design: .monospaced))
                Text("          |1  2|    |1  2|    |1 1|")
                    .font(.system(.caption, design: .monospaced))
                
                Text("= 2(4+2) - 1(6+2) + 1(3-2)")
                    .font(.system(.caption, design: .monospaced))
                Text("= 2(6) - 1(8) + 1(1)")
                    .font(.system(.caption, design: .monospaced))
                Text("= 12 - 8 + 1 = 5")
                    .font(.system(.body, design: .monospaced))
                    .bold()
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                
                Text("Step 2: Calculate det(Aₓ), det(Aᵧ), det(A_z)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("For each variable, replace the corresponding column with b = [6, -2, -4]:")
                    .font(.body)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("det(Aₓ) = | 6  1  1| = 54")
                        .font(.system(.caption, design: .monospaced))
                    Text("         |-2  2 -2|")
                        .font(.system(.caption, design: .monospaced))
                    Text("         |-4  1  2|")
                        .font(.system(.caption, design: .monospaced))
                }
                .padding(8)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(6)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("det(Aᵧ) = |2   6  1| = -82")
                        .font(.system(.caption, design: .monospaced))
                    Text("         |3  -2 -2|")
                        .font(.system(.caption, design: .monospaced))
                    Text("         |1  -4  2|")
                        .font(.system(.caption, design: .monospaced))
                }
                .padding(8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(6)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("det(A_z) = |2  1   6| = 4")
                        .font(.system(.caption, design: .monospaced))
                    Text("          |3  2  -2|")
                        .font(.system(.caption, design: .monospaced))
                    Text("          |1  1  -4|")
                        .font(.system(.caption, design: .monospaced))
                }
                .padding(8)
                .background(Color.teal.opacity(0.1))
                .cornerRadius(6)
                
                Text("Step 3: Apply Cramer's Rule")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("x = det(Aₓ)/det(A) = 54/5")
                        .font(.system(.body, design: .monospaced))
                    Text("y = det(Aᵧ)/det(A) = -82/5")
                        .font(.system(.body, design: .monospaced))
                    Text("z = det(A_z)/det(A) = 4/5")
                        .font(.system(.body, design: .monospaced))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - 2x2 Interactive Calculator

struct Cramer2x2Calculator: View {
    @Binding var system: [[String]]
    @Binding var showSolution: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🧮 2×2 System Calculator")
                .font(.headline)
            
            Text("Enter your system (ax + by = c):")
                .font(.body)
            
            VStack(spacing: 8) {
                HStack {
                    TextField("a₁", text: $system[0][0])
                        .frame(width: 50)
                        .textFieldStyle(.roundedBorder)
                    Text("x +")
                    TextField("b₁", text: $system[0][1])
                        .frame(width: 50)
                        .textFieldStyle(.roundedBorder)
                    Text("y =")
                    TextField("c₁", text: $system[0][2])
                        .frame(width: 50)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
                    TextField("a₂", text: $system[1][0])
                        .frame(width: 50)
                        .textFieldStyle(.roundedBorder)
                    Text("x +")
                    TextField("b₂", text: $system[1][1])
                        .frame(width: 50)
                        .textFieldStyle(.roundedBorder)
                    Text("y =")
                    TextField("c₂", text: $system[1][2])
                        .frame(width: 50)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .keyboardType(.numbersAndPunctuation)
            
            Button(action: { showSolution.toggle() }) {
                HStack {
                    Image(systemName: showSolution ? "eye.slash" : "eye")
                    Text(showSolution ? "Hide Solution" : "Solve with Cramer's Rule")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.teal)
                .cornerRadius(10)
            }
            
            if showSolution {
                Cramer2x2SolutionView(system: system)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct Cramer2x2SolutionView: View {
    let system: [[String]]
    
    var coeffs: [[Double]] {
        system.map { row in row.map { Double($0) ?? 0 } }
    }
    
    var detA: Double {
        coeffs[0][0] * coeffs[1][1] - coeffs[0][1] * coeffs[1][0]
    }
    
    var detAx: Double {
        coeffs[0][2] * coeffs[1][1] - coeffs[0][1] * coeffs[1][2]
    }
    
    var detAy: Double {
        coeffs[0][0] * coeffs[1][2] - coeffs[0][2] * coeffs[1][0]
    }
    
    func format(_ n: Double) -> String {
        if n == floor(n) { return String(Int(n)) }
        return String(format: "%.3f", n)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("det(A) = \(format(detA))")
                .font(.system(.body, design: .monospaced))
            
            if abs(detA) < 0.0001 {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("det(A) = 0. Cramer's Rule does not apply.")
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            } else {
                Text("det(Aₓ) = \(format(detAx))")
                    .font(.system(.body, design: .monospaced))
                Text("det(Aᵧ) = \(format(detAy))")
                    .font(.system(.body, design: .monospaced))
                
                Divider()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("x = \(format(detAx))/\(format(detA)) = \(format(detAx / detA))")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                    Text("y = \(format(detAy))/\(format(detA)) = \(format(detAy / detA))")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                }
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - 3x3 Interactive Calculator

struct Cramer3x3Calculator: View {
    @Binding var system: [[String]]
    @Binding var showSolution: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🧮 3×3 System Calculator")
                .font(.headline)
            
            Text("Enter your system (ax + by + cz = d):")
                .font(.body)
            
            VStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { row in
                    HStack {
                        TextField("a", text: $system[row][0])
                            .frame(width: 40)
                            .textFieldStyle(.roundedBorder)
                        Text("x +")
                        TextField("b", text: $system[row][1])
                            .frame(width: 40)
                            .textFieldStyle(.roundedBorder)
                        Text("y +")
                        TextField("c", text: $system[row][2])
                            .frame(width: 40)
                            .textFieldStyle(.roundedBorder)
                        Text("z =")
                        TextField("d", text: $system[row][3])
                            .frame(width: 40)
                            .textFieldStyle(.roundedBorder)
                    }
                    .font(.caption)
                }
            }
            .keyboardType(.numbersAndPunctuation)
            
            Button(action: { showSolution.toggle() }) {
                HStack {
                    Image(systemName: showSolution ? "eye.slash" : "eye")
                    Text(showSolution ? "Hide Solution" : "Solve with Cramer's Rule")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.teal)
                .cornerRadius(10)
            }
            
            if showSolution {
                Cramer3x3SolutionView(system: system)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct Cramer3x3SolutionView: View {
    let system: [[String]]
    
    var coeffs: [[Double]] {
        system.map { row in row.map { Double($0) ?? 0 } }
    }
    
    func det3x3(_ m: [[Double]]) -> Double {
        let a = m[0][0], b = m[0][1], c = m[0][2]
        let d = m[1][0], e = m[1][1], f = m[1][2]
        let g = m[2][0], h = m[2][1], i = m[2][2]
        return a*(e*i - f*h) - b*(d*i - f*g) + c*(d*h - e*g)
    }
    
    var A: [[Double]] {
        [[coeffs[0][0], coeffs[0][1], coeffs[0][2]],
         [coeffs[1][0], coeffs[1][1], coeffs[1][2]],
         [coeffs[2][0], coeffs[2][1], coeffs[2][2]]]
    }
    
    var b: [Double] { [coeffs[0][3], coeffs[1][3], coeffs[2][3]] }
    
    var detA: Double { det3x3(A) }
    
    var Ax: [[Double]] {
        [[b[0], A[0][1], A[0][2]],
         [b[1], A[1][1], A[1][2]],
         [b[2], A[2][1], A[2][2]]]
    }
    
    var Ay: [[Double]] {
        [[A[0][0], b[0], A[0][2]],
         [A[1][0], b[1], A[1][2]],
         [A[2][0], b[2], A[2][2]]]
    }
    
    var Az: [[Double]] {
        [[A[0][0], A[0][1], b[0]],
         [A[1][0], A[1][1], b[1]],
         [A[2][0], A[2][1], b[2]]]
    }
    
    func format(_ n: Double) -> String {
        if n == floor(n) { return String(Int(n)) }
        return String(format: "%.3f", n)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("det(A) = \(format(detA))")
                .font(.system(.body, design: .monospaced))
            
            if abs(detA) < 0.0001 {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("det(A) = 0. Cramer's Rule does not apply.")
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            } else {
                Text("det(Aₓ) = \(format(det3x3(Ax)))")
                    .font(.system(.caption, design: .monospaced))
                Text("det(Aᵧ) = \(format(det3x3(Ay)))")
                    .font(.system(.caption, design: .monospaced))
                Text("det(A_z) = \(format(det3x3(Az)))")
                    .font(.system(.caption, design: .monospaced))
                
                Divider()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("x = \(format(det3x3(Ax) / detA))")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                    Text("y = \(format(det3x3(Ay) / detA))")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                    Text("z = \(format(det3x3(Az) / detA))")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                }
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(8)
    }
}
