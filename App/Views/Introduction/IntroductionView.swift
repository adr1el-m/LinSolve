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
                    
                    Text("LinSolve")
                        .font(.system(size: 42, weight: .bold, design: .serif))
                        .foregroundColor(.primary)
                    
                    Text("Interactive Linear Algebra")
                        .font(.system(size: 24, design: .serif))
                        .italic()
                        .foregroundColor(.secondary)
                    
                    Text("Learn • Compute • Visualize • Master")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(20)
                
                // Welcome Section (NEW)
                welcomeSection
                
                // Why Linear Algebra Matters (NEW)
                whyLinearAlgebraSection
                
                // Mathematical Foundation Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("The Building Blocks")
                        .font(.title2)
                        .bold()
                    
                    Text("Before diving into the details, let's understand the three fundamental objects you'll work with throughout this app. Don't worry if these seem abstract at first—each topic in this app will help you develop intuition through **interactive examples** and **step-by-step explanations**.")
                        .font(.body)
                    
                    // Core Concepts
                    VStack(alignment: .leading, spacing: 16) {
                        MathConceptRow(
                            symbol: "v",
                            title: "Vectors: The Foundation",
                            definition: "Think of a vector as an ordered list of numbers. In 2D, a vector like [3, 4] can represent a point on a graph, a direction to walk, or even a color (red, green). In physics, vectors represent forces, velocities, and positions. The key insight: vectors can be added together and scaled (multiplied by numbers).",
                            formula: "v = [v₁, v₂, ..., vₙ]ᵀ"
                        )
                        
                        Divider()
                        
                        MathConceptRow(
                            symbol: "A",
                            title: "Matrices: Organized Data",
                            definition: "A matrix is simply a rectangular grid of numbers arranged in rows and columns. An m × n matrix has m rows and n columns. Matrices can represent systems of equations, transformations (like rotations or reflections), data tables, and even images! Every pixel on your screen can be described by a matrix.",
                            formula: "A is m × n (m rows, n columns)"
                        )
                        
                        Divider()
                        
                        MathConceptRow(
                            symbol: "Ax=b",
                            title: "Linear Systems: The Central Problem",
                            definition: "The equation Ax = b is at the heart of linear algebra. Given a matrix A and a vector b, we want to find the vector x that makes the equation true. This single problem has countless applications: balancing chemical equations, analyzing circuits, computer graphics, machine learning, and much more.",
                            formula: "Find x such that Ax = b"
                        )
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(12)
                }
                
                // Key Operations Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Key Matrix Operations")
                        .font(.title2)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        OperationCard(
                            title: "Row Echelon Form (REF) & RREF",
                            description: "Gaussian elimination transforms a matrix into row echelon form using elementary row operations. Further reduction yields the **Reduced Row Echelon Form (RREF)**, which reveals the solution structure.",
                            operations: [
                                "Rᵢ ↔ Rⱼ (swap rows)",
                                "Rᵢ → cRᵢ (scale row by c ≠ 0)",
                                "Rᵢ → Rᵢ + cRⱼ (add multiple of another row)"
                            ]
                        )
                        
                        OperationCard(
                            title: "Matrix Inverse (A⁻¹)",
                            description: "A square matrix A is invertible if there exists a matrix A⁻¹ such that AA⁻¹ = A⁻¹A = I. Computed via Gauss-Jordan elimination on [A | I].",
                            operations: [
                                "Only square matrices can be invertible",
                                "det(A) ≠ 0 ⟺ A is invertible",
                                "If A⁻¹ exists: x = A⁻¹b solves Ax = b"
                            ]
                        )
                        
                        OperationCard(
                            title: "Determinant",
                            description: "The determinant is a scalar value that encodes important information about a square matrix. It determines invertibility and measures how the matrix scales volume.",
                            operations: [
                                "det(A) = 0 ⟺ A is singular (not invertible)",
                                "det(AB) = det(A)·det(B)",
                                "det(Aᵀ) = det(A)"
                            ]
                        )
                    }
                }
                
                // Four Fundamental Subspaces
                VStack(alignment: .leading, spacing: 20) {
                    Text("The Four Fundamental Subspaces")
                        .font(.title2)
                        .bold()
                    
                    Text("Every matrix A ∈ ℝᵐˣⁿ defines four fundamental subspaces that reveal the structure of the linear transformation it represents:")
                        .font(.body)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        SubspaceCard(
                            name: "Column Space",
                            notation: "C(A)",
                            space: "⊆ ℝᵐ",
                            description: "All possible outputs Ax",
                            dimension: "rank(A)",
                            color: .blue
                        )
                        
                        SubspaceCard(
                            name: "Null Space",
                            notation: "N(A)",
                            space: "⊆ ℝⁿ",
                            description: "All solutions to Ax = 0",
                            dimension: "n - rank(A)",
                            color: .green
                        )
                        
                        SubspaceCard(
                            name: "Row Space",
                            notation: "C(Aᵀ)",
                            space: "⊆ ℝⁿ",
                            description: "Span of rows of A",
                            dimension: "rank(A)",
                            color: .orange
                        )
                        
                        SubspaceCard(
                            name: "Left Null Space",
                            notation: "N(Aᵀ)",
                            space: "⊆ ℝᵐ",
                            description: "All y where Aᵀy = 0",
                            dimension: "m - rank(A)",
                            color: .purple
                        )
                    }
                    
                    // Rank-Nullity Theorem
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rank-Nullity Theorem")
                            .font(.headline)
                        Text("For any matrix A ∈ ℝᵐˣⁿ:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("dim(C(A)) + dim(N(A)) = n")
                            .font(.system(.title3, design: .serif))
                            .italic()
                            .padding(8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(6)
                        Text("This fundamental theorem connects the dimensions of the column space (rank) and null space (nullity).")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(12)
                }
                
                // Eigenvalues and Eigenvectors
                VStack(alignment: .leading, spacing: 20) {
                    Text("Eigenvalues & Eigenvectors")
                        .font(.title2)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("For a square matrix A, a non-zero vector v is an **eigenvector** if multiplication by A only scales v:")
                            .font(.body)
                        
                        Text("Av = λv")
                            .font(.system(.title, design: .serif))
                            .italic()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("The scalar λ is the corresponding **eigenvalue**. Eigenvalues are found by solving:")
                            .font(.body)
                        
                        Text("det(λI - A) = 0    (Characteristic Equation)")
                            .font(.system(.body, design: .serif))
                            .italic()
                            .padding(8)
                            .background(Color(uiColor: .tertiarySystemBackground))
                            .cornerRadius(6)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("**Applications:**")
                                .font(.subheadline)
                            Text("• Principal Component Analysis (PCA) in data science")
                                .font(.caption)
                            Text("• Vibrational analysis in mechanical engineering")
                                .font(.caption)
                            Text("• Stability analysis in dynamical systems")
                                .font(.caption)
                            Text("• Google's PageRank algorithm")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                }
                
                // Inner Products and Orthogonality
                VStack(alignment: .leading, spacing: 20) {
                    Text("Inner Products & Orthogonality")
                        .font(.title2)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Dot Product (Inner Product)")
                                .font(.headline)
                            Text("The dot product of two vectors u and v in ℝⁿ is a scalar that measures their \"alignment\":")
                                .font(.body)
                            Text("u · v = u₁v₁ + u₂v₂ + ... + uₙvₙ = Σᵢ uᵢvᵢ")
                                .font(.system(.body, design: .serif))
                                .italic()
                                .padding(8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(6)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Norm (Length)")
                                .font(.headline)
                            Text("The Euclidean norm measures the length of a vector:")
                                .font(.body)
                            Text("||v|| = √(v · v) = √(v₁² + v₂² + ... + vₙ²)")
                                .font(.system(.body, design: .serif))
                                .italic()
                                .padding(8)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(6)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Orthogonality")
                                .font(.headline)
                            Text("Two vectors are **orthogonal** (perpendicular) if their dot product is zero:")
                                .font(.body)
                            Text("u ⊥ v  ⟺  u · v = 0")
                                .font(.system(.body, design: .serif))
                                .italic()
                                .padding(8)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(6)
                            Text("Orthogonal bases simplify projections and decompositions significantly.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Angle Between Vectors")
                                .font(.headline)
                            Text("The angle θ between two non-zero vectors is given by:")
                                .font(.body)
                            Text("cos(θ) = (u · v) / (||u|| ||v||)")
                                .font(.system(.body, design: .serif))
                                .italic()
                                .padding(8)
                                .background(Color.purple.opacity(0.1))
                                .cornerRadius(6)
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                }
                
                // Least Squares
                VStack(alignment: .leading, spacing: 20) {
                    Text("Least Squares Approximation")
                        .font(.title2)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("When a system Ax = b has **no exact solution** (inconsistent), we find the **best approximation** x̂ that minimizes the error ||Ax - b||².")
                            .font(.body)
                        
                        Text("The Normal Equations")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        Text("AᵀAx̂ = Aᵀb")
                            .font(.system(.title2, design: .serif))
                            .italic()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("The solution x̂ minimizes the sum of squared residuals, making this technique essential for **linear regression**, **curve fitting**, and **data analysis**.")
                            .font(.body)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                }
                
                // Features Grid
                VStack(alignment: .leading, spacing: 24) {
                    Text("What's Inside LinSolve")
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
                    Text("Your Learning Journey")
                        .font(.title2)
                        .bold()
                    
                    Text("This app is organized to take you from absolute beginner to confident problem-solver. Follow the sidebar from top to bottom, or jump to any topic you need to review.")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        InstructionRow(number: "1", text: "Start with **Part I: Foundations** to learn about vectors and basic matrix operations.")
                        InstructionRow(number: "2", text: "Move to **Part II: Linear Systems** to master solving equations—the core skill of linear algebra.")
                        InstructionRow(number: "3", text: "Explore **Matrix Calculator** anytime to experiment with your own matrices and see step-by-step solutions.")
                        InstructionRow(number: "4", text: "Use **Practice Problems** and **Exam Mode** to test your understanding and build confidence.")
                        InstructionRow(number: "5", text: "Try the **3D Visualization** tool to develop geometric intuition for abstract concepts.")
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
    
    // MARK: - Welcome Section
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Welcome, Future Mathematician! 👋")
                .font(.title2)
                .bold()
            
            Text("""
Whether you're taking your first linear algebra course, preparing for an exam, or just curious about the mathematics behind AI, computer graphics, and data science—you're in the right place.

**LinSolve** is designed to be your study companion. Unlike a textbook that shows you the final answer, this app walks you through **every single step** of every calculation. You'll see exactly how each operation works, why it matters, and how it connects to the bigger picture.

**What makes this app special:**
• **Step-by-step solutions** that show you the "how" and "why"
• **Interactive calculators** where you can experiment with your own problems
• **Visual tools** that bring abstract math to life in 2D and 3D
• **Practice problems** with instant feedback
• **Beginner-friendly explanations** that build intuition before formulas
""")
                .font(.body)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(16)
    }
    
    // MARK: - Why Linear Algebra Section
    private var whyLinearAlgebraSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Why Learn Linear Algebra?")
                .font(.title2)
                .bold()
            
            Text("Linear algebra is everywhere in modern technology. Here's what you'll be able to understand after mastering these concepts:")
                .font(.body)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ApplicationCard(
                    icon: "brain.head.profile",
                    title: "Machine Learning & AI",
                    description: "Neural networks are fundamentally matrix operations. Every AI model you've heard of—GPT, image recognition, recommendation systems—runs on linear algebra.",
                    color: .purple
                )
                
                ApplicationCard(
                    icon: "cube.transparent",
                    title: "3D Graphics & Games",
                    description: "Every 3D video game uses matrices to rotate, scale, and project objects onto your screen. Character animations? Matrix transformations.",
                    color: .orange
                )
                
                ApplicationCard(
                    icon: "waveform.path.ecg",
                    title: "Signal Processing",
                    description: "Audio compression, noise cancellation, and medical imaging all rely on linear algebra to analyze and transform signals.",
                    color: .green
                )
                
                ApplicationCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Data Science",
                    description: "From analyzing trends to making predictions, data scientists use linear regression and matrix operations daily.",
                    color: .blue
                )
            }
            
            Text("Learning linear algebra isn't just about passing a class—it's about gaining a **superpower** that unlocks entire fields of technology and science.")
                .font(.callout)
                .italic()
                .padding(.top, 8)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Supporting Views

struct MathConceptRow: View {
    let symbol: String
    let title: String
    let definition: String
    let formula: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(symbol)
                .font(.system(.title2, design: .serif))
                .bold()
                .foregroundColor(.blue)
                .frame(width: 60)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text(definition)
                    .font(.body)
                    .foregroundColor(.secondary)
                Text(formula)
                    .font(.system(.caption, design: .serif))
                    .italic()
                    .padding(6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }
        }
    }
}

struct OperationCard: View {
    let title: String
    let description: String
    let operations: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(operations, id: \.self) { op in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .foregroundColor(.blue)
                        Text(op)
                            .font(.caption)
                    }
                }
            }
            .padding(10)
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(12)
    }
}

struct SubspaceCard: View {
    let name: String
    let notation: String
    let space: String
    let description: String
    let dimension: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(notation)
                    .font(.system(.title3, design: .serif))
                    .bold()
                    .foregroundColor(color)
                Text(space)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(name)
                .font(.subheadline)
                .bold()
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Text("dim:")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(dimension)
                    .font(.system(.caption, design: .serif))
                    .italic()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
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
            
            Text(.init(text)) // Enables markdown parsing
                .font(.system(size: 18, design: .serif))
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Application Card (New)
struct ApplicationCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(title)
                .font(.headline)
                .bold()
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
