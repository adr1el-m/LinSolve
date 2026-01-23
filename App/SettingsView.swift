import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("useSystemTheme") private var useSystemTheme: Bool = true
    
    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Toggle("Use System Theme", isOn: $useSystemTheme)
                
                if !useSystemTheme {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
            }
            
            Section(header: Text("About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                Text("VectorLens is an educational tool designed to help students visualize and understand linear algebra concepts interactively.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Settings")
    }
}
