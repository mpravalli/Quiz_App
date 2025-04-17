//
//  LoginViewModelTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 10/02/25.
//

import XCTest
@testable import Quiz_App

class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    var mockCoreDataManager: MockCoreDataManagerlogin!
    
    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManagerlogin()
        viewModel = LoginViewModel()
        viewModel.viewmodel = mockCoreDataManager // Inject the mock dependency
    }
    
    override func tearDown() {
        viewModel = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    func testLogin_WithEmptyFields_ShowsAlert() {
        viewModel.email = ""
        viewModel.password = ""
        viewModel.handleLogin()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "All fields are required")
    }
    
    func testLogin_WithInvalidEmail_ShowsAlert() {
        viewModel.email = "invalid-email"
        viewModel.password = "password123"
        viewModel.handleLogin()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Enter valid email-id")
    }
    
    func testLogin_WithInvalidEmailFormat_ShowsAlert() {
        viewModel.email = "invalid-email@"
        viewModel.password = "password123"
        viewModel.handleLogin()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Enter valid email-id")
    }
    
    func testLogin_WithUnregisteredEmail_ShowsAlert() {
        
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        viewModel.handleLogin()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Email-id not registered.Please sign up")
    }
    
    func testLogin_WithValidCredentials_NavigatesToHomeView() {
        
        viewModel.email = "register@example.com"
        viewModel.password = "Password@123"
        viewModel.handleLogin()
        
        XCTAssertTrue(viewModel.loggedin)
        XCTAssertEqual(mockCoreDataManager.mockLoggedInEmail, "register@example.com")
    }
    
    func testLogin_WithIncorrectPassword_ShowsAlert() {
        viewModel.email = "register@example.com"
        viewModel.password = "wrongpassword"
        viewModel.handleLogin()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Invalid credentials")
    }
  
}

// MARK: - Mock CoreDataManager

class MockCoreDataManagerlogin: CoreDataManager {
    var mockEmailRegistered = false
    var mockLoginStatus = false
    var mockLoggedInEmail: String = ""
    
    override func isEmailRegistered(email: String) -> Bool {
        if email == "register@example.com"{
            mockEmailRegistered = true
        }else{
            mockEmailRegistered = false
        }
        return mockEmailRegistered
    }
    
    override func validateUser(email: String, password: String) -> Bool {
        if email == "register@example.com" && password == "Password@123"{
            mockLoginStatus = true
        }else{
            mockLoginStatus = false
        }
        return mockLoginStatus
    }
    
    override func loginUser(email: String){
        mockLoggedInEmail = email
    }
    
    
}

