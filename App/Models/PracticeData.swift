import Foundation
import SwiftUI

// MARK: - Practice Data Model

class PracticeData: ObservableObject {
    @Published var totalAttempted: Int = 0
    @Published var totalCorrect: Int = 0
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0
    @Published var topicStats: [ProblemTopic: TopicStats] = [:]
    @Published var sessionHistory: [PracticeSession] = []
    
    init() {
        loadFromStorage()
    }
    
    var accuracy: Double {
        guard totalAttempted > 0 else { return 0 }
        return Double(totalCorrect) / Double(totalAttempted) * 100
    }
    
    func recordAnswer(topic: ProblemTopic, difficulty: Difficulty, correct: Bool) {
        totalAttempted += 1
        
        if correct {
            totalCorrect += 1
            currentStreak += 1
            bestStreak = max(bestStreak, currentStreak)
        } else {
            currentStreak = 0
        }
        
        // Update topic stats
        if topicStats[topic] == nil {
            topicStats[topic] = TopicStats()
        }
        topicStats[topic]?.attempted += 1
        if correct {
            topicStats[topic]?.correct += 1
        }
        
        saveToStorage()
    }
    
    func recordExamSession(_ session: PracticeSession) {
        sessionHistory.append(session)
        saveToStorage()
    }
    
    func getWeakTopics() -> [ProblemTopic] {
        return topicStats
            .filter { $0.value.accuracy < 60 && $0.value.attempted >= 3 }
            .sorted { $0.value.accuracy < $1.value.accuracy }
            .map { $0.key }
    }
    
    private func saveToStorage() {
        UserDefaults.standard.set(totalAttempted, forKey: "practice_totalAttempted")
        UserDefaults.standard.set(totalCorrect, forKey: "practice_totalCorrect")
        UserDefaults.standard.set(currentStreak, forKey: "practice_currentStreak")
        UserDefaults.standard.set(bestStreak, forKey: "practice_bestStreak")
        
        // Encode topic stats
        if let encoded = try? JSONEncoder().encode(topicStats) {
            UserDefaults.standard.set(encoded, forKey: "practice_topicStats")
        }
        
        // Encode session history
        if let encoded = try? JSONEncoder().encode(sessionHistory) {
            UserDefaults.standard.set(encoded, forKey: "practice_sessionHistory")
        }
    }
    
    private func loadFromStorage() {
        totalAttempted = UserDefaults.standard.integer(forKey: "practice_totalAttempted")
        totalCorrect = UserDefaults.standard.integer(forKey: "practice_totalCorrect")
        currentStreak = UserDefaults.standard.integer(forKey: "practice_currentStreak")
        bestStreak = UserDefaults.standard.integer(forKey: "practice_bestStreak")
        
        if let data = UserDefaults.standard.data(forKey: "practice_topicStats"),
           let decoded = try? JSONDecoder().decode([ProblemTopic: TopicStats].self, from: data) {
            topicStats = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: "practice_sessionHistory"),
           let decoded = try? JSONDecoder().decode([PracticeSession].self, from: data) {
            sessionHistory = decoded
        }
    }
    
    func resetProgress() {
        totalAttempted = 0
        totalCorrect = 0
        currentStreak = 0
        bestStreak = 0
        topicStats = [:]
        sessionHistory = []
        saveToStorage()
    }
}

// MARK: - Supporting Types

enum ProblemTopic: String, CaseIterable, Codable, Hashable {
    case determinant2x2 = "2×2 Determinant"
    case determinant3x3 = "3×3 Determinant"
    case matrixAddition = "Matrix Addition"
    case matrixMultiplication = "Matrix Multiplication"
    case systemSolving = "Systems of Equations"
    case matrixInverse = "Matrix Inverse"
    case eigenvalues = "Eigenvalues"
    
    var icon: String {
        switch self {
        case .determinant2x2, .determinant3x3: return "square.grid.2x2"
        case .matrixAddition: return "plus.circle"
        case .matrixMultiplication: return "multiply.circle"
        case .systemSolving: return "equal.circle"
        case .matrixInverse: return "arrow.uturn.backward.circle"
        case .eigenvalues: return "waveform.path.ecg"
        }
    }
    
    var color: Color {
        switch self {
        case .determinant2x2: return .blue
        case .determinant3x3: return .purple
        case .matrixAddition: return .green
        case .matrixMultiplication: return .orange
        case .systemSolving: return .teal
        case .matrixInverse: return .red
        case .eigenvalues: return .indigo
        }
    }
}

enum Difficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
    
    var valueRange: ClosedRange<Int> {
        switch self {
        case .easy: return -5...5
        case .medium: return -10...10
        case .hard: return -15...15
        }
    }
}

struct TopicStats: Codable {
    var attempted: Int = 0
    var correct: Int = 0
    
    var accuracy: Double {
        guard attempted > 0 else { return 0 }
        return Double(correct) / Double(attempted) * 100
    }
}

struct PracticeSession: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var totalQuestions: Int
    var correctAnswers: Int
    var timeSpent: TimeInterval
    var topics: [ProblemTopic]
    var difficulty: Difficulty
    
    var percentage: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalQuestions) * 100
    }
}

// MARK: - Problem Types

struct GeneratedProblem {
    var topic: ProblemTopic
    var difficulty: Difficulty
    var questionText: String
    var matrix: [[Int]]?
    var matrixB: [[Int]]?  // For operations needing two matrices
    var correctAnswer: String
    var hint: String
    var solution: String
}

struct ExamQuestion: Identifiable {
    var id = UUID()
    var problem: GeneratedProblem
    var userAnswer: String = ""
    var isCorrect: Bool?
    var isFlagged: Bool = false
}
