import AVFoundation
import UIKit

class SoundManager {
    static let shared = SoundManager()
    
    private var synthesizer: AVSpeechSynthesizer?
    private var audioPlayer: AVAudioPlayer?
    
    // Haptics
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    private init() {
        // Pre-warm haptics
        impactGenerator.prepare()
    }
    
    func playNullSpaceDiscovery() {
        // Play a "success" sound or haptic when vector hits zero
        notificationGenerator.notificationOccurred(.success)
        
        // Simple chime sound (system sound)
        AudioServicesPlaySystemSound(1057) // Tink
    }
    
    func playSingularityWarning() {
        notificationGenerator.notificationOccurred(.warning)
    }
    
    func playSelectionHaptic() {
        selectionGenerator.selectionChanged()
    }
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        if synthesizer == nil {
            synthesizer = AVSpeechSynthesizer()
        }
        synthesizer?.speak(utterance)
    }
}
