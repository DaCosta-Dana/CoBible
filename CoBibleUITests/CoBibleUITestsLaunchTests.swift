
//  CoBibleUITestsLaunchTests.swift
//
//  Created by Erwan Weinmann on 03/03/2025.
// AND created by Trâm Anh VO on 05/04/2025

import XCTest

//UI launch test to verify that the app launch correctly
//Test passed successfully
final class CoBibleUITestsLaunchTests: XCTestCase {

    //This ensures the test runs once for each UI config
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    //Setup method executed before each test method
    override func setUpWithError() throws {
        //Stop immediately if a failure happens during the test
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
        //Preserve screenshot in test results
        attachment.lifetime = .keepAlways
        //Add the screenshot attachment to the test log
        add(attachment)
    }
}



