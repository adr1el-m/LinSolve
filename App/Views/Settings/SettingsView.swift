import SwiftUI

struct SettingsView: View {
    // MARK: - App Storage
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("useSystemTheme") private var useSystemTheme: Bool = true
    @AppStorage("showStepNumbers") private var showStepNumbers: Bool = true
    @AppStorage("autoSimplifyFractions") private var autoSimplifyFractions: Bool = true
    @AppStorage("defaultMatrixSize") private var defaultMatrixSize: Int = 3
    @AppStorage("showDecimalsAlongFractions") private var showDecimalsAlongFractions: Bool = false
    @AppStorage("hapticFeedback") private var hapticFeedback: Bool = true
    
    @State private var showResetConfirmation: Bool = false
    @State private var showAcknowledgments: Bool = false
    
    var body: some View {
        Form {
            // MARK: - Appearance Section
            Section {
                Toggle(isOn: $useSystemTheme) {
                    Label("Use System Theme", systemImage: "circle.lefthalf.filled")
                }
                
                if !useSystemTheme {
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                }
            } header: {
                Text("Appearance")
            } footer: {
                Text("Choose whether to follow your device's appearance settings or set a preference manually.")
            }
            
            // MARK: - Computation Settings
            Section {
                Toggle(isOn: $autoSimplifyFractions) {
                    Label("Auto-Simplify Fractions", systemImage: "divide")
                }
                
                Toggle(isOn: $showDecimalsAlongFractions) {
                    Label("Show Decimal Equivalents", systemImage: "number")
                }
                
                Picker(selection: $defaultMatrixSize) {
                    Text("2×2").tag(2)
                    Text("3×3").tag(3)
                    Text("4×4").tag(4)
                    Text("5×5").tag(5)
                } label: {
                    Label("Default Matrix Size", systemImage: "square.grid.3x3")
                }
            } header: {
                Text("Computation")
            } footer: {
                Text("Configure how calculations are displayed and the default matrix dimensions.")
            }
            
            // MARK: - Display Settings
            Section {
                Toggle(isOn: $showStepNumbers) {
                    Label("Show Step Numbers", systemImage: "list.number")
                }
                
                Toggle(isOn: $hapticFeedback) {
                    Label("Haptic Feedback", systemImage: "hand.tap")
                }
            } header: {
                Text("Display & Feedback")
            } footer: {
                Text("Customize how step-by-step solutions are presented.")
            }
            
            // MARK: - Data Management
            Section {
                Button(role: .destructive) {
                    showResetConfirmation = true
                } label: {
                    Label("Reset All Settings", systemImage: "arrow.counterclockwise")
                }
            } header: {
                Text("Data Management")
            }
            
            // MARK: - About Section
            Section {
                HStack {
                    Label("Version", systemImage: "info.circle")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Label("Build", systemImage: "hammer")
                    Spacer()
                    Text("2026.01")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Label("Platform", systemImage: "ipad")
                    Spacer()
                    Text("iPadOS 18+")
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("About")
            }
            
            // MARK: - Developer Section
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "person.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .frame(width: 40, height: 40)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Adriel Magalona")
                                .font(.headline)
                            Text("Developer")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text("LinSolve is an educational app designed to help students visualize and understand linear algebra concepts through interactive step-by-step solutions.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                
                Button {
                    showAcknowledgments = true
                } label: {
                    Label("Acknowledgments", systemImage: "heart.fill")
                }
            } header: {
                Text("Developer")
            }
            
            // MARK: - Legal Section
            Section {
                NavigationLink {
                    PrivacyPolicyView()
                } label: {
                    Label("Privacy Policy", systemImage: "hand.raised.fill")
                }
                
                NavigationLink {
                    TermsOfUseView()
                } label: {
                    Label("Terms of Use", systemImage: "doc.text.fill")
                }
            } header: {
                Text("Legal")
            }
            
            // MARK: - Footer
            Section {
                VStack(spacing: 8) {
                    Text("Swift Student Challenge 2026")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Made with ❤️ using SwiftUI")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("© 2026 Adriel Magalona. All rights reserved.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
        }
        .navigationTitle("Settings")
        .confirmationDialog("Reset Settings", isPresented: $showResetConfirmation, titleVisibility: .visible) {
            Button("Reset All", role: .destructive) {
                resetAllSettings()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will reset all settings to their default values. This action cannot be undone.")
        }
        .sheet(isPresented: $showAcknowledgments) {
            AcknowledgmentsView()
        }
    }
    
    private func resetAllSettings() {
        useSystemTheme = true
        isDarkMode = false
        showStepNumbers = true
        autoSimplifyFractions = true
        defaultMatrixSize = 3
        showDecimalsAlongFractions = false
        hapticFeedback = true
    }
}

// MARK: - Privacy Policy View
struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .bold()
                
                Group {
                    Text("Last Updated: January 2026")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Data Collection")
                        .font(.headline)
                    Text("LinSolve does not collect, store, or transmit any personal data. All computations are performed locally on your device.")
                    
                    Text("Third-Party Services")
                        .font(.headline)
                    Text("This app does not use any third-party analytics, advertising, or tracking services.")
                    
                    Text("Data Storage")
                        .font(.headline)
                    Text("Your preferences and settings are stored locally on your device using standard iOS mechanisms. No data is synced to external servers.")
                    
                    Text("Contact")
                        .font(.headline)
                    Text("If you have any questions about this privacy policy, please contact the developer.")
                }
                .font(.body)
            }
            .padding(24)
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Terms of Use View
struct TermsOfUseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Terms of Use")
                    .font(.largeTitle)
                    .bold()
                
                Group {
                    Text("Last Updated: January 2026")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Acceptance of Terms")
                        .font(.headline)
                    Text("By using LinSolve, you agree to these terms. If you do not agree, please do not use the app.")
                    
                    Text("Educational Use")
                        .font(.headline)
                    Text("LinSolve is designed for educational purposes. While we strive for accuracy, users should verify critical calculations independently.")
                    
                    Text("Intellectual Property")
                        .font(.headline)
                    Text("All content, design, and code in LinSolve are the intellectual property of Adriel Magalona unless otherwise stated.")
                    
                    Text("Limitation of Liability")
                        .font(.headline)
                    Text("LinSolve is provided \"as is\" without warranty of any kind. The developer is not liable for any damages arising from the use of this app.")
                    
                    Text("Changes to Terms")
                        .font(.headline)
                    Text("These terms may be updated from time to time. Continued use of the app constitutes acceptance of any changes.")
                }
                .font(.body)
            }
            .padding(24)
        }
        .navigationTitle("Terms of Use")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Acknowledgments View
struct AcknowledgmentsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Acknowledgments")
                        .font(.largeTitle)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        AcknowledgmentRow(
                            title: "SwiftUI",
                            description: "Apple's declarative UI framework that made this app possible."
                        )
                        
                        AcknowledgmentRow(
                            title: "Swift Playgrounds",
                            description: "The amazing platform for building and sharing educational apps."
                        )
                        
                        AcknowledgmentRow(
                            title: "Linear Algebra Community",
                            description: "The educators and mathematicians whose work inspired this educational tool."
                        )
                        
                        AcknowledgmentRow(
                            title: "SF Symbols",
                            description: "Apple's comprehensive icon library used throughout the app."
                        )
                        
                        AcknowledgmentRow(
                            title: "Beta Testers",
                            description: "Everyone who provided valuable feedback during development."
                        )
                    }
                    
                    Divider()
                        .padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Special Thanks")
                            .font(.headline)
                        Text("To my family, friends, and mentors who supported me throughout this project. Your encouragement made LinSolve possible.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AcknowledgmentRow: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(10)
    }
}
