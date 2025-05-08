import SwiftUI

struct HomeChoice: View {
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Choose the language")
                .font(.custom("LexendDeca-Black", size: 32))
                .bold()
                .padding(.top, 40)
                .padding(.bottom, 20)

            // Language cards
            VStack(spacing: 20) {
                NavigationLink(destination: LanguageDetailView(languageName: "Java", imageName: "java-logo")) {
                    LanguageCardView(imageName: "java-logo", languageName: "Java")
                        .foregroundColor(.black)
                }
                NavigationLink(destination: LanguageDetailView(languageName: "Python", imageName: "python-logo")) {
                    LanguageCardView(imageName: "python-logo", languageName: "Python")
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.horizontal)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

struct LanguageCardView: View {
    var imageName: String
    var languageName: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            Text(languageName)
                .font(.custom("LexendDeca-Black", size: 30))
        }
        .frame(maxWidth: .infinity, minHeight: 250)
        .background(Color.yellow.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(radius: 5)
    }
}

struct HomeChoice_Previews: PreviewProvider {
    static var previews: some View {
        HomeChoice()
    }
}

