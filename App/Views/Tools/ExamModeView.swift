import SwiftUI

struct ExamModeView: View {
    @StateObject private var practiceData = PracticeData()
    
    @State private var examState: ExamState = .setup
    @State private var examConfig = ExamConfiguration()
    
    @State private var questions: [ExamQuestion] = []
    @State private var currentQuestionIndex: Int = 0
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer?
    @State private var examStartTime: Date?
    
    @State private var showResults: Bool = false
    @State private var showHistory: Bool = false
    
    enum ExamState {
        case setup, active, review, completed
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                switch examState {
                case .setup:
                    ExamSetupView(config: $examConfig, onStart: startExam)
                    
                case .active:
                    ActiveExamView(
                        questions: $questions,
                        currentIndex: $currentQuestionIndex,
                        timeRemaining: timeRemaining,
                        onSubmit: submitExam,
                        onFlag: flagCurrentQuestion
                    )
                    
                case .review:
                    ReviewView(
                        questions: questions,
                        currentIndex: $currentQuestionIndex,
                        onSubmitFinal: submitExam,
                        onReturn: { currentQuestionIndex = $0; examState = .active }
                    )
                    
                case .completed:
                    ExamResultsView(
                        questions: questions,
                        startTime: examStartTime ?? Date(),
                        config: examConfig,
                        onRetake: resetExam,
                        onNewExam: { resetExam(); examState = .setup }
                    )
                }
            }
            .padding()
        }
        .sheet(isPresented: $showHistory) {
            ExamHistoryView(practiceData: practiceData)
        }
    }
    
    // MARK: - Exam Functions
    
    func startExam() {
        // Generate questions
        questions = []
        
        let topicsToUse = examConfig.selectedTopics.isEmpty ? ProblemTopic.allCases : Array(examConfig.selectedTopics)
        
        for _ in 0..<examConfig.questionCount {
            let topic = topicsToUse.randomElement() ?? .determinant2x2
            let difficulty = examConfig.difficulty
            let problem = ProblemGenerator.generate(topic: topic, difficulty: difficulty)
            questions.append(ExamQuestion(problem: problem))
        }
        
        // Start timer
        timeRemaining = TimeInterval(examConfig.timeLimit * 60)
        examStartTime = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                submitExam()
            }
        }
        
        currentQuestionIndex = 0
        examState = .active
    }
    
    func flagCurrentQuestion() {
        questions[currentQuestionIndex].isFlagged.toggle()
    }
    
    func submitExam() {
        timer?.invalidate()
        timer = nil
        
        // Grade all questions
        for i in 0..<questions.count {
            let normalizedUser = questions[i].userAnswer
                .replacingOccurrences(of: " ", with: "")
                .lowercased()
            let normalizedCorrect = questions[i].problem.correctAnswer
                .replacingOccurrences(of: " ", with: "")
                .lowercased()
            
            questions[i].isCorrect = (normalizedUser == normalizedCorrect)
        }
        
        // Save session
        let correctCount = questions.filter { $0.isCorrect == true }.count
        let session = PracticeSession(
            date: Date(),
            totalQuestions: questions.count,
            correctAnswers: correctCount,
            timeSpent: Date().timeIntervalSince(examStartTime ?? Date()),
            topics: Array(examConfig.selectedTopics),
            difficulty: examConfig.difficulty
        )
        practiceData.recordExamSession(session)
        
        examState = .completed
    }
    
    func resetExam() {
        questions = []
        currentQuestionIndex = 0
        timeRemaining = 0
        examStartTime = nil
        showResults = false
    }
}

// MARK: - Exam Configuration

struct ExamConfiguration {
    var questionCount: Int = 10
    var timeLimit: Int = 15  // minutes
    var selectedTopics: Set<ProblemTopic> = []
    var difficulty: Difficulty = .medium
}

// MARK: - Setup View

struct ExamSetupView: View {
    @Binding var config: ExamConfiguration
    let onStart: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "timer")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text("Exam Mode")
                        .font(.largeTitle)
                        .bold()
                }
                
                Text("Timed Practice Under Exam Conditions")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text("Test your skills with a timed exam. Configure the number of questions, time limit, topics, and difficulty level below.")
                    .font(.body)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            
            // Question Count
            VStack(alignment: .leading, spacing: 12) {
                Text("Number of Questions")
                    .font(.headline)
                
                Picker("Questions", selection: $config.questionCount) {
                    Text("5").tag(5)
                    Text("10").tag(10)
                    Text("15").tag(15)
                    Text("20").tag(20)
                }
                .pickerStyle(.segmented)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            
            // Time Limit
            VStack(alignment: .leading, spacing: 12) {
                Text("Time Limit")
                    .font(.headline)
                
                Picker("Time", selection: $config.timeLimit) {
                    Text("10 min").tag(10)
                    Text("15 min").tag(15)
                    Text("20 min").tag(20)
                    Text("30 min").tag(30)
                }
                .pickerStyle(.segmented)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            
            // Topics
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Topics")
                        .font(.headline)
                    Spacer()
                    Text(config.selectedTopics.isEmpty ? "All topics" : "\(config.selectedTopics.count) selected")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(ProblemTopic.allCases, id: \.self) { topic in
                        TopicToggle(
                            topic: topic,
                            isSelected: config.selectedTopics.contains(topic),
                            action: {
                                if config.selectedTopics.contains(topic) {
                                    config.selectedTopics.remove(topic)
                                } else {
                                    config.selectedTopics.insert(topic)
                                }
                            }
                        )
                    }
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            
            // Difficulty
            VStack(alignment: .leading, spacing: 12) {
                Text("Difficulty")
                    .font(.headline)
                
                HStack(spacing: 12) {
                    ForEach(Difficulty.allCases, id: \.self) { diff in
                        Button(action: { config.difficulty = diff }) {
                            Text(diff.rawValue)
                                .font(.subheadline)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(config.difficulty == diff ? diff.color : Color(uiColor: .tertiarySystemBackground))
                                .foregroundColor(config.difficulty == diff ? .white : .primary)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            
            // Start Button
            Button(action: onStart) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Start Exam")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .cornerRadius(12)
            }
            
            Spacer()
        }
    }
}

struct TopicToggle: View {
    let topic: ProblemTopic
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: topic.icon)
                    .foregroundColor(isSelected ? .white : topic.color)
                Text(topic.rawValue)
                    .font(.caption)
                    .lineLimit(1)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption)
                }
            }
            .padding(10)
            .background(isSelected ? topic.color : Color(uiColor: .tertiarySystemBackground))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(8)
        }
    }
}

// MARK: - Active Exam View

struct ActiveExamView: View {
    @Binding var questions: [ExamQuestion]
    @Binding var currentIndex: Int
    let timeRemaining: TimeInterval
    let onSubmit: () -> Void
    let onFlag: () -> Void
    
    var currentQuestion: ExamQuestion { questions[currentIndex] }
    
    var formattedTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var timeColor: Color {
        if timeRemaining < 60 { return .red }
        if timeRemaining < 300 { return .orange }
        return .primary
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Timer bar
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(timeColor)
                Text(formattedTime)
                    .font(.system(.title2, design: .monospaced))
                    .bold()
                    .foregroundColor(timeColor)
                
                Spacer()
                
                Text("Q\(currentIndex + 1) of \(questions.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button(action: onSubmit) {
                    Text("Submit")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(10)
            
            // Question navigation
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(0..<questions.count, id: \.self) { index in
                        QuestionNavButton(
                            index: index,
                            isAnswered: !questions[index].userAnswer.isEmpty,
                            isFlagged: questions[index].isFlagged,
                            isCurrent: index == currentIndex,
                            action: { currentIndex = index }
                        )
                    }
                }
            }
            
            // Current question
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Question \(currentIndex + 1)")
                        .font(.headline)
                    
                    if currentQuestion.isFlagged {
                        Image(systemName: "flag.fill")
                            .foregroundColor(.orange)
                    }
                    
                    Spacer()
                    
                    Text(currentQuestion.problem.difficulty.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(currentQuestion.problem.difficulty.color.opacity(0.2))
                        .cornerRadius(4)
                }
                
                Text(currentQuestion.problem.questionText)
                    .font(.body)
                
                if let matrix = currentQuestion.problem.matrix {
                    ExamMatrixView(matrix: matrix, label: currentQuestion.problem.matrixB != nil ? "A" : nil)
                }
                
                if let matrixB = currentQuestion.problem.matrixB {
                    ExamMatrixView(matrix: matrixB, label: "B")
                }
                
                TextField("Your answer", text: $questions[currentIndex].userAnswer)
                    .textFieldStyle(.roundedBorder)
                    .font(.body)
                
                HStack {
                    Button(action: onFlag) {
                        Label(
                            currentQuestion.isFlagged ? "Unflag" : "Flag for Review",
                            systemImage: currentQuestion.isFlagged ? "flag.slash" : "flag"
                        )
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    if currentIndex > 0 {
                        Button(action: { currentIndex -= 1 }) {
                            Label("Previous", systemImage: "chevron.left")
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    if currentIndex < questions.count - 1 {
                        Button(action: { currentIndex += 1 }) {
                            Label("Next", systemImage: "chevron.right")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            
            Spacer()
        }
    }
}

struct QuestionNavButton: View {
    let index: Int
    let isAnswered: Bool
    let isFlagged: Bool
    let isCurrent: Bool
    let action: () -> Void
    
    var backgroundColor: Color {
        if isCurrent { return .blue }
        if isAnswered { return .green.opacity(0.5) }
        return Color(uiColor: .tertiarySystemBackground)
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Text("\(index + 1)")
                    .font(.caption)
                    .bold()
                    .foregroundColor(isCurrent ? .white : .primary)
                
                if isFlagged {
                    Image(systemName: "flag.fill")
                        .font(.system(size: 8))
                        .foregroundColor(.orange)
                        .offset(x: 10, y: -10)
                }
            }
            .frame(width: 32, height: 32)
            .background(backgroundColor)
            .cornerRadius(6)
        }
    }
}

struct ExamMatrixView: View {
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
                                .frame(minWidth: 25)
                        }
                    }
                }
            }
            .padding(8)
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(6)
        }
    }
}

// MARK: - Review View

struct ReviewView: View {
    let questions: [ExamQuestion]
    @Binding var currentIndex: Int
    let onSubmitFinal: () -> Void
    let onReturn: (Int) -> Void
    
    var unanswered: [Int] {
        questions.enumerated().filter { $0.element.userAnswer.isEmpty }.map { $0.offset }
    }
    
    var flagged: [Int] {
        questions.enumerated().filter { $0.element.isFlagged }.map { $0.offset }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Review Before Submitting")
                .font(.title2)
                .bold()
            
            if !unanswered.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.red)
                        Text("\(unanswered.count) Unanswered")
                            .font(.headline)
                    }
                    
                    ForEach(unanswered, id: \.self) { index in
                        Button(action: { onReturn(index) }) {
                            Text("Question \(index + 1)")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(10)
            }
            
            if !flagged.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "flag.fill")
                            .foregroundColor(.orange)
                        Text("\(flagged.count) Flagged for Review")
                            .font(.headline)
                    }
                    
                    ForEach(flagged, id: \.self) { index in
                        Button(action: { onReturn(index) }) {
                            Text("Question \(index + 1)")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
            }
            
            if unanswered.isEmpty && flagged.isEmpty {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("All questions answered!")
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
            }
            
            Button(action: onSubmitFinal) {
                HStack {
                    Image(systemName: "checkmark.circle")
                    Text("Submit Exam")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Results View

struct ExamResultsView: View {
    let questions: [ExamQuestion]
    let startTime: Date
    let config: ExamConfiguration
    let onRetake: () -> Void
    let onNewExam: () -> Void
    
    var correctCount: Int {
        questions.filter { $0.isCorrect == true }.count
    }
    
    var percentage: Double {
        Double(correctCount) / Double(questions.count) * 100
    }
    
    var timeTaken: TimeInterval {
        Date().timeIntervalSince(startTime)
    }
    
    var gradeColor: Color {
        if percentage >= 90 { return .green }
        if percentage >= 70 { return .blue }
        if percentage >= 50 { return .orange }
        return .red
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Score Display
            VStack(spacing: 8) {
                Text("Exam Complete!")
                    .font(.title)
                    .bold()
                
                ZStack {
                    Circle()
                        .stroke(gradeColor.opacity(0.2), lineWidth: 12)
                        .frame(width: 150, height: 150)
                    
                    Circle()
                        .trim(from: 0, to: percentage / 100)
                        .stroke(gradeColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text("\(correctCount)/\(questions.count)")
                            .font(.largeTitle)
                            .bold()
                        Text(String(format: "%.0f%%", percentage))
                            .font(.title2)
                            .foregroundColor(gradeColor)
                    }
                }
                
                Text(getGradeMessage())
                    .font(.headline)
                    .foregroundColor(gradeColor)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            
            // Stats
            HStack(spacing: 20) {
                VStack {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                    Text(formatTime(timeTaken))
                        .font(.headline)
                    Text("Time")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                    Text("\(correctCount)")
                        .font(.headline)
                    Text("Correct")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.red)
                    Text("\(questions.count - correctCount)")
                        .font(.headline)
                    Text("Wrong")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            
            // Question-by-question review
            VStack(alignment: .leading, spacing: 12) {
                Text("Question Review")
                    .font(.headline)
                
                ForEach(Array(questions.enumerated()), id: \.offset) { index, question in
                    HStack {
                        Image(systemName: question.isCorrect == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(question.isCorrect == true ? .green : .red)
                        
                        Text("Q\(index + 1): \(question.problem.topic.rawValue)")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        if question.isCorrect != true {
                            Text(question.problem.correctAnswer)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            
            // Actions
            HStack(spacing: 16) {
                Button(action: onRetake) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Retake")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button(action: onNewExam) {
                    HStack {
                        Image(systemName: "plus")
                        Text("New Exam")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
    }
    
    func getGradeMessage() -> String {
        if percentage >= 90 { return "Outstanding! 🌟" }
        if percentage >= 80 { return "Great Job! 🎉" }
        if percentage >= 70 { return "Good Work! 👍" }
        if percentage >= 60 { return "Keep Practicing! 💪" }
        return "More Practice Needed 📚"
    }
    
    func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - History View

struct ExamHistoryView: View {
    @ObservedObject var practiceData: PracticeData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                if practiceData.sessionHistory.isEmpty {
                    Text("No exam history yet")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(practiceData.sessionHistory.reversed()) { session in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(session.date, style: .date)
                                    .font(.subheadline)
                                Text("\(session.totalQuestions) questions • \(session.difficulty.rawValue)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(String(format: "%.0f%%", session.percentage))
                                .font(.headline)
                                .foregroundColor(session.percentage >= 70 ? .green : .orange)
                        }
                    }
                }
            }
            .navigationTitle("Exam History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
