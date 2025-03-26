import SwiftUI
import MongoSwift

struct HomeView: View {
    @Environment(\.mongoClient) var mongoClient: MongoClient
    @State private var items: [Item] = []

    var body: some View {
        NavigationView {
            TabView {
                Home1()
                Home2()
                Home3()
                Home4()
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
        .onAppear {
            fetchItems()
        }
    }

    private func fetchItems() {
        Task {
            do {
                let database = mongoClient.db("CoBibleDB")
                let collection = database.collection("items", withType: Item.self)
                let fetchedItems = try await collection.find().toArray()
                DispatchQueue.main.async {
                    self.items = fetchedItems
                }
            } catch {
                print("Failed to fetch items: \(error)")
            }
        }
    }
}

struct Home1: View {
    var body: some View {
        VStack {
            Spacer()
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.opacity(0.2))
                .frame(height: 850)
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Welcome to")
                            .font(.custom("LexendDeca-Black", size: 40))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("CoBible")
                            .font(.custom("LexendDeca-Black", size: 40))
                            
                        
                        Text("Ready to start this new learning adventure.")
                            .font(.custom("LexendDeca-Black", size: 18))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Geometry_Home1()
                            .frame(height: 250)
                        
                        Spacer()
                        
                    }
                    .padding()
                )
                .padding()
            
            Spacer()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct Home2: View {
    var body: some View {
        VStack {
            Spacer()
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.green.opacity(0.2))
                .frame(height: 850)
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Choose your")
                            .font(.custom("LexendDeca-Black", size: 40))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Language")
                            .font(.custom("LexendDeca-Black", size: 40))
                            
                        
                        Text("Choose between Java and Python.")
                            .font(.custom("LexendDeca-Black", size: 18))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Geometry_Home2()
                        
                        Spacer()
                        
                    }
                    .padding()
                )
                .padding()
            
            Spacer()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct Home3: View {
    var body: some View {
        VStack {
            Spacer()
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.yellow.opacity(0.2))
                .frame(height: 850)
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Study thanks to")
                            .font(.custom("LexendDeca-Black", size: 40))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Quizzes &")
                            .font(.custom("LexendDeca-Black", size: 40))
                        
                        Text("Flashcards")
                            .font(.custom("LexendDeca-Black", size: 40))
                            
                        Text("Use the quizzes and Flashcards features that will help you Study for those hard exams.")
                            .font(.custom("LexendDeca-Black", size: 18))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Geometry_Home3()
                        
                        Spacer()
                        
                    }
                    .padding()
                )
                .padding()
            
            Spacer()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct Home4: View {
    var body: some View {
        VStack(spacing: 20) { // Réduit l'espace entre les éléments
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 710)
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ready to ")
                            .font(.custom("LexendDeca-Black", size: 40))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("start this")
                            .font(.custom("LexendDeca-Black", size: 40))
                        
                        Text("journey?")
                            .font(.custom("LexendDeca-Black", size: 40))
                        
                        Spacer()
                        
                        Geometry_Home4()
                    }
                    .padding()
                )
            
            // Rectangle du bas avec le bouton
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 120)
                .overlay(
                    NavigationLink(destination: HomeChoice()) {
                        Text("Let's get this started")
                            .font(.custom("LexendDeca-Black", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                )
        }
        .padding(.horizontal) // Garde un padding sur les côtés
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}



struct Geometry_Home1: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 220, height: 220)
                
            
            Triangle()
                .fill(Color.white.opacity(0.25))
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 240, height: 240)
                .offset(x: 80, y: -110)
                .rotationEffect(Angle(degrees: 78))
                
            
            Triangle()
                .fill(Color.blue.opacity(0.25))
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 100, height: 100)
                .offset(x: -80, y: -110)
                .rotationEffect(Angle(degrees: 90))
        }
    }
}

struct Geometry_Home2: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.1))
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 220, height: 220)
                .offset(x: 150, y: 0)
            
            Circle()
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 220, height: 220)
                .offset(x: 40, y: -20)
            
            Circle()
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 220, height: 220)
                .offset(x: 75, y: 100)
                
        }
    }
}

struct Geometry_Home3: View {
    var body: some View {
        ZStack {
            StarburstShape(points: 8, scale: 0.7)
                .fill(Color.red.opacity(0.3))
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 120, height: 120)
                .offset(x: 25, y: 110)
            
            StarburstShape(points: 8, scale: 0.7)
                .fill(Color.red.opacity(0.2))
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 240, height: 240)
                .offset(x: 25, y: 110)
            
            StarburstShape(points: 8, scale: 0.7)
                .fill(Color.red.opacity(0.1))
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 360, height: 360)
                .offset(x: 25, y: 110)
        }
    }
}

struct Geometry_Home4: View {
    var body: some View {
        ZStack {
            
            StarburstShape(points: 8, scale: 0.7)
                .fill(Color.yellow.opacity(0.1))
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 300, height: 300)
                .offset(x: 0, y: -100)
            
            Circle()
                .fill(Color.green.opacity(0.1))
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 180, height: 180)
                .offset(x: -50, y: 50)
            
            Triangle()
                .fill(Color.blue.opacity(0.25))
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 200, height: 200)
                .offset(x: 40, y: -100)
                .rotationEffect(Angle(degrees: 80))
                
            
        }
    }
}


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

struct StarburstShape: Shape {
    var points: Int
    var scale: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<(points * 2) {
            let angle = Angle(degrees: Double(i) * (360.0 / Double(points * 2)))
            let distance = i.isMultiple(of: 2) ? radius : radius * scale
            let x = center.x + cos(angle.radians) * distance
            let y = center.y + sin(angle.radians) * distance
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width * 0.5, y: 0)) // Sommet haut
        path.addCurve(to: CGPoint(x: width, y: height * 0.5),
                      control1: CGPoint(x: width * 0.8, y: 0),
                      control2: CGPoint(x: width, y: height * 0.2))
        
        path.addCurve(to: CGPoint(x: width * 0.5, y: height),
                      control1: CGPoint(x: width, y: height * 0.8),
                      control2: CGPoint(x: width * 0.8, y: height))
        
        path.addCurve(to: CGPoint(x: 0, y: height * 0.5),
                      control1: CGPoint(x: width * 0.2, y: height),
                      control2: CGPoint(x: 0, y: height * 0.8))
        
        path.addCurve(to: CGPoint(x: width * 0.5, y: 0),
                      control1: CGPoint(x: 0, y: height * 0.2),
                      control2: CGPoint(x: width * 0.2, y: 0))
        
        return path
    }
}



// ✅ Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

