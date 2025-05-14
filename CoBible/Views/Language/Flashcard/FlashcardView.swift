import SwiftUI

struct FlashcardView: View {
    var cards: [Flashcard]
    @State private var currentIndex: Int = 0
    @State private var isFlipped: Bool = false
    @GestureState private var dragOffset: CGFloat = 0
    @Environment(\.presentationMode) var presentationMode
    @State private var isCardVisible: Bool = true
    @State private var cardOffset: CGFloat = 0

    var body: some View {
        VStack {
            // Top bar with back button
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .font(.custom("LexendDeca-Black", size: 16))
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)

            if cards.isEmpty {
                // Show message if there are no flashcards
                Text("No flashcards available")
                    .font(.custom("LexendDeca-Regular", size: 20))
                    .foregroundColor(.gray)
            } else {
                ZStack {
                    // Show only the current card with animation
                    if isCardVisible {
                        FlashcardContentView(card: cards[currentIndex], isFlipped: $isFlipped)
                            .id(currentIndex)
                            .offset(x: cardOffset + dragOffset)
                            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: cardOffset)
                            .gesture(
                                DragGesture()
                                    .updating($dragOffset, body: { value, state, _ in
                                        // Track drag offset for swipe gesture
                                        state = value.translation.width
                                    })
                                    .onEnded { value in
                                        // Handle swipe left (next card)
                                        if value.translation.width < -100 && currentIndex < cards.count - 1 {
                                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                                cardOffset = -UIScreen.main.bounds.width
                                            }
                                            isFlipped = false
                                            // After animation, update card index and reset state
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
                                                cardOffset = 0
                                                currentIndex += 1
                                                isCardVisible = false
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                                    isCardVisible = true
                                                }
                                            }
                                        }
                                        // Handle swipe right (previous card)
                                        else if value.translation.width > 100 && currentIndex > 0 {
                                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                                cardOffset = UIScreen.main.bounds.width
                                            }
                                            isFlipped = false
                                            // After animation, update card index and reset state
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
                                                cardOffset = 0
                                                currentIndex -= 1
                                                isCardVisible = false
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                                    isCardVisible = true
                                                }
                                            }
                                        }
                                    }
                            )
                    }
                }
                // Card index display
                Text("< \(currentIndex + 1) of \(cards.count) >")
                    .font(.custom("LexendDeca-Regular", size: 16))
                    .foregroundColor(.gray)
                    .padding(.top, 16)
            }
        }
        .padding()
        .background(
            // Gradient background
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }

    // Animate to next card
    private func goToNextCard() {
        if currentIndex < cards.count - 1 {
            isFlipped = false
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                cardOffset = -UIScreen.main.bounds.width
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
                cardOffset = 0
                currentIndex += 1
                isCardVisible = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    isCardVisible = true
                }
            }
        }
    }

    // Animate to previous card
    private func goToPreviousCard() {
        if currentIndex > 0 {
            isFlipped = false
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                cardOffset = UIScreen.main.bounds.width
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
                cardOffset = 0
                currentIndex -= 1
                isCardVisible = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    isCardVisible = true
                }
            }
        }
    }
}

// View for the content of a single flashcard
struct FlashcardContentView: View {
    var card: Flashcard
    @Binding var isFlipped: Bool

    var body: some View {
        ZStack {
            // Front side (question)
            Group {
                if !isFlipped {
                    Text(card.question)
                        .font(.custom("LexendDeca-Regular", size: 20))
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.blue.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 5)
                }
            }
            .opacity(isFlipped ? 0 : 1)
            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

            // Back side (answer)
            Group {
                if isFlipped {
                    Text(card.answer)
                        .font(.custom("LexendDeca-Regular", size: 20))
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.orange.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 5)
                }
            }
            .opacity(isFlipped ? 1 : 0)
            .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        // Tap to flip the card
        .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isFlipped.toggle()
            }
        }
    }
}

// Preview for SwiftUI canvas
struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardView(cards: [
            Flashcard(question: "What is a class in Java?", answer: "A class is a blueprint for creating objects."),
            Flashcard(question: "What is a list in Python?", answer: "A list is a collection of items that is ordered and mutable.")
        ])
    }
}
