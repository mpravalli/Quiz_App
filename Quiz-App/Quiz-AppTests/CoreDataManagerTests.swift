//
//  CoreDataManagerTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 10/02/25.
//

import XCTest
import CoreData
@testable import Quiz_App

class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    var testContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        // Use in-memory store to avoid persistent changes
        let container = NSPersistentContainer(name: "Quiz_App")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { (_, error) in
            if let error = error {
            fatalError("Failed to load in-memory store: \(error.localizedDescription)")
            }
            XCTAssertNil(error)
        }
        
        testContext = container.viewContext
        coreDataManager = CoreDataManager()
        coreDataManager.persistentContainer = container
    }
    
    override func tearDown() {
        super.tearDown()
        testContext = nil
        coreDataManager = nil
    }
    
    func testValidateUser_ValidCredentials() {
        
        let email = "test@example.com"
        let password = "password"
        _ = coreDataManager.saveUser(name: "Test User", email: email, password: password)
        XCTAssertTrue(coreDataManager.validateUser(email: email, password: password), "Valid credentials should return true")
        XCTAssertFalse(coreDataManager.validateUser(email: email, password: "12345"), "Should return false when fetch fails")
        
    }
    
    func testValidateUser_InvalidEmail() {
        let email = "test@example.com"
        let password = "password"
        _ = coreDataManager.saveUser(name: "Test User", email: email, password: password)
        XCTAssertFalse(coreDataManager.validateUser(email: "wrong@example.com", password: password), "Invalid email should return false")
    }
    
    func testValidateUser_InvalidPassword() {
        let email = "test@example.com"
        let password = "password"
        _ = coreDataManager.saveUser(name: "Test User", email: email, password: password)
        XCTAssertFalse(coreDataManager.validateUser(email: email, password: "wrongpassword"), "Invalid password should return false")
    }
    
    // User Saving
    func testSaveUser() {
        let name = "Test User"
        let email = "test@example.com"
        let password = "password"
        XCTAssertTrue(coreDataManager.saveUser(name: name, email: email, password: password), "User should be saved successfully")
        XCTAssertTrue(coreDataManager.isEmailRegistered(email: email), "User should exist in the database")
        
    }
    
    // Fetching Logged-In User Data
    func testGetUserData_LoggedInUser() {
        let name = "Test User"
        let email = "test@example.com"
        let password = "password"
        _ = coreDataManager.saveUser(name: name, email: email, password: password)
        coreDataManager.loginUser(email: email)
        
        let user = coreDataManager.getUserData()
        XCTAssertEqual(user?.name, name, "User name should match")
        XCTAssertEqual(user?.email, email, "User email should match")
    }
    
    //  Test Login Session Management
    func testLoginUser() {
        let email = "session@example.com"
        coreDataManager.loginUser(email: email)
        
        let isLoggedIn = coreDataManager.isUserLoggedIn()
        XCTAssertTrue(isLoggedIn, "User should be marked as logged in")
        
        let storedEmail = coreDataManager.getLoggedInUserEmail()
        XCTAssertEqual(storedEmail, email, "Stored email should match the logged-in email")
    }
    
    //  Test Logout
    func testLogoutUser() {
        coreDataManager.loginUser(email: "logout@example.com")
        coreDataManager.logoutUser()
        
        let isLoggedIn = coreDataManager.isUserLoggedIn()
        XCTAssertFalse(isLoggedIn, "User should be logged out")
        
        let email = coreDataManager.getLoggedInUserEmail()
        XCTAssertNil(email, "Email should be nil after logout")
    }
    
    //  Test Saving Quiz Result
    func testSaveQuizResult() {
        coreDataManager.loginUser(email: "quizuser@example.com")
        coreDataManager.saveQuizResult(category: "Math", level: "Easy", score: 8, totalquestions: 10)
        
        let results = coreDataManager.fetchQuizResults()
        XCTAssertFalse(results.isEmpty, "Quiz result should be saved")
        XCTAssertEqual(results.first?.category, "Math", "Category should match")
        XCTAssertEqual(results.first?.score, 8, "Score should match")
        XCTAssertEqual(results.first?.totalquestions, 10, "Total questions should match")
    }
    
    //verify user loggedin successfully
    func testLoginUserVerify() {
        let email = "test@example.com"
        coreDataManager.loginUser(email: email)
        XCTAssertTrue(CoreDataManager.shared.isUserLoggedIn(), "User should be logged in")
    }
    
    //verify user logout successfully
    func testLogoutUserVerify() {
        let email = "test@example.com"
        coreDataManager.loginUser(email: email)
        coreDataManager.logoutUser()
        XCTAssertFalse(coreDataManager.isUserLoggedIn(), "User should be logged out")
    }
    
    func testIsEmailRegistered_EmailDoesNotExist() {
        let email = "nonexistent@example.com"
        XCTAssertFalse(coreDataManager.isEmailRegistered(email: email), "Email should not be registered")
    }
    
    func testIsEmailRegistered_EmailExists() {
        let email = "test@example.com"
        _ = coreDataManager.saveUser(name: "Test User", email: email, password: "password")
        XCTAssertTrue(coreDataManager.isEmailRegistered(email: email), "Email should be registered")
    }
    
    func testGetUserData_NoLoggedInUser() {
        coreDataManager.logoutUser()
        XCTAssertNil(coreDataManager.getUserData(), "Function should return nil when no user is logged in")
    }
    
    func testGetLoggedInUserEmail() {
        let email = "test@example.com"
        coreDataManager.loginUser(email: email)
        XCTAssertEqual(coreDataManager.getLoggedInUserEmail(), email, "Function should return the logged-in user's email")
    }
    
    
    func testFetchQuizResults_LoggedInUser() {
        
        let email = "test@example.com"
        
        coreDataManager.loginUser(email: email)
        
        coreDataManager.saveQuizResult(category: "General Knowledge", level: "easy", score: 10, totalquestions: 15)
        
        let results = coreDataManager.fetchQuizResults()
        
        XCTAssertEqual(results.first?.category, "General Knowledge", "Category should match")
        XCTAssertEqual(results.first?.level, "easy", "Level should match")
        XCTAssertEqual(results.first?.score, 10, "Score should match")
        XCTAssertEqual(results.first?.totalquestions, 15, "Total questions should match")
        
        coreDataManager.logoutUser()
    }
    
    func testFetchQuizResults_NoLoggedInUser() {
        coreDataManager.logoutUser()
        let results = coreDataManager.fetchQuizResults()
        
        XCTAssertTrue(results.isEmpty, "Should return an empty array when no user is logged in")
    }
    
    func testSaveQuizResult_NoLoggedInUser() {
        coreDataManager.logoutUser()
        coreDataManager.saveQuizResult(category: "Math", level: "Easy", score: 8, totalquestions: 10)
        
        let results = coreDataManager.fetchQuizResults()
        XCTAssertTrue(results.isEmpty, "Should not save quiz result when no user is logged in")
    }
    
    // Badge System Tests
    func testSaveAndFetchBadges() {
        coreDataManager.loginUser(email: "badgeuser@example.com")
        let badge = Badge.firstQuiz
        coreDataManager.saveBadge(badge)
        
        let fetchedBadges = coreDataManager.fetchEarnedBadges()
        XCTAssertTrue(fetchedBadges.contains(badge), "Saved badge should be fetched")
    }
    
    //test for no badges are exist
    func testFetchEarnedBadges_NoBadgesAwarded() {
        let badges = coreDataManager.fetchEarnedBadges()
        XCTAssertTrue(badges.isEmpty, "Should return an empty array when no badges have been awarded")
    }
    
    //test for isBadgeAlreadyAwarded() method
    func testIsBadgeAlreadyAwarded() {
        coreDataManager.loginUser(email: "badgeuser@example.com")
        let badge = Badge.firstQuiz
        coreDataManager.saveBadge(badge)
        
        XCTAssertTrue(coreDataManager.isBadgeAlreadyAwarded(badge), "Should return true if the badge has been awarded")
        XCTAssertFalse(coreDataManager.isBadgeAlreadyAwarded(.hundredQuizzes), "Should return false if the badge has not been awarded")
    }
    
    
    // Custom Quiz Question Tests

    func testSaveCustomQuestion() {
        
        let testEmail = "test@example.com"
        coreDataManager.loginUser(email: testEmail)
        
        let questionText = "What is the capital of France?"
        let option1 = "Paris"
        let option2 = "London"
        let option3 = "Berlin"
        let option4 = "Rome"
        let correctIndex:Int16 = 1
        
        coreDataManager.saveCustomQuestion(question:questionText,option1: option1,option2: option2,option3: option3,option4: option4,correctIndex: Int(correctIndex))

        let fetchedQuestions = coreDataManager.fetchCustomQuestions()
        XCTAssertEqual(fetchedQuestions.count, 1, "Should fetch one custom question")
        XCTAssertEqual(fetchedQuestions.first?.questionText, questionText)
        XCTAssertEqual(fetchedQuestions.first?.correctIndex, correctIndex)
        XCTAssertEqual(fetchedQuestions.first?.option1,option1)
        XCTAssertEqual(fetchedQuestions.first?.option2,option2)
        XCTAssertEqual(fetchedQuestions.first?.option3,option3)
        XCTAssertEqual(fetchedQuestions.first?.option4,option4)
        
    }

    func testFetchCustomQuestions_NoQuestionsExist() {
        
        let testEmail = "test@example.com"
        coreDataManager.loginUser(email: testEmail)
        
        let questions = coreDataManager.fetchCustomQuestions()
        XCTAssertTrue(questions.isEmpty, "Should return empty array when no custom questions are added")
    }
    
    func testDeleteCustomQuestion() {
        // Step 1: Login a test user
        let testEmail = "test@example.com"
        coreDataManager.loginUser(email: testEmail)

        // Step 2: Save a custom question
        let questionText = "What is the capital of Thailand?"
        let option1 = "Bangkok"
        let option2 = "London"
        let option3 = "Berlin"
        let option4 = "Rome"
        let correctIndex: Int = 0

        coreDataManager.saveCustomQuestion(
            question: questionText,
            option1: option1,
            option2: option2,
            option3: option3,
            option4: option4,
            correctIndex: correctIndex
        )
        
        var fetchedQuestions = coreDataManager.fetchCustomQuestions()
        XCTAssertEqual(fetchedQuestions.count, 1, "Should fetch one custom question")

        if let questionToDelete = fetchedQuestions.first {
            coreDataManager.deleteCustomQuestion(questionToDelete)
        } else {
            XCTFail("No custom question to delete")
        }

        fetchedQuestions = coreDataManager.fetchCustomQuestions()
        XCTAssertEqual(fetchedQuestions.count, 0, "Custom question should be deleted")
    }




}
