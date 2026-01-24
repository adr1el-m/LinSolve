import SwiftUI

struct ParallelVectorsView: View {
    // Mode 1: Check if two vectors are parallel
    // Mode 2: Solve for missing variable (Example 10 style)
    
    @State private var uVec: [String] = ["1", "2"]
    @State private var vVec: [String] = ["2", "4"]
    
    // Result State
    @State private var isParallel: Bool = false
    @State private var scaleFactor: Fraction? = nil
    @State private var hasChecked: Bool = false
    
    // Symbolic Example State
    @State private var tResult: String = ""
    @State private var showSymbolicSteps: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Parallel Vectors")
                        .font(.largeTitle)
                        .bold()
                    Text("Scalar Multiples")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("Two vectors u and v are parallel if one is a scalar multiple of the other. That is, there exists a scalar k such that:")
                        .font(.body)
                    
                    HStack {
                        Spacer()
                        Text("u = kv")
                            .font(.system(.title, design: .serif))
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        Spacer()
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                Divider()
                
                // Section 1: Check Parallelism
                VStack(alignment: .leading, spacing: 20) {
                    Text("Check Parallelism").font(.title2).bold()
                    Text("Enter two vectors to check if they are parallel.")
                    
                    HStack(spacing: 40) {
                        VectorInputColumnSimple(label: "u", vector: $uVec)
                        Text("?").font(.title).foregroundColor(.secondary)
                        VectorInputColumnSimple(label: "v", vector: $vVec)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    
                    Button(action: checkParallelism) {
                        Text("Check Vectors")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    if hasChecked {
                        HStack {
                            if isParallel {
                                Image(systemName: "equal.circle.fill").foregroundColor(.green).font(.title)
                                VStack(alignment: .leading) {
                                    Text("Parallel!").font(.headline).foregroundColor(.green)
                                    if let k = scaleFactor {
                                        Text("u = \(k.description)v").font(.body)
                                    }
                                }
                            } else {
                                Image(systemName: "slash.circle.fill").foregroundColor(.red).font(.title)
                                VStack(alignment: .leading) {
                                    Text("Not Parallel").font(.headline).foregroundColor(.red)
                                    Text("No single scalar k satisfies u = kv for all components.").font(.caption)
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(isParallel ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                        .cornerRadius(10)
                        .transition(.scale)
                    }
                }
                .padding()
                
                Divider()
                
                // Section 2: Solve for Variable (Example 10)
                VStack(alignment: .leading, spacing: 20) {
                    Text("Symbolic Problem Solver").font(.title2).bold()
                    Text("Example 10: Find t such that vectors are parallel.")
                    
                    HStack(alignment: .center, spacing: 20) {
                        // Vector 1: [1, t^2]
                        VStack(spacing: 6) {
                            Text("1").frame(width: 40, height: 30).background(Color.gray.opacity(0.1)).cornerRadius(4)
                            Text("t²").font(.system(.body, design: .serif)).italic().frame(width: 40, height: 30).background(Color.yellow.opacity(0.2)).cornerRadius(4).overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.orange, lineWidth: 1))
                        }
                        .padding(8)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(HStack { BracketShape(left: true).stroke(Color.primary, lineWidth: 1.5).frame(width: 8); Spacer(); BracketShape(left: false).stroke(Color.primary, lineWidth: 1.5).frame(width: 8) })
                        
                        Text("is parallel to")
                        
                        // Vector 2: [4, 1]
                        VStack(spacing: 6) {
                            Text("4").frame(width: 40, height: 30).background(Color.gray.opacity(0.1)).cornerRadius(4)
                            Text("1").frame(width: 40, height: 30).background(Color.gray.opacity(0.1)).cornerRadius(4)
                        }
                        .padding(8)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(HStack { BracketShape(left: true).stroke(Color.primary, lineWidth: 1.5).frame(width: 8); Spacer(); BracketShape(left: false).stroke(Color.primary, lineWidth: 1.5).frame(width: 8) })
                    }
                    .padding()
                    
                    Button(action: solveSymbolic) {
                        Text("Solve for t")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                    
                    if showSymbolicSteps {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Solution Steps").font(.headline)
                            
                            Group {
                                Text("1. Set up the scalar equation:")
                                    .bold()
                                Text("k * [1, t²] = [4, 1]")
                                    .font(.system(.body, design: .monospaced))
                                    .padding(.leading)
                                
                                Text("2. Solve for k using the first component:")
                                    .bold()
                                Text("k * 1 = 4  =>  k = 4")
                                    .font(.system(.body, design: .monospaced))
                                    .padding(.leading)
                                
                                Text("3. Substitute k into the second component:")
                                    .bold()
                                Text("4 * t² = 1")
                                    .font(.system(.body, design: .monospaced))
                                    .padding(.leading)
                                
                                Text("4. Solve for t:")
                                    .bold()
                                Text("t² = 1/4")
                                    .font(.system(.body, design: .monospaced))
                                    .padding(.leading)
                                Text("t = ±1/2")
                                    .font(.system(.title3, design: .serif))
                                    .bold()
                                    .foregroundColor(.purple)
                                    .padding(.top, 4)
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                        .transition(.opacity)
                    }
                }
                .padding()
                
                Spacer()
            }
        }
    }
    
    func checkParallelism() {
        let u = uVec.map { Fraction(string: $0) }
        let v = vVec.map { Fraction(string: $0) }
        
        // Check u = k * v
        // Or v = k * u
        // Find first non-zero pair to establish k
        
        var k: Fraction? = nil
        var consistent = true
        
        // We will try to find k such that u = k * v
        // If v has 0 where u has non-zero, impossible (unless u is 0).
        
        // Handle zero vectors
        let uIsZero = u.allSatisfy { $0 == .zero }
        let vIsZero = v.allSatisfy { $0 == .zero }
        
        if uIsZero || vIsZero {
            // Zero vector is parallel to everything (k=0)
            self.isParallel = true
            self.scaleFactor = Fraction.zero
            self.hasChecked = true
            return
        }
        
        // Find candidate k
        for i in 0..<u.count {
            if v[i] != .zero {
                let candidate = u[i] / v[i]
                if k == nil {
                    k = candidate
                } else {
                    if k != candidate {
                        consistent = false
                        break
                    }
                }
            } else {
                // v[i] is 0. u[i] must be 0 for consistency.
                if u[i] != .zero {
                    consistent = false
                    break
                }
            }
        }
        
        self.isParallel = consistent
        self.scaleFactor = k
        withAnimation {
            self.hasChecked = true
        }
    }
    
    func solveSymbolic() {
        withAnimation {
            showSymbolicSteps = true
        }
    }
}
