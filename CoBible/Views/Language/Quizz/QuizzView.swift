import SwiftUI

struct QuizzView: View {
    let language: String
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int? = nil
    @State private var score = 0
    @State private var hasAnswered = false
    @State private var showResults = false
    @State private var timeRemaining = 20
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            if showResults {
                quizResultsView
            } else if questions.isEmpty {
                ProgressView("Loading questions...")
                    .padding(.top, 20) // Added spacing
                    .onAppear {
                        loadQuestions()
                    }
            } else {
                quizContentView
            }
            
            VStack {
                Text("\(language) Quiz")
                    .font(.custom("LexendDeca-Black", size: 40))
                    .padding(.top, 20) // Consistent spacing
                Spacer()
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private var quizContentView: some View {
        VStack(spacing: 20) {
            progressView
                .padding(.horizontal, 16) // Consistent horizontal padding
            
            questionView
                .padding(.horizontal, 16) // Consistent horizontal padding
            
            optionsView
                .padding(.horizontal, 16) // Consistent horizontal padding
            
            if hasAnswered {
                feedbackView
                    .padding(.horizontal, 16) // Consistent horizontal padding
            }
            
            Spacer()
            
            if hasAnswered {
                nextButton
                    .padding(.horizontal, 16) // Consistent horizontal padding
            }
        }
        .padding(.top, 20) // Consistent top padding
    }
    
    private var progressView: some View {
        VStack {
            
            HStack {
                Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                    .font(.custom("LexendDeca-Black", size: 16)) // Updated font
                Spacer()
                Text("Score: \(score)")
                    .font(.custom("LexendDeca-Black", size: 16))
                    .bold()
            }
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 8)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(width: CGFloat(currentQuestionIndex + 1) / CGFloat(questions.count) * UIScreen.main.bounds.width - 40, height: 8)
                    .foregroundColor(.blue)
            }
            .cornerRadius(4)
            
            HStack {
                Image(systemName: "clock")
                Text("\(timeRemaining)")
                    .fontWeight(.bold)
                    .foregroundColor(timeRemaining < 5 ? .red : .primary)
            }
            .padding(.top, 5)
        }
        .padding(.top, 100)
    }
    
    private var questionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(getCurrentQuestion().questionText)
                .font(.custom("LexendDeca-ExtraBold", size: 18)) // Updated font
                .fontWeight(.medium)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }
    
    private var optionsView: some View {
        VStack(spacing: 12) {
            ForEach(0..<4, id: \.self) { index in
                Button {
                    if !hasAnswered {
                        selectAnswer(index)
                    }
                } label: {
                    HStack {
                        Text("\(["A", "B", "C", "D"][index])")
                            .font(.custom("LexendDeca-Black", size: 16)) // Updated font
                            .padding(8)
                            .background(Circle().fill(optionCircleColor(for: index)))
                            .foregroundColor(.white)
                        
                        Text(getCurrentQuestion().options[index])
                            .font(.custom("LexendDeca-ExtraBold", size: 16)) // Updated font
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if hasAnswered && index == getCurrentQuestion().correctAnswerIndex {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else if hasAnswered && index == selectedAnswerIndex && index != getCurrentQuestion().correctAnswerIndex {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(optionBackgroundColor(for: index))
                    .cornerRadius(10)
                }
                .disabled(hasAnswered)
            }
        }
    }
    
    private var feedbackView: some View {
        Text(selectedAnswerIndex == getCurrentQuestion().correctAnswerIndex ? "Correct! 🎉" : "Incorrect! The correct answer is \(["A", "B", "C", "D"][getCurrentQuestion().correctAnswerIndex])")
            .font(.custom("LexendDeca-Black", size: 16)) // Updated font
            .foregroundColor(selectedAnswerIndex == getCurrentQuestion().correctAnswerIndex ? .green : .red)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
    }
    
    private var nextButton: some View {
        Button(action: nextQuestion) {
            Text(isLastQuestion ? "See Results" : "Next Question")
                .font(.custom("LexendDeca-Black", size: 16)) // Updated font
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding(.horizontal, 16)
    }
    
    private var quizResultsView: some View {
        VStack(spacing: 20) {
            Text("Quiz Complete!")
                .font(.custom("LexendDeca-Black", size: 20))
                .fontWeight(.bold)
                .padding(.top, 20) // Consistent top padding
                
            Text("Your score: \(score) / \(questions.count)")
                .font(.custom("LexendDeca-Black", size: 18))
                .padding(.horizontal, 16) // Consistent horizontal padding
                
            VStack(alignment: .leading, spacing: 15) {
                Text("Performance:")
                    .font(.custom("LexendDeca-Black", size: 16))
                    
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 15, height: 15)
                    Text("Correct: \(score)")
                        .font(.custom("LexendDeca-Black", size: 16))
                }
                
                HStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 15, height: 15)
                    Text("Incorrect: \(questions.count - score)")
                        .font(.custom("LexendDeca-Black", size: 16))
                }
                
                Text("Accuracy: \(Int((Double(score) / Double(questions.count)) * 100))%")
                    .font(.custom("LexendDeca-Black", size: 16))
                    .fontWeight(.medium)
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 16) // Consistent horizontal padding
            
            Button(action: resetQuiz) {
                Text("Try Again")
                    .font(.custom("LexendDeca-Black", size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 16) // Consistent horizontal padding
            .padding(.top, 20) // Consistent top padding
        }
        .padding(.horizontal, 16) // Consistent horizontal padding
    }
    
    private func loadQuestions() {
        questions = Quizz.shared.getRandomQuestionsForLanguage(language: language, count: 10)
        startTimer()
    }
    
    private func startTimer() {
        timeRemaining = 20
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                if !hasAnswered {
                    // Time's up, auto-submit wrong answer
                    selectAnswer(nil)
                }
            }
        }
    }
    
    private func selectAnswer(_ index: Int?) {
        selectedAnswerIndex = index
        hasAnswered = true
        timer?.invalidate()
        
        if let index = index, index == getCurrentQuestion().correctAnswerIndex {
            score += 1
        }
    }
    
    private func nextQuestion() {
        if isLastQuestion {
            showResults = true
        } else {
            currentQuestionIndex += 1
            selectedAnswerIndex = nil
            hasAnswered = false
            startTimer()
        }
    }
    
    private func resetQuiz() {
        currentQuestionIndex = 0
        selectedAnswerIndex = nil
        score = 0
        hasAnswered = false
        showResults = false
        loadQuestions()
    }
    
    private func getCurrentQuestion() -> Question {
        questions[currentQuestionIndex]
    }
    
    private var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }
    
    private func optionCircleColor(for index: Int) -> Color {
        if !hasAnswered {
            return selectedAnswerIndex == index ? .blue : .gray
        }
        
        if index == getCurrentQuestion().correctAnswerIndex {
            return .green
        } else if index == selectedAnswerIndex {
            return .red
        }
        
        return .gray
    }
    
    private func optionBackgroundColor(for index: Int) -> Color {
        if !hasAnswered {
            return selectedAnswerIndex == index ? Color.blue.opacity(0.1) : Color.white
        }
        
        if index == getCurrentQuestion().correctAnswerIndex {
            return Color.green.opacity(0.1)
        } else if index == selectedAnswerIndex {
            return Color.red.opacity(0.1)
        }
        
        return Color.white
    }
}

struct QuizzView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QuizzView(language: "Java")
        }
    }
}

