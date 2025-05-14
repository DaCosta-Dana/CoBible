
//  CoBibleTests.swift
//  CoBibleTests
//
//  Created by Erwan Weinmann on 03/03/2025.
//  Edited by Trâm Anh VO on 05/04/2025
//

import XCTest
import SwiftData
@testable import CoBible

// Unit tests for the CoBible app, focused on verifying shortcut population logic
//Test passed successfully
@MainActor
final class CoBibleTests: XCTestCase {
    //model container for testing without affecting storage
    var modelContainer: ModelContainer!
    // The main context used to perform operations in this test
    var context: ModelContext!
    
    //Set up test environment with an in-memory SwitchData Model
    override func setUpWithError() throws {
        let schema = Schema([
            Shortcut.self
        ])
        //Create a configuration that keep data in memory only for isolated testing
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        //Initialize the model container
        modelContainer = try ModelContainer(for: schema, configurations: [config])
        //Retrieve main context from model container
        context = modelContainer.mainContext
    }

    //Clean up ressources after each test 
    override func tearDownWithError() throws {
        modelContainer = nil
        context = nil
    }
    
//Test passed successfully
    // Note: Had to remove a breakpoint manually in Xcode (Breakpoint Navigator)to allow the test to run without pausing unexpectedly.
    func testPopulateShortcutsAddsData() async throws {
        // Ensure the context is empty
        let initialShortcuts = try context.fetch(FetchDescriptor<Shortcut>())
        XCTAssertEqual(initialShortcuts.count, 0, "Expected no shortcuts initially")

        // Call your population logic
        ShortcutDataManager.populateShortcuts(context: context)

        // Fetch again to see if data was added
        let newShortcuts = try context.fetch(FetchDescriptor<Shortcut>())
        XCTAssertGreaterThan(newShortcuts.count, 0, "Expected shortcuts to be populated")
    }
}
