import SwiftUI

struct QuizzView: View {
    @State private var currentQuestionIndex: Int = 0
    @State private var selectedAnswer: String? = nil
    @State private var showResult: Bool = false
    @State private var score: Int = 0

    let questions: [QuizzQuestion] = QuizzDataManager.loadQuestions()

    var body: some View {
        VStack(spacing: 20) {
            if currentQuestionIndex < questions.count {
                // Display question
                Text(questions[currentQuestionIndex].question)
                    .font(.custom("LexendDeca-Black", size: 24))
                    .multilineTextAlignment(.center)
                    .padding()

                // Display options
                ForEach(questions[currentQuestionIndex].options, id: \.self) { option in
                    Button(action: {
                        selectedAnswer = option
                        checkAnswer()
                    }) {
                        Text(option)
                            .font(.custom("LexendDeca-Regular", size: 18))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedAnswer == option ? Color.blue.opacity(0.7) : Color.gray.opacity(0.2))
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    }
                }

                Spacer()

                // Next button
                Button(action: {
                    nextQuestion()
                }) {
                    Text("Next")
                        .font(.custom("LexendDeca-Black", size: 18))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
            } else {
                // Display result
                Text("Quiz Completed!")
                    .font(.custom("LexendDeca-Black", size: 24))
                Text("Your Score: \(score)/\(questions.count)")
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .padding()

                Button(action: {
                    resetQuiz()
                }) {
                    Text("Restart")
                        .font(.custom("LexendDeca-Black", size: 18))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func checkAnswer() {
        if selectedAnswer == questions[currentQuestionIndex].correctAnswer {
            score += 1
        }
    }

    private func nextQuestion() {
        selectedAnswer = nil
        currentQuestionIndex += 1
    }

    private func resetQuiz() {
        currentQuestionIndex = 0
        score = 0
        selectedAnswer = nil
    }
}

struct QuizzQuestion {
    let question: String
    let options: [String]
    let correctAnswer: String
}

final class QuizzDataManager {
    static func loadQuestions() -> [QuizzQuestion] {
        // Replace this with actual data loading logic (e.g., from a CSV or database)
        return [
            QuizzQuestion(question: "What is the size of an int in Java?", options: ["2 bytes", "4 bytes", "8 bytes", "16 bytes"], correctAnswer: "4 bytes"),
            QuizzQuestion(question: "Which keyword is used to inherit a class in Java?", options: ["this", "super", "extends", "implements"], correctAnswer: "extends"),
            // Add more questions here...
        ]
    }
}

struct QuizzView_Previews: PreviewProvider {
    static var previews: some View {
        QuizzView()
    }
}
