//
//  QuizHistoryViewModelTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 11/02/25.
//
import XCTest
@testable import Quiz_App

class QuizHistoryViewModelTests: XCTestCase {
    
    var viewModel: QuizHistoryViewModel!
    var mockCoreDataManager: MockCoreDataManagerHistory!
    
    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManagerHistory()
        viewModel = QuizHistoryViewModel(coreDataManager: mockCoreDataManager)
        // Override the core data manager with the mock
        
    }
    
    override func tearDown() {
        viewModel = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    
    // Test if fetchQuizHistory fetches the results correctly
    func testFetchQuizHistory_withValidResults() {
        let quizResult = QuizResultt(context: mockCoreDataManager.context)
        quizResult.id = UUID()
        quizResult.category = "Science"
        quizResult.level = "Easy"
        quizResult.score = 10
        quizResult.date = Date()
        quizResult.useremail = "test@example.com"
        
        mockCoreDataManager.quizResults = [quizResult]
        
        viewModel.fetchQuizHistory()
        
        XCTAssertEqual(viewModel.quizHistory.count, 1)
        XCTAssertEqual(viewModel.quizHistory.first?.category, "Science")
        XCTAssertEqual(viewModel.quizHistory.first?.score, 10)
    }
    
    // Test if user progress is calculated correctly
    func testCalculateUserProgress_withValidResults() {
        let quizResult1 = QuizResultt(context: mockCoreDataManager.context)
        quizResult1.score = 10
        quizResult1.date = Date()
        
        let quizResult2 = QuizResultt(context: mockCoreDataManager.context)
        quizResult2.score = 20
        quizResult2.date = Date()
        
        mockCoreDataManager.quizResults = [quizResult1, quizResult2]
        
        viewModel.fetchQuizHistory()
        
        XCTAssertEqual(viewModel.totalQuizzes, 2)
        XCTAssertEqual(viewModel.bestScore, 20)
    }
    
    // Test when there are no quiz results
    func testFetchQuizHistory_withNoResults() {
        mockCoreDataManager.quizResults = []
        
        viewModel.fetchQuizHistory()
        
        XCTAssertEqual(viewModel.quizHistory.count, 0)
        XCTAssertEqual(viewModel.totalQuizzes, 0)
        XCTAssertEqual(viewModel.bestScore, 0)
    }
    
    // Test when there is only one quiz result
    func testFetchQuizHistory_withOneResult() {
        let quizResult = QuizResultt(context: mockCoreDataManager.context)
        quizResult.score = 15
        quizResult.date = Date()
        
        mockCoreDataManager.quizResults = [quizResult]
        
        viewModel.fetchQuizHistory()
        
        XCTAssertEqual(viewModel.totalQuizzes, 1)
        XCTAssertEqual(viewModel.bestScore, 15)
    }
    
    func testFetchQuizHistory_forSpecificUser() {
        let quizResult1 = QuizResultt(context: mockCoreDataManager.context)
        quizResult1.useremail = "test1@example.com"
        quizResult1.score = 8
        quizResult1.category = "Math"
        
        let quizResult2 = QuizResultt(context: mockCoreDataManager.context)
        quizResult2.useremail = "test2@example.com"
        quizResult2.score = 9
        quizResult2.category = "Science"
        
        mockCoreDataManager.quizResults = [quizResult1, quizResult2]
        
        viewModel = QuizHistoryViewModel(coreDataManager: mockCoreDataManager, userEmail: "test1@example.com")
        viewModel.fetchQuizHistory()
        
        XCTAssertEqual(viewModel.quizHistory.count, 1)
        XCTAssertEqual(viewModel.quizHistory.first?.category, "Math")
    }
    
    //update badges tests
    
    //firstquiz badge
    func testAwardFirstQuizBadge() {
        viewModel.totalQuizzes = 1
        mockCoreDataManager.isBadgeAlreadyAwardedReturnValue = false
        
        viewModel.updateBadges()
        
        XCTAssertTrue(mockCoreDataManager.saveBadgeCalledWith.contains(.firstQuiz), "First Quiz badge should be awarded.")
    }
    
    //score>10 badge
    func testAwardScoreAbove10Badge() {
        viewModel.bestScore = 11
        mockCoreDataManager.isBadgeAlreadyAwardedReturnValue = false
        
        viewModel.updateBadges()
        
        XCTAssertTrue(mockCoreDataManager.saveBadgeCalledWith.contains(.scoreAbove10), "Score Above 10 badge should be awarded.")
    }
    
    //100 quizes completed badge
    func testAwardHundredQuizzesBadge() {
        viewModel.totalQuizzes = 100
        mockCoreDataManager.isBadgeAlreadyAwardedReturnValue = false
        
        viewModel.updateBadges()
        
        XCTAssertTrue(mockCoreDataManager.saveBadgeCalledWith.contains(.hundredQuizzes), "Hundred Quizzes badge should be awarded.")
    }
    
    func testBadgesNotAwardedTwice() {
        mockCoreDataManager.isBadgeAlreadyAwardedReturnValue = true // Simulating badge already awarded
        
        viewModel.updateBadges()
        
        XCTAssertTrue(mockCoreDataManager.saveBadgeCalledWith.isEmpty, "No badge should be awarded if already given.")
    }
    
}

// Mock CoreDataManager to simulate different conditions
class MockCoreDataManagerHistory: CoreDataManager {
    var quizResults: [QuizResultt] = []
    var isBadgeAlreadyAwardedReturnValue: Bool = false
    var saveBadgeCalledWith: [Badge] = []
    
    override func fetchQuizResults() -> [QuizResultt] {
        return quizResults
    }
    
    override func isBadgeAlreadyAwarded(_ badge: Badge) -> Bool {
        return isBadgeAlreadyAwardedReturnValue
    }
    
    override func saveBadge(_ badge: Badge) {
        saveBadgeCalledWith.append(badge)
    }
}


