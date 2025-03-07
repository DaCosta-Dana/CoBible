import SwiftUI

struct Home2: View {
    @State private var navigateToHome1View = false // État pour gérer la navigation vers Home1
    @State private var navigateToHome3View = false // État pour gérer la navigation vers Home3

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.green.opacity(0.2))
                    .frame(height: 750)
                    .overlay(
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Choose your language")
                                .font(.largeTitle)
                                .bold()
                            
                            Text("Chose between Java and Python. More Languages are coming soon.")
                                .font(.body)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            GeometryView1()
                                .frame(height: 250)
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    navigateToHome1View = true // Déclenche la navigation vers Home1
                                }) {
                                    Image(systemName: "arrow.left")
                                        .font(.title)
                                        .padding()
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .shadow(radius: 2)
                                        .foregroundColor(.black)
                                }
                                
                                Button(action: {
                                    navigateToHome3View = true // Déclenche la navigation vers Home3
                                }) {
                                    Image(systemName: "arrow.right")
                                        .font(.title)
                                        .padding()
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .shadow(radius: 2)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.horizontal)
                            
                            PageIndicator()
                        }
                        .padding()
                    )
                    .padding()
                
                Spacer()
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .navigationDestination(isPresented: $navigateToHome1View) {
                Home1() // Navigue vers Home1
            }
            .navigationDestination(isPresented: $navigateToHome3View) {
                HomeView() // Navigue vers Home3
            }
            .navigationBarBackButtonHidden(true) // Cache le bouton "back"
        }
    }
}

// ✅ Ajout de GeometryView et Triangle
struct GeometryView1: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 150, height: 150)
                .offset(x: 180, y: 60)
            
            Circle()
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 150, height: 150)
                .offset(x: 90, y: 60)
            
            Circle()
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 150, height: 150)
                .offset(x: 135, y: 140)
        }
    }
}

struct Home_Preview2: PreviewProvider {
    static var previews: some View {
        Home2()
    }
}
