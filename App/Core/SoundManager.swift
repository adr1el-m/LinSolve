import AVFoundation
import UIKit

/// Manages audio feedback and haptics throughout the app
/// Provides success sounds, warnings, and speech synthesis for accessibility
class SoundManager {
    static let shared = SoundManager()
    
    private var synthesizer: AVSpeechSynthesizer?
    private var audioPlayer: AVAudioPlayer?
    
    // MARK: - Haptic Generators
    
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    private init() {
        // Pre-warm haptics for better responsiveness
        impactGenerator.prepare()
    }
    
    // MARK: - Public Methods
    
    /// Plays success sound when discovering null space vectors
    func playNullSpaceDiscovery() {
        notificationGenerator.notificationOccurred(.success)
        AudioServicesPlaySystemSound(1057) // Tink sound
    }
    
    /// Plays warning haptic for singular matrices
    func playSingularityWarning() {
        notificationGenerator.notificationOccurred(.warning)
    }
    
    /// Plays selection changed haptic
    func playSelectionHaptic() {
        selectionGenerator.selectionChanged()
    }
    
    /// Speaks text using speech synthesis for accessibility
    /// - Parameter text: Text to be spoken
    func speak(_ text: String) {
        guard !text.isEmpty else { return }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        if synthesizer == nil {
            synthesizer = AVSpeechSynthesizer()
        }
        synthesizer?.speak(utterance)
    }
}
