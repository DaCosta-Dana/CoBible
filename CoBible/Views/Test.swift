import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [Favorite]
    
    let language: String // "Java" ou "Python"

    @State private var newTitle = ""
    @State private var newDetails = ""

    var body: some View {
        VStack {
            Text("Favoris \(language)")
                .font(.largeTitle)
                .bold()
                .padding()

            List {
                ForEach(favorites) { item in
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.headline)
                        Text(item.detail)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .onDelete(perform: deleteFavorite)
            }

            HStack {
                TextField("Titre", text: $newTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Détails", text: $newDetails)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Ajouter") {
                    addFavorite()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("Favoris \(language)")
    }

    private func addFavorite() {
        guard !newTitle.isEmpty, !newDetails.isEmpty else { return }
        let newItem = Favorite(title: newTitle, detail: newDetails)
        modelContext.insert(newItem)
        newTitle = ""
        newDetails = ""
    }

    private func deleteFavorite(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(favorites[index])
        }
    }
}


#Preview {
    FavoritesView(language: "Python")
        .modelContainer(for: Favorite.self, inMemory: true)
}
