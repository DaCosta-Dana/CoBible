import SwiftUI
import SwiftData

struct ShortcutView: View {
    var languageName: String
    @Query var shortcuts: [Shortcut] // Fetch shortcuts from the database
    @Environment(\.presentationMode) var presentationMode // For navigation back

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Page title
                Text("\(languageName) Shortcuts")
                    .font(.custom("LexendDeca-Black", size: 30))
                    .bold()
                    .padding(.top, 20)
                    .padding(.horizontal)

                // Filter and display shortcuts for the selected language
                ForEach(shortcuts.filter { $0.language == languageName }) { shortcut in
                    NavigationLink(destination: ShortcutDetailView(shortcut: shortcut)) {
                        ShortcutCardView(shortcut: shortcut)
                    }
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
                    presentationMode.wrappedValue.dismiss() // Navigate back to LangageDetailView
                }) {
                    HStack {
                        Image(systemName: "house")
                        Text("Home")
                            .font(.custom("LexendDeca-Black", size: 16))
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ShortcutCardView: View {
    var shortcut: Shortcut

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(shortcut.title)
                .font(.custom("LexendDeca-Black", size: 20))
                .bold()
            Text(shortcut.explanation)
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

// ✅ Preview
struct ShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutView(languageName: "Java")
            .modelContainer(for: Shortcut.self) // Provide a model container for preview
    }
}
