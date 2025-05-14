import SwiftUI

// Main view for displaying details and options for a selected programming language
struct LanguageDetailView: View {
    var languageName: String   // Name of the language (Java or Python)
    var imageName: String      // Image asset name for the language

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Page title
                Text(languageName)
                    .font(.custom("LexendDeca-Black", size: 40))
                    .bold()
                    .padding(.top, 20)
                
                // Language logo/image
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding()

                // Options for Shortcuts, Quizzes, and Flashcards
                VStack(spacing: 20) {
                    // Navigation to ShortcutView
                    NavigationLink(
                        destination: ShortcutView(
                            languageName: languageName
                        )
                    ) {
                        OptionCardView(optionName: "Shortcuts", iconName: "bolt.fill", color: .blue)
                            .foregroundColor(.black)
                    }

                    // Navigation to QuizzView
                    NavigationLink(
                        destination: QuizzView(language: languageName)
                    ) {
                        OptionCardView(optionName: "Quizzes", iconName: "questionmark.circle.fill", color: .green)
                            .foregroundColor(.black)
                    }

                    // Navigation to FlashcardMenuView
                    NavigationLink(
                        destination: FlashcardMenuView(selectedLanguage: languageName)
                    ) {
                        OptionCardView(optionName: "Flashcards", iconName: "rectangle.stack.fill", color: .orange)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .background(
                // Gradient background for the page
                LinearGradient(gradient: Gradient(colors: [Color.white, Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
            .toolbar {
                // Toolbar with a language switch button (top right)
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: LanguageDetailView(
                            languageName: languageName == "Java" ? "Python" : "Java",
                            imageName: languageName == "Java" ? "python-logo" : "java-logo"
                        )
                    ) {
                        Text(languageName == "Java" ? "Python" : "Java")
                            .font(.custom("LexendDeca-Black", size: 16))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 3)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline) // Compact or no title in navigation bar
    }
}

// Card view for displaying an option (Shortcuts, Quizzes, Flashcards)
struct OptionCardView: View {
    var optionName: String // Name of the option
    var iconName: String   // SF Symbol icon name
    var color: Color       // Icon color

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(color)
                .font(.system(size: 40))
                .padding()
            Text(optionName)
                .font(.custom("LexendDeca-Black", size: 20))
                .bold()
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
    }
}

// Preview for SwiftUI canvas
struct LanguageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageDetailView(languageName: "Java", imageName: "java-logo")
    }
}
