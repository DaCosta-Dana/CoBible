import SwiftUI
import SwiftData

// Main view for displaying programming shortcuts for a selected language
struct ShortcutView: View {
    var languageName: String // The initial language (Java or Python)
    @Query var shortcuts: [Shortcut] // All shortcuts from the database
    @Environment(\.presentationMode) var presentationMode // For dismissing the view
    @State private var searchText: String = "" // Search bar text
    @State private var currentLanguage: String // The language currently displayed

    // Custom initializer to set the initial language
    init(languageName: String) {
        self.languageName = languageName
        _currentLanguage = State(initialValue: languageName)
    }

    // Filter shortcuts based on search text
    var filteredShortcuts: [Shortcut] {
        if searchText.isEmpty {
            return shortcuts
        } else {
            return shortcuts.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Top bar with back button and language switch
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
                    // Switch between Java and Python
                    currentLanguage = (currentLanguage == "Java" ? "Python" : "Java")
                }) {
                    Text(currentLanguage == "Java" ? "Python" : "Java")
                        .font(.custom("LexendDeca-Black", size: 16))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                }
            }
            .padding(.horizontal)
            
            // Title for the shortcuts section
            Text("\(currentLanguage) Shortcuts")
                .font(.custom("LexendDeca-Black", size: 40))
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Search bar for filtering shortcuts
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

            // List of shortcut cards
            ScrollView {
                VStack(spacing: 20) {
                    Spacer().frame(height: 1)
                    ForEach(filteredShortcuts) { shortcut in
                        // Navigate to detail view on tap
                        NavigationLink(destination: ShortcutDetailView(shortcutTitle: shortcut.title, selectedLanguage: currentLanguage)) {
                            ShortcutCardView(shortcut: shortcut)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(
            // Gradient background
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .navigationBarHidden(true)
    }
}

// Card view for displaying a single shortcut summary
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

// Utility view for adding a blur effect (not used in this file)
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// Preview for SwiftUI canvas
struct ShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutView(languageName: "Java")
            .modelContainer(for: Shortcut.self)
    }
}
