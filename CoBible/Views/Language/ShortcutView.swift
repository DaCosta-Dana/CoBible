import SwiftUI

struct ShortcutView: View {
    var languageName: String
    var shortcuts: [Shortcut]
    @Environment(\.presentationMode) var presentationMode // Pour gérer le retour en arrière

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Titre de la page
                Text("\(languageName) Shortcuts")
                    .font(.custom("LexendDeca-Black", size: 30))
                    .bold()
                    .padding(.top, 20)
                    .padding(.horizontal)

                // Liste des raccourcis
                ForEach(shortcuts) { shortcut in
                    ShortcutCardView(shortcut: shortcut)
                }
            }
            .padding(.horizontal)
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Retour à la vue précédente
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .font(.custom("LexendDeca-Black", size: 16))
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ShortcutCardView: View {
    var shortcut: Shortcut

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(shortcut.title)
                .font(.custom("LexendDeca-Black", size: 20))
                .bold()
            Text(shortcut.description)
                .font(.custom("LexendDeca-Regular", size: 16))
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 5)
    }
}

struct Shortcut: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

// ✅ Preview
struct ShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutView(
            languageName: "Java",
            shortcuts: [
                Shortcut(title: "Print", description: "Use System.out.println(\"message\"); to print a message."),
                Shortcut(title: "For Loop", description: "Use for(int i = 0; i < n; i++) to create a loop."),
                Shortcut(title: "If Statement", description: "Use if(condition) { ... } to create a conditional block."),
                Shortcut(title: "While Loop", description: "Use while(condition) { ... } to create a loop."),
                Shortcut(title: "Array Declaration", description: "Use int[] arr = new int[size]; to declare an array."),
                Shortcut(title: "Class Declaration", description: "Use class ClassName { ... } to declare a class."),
                Shortcut(title: "Method Declaration", description: "Use returnType methodName() { ... } to declare a method."),
                Shortcut(title: "Try-Catch Block", description: "Use try { ... } catch(Exception e) { ... } to handle exceptions."),
                Shortcut(title: "Switch Statement", description: "Use switch(variable) { case value: ... } to create a switch."),
                Shortcut(title: "Import Statement", description: "Use import packageName.ClassName; to import a class.")
            ]
        )
    }
}
