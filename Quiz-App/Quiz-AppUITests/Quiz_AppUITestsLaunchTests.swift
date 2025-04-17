//
//  Quiz_AppUITestsLaunchTests.swift
//  Quiz-AppUITests
//
//  Created by Makula Pravallika on 21/01/25.
//

import XCTest

final class Quiz_AppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

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

/*import XCTest

final class Quiz_AppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        // Set to false unless you specifically need to test different configurations
        false
    }

    override func setUpWithError() throws {
        // Disable animations for more reliable tests
        //UIView.setAnimationsEnabled(false)
        
        // Configure app for testing
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launchEnvironment["XCUI"] = "true"
        
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Wait for app to become ready
        let mainWindow = app.windows.firstMatch
        XCTAssertTrue(mainWindow.waitForExistence(timeout: 15))
        
        // Add a short delay to ensure all UI elements are loaded
        let expectation = XCTestExpectation(description: "Wait for UI to stabilize")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        // Take screenshot
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    override func tearDown() {
        // Clean up
        XCUIApplication().terminate()
        super.tearDown()
    }
}*/
