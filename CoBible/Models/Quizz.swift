import Foundation

struct Question: Identifiable {
    let id = UUID()
    let language: String
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
                if columns.count >= 7 {
                    let language = columns[0]
                    let questionText = columns[1]
                    let options = [columns[2], columns[3], columns[4], columns[5]]
                    let correctAnswer = columns[6]
                    
                    let question = Question(
                        language: language,
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
}
