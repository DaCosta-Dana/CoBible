import SwiftUI

struct FlashcardMenuView: View {
    @State private var selectedLanguage: String // Now @State for dynamic switching
    @State private var flashcardGroups: [FlashcardGroup] = []
    @Environment(\.presentationMode) var presentationMode

    init(selectedLanguage: String) {
        _selectedLanguage = State(initialValue: selectedLanguage)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Top bar with Home and Language switch
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Home")
                            .font(.custom("LexendDeca-Black", size: 16))
                    }
                }
                Spacer()
                Button(action: {
                    selectedLanguage = (selectedLanguage == "Java" ? "Python" : "Java")
                    loadFlashcardGroups()
                }) {
                    Text(selectedLanguage == "Java" ? "Python" : "Java")
                        .font(.custom("LexendDeca-Black", size: 16))
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)

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
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }

    // Helper function to parse a CSV row with quoted fields
    private func parseCSVRow(_ row: String) -> [String] {
        var result: [String] = []
        var value = ""
        var insideQuotes = false
        var iterator = row.makeIterator()
        while let char = iterator.next() {
            if char == "\"" {
                insideQuotes.toggle()
            } else if char == "," && !insideQuotes {
                result.append(value)
                value = ""
            } else {
                value.append(char)
            }
        }
        result.append(value)
        return result
    }

    // Load flashcard groups from a CSV file in the Resources folder
    private func loadFlashcardGroups() {
        guard let csvPath = Bundle.main.path(forResource: "flashcards", ofType: "csv"),
              let csvContent = try? String(contentsOfFile: csvPath, encoding: .utf8) else {
            print("Failed to load flashcards.csv")
            return
        }

        var groups: [String: FlashcardGroup] = [:]
        let rows = csvContent.split(separator: "\n")

        for row in rows.dropFirst() { // Skip the header row
            let columns = parseCSVRow(String(row))
            guard columns.count >= 5 else { continue } // Ensure valid row format

            let language = columns[1].trimmingCharacters(in: .whitespaces)
            guard language == selectedLanguage else { continue } // Filter by selected language

            let groupName = columns[4].trimmingCharacters(in: .whitespaces)
            let question = columns[2].trimmingCharacters(in: .whitespaces)
            let answer = columns[3].trimmingCharacters(in: .whitespaces)

            if groups[groupName] == nil {
                groups[groupName] = FlashcardGroup(title: groupName, cards: [])
            }

            groups[groupName]?.cards.append(Flashcard(question: question, answer: answer))
        }

        flashcardGroups = Array(groups.values)
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

struct FlashcardMenuView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardMenuView(selectedLanguage: "Java") // Use a valid language for preview
    }
}
