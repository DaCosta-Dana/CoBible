import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 30) {
            // Titre principal
            Text("CoBible")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.top, 100)

            // Sous-titre
            Text("Learn Java & Python")
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 95)

            Spacer()

            // Boutons pour choisir le langage
            NavigationLink(destination: LanguageView(language: "Java")) {
                LanguageButton(label: "Java", color: .gray)
            }

            NavigationLink(destination: LanguageView(language: "Python")) {
                LanguageButton(label: "Python", color: .gray)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }
}

// Composant réutilisable pour les boutons
struct LanguageButton: View {
    let label: String
    let color: Color

    var body: some View {
        Text(label)
            .font(.title2)
            .bold()
            .foregroundColor(.white)
            .frame(width: 200, height: 60)
            .background(color)
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding(.vertical, 10)
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
}

