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

                // List of shortcuts
                ForEach(shortcuts) { shortcut in
                    ShortcutCardView(shortcut: shortcut)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 70) // Add padding at the bottom to give space for the navigation bar
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .overlay(
            VStack {
                Spacer()
                HStack(spacing: 100) {
                    NavigationLink(destination: LanguageDetailView(
                        languageName: languageName == "Java" ? "Python" : "Java",
                        imageName: languageName == "Java" ? "python-logo" : "java-logo"
                    )) {
                        VStack {
                            Image(systemName: "house.fill")
                                .font(.system(size: 24))
                            Text("Home")
                                .font(.custom("LexendDeca-Regular", size: 12))
                        }
                    }

                    NavigationLink(destination: Text("Profile View").font(.largeTitle)) {
                        VStack {
                            Image(systemName: "person.fill")
                                .font(.system(size: 24))
                                
                            Text("Profile")
                                .font(.custom("LexendDeca-Regular", size: 12))
                        }
                    }

                    NavigationLink(destination: HomeChoice()) {
                        VStack {
                            Image(systemName: "globe")
                                .font(.system(size: 24))
                            Text("Language")
                                .font(.custom("LexendDeca-Regular", size: 12))
                        }
                    }
                }
                .padding(.vertical, 25)
                .frame(maxWidth: .infinity)
                .background(BlurView(style: .systemThinMaterial)) // Effet de flou
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, -100)
                .shadow(radius: 7)
                //.padding(.bottom, 1)
            }
            .edgesIgnoringSafeArea(.bottom),
            alignment: .bottom
        )

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
            .modelContainer(for: Shortcut.self) // Provide a model container for preview
    }
}
