import Foundation
import SwiftData

@Model
final class Shortcut {
    var id: UUID
    var number: Int
    var title: String
    var code: String
    var explanation: String
    var language: String // New property to store the language

    init(number: Int, title: String, code: String, explanation: String, language: String) {
        self.id = UUID()
        self.number = number
        self.title = title
        self.code = code
        self.explanation = explanation
        self.language = language
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
        for row in rows {
            let columns = row.split(separator: ",")
            guard columns.count == 5, // Updated to handle the new language column
                  let number = Int(columns[0].trimmingCharacters(in: .whitespaces)) else {
                continue // Skip invalid rows
            }

            let title = String(columns[1].trimmingCharacters(in: .whitespaces))
            let explanation = String(columns[2].trimmingCharacters(in: .whitespaces))
            let code = String(columns[3].trimmingCharacters(in: .whitespaces))
            let language = String(columns[4].trimmingCharacters(in: .whitespaces)) // Extract language

            let shortcut = Shortcut(number: number, title: title, code: code, explanation: explanation, language: language)
            context.insert(shortcut)
        }
    }
}
