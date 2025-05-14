import SwiftUI

// Main home view with onboarding pages (swipeable)
struct HomeView: View {
    var body: some View {
        NavigationView {
            TabView {
                Home1() // First onboarding page
                Home2() // Second onboarding page
                Home3() // Third onboarding page
                Home4() // Final onboarding page with start button
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
    }
}

// First onboarding page: Welcome message and illustration
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

// Second onboarding page: Language selection info and illustration
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

// Third onboarding page: Quizzes and flashcards info and illustration
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

// Fourth onboarding page: Final message and start button
struct Home4: View {
    var body: some View {
        VStack(spacing: 20) {
            // Top rounded rectangle with message and illustration
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
            // Bottom rounded rectangle with navigation button to HomeChoice
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
        .padding(.horizontal)
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

// Custom geometric illustration for Home1
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

// Custom geometric illustration for Home2
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

// Custom geometric illustration for Home3
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

// Custom geometric illustration for Home4
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

// Shape for drawing a triangle
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

// Shape for drawing a starburst (spiky star)
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

// Preview for SwiftUI canvas
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

