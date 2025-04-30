
//
//  CoBibleUITestsLaunchTests.swift
//  CoBibleUITests
//
//  Created by Erwan Weinmann on 03/03/2025.
// AND created by Trâm Anh VO on 05/04/2025

import XCTest

//Test passed successfully
final class CoBibleUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

//Test passed successfully
    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}



//
//  CoBibleTests.swift
//  CoBibleTests
//
//  Created by Erwan Weinmann on 03/03/2025.
//  Edited by Trâm Anh VO on 05/04/2025
//

import XCTest
import SwiftData
@testable import CoBible

//Test passed successfully
@MainActor
final class CoBibleTests: XCTestCase {

    var modelContainer: ModelContainer!
    var context: ModelContext!

    override func setUpWithError() throws {
        let schema = Schema([
            Shortcut.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: schema, configurations: [config])
        context = modelContainer.mainContext
    }

    override func tearDownWithError() throws {
        modelContainer = nil
        context = nil
    }
    
//Test passed successfully
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
