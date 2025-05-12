import Foundation

struct Question: Identifiable {
    let id = UUID()
    let language: String
    let category: String // Added category
    let questionText: String
    let options: [String]
    let correctAnswer: String
    
    // Convert letter answer (A, B, C, D) to index (0, 1, 2, 3)
    var correctAnswerIndex: Int {
        switch correctAnswer {
        case "A": return 0
        case "B": return 1
        case "C": return 2
        case "D": return 3
        default: return 0
        }
    }
}

class Quizz {
    static let shared = Quizz() // Singleton for easy access
    
    private(set) var allQuestions: [Question] = []
    private(set) var isLoaded = false
    
    private init() {
        loadQuestions()
    }
    
    private func loadQuestions() {
        guard let path = Bundle.main.path(forResource: "quizz", ofType: "csv") else {
            print("Failed to find quizz.csv")
            return
        }
        
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            let rows = content.components(separatedBy: .newlines)
            
            // Skip the header row
            for i in 1..<rows.count {
                let row = rows[i]
                if row.isEmpty { continue }
                
                let columns = row.components(separatedBy: ",")
                // Now expecting 8 columns: Language,Category,Question,Option A,B,C,D,Answer
                if columns.count >= 8 {
                    let language = columns[0]
                    let category = columns[1]
                    let questionText = columns[2]
                    let options = [columns[3], columns[4], columns[5], columns[6]]
                    let correctAnswer = columns[7]
                    
                    let question = Question(
                        language: language,
                        category: category,
                        questionText: questionText,
                        options: options,
                        correctAnswer: correctAnswer
                    )
                    
                    allQuestions.append(question)
                }
            }
            
            isLoaded = true
            print("Successfully loaded \(allQuestions.count) questions")
        } catch {
            print("Error loading quizz.csv: \(error)")
        }
    }
    
    // Get 10 random questions (or fewer if not enough are available)
    func getRandomQuestions(count: Int = 10) -> [Question] {
        guard isLoaded else { return [] }
        let shuffledQuestions = allQuestions.shuffled()
        return Array(shuffledQuestions.prefix(min(count, shuffledQuestions.count)))
    }
    
    // Get random questions for a specific programming language
    func getRandomQuestionsForLanguage(language: String, count: Int = 10) -> [Question] {
        guard isLoaded else { return [] }
        let languageQuestions = allQuestions.filter { $0.language == language }
        let shuffledQuestions = languageQuestions.shuffled()
        return Array(shuffledQuestions.prefix(min(count, shuffledQuestions.count)))
    }
    
    // Get list of available programming languages
    func getAvailableLanguages() -> [String] {
        guard isLoaded else { return [] }
        return Array(Set(allQuestions.map { $0.language })).sorted()
    }

    // Get random questions for a specific language and category
    func getRandomQuestionsForLanguageAndCategory(language: String, category: String, count: Int = 10) -> [Question] {
        guard isLoaded else { return [] }
        let filtered = allQuestions.filter { $0.language == language && $0.category == category }
        let shuffled = filtered.shuffled()
        return Array(shuffled.prefix(min(count, shuffled.count)))
    }

    // Get available categories for a language
    func getAvailableCategories(for language: String) -> [String] {
        guard isLoaded else { return [] }
        let categories = allQuestions.filter { $0.language == language }.map { $0.category }
        return Array(Set(categories)).sorted()
    }

    // Get random questions for a specific language and multiple categories
    func getRandomQuestionsForLanguageAndCategories(language: String, categories: [String], count: Int = 10) -> [Question] {
        guard isLoaded else { return [] }
        let filtered = allQuestions.filter { $0.language == language && categories.contains($0.category) }
        let shuffled = filtered.shuffled()
        return Array(shuffled.prefix(min(count, shuffled.count)))
    }
}
