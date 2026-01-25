import SwiftUI

// MARK: - Info Box
/// A versatile box for displaying definitions, formulas, methods, or properties.
/// Replaces: FormulaBox, DefinitionBox, MethodBox, IsometryPropertyBox, etc.
struct InfoBox: View {
    let title: String
    let content: String // Can be a formula or definition text
    let description: String?
    let icon: String?
    let color: Color
    
    init(title: String, content: String, description: String? = nil, icon: String? = nil, color: Color = .blue) {
        self.title = title
        self.content = content
        self.description = description
        self.icon = icon
        self.color = color
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20))
                    .frame(width: 24)
            } else {
                Rectangle()
                    .fill(color)
                    .frame(width: 4, height: 40)
                    .cornerRadius(2)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                
                Text(content)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(color)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                
                if let description = description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(12)
        .background(color.opacity(0.1))
        .cornerRadius(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(content)")
        .accessibilityHint(description ?? "")
    }
}

// MARK: - Matrix Display Box
/// Displays a matrix with a title and optional note.
/// Replaces: MatrixTemplateBox
struct MatrixDisplayBox: View {
    let title: String
    let matrix: String
    let note: String?
    let color: Color
    
    init(title: String, matrix: String, note: String? = nil, color: Color = .blue) {
        self.title = title
        self.matrix = matrix
        self.note = note
        self.color = color
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .bold()
            
            Text(matrix)
                .font(.system(.caption, design: .monospaced))
                .padding(8)
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(6)
                .fixedSize(horizontal: false, vertical: true)
            
            if let note = note {
                Text(note)
                    .font(.caption2)
                    .foregroundColor(color)
                    .bold()
            }
        }
        .padding()
        .background(color.opacity(0.05))
        .cornerRadius(8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Process Step View
/// Displays a numbered step in a process or calculation.
/// Replaces: various StepViews
struct ProcessStepView: View {
    let step: Int
    let title: String
    let content: AnyView
    let result: String?
    let color: Color
    
    // Generic init with AnyView content
    init(step: Int, title: String, content: AnyView, result: String? = nil, color: Color = .blue) {
        self.step = step
        self.title = title
        self.content = content
        self.result = result
        self.color = color
    }
    
    // Convenience init for text string content
    init(step: Int, title: String, text: String, result: String? = nil, color: Color = .blue) {
        self.step = step
        self.title = title
        self.content = AnyView(Text(text).font(.system(.caption, design: .monospaced)))
        self.result = result
        self.color = color
    }
    
    // Convenience init for vertical stack of strings (like calculations)
    init(step: Int, title: String, lines: [String], result: String? = nil, color: Color = .blue) {
        self.step = step
        self.title = title
        self.content = AnyView(
            VStack(alignment: .leading, spacing: 4) {
                ForEach(lines, id: \.self) { line in
                    Text(line).font(.system(.caption, design: .monospaced))
                }
            }
        )
        self.result = result
        self.color = color
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(step)")
                .font(.caption)
                .bold()
                .frame(width: 24, height: 24)
                .background(color)
                .foregroundColor(.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                
                content
                
                if let result = result {
                    Text(result)
                        .font(.caption)
                        .foregroundColor(color)
                        .bold()
                        .padding(.top, 2)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Step \(step): \(title)")
    }
}
