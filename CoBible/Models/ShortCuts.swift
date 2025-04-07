import Foundation
import SwiftData


@Model
final class Shortcut {
    var id: UUID
    var number: Int
    var title: String
    var explanation: String
    var javaCode: String // Java code snippet
    var pythonCode: String // Python code snippet

    init(number: Int, title: String, explanation: String, javaCode: String, pythonCode: String) {
        self.id = UUID()
        self.number = number
        self.title = title
        self.explanation = explanation
        self.javaCode = javaCode
        self.pythonCode = pythonCode
    }
}

final class ShortcutDataManager {
    static func populateShortcuts(context: ModelContext) {
        // Check if any Shortcut objects already exist
        let fetchDescriptor = FetchDescriptor<Shortcut>()
        if let existingShortcuts = try? context.fetch(fetchDescriptor), !existingShortcuts.isEmpty {
            return // Data already exists, skip insertion
        }

        // Read data from CSV file
        guard let csvPath = Bundle.main.path(forResource: "shortcuts", ofType: "csv"),
              let csvContent = try? String(contentsOfFile: csvPath) else {
            print("Failed to load shortcuts.csv")
            return
        }

        let rows = csvContent.split(separator: "\n")
        for row in rows.dropFirst() { // Skip the header row
            let columns = row.split(separator: ",")
            guard columns.count == 5, // Ensure all columns are present
                  let number = Int(columns[0].trimmingCharacters(in: .whitespaces)) else {
                continue // Skip invalid rows
            }

            let title = String(columns[1].trimmingCharacters(in: .whitespaces))
            let explanation = String(columns[2].trimmingCharacters(in: .whitespaces))
            let javaCode = String(columns[3].trimmingCharacters(in: .whitespaces))
            let pythonCode = String(columns[4].trimmingCharacters(in: .whitespaces))

            let shortcut = Shortcut(
                number: number,
                title: title,
                explanation: explanation,
                javaCode: javaCode,
                pythonCode: pythonCode
            )
            context.insert(shortcut)
        }
    }

    static func fetchShortcutByTitle(title: String, context: ModelContext) -> Shortcut? {
        let fetchDescriptor = FetchDescriptor<Shortcut>(predicate: #Predicate { $0.title == title })
        return try? context.fetch(fetchDescriptor).first
    }
}
