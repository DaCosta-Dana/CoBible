import Foundation
import SwiftData

@Model
final class Quizz {
    var id: UUID
    var language: String
    var question: String
    var optionA: String
    var optionB: String
    var optionC: String
    var optionD: String
    var answer: String

    init(language: String, question: String, optionA: String, optionB: String, optionC: String, optionD: String, answer: String) {
        self.id = UUID()
        self.language = language
        self.question = question
        self.optionA = optionA
        self.optionB = optionB
        self.optionC = optionC
        self.optionD = optionD
        self.answer = answer
    }
}

final class QuizzDataManager {
    static func populateQuizz(context: ModelContext) {
        // Check if any Quizz objects already exist
        let fetchDescriptor = FetchDescriptor<Quizz>()
        if let existingQuizz = try? context.fetch(fetchDescriptor), !existingQuizz.isEmpty {
            return // Data already exists, skip insertion
        }

        // Read data from CSV file
        guard let csvPath = Bundle.main.path(forResource: "quizz", ofType: "csv"),
              let csvContent = try? String(contentsOfFile: csvPath, encoding: .utf8) else {
            print("Failed to load quizz.csv")
            return
        }

        let rows = csvContent.split(separator: "\n")
        for row in rows.dropFirst() { // Skip the header row
            let columns = row.split(separator: ",", omittingEmptySubsequences: false)
            guard columns.count >= 7 else { continue }
            let language = String(columns[0].trimmingCharacters(in: .whitespaces))
            let question = String(columns[1].trimmingCharacters(in: .whitespaces))
            let optionA = String(columns[2].trimmingCharacters(in: .whitespaces))
            let optionB = String(columns[3].trimmingCharacters(in: .whitespaces))
            let optionC = String(columns[4].trimmingCharacters(in: .whitespaces))
            let optionD = String(columns[5].trimmingCharacters(in: .whitespaces))
            let answer = String(columns[6].trimmingCharacters(in: .whitespaces))

            let quizz = Quizz(
                language: language,
                question: question,
                optionA: optionA,
                optionB: optionB,
                optionC: optionC,
                optionD: optionD,
                answer: answer
            )
            context.insert(quizz)
        }
    }

    static func fetchQuizzByLanguage(language: String, context: ModelContext) -> [Quizz] {
        let fetchDescriptor = FetchDescriptor<Quizz>(predicate: #Predicate { $0.language == language })
        return (try? context.fetch(fetchDescriptor)) ?? []
    }
}
