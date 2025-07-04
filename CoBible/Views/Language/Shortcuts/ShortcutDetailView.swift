import SwiftUI
import SwiftData
import WebKit

// UIViewRepresentable to display syntax-highlighted code using WKWebView and highlight.js
struct SyntaxHighlightedWebView: UIViewRepresentable {
    var code: String      // The code to display
    var language: String  // The programming language for syntax highlighting

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        // Replace escaped newlines with actual newlines for formatting
        let formattedCode = code.replacingOccurrences(of: "\\n", with: "\n")
        // HTML template with highlight.js for syntax highlighting
        let html = """
        <html>
        <head>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/highlight.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/styles/atom-one-light.min.css">
        <style>
            body {
                font-size: 40px; /* Larger font size for the code */
            }
            pre {
                font-size: 24px; /* Larger font size for preformatted text */
                background-color: #ffffff;
                color: #000000;
                padding: 15px;
                background-color: #f5f5f5; /* Light background */
                border-radius: 10px; /* Rounded corners */
                overflow-x: auto;
            }
        </style>
        </head>
        <body>
        <pre><code class="\(language)">\(formattedCode)</code></pre>
        <script>hljs.highlightAll();</script>
        </body>
        </html>
        """
        // Load the HTML string into the web view
        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No update needed for static code
    }
}

struct ShortcutDetailView: View {
    var shortcutTitle: String
    var selectedLanguage: String
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var context

    @State private var shortcut: Shortcut?
    @State private var codeToDisplay: String = ""

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

                        // Show syntax-highlighted code
                        SyntaxHighlightedWebView(code: selectedLanguage == "Java" ? shortcut.javaCode : shortcut.pythonCode, language: selectedLanguage)
                            .frame(height: 400) // Increased height for better visibility
                            .padding()
                            .clipShape(RoundedRectangle(cornerRadius: 15)) // Rounded corners for the code container
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

        //Custom back button in the toolbar
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
            //Fetch the shortcut from the database when the view appears
            shortcut = ShortcutDataManager.fetchShortcutByTitle(title: shortcutTitle, context: context)
        }
    }
}

//Preview provider for SwiftUi previews
struct ShortcutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutDetailView(shortcutTitle: "Print", selectedLanguage: "Java")
            .modelContainer(for: Shortcut.self)
    }
}
