import SwiftUI

struct FlashcardMenuView: View {
    // State for selected language (Java/Python)
    @State private var selectedLanguage: String
    // All flashcard groups for the selected language
    @State private var flashcardGroups: [FlashcardGroup] = []
    // Set of selected category titles
    @State private var selectedCategories: Set<String> = []
    // Controls navigation to FlashcardView
    @State private var showFlashcards = false
    // Cards to show in FlashcardView
    @State private var cardsToShow: [Flashcard] = []
    @Environment(\.presentationMode) var presentationMode

    // Custom initializer to set the language
    init(selectedLanguage: String) {
        _selectedLanguage = State(initialValue: selectedLanguage)
    }

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Top bar with back and language switch buttons
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
                        // Switch language and reload groups
                        selectedLanguage = (selectedLanguage == "Java" ? "Python" : "Java")
                        loadFlashcardGroups()
                        selectedCategories = []
                    }) {
                        Text(selectedLanguage == "Java" ? "Python" : "Java")
                            .font(.custom("LexendDeca-Black", size: 16))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal)
               
                // Title for the flashcard section
                Text("\(selectedLanguage) Flashcards")
                    .font(.custom("LexendDeca-Black", size: 40))
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                // Category selection area
                VStack(spacing: 10) {
                    Text("Choose Categories")
                        .font(.custom("LexendDeca-Black", size: 20))
                    // If groups are loaded, show them
                    if !flashcardGroups.isEmpty {
                        ScrollView {
                            VStack(spacing: 20) {
                                Spacer().frame(height: 1)
                                ForEach(flashcardGroups, id: \.id) { group in
                                    categoryButton(for: group)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 10)
                        }
                        .padding(.bottom, 10)
                    } else {
                        // Show loading indicator if groups are not loaded yet
                        ProgressView("Loading categories...")
                            .padding(.top, 20)
                    }
                    // Button to start flashcards with selected categories
                    Button(action: {
                        // Gather all cards from selected categories
                        let selectedGroups = flashcardGroups.filter { selectedCategories.contains($0.title) }
                        cardsToShow = selectedGroups.flatMap { $0.cards }
                        showFlashcards = true
                    }) {
                        Text("Start Flashcards")
                            .font(.custom("LexendDeca-Black", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedCategories.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(12)
                            .shadow(radius: 3)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    .disabled(selectedCategories.isEmpty)
                    Spacer()
                }
                .padding(.top, 10)
            }

            // NavigationLink to FlashcardView, triggered by showFlashcards
            NavigationLink(
                destination: FlashcardView(cards: cardsToShow),
                isActive: $showFlashcards
            ) { EmptyView() }
        }
        .onAppear {
            // Load flashcard groups when view appears
            loadFlashcardGroups()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }

    // Button for selecting/deselecting a category
    private func categoryButton(for group: FlashcardGroup) -> some View {
        Button(action: {
            if selectedCategories.contains(group.title) {
                selectedCategories.remove(group.title)
            } else {
                selectedCategories.insert(group.title)
            }
        }) {
            HStack {
                Image(systemName: selectedCategories.contains(group.title) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(selectedCategories.contains(group.title) ? .green : .gray)
                    .font(.system(size: 24))
                VStack(alignment: .leading, spacing: 6) {
                    Text(group.title)
                        .font(.custom("LexendDeca-Black", size: 18))
                        .bold()
                    Text("\(group.cards.count) cards")
                        .font(.custom("LexendDeca-Regular", size: 15))
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(selectedCategories.contains(group.title) ? Color.blue.opacity(0.15) : Color(UIColor.white))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selectedCategories.contains(group.title) ? Color.blue : Color.gray.opacity(0.2), lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)
            .padding(.vertical, 2)
        }
        .buttonStyle(.plain)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 0)
    }

    // Helper to parse a CSV row, handling quoted commas
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

    // Loads flashcard groups from the CSV file for the selected language
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
        // Auto-select first category if none selected
        if let first = flashcardGroups.first, selectedCategories.isEmpty {
            selectedCategories = [first.title]
        }
    }
}

// Preview for SwiftUI canvas
struct FlashcardMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FlashcardMenuView(selectedLanguage: "Java")
        }
    }
}
