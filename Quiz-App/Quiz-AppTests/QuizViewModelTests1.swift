//
//  QuizViewModelTests1.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 11/02/25.
//
import XCTest
import Combine
@testable import Quiz_App
@MainActor
final class QuizViewModelTests1: XCTestCase {
    
    var viewModel: QuizViewModel!
    var cancellables: Set<AnyCancellable> = []
    //var mockSession: MockNetworkSession!
    var mockCoreDataManager: MockCoreDataManagerQuiz!

    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManagerQuiz()
        //mockSession = MockNetworkSession(mockData: <#Data#>)
        viewModel = QuizViewModel()
        viewModel.coredatamanager = mockCoreDataManager
    }

    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testInitialValues() {
        XCTAssertEqual(viewModel.categories.count, 0)
        XCTAssertEqual(viewModel.levels, ["easy", "medium", "hard"])
        XCTAssertEqual(viewModel.selectedCategory, "9")
        XCTAssertEqual(viewModel.selectedLevel, "easy")
        XCTAssertEqual(viewModel.questions.count, 0)
        XCTAssertEqual(viewModel.currentQuestionIndex, 0)
        XCTAssertEqual(viewModel.score, 0)
        XCTAssertEqual(viewModel.timerRemaining, 20)
        XCTAssertFalse(viewModel.showResult)
        XCTAssertEqual(viewModel.progress, 0.0)
        XCTAssertEqual(viewModel.selectedCategoryName,"General Knowledge")
    }

    func testReturnToHome() {
        viewModel.returnToHome()
        XCTAssertTrue(viewModel.navigateToHome, "Should navigate to home screen")
    }
    

    func testStartTimer() {
        viewModel.startTimer()
        XCTAssertNotNil(viewModel.timer, "Timer should be initialized")
        XCTAssertEqual(viewModel.timerRemaining, 20, "Timer should start with 20 seconds")
    }

    func testStartTimerResumeFromPaused() {
        viewModel.timeWhenPaused = 10
        viewModel.startTimer()
        XCTAssertEqual(viewModel.timerRemaining, 10, "Timer should resume from paused time")
        XCTAssertNil(viewModel.timeWhenPaused, "Paused time should be cleared after resuming")
    }
    
    func testNavigateToQuiz() {
        viewModel.restartQuiz()
        XCTAssertTrue(viewModel.navigateToQuiz, "Should navigate to quiz screen after restart")
    }
    
    func testSelectedCategoryName() {
        let category = TriviaCategory(id: 9, name: "General Knowledge")
        viewModel.categories = [category]
        viewModel.selectedCategory = "9"
        viewModel.selectedCategoryName = category.name
        XCTAssertEqual(viewModel.selectedCategoryName, "General Knowledge", "Selected category name should match")
    }
    
    func testProgressCalculation() {
        viewModel.questions = [TriviaQuestion(question: "Q1", correct_answer: "A", incorrect_answers: ["B", "C", "D"]),
                               TriviaQuestion(question: "Q2", correct_answer: "A", incorrect_answers: ["B", "C", "D"])]
        viewModel.currentQuestionIndex = 1
        viewModel.progress = CGFloat(viewModel.currentQuestionIndex + 1) / CGFloat(viewModel.questions.count)
        XCTAssertEqual(viewModel.progress, 1.0, accuracy: 0.001, "Progress should be correctly calculated")
    }
    
    func testLastQuestionIndexAndScoreBeforeRestart() {
        viewModel.questions = [TriviaQuestion(question: "Q1", correct_answer: "A", incorrect_answers: ["B", "C", "D"]),
                               TriviaQuestion(question: "Q2", correct_answer: "A", incorrect_answers: ["B", "C", "D"])]
        viewModel.currentQuestionIndex = 1
        viewModel.score = 1
        viewModel.restartQuiz()
        XCTAssertEqual(viewModel.lastQuestionIndexBeforeRestart, 1, "Last question index before restart should be set")
        XCTAssertEqual(viewModel.scoreBeforeRestart, 1, "Score before restart should be set")
    }

     
    //initial starting
    func testStartTimer_NewQuestion_ShouldStartWithDefaultTime() {
        viewModel.selectedAnswer = nil
        viewModel.startTimer()
        
        XCTAssertEqual(viewModel.timerRemaining, 20, "Timer should start with 20 seconds for a new question")
    }
    
    //Resume timer from paused time
    func testStartTimer_ResumeFromPause_ShouldContinueFromPreviousTime() {
        viewModel.timeWhenPaused = 10
        viewModel.startTimer()
        
        XCTAssertEqual(viewModel.timerRemaining, 10, "Timer should resume from paused time")
    }
    
    //Timer should decrement every second
    func testStartTimer_TimerShouldDecrementEachSecond() {
        viewModel.startTimer()
        
        let expectation = XCTestExpectation(description: "Wait for timer to decrement")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) { // Wait 2 seconds
            XCTAssertEqual(self.viewModel.timerRemaining, 18, "Timer should decrement every second")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    //Timer should stop when it reaches 0
    func testStartTimer_TimerShouldStopAtZero() {
        viewModel.startTimer()
        viewModel.timerRemaining = 1
        
        let expectation = XCTestExpectation(description: "Wait for timer to reach zero")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) { // Wait 2 seconds
            XCTAssertEqual(self.viewModel.timerRemaining, 0, "Timer should stop at zero")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    //Timer should move to next question when it expires
    func testStartTimer_TimerExpires_ShouldMoveToNextQuestion() {
        viewModel.questions = [TriviaQuestion(question: "Q1", correct_answer: "A", incorrect_answers: ["B", "C", "D"]),
                               TriviaQuestion(question: "Q2", correct_answer: "A", incorrect_answers: ["B", "C", "D"])]
        viewModel.currentQuestionIndex = 0
        viewModel.startTimer()
        viewModel.timerRemaining = 1
        
        
        let expectation = XCTestExpectation(description: "Timer should move to next question")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            XCTAssertEqual(self.viewModel.currentQuestionIndex, 1, "Quiz should move to next question when timer expires")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    //Timer expiration on last question should complete the test
    func testStartTimer_TimerExpiresOnLastQuestion_ShouldCompleteTest() {
        viewModel.questions = [
            TriviaQuestion(question: "Q1", correct_answer: "A", incorrect_answers: ["B", "C", "D"])
        ]
        viewModel.currentQuestionIndex = 0
        viewModel.startTimer()
        viewModel.timerRemaining = 1
        
        let expectation = XCTestExpectation(description: "Timer should complete the test on last question")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { 
            XCTAssertTrue(self.viewModel.showResult, "Test should be completed when timer expires on last question")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testCheckAnswerCorrect() {
        let question = TriviaQuestion(
            question: "What is the capital of France?",
            correct_answer: "Paris",
            incorrect_answers: ["London", "Berlin", "Rome"],
            userSelectedAnswer: "Paris"
        )
        viewModel.questions = [question]
        
        viewModel.checkAnswer("Paris")
        
        XCTAssertEqual(viewModel.score, 1, "Score should increment for correct answer")
        XCTAssertNotNil(viewModel.selectedAnswer, "Selected answer should be set")
        XCTAssertNil(viewModel.timer, "Timer should be stopped after answering")
    }
    
    func testCheckAnswerIncorrect() {
        let question = TriviaQuestion(
            question: "What is 2 + 2?",
            correct_answer: "4",
            incorrect_answers: ["3", "5", "6"],
            userSelectedAnswer: nil
        )
        viewModel.questions = [question]
        
        viewModel.checkAnswer("3")
        
        XCTAssertEqual(viewModel.score, 0, "Score should not increment for incorrect answer")
        XCTAssertNotNil(viewModel.selectedAnswer, "Selected answer should be set")
        XCTAssertNil(viewModel.timer, "Timer should be stopped after answering")
    }
    
    func testMoveToNextQuestion() {
        viewModel.questions = [
            TriviaQuestion(question: "Q1", correct_answer: "A1", incorrect_answers: ["B1", "C1", "D1"], userSelectedAnswer: nil),
            TriviaQuestion(question: "Q2", correct_answer: "A2", incorrect_answers: ["B2", "C2", "D2"], userSelectedAnswer: nil)
        ]
        
        viewModel.moveToNextQuestion()
        
        XCTAssertEqual(viewModel.currentQuestionIndex, 1, "Current question index should increment")
        XCTAssertEqual(viewModel.progress, 1.0, "Progress should be updated")
    }
    
    func test_Save_Result(){
        viewModel.selectedCategoryName = "General Knowledge"
        viewModel.selectedLevel = "easy"
        viewModel.score = 20
        viewModel.saveResult(category: viewModel.selectedCategoryName, level: viewModel.selectedLevel, score: Int16(viewModel.score), totalquestions: 25)
        
        XCTAssertTrue(mockCoreDataManager.mockSaveQuizResult,"successfully saved quiz result")
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
}

class MockCoreDataManagerQuiz: CoreDataManager {
    
    var mockSaveQuizResult: Bool = false
    
    override func saveQuizResult(category: String, level: String, score: Int16, totalquestions: Int16) {
        mockSaveQuizResult = true
    }
    
}
