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
    @State private var selectedCategories: Set<String> = [] // Multi-selection
    @State private var availableCategories: [String] = []

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack {
                Text("\(language) Quiz")
                    .font(.custom("LexendDeca-Black", size: 40))
                Spacer()
            }

            contentSwitcher
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    // Split the main conditional into a computed property to help the compiler
    @ViewBuilder
    private var contentSwitcher: some View {
        if showResults {
            quizResultsView
        } else if questions.isEmpty {
            categorySelectionView
        } else {
            quizContentView
        }
    }

    private var categorySelectionView: some View {
        VStack(spacing: 24) {
            Text("Choose Categories")
                .font(.custom("LexendDeca-Black", size: 20))
                .padding(.top, 60)
            if !availableCategories.isEmpty {
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer().frame(height: 1)
                        ForEach(availableCategories, id: \.self) { category in
                            categoryButton(for: category)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 10)
            } else {
                ProgressView("Loading categories...")
                    .padding(.top, 20)
            }
            if !selectedCategories.isEmpty {
                Button(action: loadQuestions) {
                    Text("Start Quiz")
                        .font(.custom("LexendDeca-Black", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .transition(.opacity)
            }
            Spacer()
        }
        .onAppear {
            loadCategories()
        }
    }

    // Extracted category button to further help the compiler
    private func categoryButton(for category: String) -> some View {
        Button(action: {
            if selectedCategories.contains(category) {
                selectedCategories.remove(category)
            } else {
                selectedCategories.insert(category)
            }
        }) {
            HStack {
                Image(systemName: selectedCategories.contains(category) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(selectedCategories.contains(category) ? .green : .gray)
                    .font(.system(size: 24))
                Text(category)
                    .font(.custom("LexendDeca-Black", size: 18))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(selectedCategories.contains(category) ? Color.blue.opacity(0.15) : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selectedCategories.contains(category) ? Color.blue : Color.gray.opacity(0.2), lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 0)
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
    
    private func loadCategories() {
        let cats = Quizz.shared.getAvailableCategories(for: language)
        availableCategories = cats
        if let first = cats.first, selectedCategories.isEmpty {
            selectedCategories = [first]
        }
    }

    private func loadQuestions() {
        let selected = Array(selectedCategories)
        questions = Quizz.shared.getRandomQuestionsForLanguageAndCategories(language: language, categories: selected, count: 10)
        currentQuestionIndex = 0
        selectedAnswerIndex = nil
        score = 0
        hasAnswered = false
        showResults = false
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
        questions = []
        loadCategories()
    }
    
    private func getCurrentQuestion() -> Question {
        questions[currentQuestionIndex]
    }
    
    private var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }
    
    private func optionCircleColor(for index: Int) -> Color {
        if (!hasAnswered) {
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
        if (!hasAnswered) {
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

