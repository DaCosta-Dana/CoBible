import SwiftUI
import SwiftData

struct QuizzView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var currentLanguage: String
    @State private var questions: [Quizz] = []
    @State private var currentQuestionIndex = 0
    @State private var selectedOption: String?
    @State private var showingFeedback = false
    @State private var isCorrect = false
    @State private var score = 0
    
    
    init(language: String) {
        self._currentLanguage = State(initialValue: language)
    }
    
    var body: some View {
        VStack {
            if questions.isEmpty {
                Text("No questions available for \(currentLanguage)")
                    .padding()
            } else if currentQuestionIndex < questions.count {
                quizContent
            } else {
                quizCompleted
            }
        }
        .navigationTitle("\(currentLanguage) Quiz")
        .onAppear {
            loadQuestions()
        }
    }
    
    private var quizContent: some View {
        let currentQuestion = questions[currentQuestionIndex]
        
        return VStack(spacing: 20) {
            Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                .font(.headline)
                .padding()
            
            Text(currentQuestion.question)
                .font(.title2)
                .padding()
                .multilineTextAlignment(.center)
            
            VStack(spacing: 15) {
                optionButton(option: currentQuestion.optionA, label: "A")
                optionButton(option: currentQuestion.optionB, label: "B")
                optionButton(option: currentQuestion.optionC, label: "C")
                optionButton(option: currentQuestion.optionD, label: "D")
            }
            
            if showingFeedback {
                Text(isCorrect ? "Correct!" : "Incorrect!")
                    .font(.title)
                    .foregroundColor(isCorrect ? .green : .red)
                    .padding()
                
                Button("Next Question") {
                    nextQuestion()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Text("Score: \(score)")
                .font(.headline)
                .padding()
        }
        .padding()
    }
    
    private var quizCompleted: some View {
        VStack(spacing: 20) {
            Text("Quiz Completed!")
                .font(.title)
                .padding()
            
            Text("Your final score is \(score) out of \(questions.count)")
                .font(.headline)
                .padding()
            
            Button("Restart Quiz") {
                resetQuiz()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    private func optionButton(option: String, label: String) -> some View {
        Button(action: {
            if !showingFeedback {
                checkAnswer(selected: label)
            }
        }) {
            HStack {
                Text("\(label): ")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(option)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                selectedOption == label 
                ? (showingFeedback 
                   ? (isCorrect ? Color.green : Color.red) 
                   : Color.blue.opacity(0.8))
                : Color.blue.opacity(0.5)
            )
            .cornerRadius(10)
        }
    }
    
    private func loadQuestions() {
        questions = QuizzDataManager.fetchQuizzByLanguage(language: currentLanguage, context: modelContext)
        questions.shuffle() // Randomize question order
        resetQuiz()
    }
    
    private func checkAnswer(selected: String) {
        selectedOption = selected
        showingFeedback = true
        
        let currentQuestion = questions[currentQuestionIndex]
        isCorrect = selected == currentQuestion.answer
        
        if isCorrect {
            score += 1
        }
    }
    
    private func nextQuestion() {
        currentQuestionIndex += 1
        selectedOption = nil
        showingFeedback = false
    }
    
    private func resetQuiz() {
        currentQuestionIndex = 0
        score = 0
        selectedOption = nil
        showingFeedback = false
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Quizz.self, configurations: config)
        
        // Add some sample data for the preview
        let sampleQuizz = Quizz(
            language: "Java",
            question: "What is the size of an int in Java?",
            optionA: "2 bytes",
            optionB: "4 bytes",
            optionC: "8 bytes",
            optionD: "16 bytes",
            answer: "B"
        )
        container.mainContext.insert(sampleQuizz)
        
        return QuizzView(language: "Java")
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
