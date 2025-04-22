import SwiftUI
import SwiftData

struct ShortcutDetailView: View {
    var shortcutTitle: String
    var selectedLanguage: String // Pass the selected language
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var context

    @State private var shortcut: Shortcut?

    var body: some View {
        ScrollView {
            if let shortcut = shortcut {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    Text(shortcut.title)
                        .font(.custom("LexendDeca-Black", size: 30))
                        .bold()
                        .padding(.top, 20)
                        .padding(.horizontal)

                    // Description
                    Text(shortcut.explanation)
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                    // How to do it (in a box)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("How to code it in \(selectedLanguage)?")
                            .font(.custom("LexendDeca-Black", size: 20))
                            .bold()
                            .padding(.bottom, 5)

                        Text(selectedLanguage == "Java" ? shortcut.javaCode : shortcut.pythonCode)
                            .font(.custom("LexendDeca-Regular", size: 16))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                // Loading or error state
                Text("Loading...")
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .foregroundColor(.gray)
                    .padding(.top, 50)
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
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
        .onAppear {
            shortcut = ShortcutDataManager.fetchShortcutByTitle(title: shortcutTitle, context: context)
        }
    }
}

// ✅ Preview
struct ShortcutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutDetailView(shortcutTitle: "Print", selectedLanguage: "Java")
            .modelContainer(for: Shortcut.self)
    }
}
