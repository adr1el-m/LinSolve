import SwiftUI

/// Main content view providing navigation split view architecture
/// Manages theme settings and matrix data computation
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
            detailContent
        }
        .preferredColorScheme(colorScheme)
        .onAppear(perform: initializeMatrixData)
    }
    
    // MARK: - Private Views
    
    @ViewBuilder
    private var detailContent: some View {
        if let section = selectedSection {
            DetailView(section: section, selectedSection: $selectedSection)
                .environmentObject(matrixData)
        } else {
            Text("Select a topic")
                .foregroundColor(.secondary)
                .font(.title3)
        }
    }
    
    // MARK: - Computed Properties
    
    private var colorScheme: ColorScheme? {
        useSystemTheme ? nil : (isDarkMode ? .dark : .light)
    }
    
    // MARK: - Private Methods
    
    private func initializeMatrixData() {
        guard !matrixData.hasComputed else { return }
        matrixData.compute()
    }
}
