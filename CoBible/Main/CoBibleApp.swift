//
//  CoBibleApp.swift
//  CoBible
//
//  Created by Erwan Weinmann on 03/03/2025.
//

import SwiftUI
import SwiftData
import MongoSwift

@main
struct CoBibleApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var mongoClient: MongoClient = {
        do {
            let client = try MongoClient("mongodb+srv://dana:2002D@n@0516@java.doawzub.mongodb.net/?retryWrites=true&w=majority&appName=Java")
            return client
        } catch {
            fatalError("Failed to initialize MongoDB client: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.mongoClient, mongoClient) // Pass MongoClient to the environment
        }
        .modelContainer(sharedModelContainer)
    }
}
