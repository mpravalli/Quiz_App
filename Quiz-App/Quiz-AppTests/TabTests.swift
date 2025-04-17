//
//  TabTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 17/03/25.
//

import XCTest
@testable import Quiz_App

final class TabTests: XCTestCase {

    func test_HomeTab_ShouldBeHome() {
        let tab: Tab = .home
        XCTAssertEqual(tab, Tab.home, "Tab should be home")
    }
    
    func test_LeaderboardTab_ShouldBeLeaderboard() {
        let tab: Tab = .leaderboard
        XCTAssertEqual(tab, Tab.leaderboard, "Tab should be leaderboard")
    }
    
    func test_HomeAndLeaderboardTabs_ShouldNotBeEqual() {
        let homeTab: Tab = .home
        let leaderboardTab: Tab = .leaderboard
        XCTAssertNotEqual(homeTab, leaderboardTab, "Home and leaderboard tabs should not be equal")
    }
}
