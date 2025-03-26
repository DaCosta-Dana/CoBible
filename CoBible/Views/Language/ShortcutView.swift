import SwiftUI
import MongoSwift

struct ShortcutView: View {
    var languageName: String
    @Environment(\.mongoClient) var mongoClient: MongoClient
    @State private var shortcuts: [Shortcut] = []
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Titre de la page
                Text("\(languageName) Shortcuts")
                    .font(.custom("LexendDeca-Black", size: 30))
                    .bold()
                    .padding(.top, 20)
                    .padding(.horizontal)

                // Liste des raccourcis
                ForEach(shortcuts) { shortcut in
                    ShortcutCardView(shortcut: shortcut)
                }
            }
            .padding(.horizontal)
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .font(.custom("LexendDeca-Black", size: 16))
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchShortcuts()
        }
    }

    private func fetchShortcuts() {
        Task {
            do {
                let database = mongoClient.db("JavaShortcuts")
                let collection = database.collection("JavaSC", withType: Shortcut.self)
                let fetchedShortcuts = try await collection.find().toArray()
                DispatchQueue.main.async {
                    self.shortcuts = fetchedShortcuts
                }
            } catch {
                print("Failed to fetch shortcuts: \(error)")
            }
        }
    }
}

struct ShortcutCardView: View {
    var shortcut: Shortcut

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Shortcut \(shortcut.no): \(shortcut.whatItDoes)")
                .font(.custom("LexendDeca-Black", size: 20))
                .bold()
            Text("How to do it: \(shortcut.howToDoIt)")
                .font(.custom("LexendDeca-Regular", size: 16))
                .foregroundColor(.gray)
            Text("Explanation: \(shortcut.explanation)")
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

struct Shortcut: Identifiable, Codable {
    let id: BSONObjectID
    let no: Int
    let whatItDoes: String
    let howToDoIt: String
    let explanation: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case no = "No"
        case whatItDoes = "What it does"
        case howToDoIt = "How to do it?"
        case explanation = "Explanation"
    }
}

// Removed the ShortcutView_Previews struct since data is fetched dynamically.
