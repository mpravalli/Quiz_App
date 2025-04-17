//
//  CustomQuestionsViewModelTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 15/04/25.
//

import XCTest
@testable import Quiz_App
import CoreData

class CustomQuestionsViewModelTests: XCTestCase {
    var viewModel: CustomQuestionsViewModel!
    var mockCoreDataManager: MockCoreDataManagerCustom!
    
    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManagerCustom()
        viewModel = CustomQuestionsViewModel()
        viewModel.coredatamanager = mockCoreDataManager
    }
    
    override func tearDown() {
        viewModel = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization_FetchesQuestions() {
        viewModel.fetchQuestions()
        XCTAssertTrue(mockCoreDataManager.fetchCalled)
    }
    
    // MARK: - Fetch Questions Tests
    
    func testFetchQuestions_ReturnsEmptyArrayWhenNoQuestions() {
        viewModel.fetchQuestions()
        XCTAssertTrue(viewModel.customQuestions.isEmpty)
    }
    
    func testFetchQuestions_ReturnsSavedQuestions() {
        // Setup mock with test data
        let testQuestion = CustomQuestion(context: mockCoreDataManager.persistentContainer.viewContext)
        testQuestion.id = UUID()
        testQuestion.questionText = "Test Question"
        testQuestion.option1 = "A"
        testQuestion.option2 = "B"
        testQuestion.option3 = "C"
        testQuestion.option4 = "D"
        testQuestion.correctIndex = 1
        mockCoreDataManager.savedQuestions = [testQuestion]
        
        viewModel.fetchQuestions()
        
        XCTAssertEqual(viewModel.customQuestions.count, 1)
        XCTAssertEqual(viewModel.customQuestions.first?.questionText, "Test Question")
        XCTAssertEqual(viewModel.customQuestions.first?.options, ["A", "B", "C", "D"])
        XCTAssertEqual(viewModel.customQuestions.first?.correctIndex, 1)
    }
    
    // MARK: - Validate and Add Question Tests
    
    func testValidateAndAddQuestion_WithValidData_SavesQuestion() {
        viewModel.questionText = "New Question"
        viewModel.options = ["A", "B", "C", "D"]
        viewModel.correctIndex = 2
        
        let result = viewModel.validateAndAddQuestion()
        
        XCTAssertTrue(result)
        XCTAssertTrue(mockCoreDataManager.saveCalled)
        XCTAssertEqual(mockCoreDataManager.savedQuestions.count, 1)
        XCTAssertEqual(mockCoreDataManager.savedQuestions.first?.questionText, "New Question")
    }
    
    func testValidateAndAddQuestion_WithEmptyQuestionText_ReturnsFalse() {
        viewModel.questionText = ""
        viewModel.options = ["A", "B", "C", "D"]
        viewModel.correctIndex = 0
        
        let result = viewModel.validateAndAddQuestion()
        
        XCTAssertFalse(result)
        XCTAssertFalse(mockCoreDataManager.saveCalled)
    }
    
    func testValidateAndAddQuestion_WithEmptyOption_ReturnsFalse() {
        viewModel.questionText = "Valid Question"
        viewModel.options = ["A", "", "C", "D"]
        viewModel.correctIndex = 0
        
        let result = viewModel.validateAndAddQuestion()
        
        XCTAssertFalse(result)
        XCTAssertFalse(mockCoreDataManager.saveCalled)
    }
    
    func testValidateAndAddQuestion_ResetsFormAfterSuccess() {
        viewModel.questionText = "New Question"
        viewModel.options = ["A", "B", "C", "D"]
        viewModel.correctIndex = 2
        
        _ = viewModel.validateAndAddQuestion()
        
        XCTAssertEqual(viewModel.questionText, "")
        XCTAssertEqual(viewModel.options, ["", "", "", ""])
        XCTAssertEqual(viewModel.correctIndex, 0)
    }
    
    // MARK: - Delete Question Tests
    
    func testDeleteQuestion_RemovesQuestion() {
        // Add test question
        let testQuestion = CustomQuestion(context: mockCoreDataManager.persistentContainer.viewContext)
        testQuestion.id = UUID()
        testQuestion.questionText = "To Delete"
        mockCoreDataManager.savedQuestions = [testQuestion]
        viewModel.fetchQuestions()
        
        viewModel.deleteQuestion(at: IndexSet([0]))
        
        XCTAssertTrue(mockCoreDataManager.deleteCalled)
        XCTAssertTrue(viewModel.customQuestions.isEmpty)
        XCTAssertTrue(mockCoreDataManager.savedQuestions.isEmpty)
    }
    
    func testDeleteQuestion_WithMultipleQuestions_DeletesCorrectOne() {
        // Add test questions
        let question1 = CustomQuestion(context: mockCoreDataManager.persistentContainer.viewContext)
        question1.id = UUID()
        question1.questionText = "Question 1"
        
        let question2 = CustomQuestion(context: mockCoreDataManager.persistentContainer.viewContext)
        question2.id = UUID()
        question2.questionText = "Question 2"
        
        mockCoreDataManager.savedQuestions = [question1, question2]
        viewModel.fetchQuestions()
        
        // Delete second question
        viewModel.deleteQuestion(at: IndexSet([1]))
        
        XCTAssertEqual(mockCoreDataManager.savedQuestions.count, 1)
        XCTAssertEqual(mockCoreDataManager.savedQuestions.first?.questionText, "Question 1")
    }
    
    // MARK: - Reset Form Tests
    
    func testResetForm_ClearsAllFields() {
        viewModel.questionText = "Test"
        viewModel.options = ["A", "B", "C", "D"]
        viewModel.correctIndex = 2
        
        viewModel.resetForm()
        
        XCTAssertEqual(viewModel.questionText, "")
        XCTAssertEqual(viewModel.options, ["", "", "", ""])
        XCTAssertEqual(viewModel.correctIndex, 0)
    }
}


class MockCoreDataManagerCustom: CoreDataManager {
    var savedQuestions: [CustomQuestion] = []
    var fetchCalled = false
    var saveCalled = false
    var deleteCalled = false
    
    override func fetchCustomQuestions() -> [CustomQuestion] {
        fetchCalled = true
        return savedQuestions
    }
    
    override func saveCustomQuestion(question: String, option1: String, option2: String, option3: String, option4: String, correctIndex: Int) {
        saveCalled = true
        let newQuestion = CustomQuestion(context: persistentContainer.viewContext)
        newQuestion.questionText = question
        newQuestion.option1 = option1
        newQuestion.option2 = option2
        newQuestion.option3 = option3
        newQuestion.option4 = option4
        newQuestion.correctIndex = Int16(correctIndex)
        newQuestion.id = UUID()
        savedQuestions.append(newQuestion)
    }
    
    override func deleteCustomQuestion(_ question: CustomQuestion) {
        deleteCalled = true
        savedQuestions.removeAll { $0.id == question.id }
    }
}
