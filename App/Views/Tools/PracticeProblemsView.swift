import SwiftUI

struct PracticeProblemsView: View {
    @StateObject private var practiceData = PracticeData()
    
    @State private var selectedTopic: ProblemTopic = .determinant2x2
    @State private var selectedDifficulty: Difficulty = .easy
    
    @State private var currentProblem: GeneratedProblem?
    @State private var userAnswer: String = ""
    @State private var showHint: Bool = false
    @State private var showSolution: Bool = false
    @State private var answerResult: AnswerResult?
    
    @State private var showStats: Bool = false
    
    enum AnswerResult {
        case correct, incorrect
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "pencil.and.list.clipboard")
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                        Text("Practice Problems")
                            .font(.largeTitle)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: { showStats.toggle() }) {
                            Image(systemName: "chart.bar.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Text("Master Linear Algebra with Unlimited Practice")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Stats Banner
                StatsQuickView(practiceData: practiceData)
                
                // Topic & Difficulty Selection
                VStack(alignment: .leading, spacing: 16) {
                    Text("Choose Your Challenge")
                        .font(.headline)
                    
                    // Topic Selection
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(ProblemTopic.allCases, id: \.self) { topic in
                                TopicButton(
                                    topic: topic,
                                    isSelected: selectedTopic == topic,
                                    action: { selectedTopic = topic }
                                )
                            }
                        }
                    }
                    
                    // Difficulty Selection
                    HStack(spacing: 12) {
                        ForEach(Difficulty.allCases, id: \.self) { diff in
                            DifficultyButton(
                                difficulty: diff,
                                isSelected: selectedDifficulty == diff,
                                action: { selectedDifficulty = diff }
                            )
                        }
                    }
                    
                    Button(action: generateNewProblem) {
                        HStack {
                            Image(systemName: "shuffle")
                            Text(currentProblem == nil ? "Generate Problem" : "New Problem")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Problem Display
                if let problem = currentProblem {
                    ProblemCard(
                        problem: problem,
                        userAnswer: $userAnswer,
                        showHint: $showHint,
                        showSolution: $showSolution,
                        answerResult: $answerResult,
                        onCheck: checkAnswer,
                        onShowHint: { showHint = true },
                        onShowSolution: { showSolution = true }
                    )
                }
                
                // Weak Areas
                let weakTopics = practiceData.getWeakTopics()
                if !weakTopics.isEmpty {
                    WeakAreasCard(topics: weakTopics, onSelect: { topic in
                        selectedTopic = topic
                        generateNewProblem()
                    })
                }
                
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showStats) {
            StatsDetailView(practiceData: practiceData)
        }
    }
    
    func generateNewProblem() {
        currentProblem = ProblemGenerator.generate(topic: selectedTopic, difficulty: selectedDifficulty)
        userAnswer = ""
        showHint = false
        showSolution = false
        answerResult = nil
    }
    
    func checkAnswer() {
        guard let problem = currentProblem else { return }
        
        let normalizedUserAnswer = userAnswer.replacingOccurrences(of: " ", with: "").lowercased()
        let normalizedCorrect = problem.correctAnswer.replacingOccurrences(of: " ", with: "").lowercased()
        
        let isCorrect = normalizedUserAnswer == normalizedCorrect
        answerResult = isCorrect ? .correct : .incorrect
        
        practiceData.recordAnswer(
            topic: problem.topic,
            difficulty: problem.difficulty,
            correct: isCorrect
        )
    }
}

// MARK: - Supporting Views

struct StatsQuickView: View {
    @ObservedObject var practiceData: PracticeData
    
    var body: some View {
        HStack(spacing: 20) {
            StatBox(
                icon: "checkmark.circle.fill",
                value: "\(practiceData.totalCorrect)/\(practiceData.totalAttempted)",
                label: "Solved",
                color: .green
            )
            
            StatBox(
                icon: "percent",
                value: String(format: "%.0f%%", practiceData.accuracy),
                label: "Accuracy",
                color: .blue
            )
            
            StatBox(
                icon: "flame.fill",
                value: "\(practiceData.currentStreak)",
                label: "Streak",
                color: .orange
            )
            
            StatBox(
                icon: "trophy.fill",
                value: "\(practiceData.bestStreak)",
                label: "Best",
                color: .yellow
            )
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct StatBox: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(value)
                .font(.system(.headline, design: .rounded))
                .bold()
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TopicButton: View {
    let topic: ProblemTopic
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: topic.icon)
                    .font(.title3)
                Text(topic.rawValue)
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(width: 80, height: 70)
            .background(isSelected ? topic.color : Color(uiColor: .tertiarySystemBackground))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(10)
        }
    }
}

struct DifficultyButton: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(difficulty.rawValue)
                .font(.subheadline)
                .bold()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isSelected ? difficulty.color : Color(uiColor: .tertiarySystemBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
    }
}

struct ProblemCard: View {
    let problem: GeneratedProblem
    @Binding var userAnswer: String
    @Binding var showHint: Bool
    @Binding var showSolution: Bool
    @Binding var answerResult: PracticeProblemsView.AnswerResult?
    
    let onCheck: () -> Void
    let onShowHint: () -> Void
    let onShowSolution: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Problem header
            HStack {
                Image(systemName: problem.topic.icon)
                    .foregroundColor(problem.topic.color)
                Text(problem.topic.rawValue)
                    .font(.headline)
                Spacer()
                Text(problem.difficulty.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(problem.difficulty.color.opacity(0.2))
                    .foregroundColor(problem.difficulty.color)
                    .cornerRadius(4)
            }
            
            // Question
            Text(problem.questionText)
                .font(.body)
            
            // Matrix display
            if let matrix = problem.matrix {
                MatrixDisplayView(matrix: matrix, label: problem.matrixB != nil ? "A" : nil)
            }
            
            if let matrixB = problem.matrixB {
                MatrixDisplayView(matrix: matrixB, label: "B")
            }
            
            // Hint
            if showHint {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text(problem.hint)
                        .font(.caption)
                }
                .padding()
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(8)
            }
            
            // Answer input
            HStack {
                TextField("Your answer", text: $userAnswer)
                    .textFieldStyle(.roundedBorder)
                    .disabled(answerResult != nil)
                
                if answerResult == nil {
                    Button("Check") {
                        onCheck()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            // Result feedback
            if let result = answerResult {
                HStack {
                    Image(systemName: result == .correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(result == .correct ? .green : .red)
                    Text(result == .correct ? "Correct! 🎉" : "Not quite. Try reviewing the solution.")
                        .font(.subheadline)
                        .bold()
                }
                .padding()
                .background((result == .correct ? Color.green : Color.red).opacity(0.1))
                .cornerRadius(8)
            }
            
            // Action buttons
            HStack {
                if !showHint && answerResult == nil {
                    Button(action: onShowHint) {
                        Label("Hint", systemImage: "lightbulb")
                    }
                    .buttonStyle(.bordered)
                }
                
                if answerResult != nil || showSolution {
                    Button(action: onShowSolution) {
                        Label("Solution", systemImage: "doc.text")
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            // Solution
            if showSolution {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Solution:")
                        .font(.subheadline)
                        .bold()
                    
                    Text(problem.solution)
                        .font(.system(.caption, design: .monospaced))
                    
                    HStack {
                        Text("Correct answer:")
                            .foregroundColor(.secondary)
                        Text(problem.correctAnswer)
                            .font(.system(.body, design: .monospaced))
                            .bold()
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct MatrixDisplayView: View {
    let matrix: [[Int]]
    let label: String?
    
    var body: some View {
        HStack {
            if let label = label {
                Text(label)
                    .font(.headline)
                Text("=")
            }
            
            VStack(spacing: 2) {
                ForEach(0..<matrix.count, id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(0..<matrix[row].count, id: \.self) { col in
                            Text("\(matrix[row][col])")
                                .font(.system(.body, design: .monospaced))
                                .frame(minWidth: 30)
                        }
                    }
                }
            }
            .padding(8)
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(6)
            .overlay(
                HStack {
                    BracketShape(left: true).stroke(Color.primary, lineWidth: 1.5).frame(width: 8)
                    Spacer()
                    BracketShape(left: false).stroke(Color.primary, lineWidth: 1.5).frame(width: 8)
                }
            )
        }
    }
}

struct WeakAreasCard: View {
    let topics: [ProblemTopic]
    let onSelect: (ProblemTopic) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text("Areas to Improve")
                    .font(.headline)
            }
            
            Text("Based on your practice history, you might want to focus on:")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ForEach(topics, id: \.self) { topic in
                Button(action: { onSelect(topic) }) {
                    HStack {
                        Image(systemName: topic.icon)
                            .foregroundColor(topic.color)
                        Text(topic.rawValue)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

struct StatsDetailView: View {
    @ObservedObject var practiceData: PracticeData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Overall stats
                    VStack(spacing: 16) {
                        Text("Overall Performance")
                            .font(.headline)
                        
                        HStack(spacing: 30) {
                            StatCircle(value: practiceData.totalAttempted, label: "Attempted", color: .blue)
                            StatCircle(value: practiceData.totalCorrect, label: "Correct", color: .green)
                            StatCircle(value: Int(practiceData.accuracy), label: "Accuracy %", color: .purple)
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    
                    // Topic breakdown
                    VStack(alignment: .leading, spacing: 12) {
                        Text("By Topic")
                            .font(.headline)
                        
                        ForEach(ProblemTopic.allCases, id: \.self) { topic in
                            if let stats = practiceData.topicStats[topic], stats.attempted > 0 {
                                TopicStatsRow(topic: topic, stats: stats)
                            }
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    
                    // Reset button
                    Button(action: { practiceData.resetProgress() }) {
                        Text("Reset All Progress")
                            .foregroundColor(.red)
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct StatCircle: View {
    let value: Int
    let label: String
    let color: Color
    
    var body: some View {
        VStack {
            Text("\(value)")
                .font(.title)
                .bold()
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct TopicStatsRow: View {
    let topic: ProblemTopic
    let stats: TopicStats
    
    var body: some View {
        HStack {
            Image(systemName: topic.icon)
                .foregroundColor(topic.color)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(topic.rawValue)
                    .font(.subheadline)
                Text("\(stats.correct)/\(stats.attempted)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(String(format: "%.0f%%", stats.accuracy))
                .font(.headline)
                .foregroundColor(stats.accuracy >= 70 ? .green : (stats.accuracy >= 50 ? .orange : .red))
        }
        .padding(.vertical, 8)
    }
}
