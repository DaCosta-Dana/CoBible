import SwiftUI

struct QuizzView: View {
    // Environment variable to dismiss the view
    @Environment(\.presentationMode) var presentationMode
    // State for the selected language (Java/Python)
    @State private var selectedLanguage: String
    // Array of questions for the quiz
    @State private var questions: [Question] = []
    // Index of the current question
    @State private var currentQuestionIndex = 0
    // Index of the selected answer for the current question
    @State private var selectedAnswerIndex: Int? = nil
    // User's score
    @State private var score = 0
    // Whether the user has answered the current question
    @State private var hasAnswered = false
    // Whether to show the results screen
    @State private var showResults = false
    // Time remaining for the current question
    @State private var timeRemaining = 20
    // Timer for the countdown
    @State private var timer: Timer?
    // Set of selected categories for filtering questions
    @State private var selectedCategories: Set<String> = []
    // List of available categories for the selected language
    @State private var availableCategories: [String] = []

    // Custom initializer to set the language
    init(language: String) {
        _selectedLanguage = State(initialValue: language)
    }

    var body: some View {
        ZStack {
            // White background
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Top bar with back and language switch (only on category selection)
                if questions.isEmpty && !showResults {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                                    .font(.custom("LexendDeca-Black", size: 16))
                            }
                        }
                        Spacer()
                        Button(action: {
                            // Switch language and reset quiz
                            selectedLanguage = (selectedLanguage == "Java" ? "Python" : "Java")
                            resetQuiz()
                        }) {
                            Text(selectedLanguage == "Java" ? "Python" : "Java")
                                .font(.custom("LexendDeca-Black", size: 16))
                                .foregroundColor(.blue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal)
                }

                // Quiz title
                Text("\(selectedLanguage) Quiz")
                    .font(.custom("LexendDeca-Black", size: 40))
                Spacer()

                // Switch between category selection, quiz, and results
                contentSwitcher
            }
        }
        .onDisappear {
            // Stop timer when view disappears
            timer?.invalidate()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }

    // Switches between results, category selection, and quiz content
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

    // View for selecting quiz categories
    private var categorySelectionView: some View {
        VStack(spacing: 10) {
            Text("Choose Categories")
                .font(.custom("LexendDeca-Black", size: 20))
            // Show available categories or loading indicator
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
            // Show start button if at least one category is selected
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
            // Load categories when view appears
            loadCategories()
        }
    }

    // Button for selecting/deselecting a category
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

    // Main quiz content view (question, options, progress, etc.)
    private var quizContentView: some View {
        VStack(spacing: 20) {
            progressView
                .padding(.horizontal, 16)
            questionView
                .padding(.horizontal, 16)
            optionsView
                .padding(.horizontal, 16)
            if hasAnswered {
                feedbackView
                    .padding(.horizontal, 16)
            }
            Spacer()
            if hasAnswered {
                nextButton
                    .padding(.horizontal, 16)
            }
        }
    }

    // Progress bar and timer display
    private var progressView: some View {
        VStack {
            HStack {
                Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                    .font(.custom("LexendDeca-Black", size: 16))
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
        .padding(.top, 50)
    }

    // Displays the current question
    private var questionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(getCurrentQuestion().questionText)
                .font(.custom("LexendDeca-ExtraBold", size: 18))
                .fontWeight(.medium)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }

    // Displays answer options as buttons
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
                            .font(.custom("LexendDeca-Black", size: 16))
                            .padding(8)
                            .background(Circle().fill(optionCircleColor(for: index)))
                            .foregroundColor(.white)
                        Text(getCurrentQuestion().options[index])
                            .font(.custom("LexendDeca-ExtraBold", size: 16))
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

    // Feedback after answering a question
    private var feedbackView: some View {
        Text(selectedAnswerIndex == getCurrentQuestion().correctAnswerIndex ? "Correct! 🎉" : "Incorrect! The correct answer is \(["A", "B", "C", "D"][getCurrentQuestion().correctAnswerIndex])")
            .font(.custom("LexendDeca-Black", size: 16))
            .foregroundColor(selectedAnswerIndex == getCurrentQuestion().correctAnswerIndex ? .green : .red)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
    }

    // Button to go to the next question or see results
    private var nextButton: some View {
        Button(action: nextQuestion) {
            Text(isLastQuestion ? "See Results" : "Next Question")
                .font(.custom("LexendDeca-Black", size: 16))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding(.horizontal, 16)
    }

    // Results view after finishing the quiz
    private var quizResultsView: some View {
        VStack(spacing: 20) {
            Text("Quiz Complete!")
                .font(.custom("LexendDeca-Black", size: 20))
                .fontWeight(.bold)
                .padding(.top, 20)
            Text("Your score: \(score) / \(questions.count)")
                .font(.custom("LexendDeca-Black", size: 18))
                .padding(.horizontal, 16)
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
            .padding(.horizontal, 16)
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
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .padding(.horizontal, 16)
    }

    // Loads available categories for the selected language
    private func loadCategories() {
        let cats = Quizz.shared.getAvailableCategories(for: selectedLanguage)
        availableCategories = cats
        if let first = cats.first, selectedCategories.isEmpty {
            selectedCategories = [first]
        }
    }

    // Loads questions for the selected language and categories
    private func loadQuestions() {
        let selected = Array(selectedCategories)
        questions = Quizz.shared.getRandomQuestionsForLanguageAndCategories(language: selectedLanguage, categories: selected, count: 10)
        currentQuestionIndex = 0
        selectedAnswerIndex = nil
        score = 0
        hasAnswered = false
        showResults = false
        startTimer()
    }

    // Starts the countdown timer for the current question
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

    // Handles answer selection and scoring
    private func selectAnswer(_ index: Int?) {
        selectedAnswerIndex = index
        hasAnswered = true
        timer?.invalidate()
        if let index = index, index == getCurrentQuestion().correctAnswerIndex {
            score += 1
        }
    }

    // Moves to the next question or shows results
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

    // Resets the quiz to the initial state
    private func resetQuiz() {
        currentQuestionIndex = 0
        selectedAnswerIndex = nil
        score = 0
        hasAnswered = false
        showResults = false
        questions = []
        loadCategories()
    }

    // Returns the current question object
    private func getCurrentQuestion() -> Question {
        questions[currentQuestionIndex]
    }

    // Checks if the current question is the last one
    private var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }

    // Returns the color for the answer option circle
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

    // Returns the background color for the answer option
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

// Preview for SwiftUI canvas
struct QuizzView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QuizzView(language: "Java")
        }
    }
}

