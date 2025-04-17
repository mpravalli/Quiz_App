//
//  FetchQuestionTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 15/04/25.
//

import SwiftUI
import XCTest
@testable import Quiz_App
import Combine
/*@MainActor
final class FetchQuestionTests: XCTestCase {
    
    var viewModel: QuizViewModel!
    var cancellables: Set<AnyCancellable> = []
    //var mockSession: MockNetworkSession!
    
    override func setUp() {
        super.setUp()
        //mockCoreDataManager = MockCoreDataManagerQuiz()
        //mockSession = MockNetworkSession(mockData: <#Data#>)
        viewModel = QuizViewModel()
        //viewModel.coredatamanager = mockCoreDataManager
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testFetchCategories_Success() async {
        // Given
        let json = """
        {
            "trivia_categories": [
                { "id": 9, "name": "General Knowledge" },
                { "id": 10, "name": "Books" }
            ]
        }
        """.data(using: .utf8)!
        
        let mockSession = MockNetworkSession2(mockData: json)
        let viewModel = QuizViewModel(session: mockSession)
        
        // When
        await viewModel.fetchCategories()
        
        // Then
        XCTAssertEqual(viewModel.categories.count, 2)
        XCTAssertEqual(viewModel.categories[0].id, 9)
        XCTAssertEqual(viewModel.categories[0].name, "General Knowledge")
        XCTAssertEqual(viewModel.categories[1].id, 10)
        XCTAssertEqual(viewModel.categories[1].name, "Books")
    }
    
    func testFetchCategories_EmptyResponse() async {
        // Given
        let json = """
        {
            "trivia_categories": []
        }
        """.data(using: .utf8)!
        
        let mockSession = MockNetworkSession2(mockData: json)
        let viewModel = QuizViewModel(session: mockSession)
        
        // When
        await viewModel.fetchCategories()
        
        // Then
        XCTAssertEqual(viewModel.categories.count, 0)
    }
    
    func testFetchCategories_InvalidJSON() async {
        // Given
        let json = "Invalid JSON".data(using: .utf8)!
        
        let mockSession = MockNetworkSession2(mockData: json)
        let viewModel = QuizViewModel(session: mockSession)
        
        // When
        await viewModel.fetchCategories()
        
        // Then
        XCTAssertEqual(viewModel.categories.count, 0)
    }
    
    func testFetchCategories_NetworkError() async {
        // Given
        let mockSession = MockNetworkSession2(mockData: Data())
        mockSession.shouldThrowError = true
        let viewModel = QuizViewModel(session: mockSession)
        
        // When
        await viewModel.fetchCategories()
        
        // Then
        XCTAssertEqual(viewModel.categories.count, 0)
    }
    
    
    
    func testFetchQuestions_Success() async {
        // Given
        let categoryCountJson = """
        {
            "category_id": 9,
            "category_question_count": {
                "total_question_count": 100,
                "total_easy_question_count": 30,
                "total_medium_question_count": 40,
                "total_hard_question_count": 30
            }
        }
        """.data(using: .utf8)!
        
        let questionsJson = """
        {
            "response_code": 0,
            "results": [
                {
                    "category": "General Knowledge",
                    "type": "multiple",
                    "difficulty": "easy",
                    "question": "What is the capital of France?",
                    "correct_answer": "Paris",
                    "incorrect_answers": ["London", "Berlin", "Madrid"]
                }
            ]
        }
        """.data(using: .utf8)!
        
        let mockSession = MockNetworkSession2(mockData: questionsJson)
        mockSession.mockResponses = [
            URL(string: "https://opentdb.com/api_count.php?category=9")!: categoryCountJson,
            URL(string: "https://opentdb.com/api.php?amount=25&category=9&difficulty=easy")!: questionsJson
        ]
        
        let viewModel = QuizViewModel(session: mockSession)
        viewModel.selectedCategory = "9"
        viewModel.selectedLevel = "easy"
        
        // When
        await viewModel.fetchQuestions()
        
        // Then
        XCTAssertEqual(viewModel.questions.count, 1)
        XCTAssertEqual(viewModel.questions[0].question, "What is the capital of France?")
        XCTAssertEqual(viewModel.questions[0].correct_answer, "Paris")
        XCTAssertEqual(viewModel.questions[0].incorrect_answers, ["London", "Berlin", "Madrid"])
        XCTAssertEqual(viewModel.questions[0].allAnswers.count, 4) // Correct + 3 incorrect
    }

    func testFetchQuestions_WithHTMLEncoding() async {
        // Given
        let categoryCountJson = """
        {
            "category_id": 9,
            "category_question_count": {
                "total_question_count": 100,
                "total_easy_question_count": 30,
                "total_medium_question_count": 40,
                "total_hard_question_count": 30
            }
        }
        """.data(using: .utf8)!
        
        let questionsJson = """
        {
            "response_code": 0,
            "results": [
                {
                    "category": "General Knowledge",
                    "type": "multiple",
                    "difficulty": "easy",
                    "question": "What is &quot;JavaScript&quot;?",
                    "correct_answer": "Programming Language",
                    "incorrect_answers": ["Script", "Java", "Coffee"]
                }
            ]
        }
        """.data(using: .utf8)!
        
        let mockSession = MockNetworkSession2(mockData: questionsJson)
        mockSession.mockResponses = [
            URL(string: "https://opentdb.com/api_count.php?category=9")!: categoryCountJson,
            URL(string: "https://opentdb.com/api.php?amount=25&category=9&difficulty=easy")!: questionsJson
        ]
        
        let viewModel = QuizViewModel(session: mockSession)
        viewModel.selectedCategory = "9"
        viewModel.selectedLevel = "easy"
        
        // When
        await viewModel.fetchQuestions()
        
        // Then
        XCTAssertEqual(viewModel.questions[0].question, "What is \"JavaScript\"?")
    }

    func testFetchQuestions_NoQuestionsAvailable() async {
        // Given
        let categoryCountJson = """
        {
            "category_id": 9,
            "category_question_count": {
                "total_question_count": 100,
                "total_easy_question_count": 0, // No easy questions
                "total_medium_question_count": 40,
                "total_hard_question_count": 30
            }
        }
        """.data(using: .utf8)!
        
        let mockSession = MockNetworkSession2(mockData: categoryCountJson)
        let viewModel = QuizViewModel(session: mockSession)
        viewModel.selectedCategory = "9"
        viewModel.selectedLevel = "easy"
        
        // When
        await viewModel.fetchQuestions()
        
        // Then
        XCTAssertEqual(viewModel.questions.count, 0)
    }

    func testFetchQuestions_NetworkError() async {
        // Given
        let mockSession = MockNetworkSession2(mockData: Data())
        mockSession.shouldThrowError = true
        let viewModel = QuizViewModel(session: mockSession)
        viewModel.selectedCategory = "9"
        viewModel.selectedLevel = "easy"
        
        // When
        await viewModel.fetchQuestions()
        
        // Then
        XCTAssertEqual(viewModel.questions.count, 0)
    }

    func testFetchQuestions_InvalidCategory() async {
        // Given
        let mockSession = MockNetworkSession2(mockData: Data())
        let viewModel = QuizViewModel(session: mockSession)
        viewModel.selectedCategory = "999" // Invalid category
        viewModel.selectedLevel = "easy"
        
        // When
        await viewModel.fetchQuestions()
        
        // Then
        XCTAssertEqual(viewModel.questions.count, 0)
    }

    func testFetchQuestions_LimitedQuestionsAvailable() async {
        // Given - Only 5 easy questions available
        let categoryCountJson = """
        {
            "category_id": 9,
            "category_question_count": {
                "total_question_count": 100,
                "total_easy_question_count": 5,
                "total_medium_question_count": 40,
                "total_hard_question_count": 30
            }
        }
        """.data(using: .utf8)!
        
        // Create a response with 5 questions
        var results = [String]()
        for i in 1...5 {
            results.append("""
            {
                "category": "General Knowledge",
                "type": "multiple",
                "difficulty": "easy",
                "question": "Question \(i)",
                "correct_answer": "Correct \(i)",
                "incorrect_answers": ["Wrong1", "Wrong2", "Wrong3"]
            }
            """)
        }
        
        let questionsJson = """
        {
            "response_code": 0,
            "results": [\(results.joined(separator: ","))]
        }
        """.data(using: .utf8)!
        
        let mockSession = MockNetworkSession2(mockData: questionsJson)
        mockSession.mockResponses = [
            URL(string: "https://opentdb.com/api_count.php?category=9")!: categoryCountJson,
            URL(string: "https://opentdb.com/api.php?amount=5&category=9&difficulty=easy")!: questionsJson
        ]
        
        let viewModel = QuizViewModel(session: mockSession)
        viewModel.selectedCategory = "9"
        viewModel.selectedLevel = "easy"
        
        // When
        await viewModel.fetchQuestions()
        
        // Then
        XCTAssertEqual(viewModel.questions.count, 5, "Should fetch exactly 5 questions when only 5 are available")
    }
    
}
class MockNetworkSession2: NetworkSession {
    var mockData: Data
    var mockResponse: URLResponse = URLResponse()
    var shouldThrowError: Bool = false
    var mockResponses: [URL: Data] = [:]
    
    init(mockData: Data = Data(), mockResponse: URLResponse = URLResponse()) {
        self.mockData = mockData
        self.mockResponse = mockResponse
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        
        if let responseData = mockResponses[url] {
            return (responseData, mockResponse)
        }
        
        return (mockData, mockResponse)
    }
}*/
