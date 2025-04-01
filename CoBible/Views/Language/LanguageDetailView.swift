import SwiftUI

struct LanguageDetailView: View {
    var languageName: String
    var imageName: String

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Titre de la page
                Text(languageName)
                    .font(.custom("LexendDeca-Black", size: 40))
                    .bold()
                    .padding(.top, 20)
                
                // Image du langage
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding()

                // Options (Shortcuts, Quizzes, Flashcards)
                VStack(spacing: 20) {
                    // Navigation vers ShortcutView
                    NavigationLink(
                        destination: ShortcutView(
                            languageName: languageName
                            //shortcuts: getShortcuts(for: languageName)
                        )
                    ) {
                        OptionCardView(optionName: "Shortcuts", iconName: "bolt.fill", color: .blue)
                            .foregroundColor(.black)
                    }

                    // Placeholder for other options
                    OptionCardView(optionName: "Quizzes", iconName: "questionmark.circle.fill", color: .green)
                    OptionCardView(optionName: "Flashcards", iconName: "rectangle.stack.fill", color: .orange)
                }
                .padding(.horizontal)

                Spacer()
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.white, Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: HomeChoice()) {
                        HStack {
                            Image(systemName: "house.fill")
                            Text("Home")
                                .font(.custom("LexendDeca-Black", size: 16))
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: LanguageDetailView(
                            languageName: languageName == "Java" ? "Python" : "Java",
                            imageName: languageName == "Java" ? "python-logo" : "java-logo"
                        )
                    ) {
                        Text(languageName == "Java" ? "Python" : "Java")
                            .font(.custom("LexendDeca-Black", size: 16))
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline) // Optionnel : titre compact ou aucun titre
    }
}


struct OptionCardView: View {
    var optionName: String
    var iconName: String
    var color: Color

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

// ✅ Preview
struct LanguageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageDetailView(languageName: "Java", imageName: "java-logo")
    }
}
