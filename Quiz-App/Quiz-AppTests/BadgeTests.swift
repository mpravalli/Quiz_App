//
//  BadgeTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 25/02/25.
//
import XCTest
import SwiftUI
@testable import Quiz_App

class BadgeTests: XCTestCase {
    
    func testBadgeIDMatchesRawValue() {
        XCTAssertEqual(Badge.firstQuiz.id, "First Quiz Completed")
        XCTAssertEqual(Badge.scoreAbove10.id, "Best Score > 10")
        XCTAssertEqual(Badge.hundredQuizzes.id, "100 Quizzes Completed")
    }
    
    func testBadgeIconReturnsCorrectSymbol() {
        XCTAssertEqual(Badge.firstQuiz.icon, "star.fill")
        XCTAssertEqual(Badge.scoreAbove10.icon, "trophy.fill")
        XCTAssertEqual(Badge.hundredQuizzes.icon, "crown.fill")
    }
    
    func testBadgeColorMatchesExpectedValue() {
        XCTAssertEqual(Badge.firstQuiz.color, Color.yellow)
        XCTAssertEqual(Badge.scoreAbove10.color, Color.green)
        XCTAssertEqual(Badge.hundredQuizzes.color, Color.orange)
    }
    
    func testBadgeCaseIterableContainsAllCases() {
        let allBadges = Badge.allCases
        XCTAssertEqual(allBadges.count, 3)
        XCTAssertTrue(allBadges.contains(.firstQuiz))
        XCTAssertTrue(allBadges.contains(.scoreAbove10))
        XCTAssertTrue(allBadges.contains(.hundredQuizzes))
    }
}


