import SwiftUI

struct Home1: View {
    @State private var navigateToHomeView = false // État pour gérer la navigation

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue.opacity(0.2))
                    .frame(height: 750)
                    .overlay(
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Welcome to")
                                .font(.largeTitle)
                                .bold()
                            
                            Text("CoBible")
                                .font(.largeTitle)
                                .bold()
                            
                            Text("Ready to start this new learning adventure.")
                                .font(.body)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            GeometryView() // ✅ Ajout de GeometryView
                                .frame(height: 250)
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    navigateToHomeView = true // Déclenche la navigation
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
            .navigationDestination(isPresented: $navigateToHomeView) {
                HomeView()
            }
        }
    }
}

// ✅ Ajout de GeometryView et Triangle
struct GeometryView: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 270, height: 270)
                .offset(x: 40, y: -30)
            
            Triangle()
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 280, height: 280)
                .offset(x: 50, y: -30)
            
            Triangle()
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 100, height: 100)
                .offset(x: -50, y: -30)
        }
    }
}

// Forme de triangle personnalisée
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}


struct PageIndicator: View {
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<4) { index in
                Circle()
                    .fill(index == 0 ? Color.black : Color.gray.opacity(0.5))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.top)
    }
}



struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        Home1()
    }
}
