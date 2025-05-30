import SwiftUI
import SwiftData

//Entry point of the SwiftUi applicationn
@main
struct CoBibleApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Shortcut.self,
        ])

        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        //Try to create the model container with the provided schema and configuration
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            //If model container creation fails,
            //crash the app and show the error
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    //Define the main user interface scene of the app
    var body: some Scene {
        WindowGroup {
            // Launches the HomeView when the app starts
            HomeView()
                .onAppear {
                    let context = sharedModelContainer.mainContext
                    //Populate the shortcut data when the app appears
                    ShortcutDataManager.populateShortcuts(context: context)
                    
                }
        }
        //Attach the model container to the scene to enable data persistence
        .modelContainer(sharedModelContainer)
    }
}
