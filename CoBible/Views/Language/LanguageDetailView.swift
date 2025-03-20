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
                            languageName: languageName,
                            shortcuts: getShortcuts(for: languageName)
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


func getShortcuts(for language: String) -> [Shortcut] {
    switch language {
    case "Java":
        return [
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
    case "Python":
        return [
            Shortcut(title: "Print", description: "Use print(\"message\") to print a message."),
            Shortcut(title: "For Loop", description: "Use for i in range(n): to create a loop."),
            Shortcut(title: "If Statement", description: "Use if condition: to create a conditional block."),
            Shortcut(title: "While Loop", description: "Use while condition: to create a loop."),
            Shortcut(title: "List Declaration", description: "Use my_list = [] to declare a list."),
            Shortcut(title: "Function Declaration", description: "Use def function_name(): to declare a function."),
            Shortcut(title: "Class Declaration", description: "Use class ClassName: to declare a class."),
            Shortcut(title: "Exception Handling", description: "Use try: ... except Exception as e: to handle exceptions."),
            Shortcut(title: "Dictionary Declaration", description: "Use my_dict = {} to declare a dictionary."),
            Shortcut(title: "Import Statement", description: "Use import module_name to import a module.")
        ]
    default:
        return []
    }
}

// ✅ Preview
struct LanguageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageDetailView(languageName: "Java", imageName: "java-logo")
    }
}
