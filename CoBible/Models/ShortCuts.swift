import Foundation
import SwiftData

// Model class representing a programming shortcut
@Model
final class Shortcut {
    var id: UUID                   // Unique identifier
    var number: Int                // Shortcut number/order
    var title: String              // Shortcut title
    var explanation: String        // Description/explanation of the shortcut
    var javaCode: String           // Java code snippet
    var pythonCode: String         // Python code snippet

    // Initializer for Shortcut
    init(number: Int, title: String, explanation: String, javaCode: String, pythonCode: String) {
        self.id = UUID()
        self.number = number
        self.title = title
        self.explanation = explanation
        self.javaCode = javaCode
        self.pythonCode = pythonCode
    }
}

// Data manager for handling Shortcut objects in the database
final class ShortcutDataManager {
    // Populates the database with shortcuts from a CSV file (if not already present)
    static func populateShortcuts(context: ModelContext) {
        // Check if any Shortcut objects already exist
        let fetchDescriptor = FetchDescriptor<Shortcut>()
        if let existingShortcuts = try? context.fetch(fetchDescriptor), !existingShortcuts.isEmpty {
            return // Data already exists, skip insertion
        }

        // Read data from CSV file
        guard let csvPath = Bundle.main.path(forResource: "shortcuts", ofType: "csv"),
              let csvContent = try? String(contentsOfFile: csvPath, encoding: .utf8) else {
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

            // Create a new Shortcut object and insert it into the context
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

    // Fetch a shortcut by its title
    static func fetchShortcutByTitle(title: String, context: ModelContext) -> Shortcut? {
        let fetchDescriptor = FetchDescriptor<Shortcut>(predicate: #Predicate { $0.title == title })
        return try? context.fetch(fetchDescriptor).first
    }
}
