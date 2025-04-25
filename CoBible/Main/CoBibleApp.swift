import SwiftUI
import SwiftData

@main
struct CoBibleApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Shortcut.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .onAppear {
                    let context = sharedModelContainer.mainContext
                    ShortcutDataManager.populateShortcuts(context: context)
                    
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
