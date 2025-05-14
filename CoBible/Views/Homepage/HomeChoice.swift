import SwiftUI

// Main view for choosing the programming language (Java or Python)
struct HomeChoice: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header/title
                Text("Choose the language")
                    .font(.custom("LexendDeca-Black", size: 32))
                    .bold()
                    .padding(.top, 40)
                    .padding(.bottom, 20)

                // Language selection cards
                VStack(spacing: 20) {
                    // Java card with navigation
                    NavigationLink(destination: LanguageDetailView(languageName: "Java", imageName: "java-logo")) {
                        LanguageCardView(imageName: "java-logo", languageName: "Java")
                            .foregroundColor(.black)
                    }
                    // Python card with navigation
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
                // Gradient background for the page
                LinearGradient(gradient: Gradient(colors: [Color.white, Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
    }
}

// Card view for displaying a language option (Java or Python)
struct LanguageCardView: View {
    var imageName: String      // Image asset name for the language
    var languageName: String   // Name of the language
    
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

// Preview for SwiftUI canvas
struct HomeChoice_Previews: PreviewProvider {
    static var previews: some View {
        HomeChoice()
    }
}

