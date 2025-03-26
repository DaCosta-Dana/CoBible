import SwiftUI
import MongoSwift

struct HomeChoice: View {
    @Environment(\.mongoClient) var mongoClient: MongoClient

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Home")
                    .font(.custom("LexendDeca-Black", size: 40))
                    .bold()
                    .padding(.top, 20)
                
                
                HStack {
                    Image(systemName: "briefcase.fill")
                        .foregroundColor(.pink)
                    VStack(alignment: .leading) {
                        Text("Programming Language")
                            .font(.custom("LexendDeca-Black", size: 12))
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Choose Language")
                            .font(.custom("LexendDeca-Black", size: 18))
                            .font(.headline)
                            .bold()
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 3)
                .padding(.horizontal)
                
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
                
                Button("Add Item") {
                    addItem()
                }
                
                Spacer()
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.white, Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .navigationBarBackButtonHidden(true)
    }

    private func addItem() {
        Task {
            do {
                let database = mongoClient.db("CoBibleDB")
                let collection = database.collection("items", withType: Item.self)
                let newItem = Item(timestamp: Date())
                try await collection.insertOne(newItem)
                print("Item added successfully")
            } catch {
                print("Failed to add item: \(error)")
            }
        }
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

