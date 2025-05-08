import Foundation

struct Flashcard: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct FlashcardGroup: Identifiable {
    let id = UUID()
    let title: String
    var cards: [Flashcard]
}

class FlashcardManager: ObservableObject {
    @Published var cards: [Flashcard]
    @Published var currentIndex: Int = 0

    var currentCard: Flashcard? {
        guard !cards.isEmpty, currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }

    init(cards: [Flashcard]) {
        self.cards = cards
    }

    func goToNextCard() {
        if currentIndex < cards.count - 1 {
            currentIndex += 1
        }
    }

    func goToPreviousCard() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }

    func shuffleCards() {
        cards.shuffle()
        currentIndex = 0
    }
}