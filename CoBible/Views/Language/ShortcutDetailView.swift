import SwiftUI

struct ShortcutDetailView: View {
    var shortcut: Shortcut
    @Environment(\.presentationMode) var presentationMode // For navigation back

    var body: some View {
        ScrollView {
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
                    Text("How to do it?")
                        .font(.custom("LexendDeca-Black", size: 20))
                        .bold()
                        .padding(.bottom, 5)

                    Text(shortcut.code)
                        .font(.custom("LexendDeca-Regular", size: 16))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Navigate back
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

// ✅ Preview
struct ShortcutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleShortcut = Shortcut(
            number: 1,
            title: "Print",
            code: "System.out.println(\"Hello, World!\");",
            explanation: "Use this to print text or values to the console."
        )
        ShortcutDetailView(shortcut: sampleShortcut)
    }
}
