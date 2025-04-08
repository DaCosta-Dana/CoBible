import SwiftUI
import SwiftData

struct ShortcutDetailView: View {
    var shortcutTitle: String
    var languageName: String
    var selectedLanguage: String // Pass the selected language
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var context

    @State private var shortcut: Shortcut?

    var body: some View {
        ScrollView {
            if let shortcut = shortcut {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    Text(shortcut.title)
                        .font(.custom("LexendDeca-Black", size: 30))
                        .bold()
                        .padding(.top, 20)
                        .padding(.horizontal)

                    // Description
                    Text(shortcut.explanation)
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                    // How to do it (in a box)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("How to code it in \(selectedLanguage)?")
                            .font(.custom("LexendDeca-Black", size: 20))
                            .bold()
                            .padding(.bottom, 5)

                        Text(selectedLanguage == "Java" ? shortcut.javaCode : shortcut.pythonCode)
                            .font(.custom("LexendDeca-Regular", size: 16))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            } else {
                // Loading or error state
                Text("Loading...")
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .foregroundColor(.gray)
                    .padding(.top, 50)
            }
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
                .padding(.horizontal, 100)
                .padding(.vertical, -10)
                .frame(maxWidth: .infinity)
                .background(BlurView(style: .systemThinMaterial)) // Effet de flou
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 7)
                //.padding(.bottom, 1)
            }
            .edgesIgnoringSafeArea(.bottom),
            alignment: .bottom
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            shortcut = ShortcutDataManager.fetchShortcutByTitle(title: shortcutTitle, context: context)
        }
    }
}

// Extension to find navigation controller
extension UIViewController {
    func findNavigationController() -> UINavigationController? {
        if let nav = self as? UINavigationController {
            return nav
        }
        
        for child in children {
            if let nav = child.findNavigationController() {
                return nav
            }
        }
        
        return nil
    }
}

// ✅ Preview
struct ShortcutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutDetailView(shortcutTitle: "Print", languageName: "Java", selectedLanguage: "Java")
            .modelContainer(for: Shortcut.self)
    }
}
