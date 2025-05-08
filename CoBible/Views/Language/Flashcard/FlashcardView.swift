import SwiftUI

struct FlashcardView: View {
    var cards: [Flashcard]
    @State private var currentIndex: Int = 0
    @State private var isFlipped: Bool = false
    @GestureState private var dragOffset: CGFloat = 0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
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
                Text("No flashcards available")
                    .font(.custom("LexendDeca-Regular", size: 20))
                    .foregroundColor(.gray)
            } else {
                ZStack {
                    ForEach(cards.indices, id: \.self) { index in
                        if index == currentIndex {
                            FlashcardContentView(card: cards[index], isFlipped: $isFlipped)
                                .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .trailing)))
                                .offset(x: dragOffset)
                                .gesture(
                                    DragGesture()
                                        .updating($dragOffset, body: { value, state, _ in
                                            state = value.translation.width
                                        })
                                        .onEnded { value in
                                            if value.translation.width < -100 {
                                                goToNextCard()
                                            } else if value.translation.width > 100 {
                                                goToPreviousCard()
                                            }
                                        }
                                )
                        }
                    }
                }
                .animation(.spring(), value: currentIndex)
                // Card index display
                Text("< \(currentIndex + 1) of \(cards.count) >")
                    .font(.custom("LexendDeca-Regular", size: 16))
                    .foregroundColor(.gray)
                    .padding(.top, 16)
            }
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }

    private func goToNextCard() {
        if currentIndex < cards.count - 1 {
            currentIndex += 1
            isFlipped = false
        }
    }

    private func goToPreviousCard() {
        if currentIndex > 0 {
            currentIndex -= 1
            isFlipped = false
        }
    }
}

struct FlashcardContentView: View {
    var card: Flashcard
    @Binding var isFlipped: Bool

    var body: some View {
        ZStack {
            if isFlipped {
                Text(card.answer)
                    .font(.custom("LexendDeca-Regular", size: 20))
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.orange.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 5)
            } else {
                Text(card.question)
                    .font(.custom("LexendDeca-Regular", size: 20))
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 5)
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut) {
                isFlipped.toggle()
            }
        }
    }
}

// Preview
struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardView(cards: [
            Flashcard(question: "What is a class in Java?", answer: "A class is a blueprint for creating objects."),
            Flashcard(question: "What is a list in Python?", answer: "A list is a collection of items that is ordered and mutable.")
        ])
    }
}