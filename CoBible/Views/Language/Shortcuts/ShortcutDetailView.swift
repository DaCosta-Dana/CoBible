import SwiftUI
import SwiftData
import WebKit

// WebView to show syntax-highlighted code
struct SyntaxHighlightedWebView: UIViewRepresentable {
    var code: String
    var language: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let formattedCode = code.replacingOccurrences(of: "\n", with: "<br>") // Replace \n with <br> for line breaks in HTML
        let html = """
        <html>
        <head>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/highlight.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/styles/atom-one-dark.min.css">
        <style>
            body {
                font-size: 24px; /* Larger font size for the code */
            }
            pre {
                font-size: 24px; /* Larger font size for preformatted text */
                padding: 15px;
                background-color: #2e2e2e; /* Dark background for code */
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
        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
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

struct ShortcutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutDetailView(shortcutTitle: "Print", selectedLanguage: "Java")
            .modelContainer(for: Shortcut.self)
    }
}
