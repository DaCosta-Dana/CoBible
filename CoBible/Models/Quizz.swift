import Foundation

// Model struct representing a quiz question
struct Question: Identifiable {
    let id = UUID()                // Unique identifier for the question
    let language: String           // Programming language (e.g., Java, Python)
    let category: String           // Category of the question (e.g., Variables, Loops)
    let questionText: String       // The question text
    let options: [String]          // Array of answer options (A, B, C, D)
    let correctAnswer: String      // The correct answer as a letter ("A", "B", "C", "D")
    
    // Converts the correct answer letter to its corresponding index (0-3)
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

// Singleton class to manage quiz questions and logic
class Quizz {
    static let shared = Quizz() // Singleton instance for global access
    
    private(set) var allQuestions: [Question] = [] // All loaded questions
    private(set) var isLoaded = false              // Whether questions are loaded
    
    private init() {
        loadQuestions()
    }
    
    // Loads questions from the CSV file into memory
    private func loadQuestions() {
        guard let path = Bundle.main.path(forResource: "quizz", ofType: "csv") else {
            print("Failed to find quizz.csv")
            return
        }
        
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            let rows = content.components(separatedBy: .newlines)
            
            // Skip the header row and parse each question row
            for i in 1..<rows.count {
                let row = rows[i]
                if row.isEmpty { continue }
                
                let columns = row.components(separatedBy: ",")
                // Expecting 8 columns: Language, Category, Question, Option A, B, C, D, Answer
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
    
    // Returns up to 'count' random questions from all loaded questions
    func getRandomQuestions(count: Int = 10) -> [Question] {
        guard isLoaded else { return [] }
        let shuffledQuestions = allQuestions.shuffled()
        return Array(shuffledQuestions.prefix(min(count, shuffledQuestions.count)))
    }
    
    // Returns up to 'count' random questions for a specific language
    func getRandomQuestionsForLanguage(language: String, count: Int = 10) -> [Question] {
        guard isLoaded else { return [] }
        let languageQuestions = allQuestions.filter { $0.language == language }
        let shuffledQuestions = languageQuestions.shuffled()
        return Array(shuffledQuestions.prefix(min(count, shuffledQuestions.count)))
    }
    
    // Returns a sorted list of all available programming languages
    func getAvailableLanguages() -> [String] {
        guard isLoaded else { return [] }
        return Array(Set(allQuestions.map { $0.language })).sorted()
    }

    // Returns up to 'count' random questions for a specific language and category
    func getRandomQuestionsForLanguageAndCategory(language: String, category: String, count: Int = 10) -> [Question] {
        guard isLoaded else { return [] }
        let filtered = allQuestions.filter { $0.language == language && $0.category == category }
        let shuffled = filtered.shuffled()
        return Array(shuffled.prefix(min(count, shuffled.count)))
    }

    // Returns a sorted list of available categories for a given language
    func getAvailableCategories(for language: String) -> [String] {
        guard isLoaded else { return [] }
        let categories = allQuestions.filter { $0.language == language }.map { $0.category }
        return Array(Set(categories)).sorted()
    }

    // Returns up to 'count' random questions for a language and multiple categories
    func getRandomQuestionsForLanguageAndCategories(language: String, categories: [String], count: Int = 10) -> [Question] {
        guard isLoaded else { return [] }
        let filtered = allQuestions.filter { $0.language == language && categories.contains($0.category) }
        let shuffled = filtered.shuffled()
        return Array(shuffled.prefix(min(count, shuffled.count)))
    }
}
