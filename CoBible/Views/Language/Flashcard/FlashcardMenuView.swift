import SwiftUI

struct FlashcardMenuView: View {
    @State private var flashcardGroups: [FlashcardGroup] = []

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                Text("Flashcards")
                    .font(.custom("LexendDeca-Black", size: 30))
                    .bold()
                    .padding(.top, 20)
                    .padding(.horizontal)

                // Flashcard groups
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(flashcardGroups, id: \.id) { group in
                            NavigationLink(destination: FlashcardView(cards: group.cards)) {
                                FlashcardGroupCardView(group: group)
                            }
                        }
                    .padding(.horizontal)
                    }
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.white, Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                )
                .onAppear {
                    loadFlashcardGroups()
                }
            }
        }

    // Load flashcard groups from a CSV file in the Resources folder
    private func loadFlashcardGroups() {
        guard let csvPath = Bundle.main.path(forResource: "flashcards", ofType: "csv"),
        let csvContent = try? String(contentsOfFile: csvPath, encoding: .utf8) else {
            print("Failed to load flashcards.csv")
            return
        }

        var groups: [FlashcardGroup] = []
        var currentGroup: FlashcardGroup?

        let rows = csvContent.split(separator: "\n")
        for row in rows {
            let columns = row.split(separator: ",")
            guard columns.count >= 3 else { continue } // Ensure valid row format

            let groupName = String(columns[0].trimmingCharacters(in: .whitespaces))
            let question = String(columns[1].trimmingCharacters(in: .whitespaces))
            let answer = String(columns[2].trimmingCharacters(in: .whitespaces))

            if currentGroup == nil || currentGroup?.title != groupName {
                if let group = currentGroup {
                    groups.append(group)
                }
                currentGroup = FlashcardGroup(id: UUID(), title: groupName, cards: [])
            }

            currentGroup?.cards.append(Flashcard(question: question, answer: answer))
        }

        if let group = currentGroup {
            groups.append(group)
        }

        flashcardGroups = groups
    }
}

struct FlashcardGroupCardView: View {
    var group: FlashcardGroup

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(group.title)
                .font(.custom("LexendDeca-Black", size: 20))
                .bold()
            Text("\(group.cards.count) cards")
                .font(.custom("LexendDeca-Regular", size: 16))
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 5)
    }
}

// Flashcard group model
struct FlashcardGroup: Identifiable {
    var id: UUID
    var title: String
    var cards: [Flashcard]
}

// Flashcard model
struct Flashcard {
    var question: String
    var answer: String
}

struct FlashcardMenuView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardMenuView()
    }
}