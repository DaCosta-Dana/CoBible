import SwiftUI
import SwiftData

struct ShortcutView: View {
    var languageName: String
    @Query var shortcuts: [Shortcut]
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText: String = ""
    @State private var currentLanguage: String

    init(languageName: String) {
        self.languageName = languageName
        _currentLanguage = State(initialValue: languageName)
    }

    var filteredShortcuts: [Shortcut] {
        if searchText.isEmpty {
            return shortcuts.filter { $0.language == currentLanguage }
        } else {
            return shortcuts.filter { $0.language == currentLanguage && $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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
                    currentLanguage = (currentLanguage == "Java" ? "Python" : "Java")
                }) {
                    Text(currentLanguage == "Java" ? "Python" : "Java")
                        .font(.custom("LexendDeca-Black", size: 16))
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Text("\(currentLanguage) Shortcuts")
                .font(.custom("LexendDeca-Black", size: 30))
                .bold()
                .padding(.top, 20)
                .padding(.horizontal)

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search shortcuts...", text: $searchText)
                    .font(.custom("LexendDeca-Black", size: 16))
            }
            .padding(10)
            .background(Color(UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal)

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(filteredShortcuts) { shortcut in
                        NavigationLink(destination: ShortcutDetailView(shortcutTitle: shortcut.title, selectedLanguage: currentLanguage)) {
                            ShortcutCardView(shortcut: shortcut)
                        }
                    }
                }
                .padding(.horizontal)
            }
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .navigationBarHidden(true)
    }
}

struct ShortcutCardView: View {
    var shortcut: Shortcut

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(shortcut.title)
                .font(.custom("LexendDeca-Black", size: 20))
                .bold()
                .foregroundColor(.black)
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

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct ShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutView(languageName: "Java")
            .modelContainer(for: Shortcut.self)
    }
}
