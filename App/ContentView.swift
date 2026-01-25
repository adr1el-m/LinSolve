import SwiftUI

struct ContentView: View {
    @State private var selectedSection: AppSection? = .introduction
    @StateObject private var matrixData = MatrixData()
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("useSystemTheme") private var useSystemTheme: Bool = true
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selectedSection: $selectedSection)
                .navigationTitle("LinSolve")
        } detail: {
            if let section = selectedSection {
                DetailView(section: section, selectedSection: $selectedSection)
                    .environmentObject(matrixData)
            } else {
                Text("Select a topic")
                    .foregroundColor(.secondary)
            }
        }
        .preferredColorScheme(useSystemTheme ? nil : (isDarkMode ? .dark : .light))
        .onAppear {
            if !matrixData.hasComputed {
                matrixData.compute()
            }
        }
    }
}
