import Foundation

// Model struct representing a single flashcard
struct Flashcard: Identifiable {
    let id = UUID()         // Unique identifier for the flashcard
    let question: String    // The question text
    let answer: String      // The answer text
}

// Model struct representing a group of flashcards (e.g., by category)
struct FlashcardGroup: Identifiable {
    let id = UUID()         // Unique identifier for the group
    let title: String       // Title of the group/category
    var cards: [Flashcard]  // Array of flashcards in this group
}

// ObservableObject class to manage flashcard navigation and shuffling
class FlashcardManager: ObservableObject {
    @Published var cards: [Flashcard]         // All flashcards managed by this instance
    @Published var currentIndex: Int = 0      // Index of the currently displayed card

    // Computed property to get the current flashcard, or nil if out of bounds
    var currentCard: Flashcard? {
        guard !cards.isEmpty, currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }

    // Initializer to set the flashcards
    init(cards: [Flashcard]) {
        self.cards = cards
    }

    // Move to the next card if possible
    func goToNextCard() {
        if currentIndex < cards.count - 1 {
            currentIndex += 1
        }
    }

    // Move to the previous card if possible
    func goToPreviousCard() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }

    // Shuffle the cards and reset to the first card
    func shuffleCards() {
        cards.shuffle()
        currentIndex = 0
    }
}