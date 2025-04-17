//
//  SplashScreenViewModelTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 10/02/25.
//

import XCTest
@testable import Quiz_App

final class SplashScreenViewModelTests: XCTestCase {

    private var viewModel: SplashScreenViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = SplashScreenViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    func testInitialValues() {
        XCTAssertFalse(viewModel.isActive, "isActive should be false initially")
        XCTAssertEqual(viewModel.size, 0.8, "Initial size should be 0.8")
        XCTAssertEqual(viewModel.opacity, 0.5, "Initial opacity should be 0.5")
    }

    func testSplashAnimation() {
        viewModel.splashanimation()
        XCTAssertEqual(viewModel.size, 0.9, "Size should change to 0.9 after animation")
        XCTAssertEqual(viewModel.opacity, 1.0, "Opacity should change to 1.0 after animation")
    }

    func testIsActiveChanges() {
        viewModel.isActive = true
        XCTAssertTrue(viewModel.isActive, "isActive should be true when changed")
    }
}


