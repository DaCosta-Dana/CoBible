import SwiftUI
import SwiftData

@main
struct CoBibleApp: App {
    //Shared ModelContainer for managing app data
    var sharedModelContainer: ModelContainer = {
        //Define data model
        let schema = Schema([
            Shortcut.self,
        ])
        //Storing data on disk
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            //Try to create the container with our configuration
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            //Show error if something goes wrong
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    //Main scene of what the user sees
    var body: some Scene {
        WindowGroup {
            HomeView()
                .onAppear {
                    //When the view appears, retrieve the main context of our model container
                    let context = sharedModelContainer.mainContext
                    //Populate the database with default shortcuts
                    ShortcutDataManager.populateShortcuts(context: context)
                    
                }
        }
        //Provide the model container to the entire app
        .modelContainer(sharedModelContainer)
    }
}
