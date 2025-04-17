//
//  ThemeManagerTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 10/02/25.
//

import XCTest
import SwiftUI
@testable import Quiz_App

final class ThemeManagerTests: XCTestCase {

    var themeManager: ThemeManager!

    override func setUp() {
        super.setUp()
        // Reset UserDefaults for testing
        UserDefaults.standard.removeObject(forKey: "isDarkMode")
        themeManager = ThemeManager()
    }

    override func tearDown() {
        themeManager = nil
        super.tearDown()
    }

    //light
    func testInitializationWithLightTheme() {
        
        XCTAssertFalse(themeManager.isDarkMode, "isDarkMode should be false by default")
        XCTAssertEqual(themeManager.colorScheme, .light, "colorScheme should be .light by default")
    }

    // Test initialization with dark theme
    func testInitializationWithDarkTheme() {
        
        UserDefaults.standard.set(true, forKey: "isDarkMode")
        themeManager = ThemeManager()
        XCTAssertTrue(themeManager.isDarkMode, "isDarkMode should be true")
        XCTAssertEqual(themeManager.colorScheme, .dark, "colorScheme should be .dark")
    }

}

