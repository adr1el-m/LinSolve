import SwiftUI

struct IntroductionView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Hero Section
                VStack(alignment: .center, spacing: 16) {
                    Image(systemName: "cube.transparent")
                        .font(.system(size: 60))
                        .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(.bottom, 8)
                    
                    Text("VectorLens")
                        .font(.system(size: 42, weight: .bold, design: .serif))
                        .foregroundColor(.primary)
                    
                    Text("Interactive Linear Algebra")
                        .font(.system(size: 24, design: .serif))
                        .italic()
                        .foregroundColor(.secondary)
                    
                    Text("Visualize, Compute, and Understand")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(20)
                
                // Features Grid
                VStack(alignment: .leading, spacing: 24) {
                    Text("What's Inside")
                        .font(.title2)
                        .bold()
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 20) {
                        FeatureCard(
                            icon: "square.grid.3x3.fill",
                            title: "Matrix Operations",
                            description: "Perform RREF, Inverse (Gauss-Jordan), and Determinant (Cofactor & Sarrus) calculations with step-by-step explanations.",
                            color: .blue
                        )
                        
                        FeatureCard(
                            icon: "function",
                            title: "Eigen Theory",
                            description: "Find Eigenvalues via Characteristic Polynomial and Eigenvectors via Null Space basis. Diagonalize matrices (PDP⁻¹) and verify results.",
                            color: .purple
                        )
                        
                        FeatureCard(
                            icon: "angle",
                            title: "Inner Product & Orthogonality",
                            description: "Explore dot products, norms, angles, distance, and verify orthogonal sets. Visual step-by-step breakdown.",
                            color: .red
                        )
                        
                        FeatureCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Least Squares",
                            description: "Perform Quadratic Curve Fitting and calculate Distance to Hyperplanes using Least Squares and Projection methods.",
                            color: .pink
                        )
                        
                        FeatureCard(
                            icon: "square.stack.3d.up",
                            title: "Fundamental Subspaces",
                            description: "Visualize the Four Fundamental Subspaces: Column Space, Null Space, Row Space, and Left Null Space.",
                            color: .green
                        )
                        
                        FeatureCard(
                            icon: "cube.transparent",
                            title: "Geometric Visualization",
                            description: "Interactive 3D visualization of vectors and subspaces to build geometric intuition.",
                            color: .orange
                        )
                    }
                }
                
                // Getting Started
                VStack(alignment: .leading, spacing: 24) {
                    Text("Getting Started")
                        .font(.title2)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        InstructionRow(number: "1", text: "Go to 'Matrix Setup' to define your matrix A.")
                        InstructionRow(number: "2", text: "Tap 'Compute' to generate all derived properties.")
                        InstructionRow(number: "3", text: "Navigate through the topics to see detailed step-by-step derivations.")
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(16)
                }
                
                Spacer(minLength: 50)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 20)
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(title)
                .font(.headline)
                .bold()
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct InstructionRow: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(number)
                .font(.system(size: 16, weight: .bold, design: .serif))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Circle().fill(Color.blue))
            
            Text(text)
                .font(.system(size: 18, design: .serif))
                .foregroundColor(.primary)
        }
    }
}
