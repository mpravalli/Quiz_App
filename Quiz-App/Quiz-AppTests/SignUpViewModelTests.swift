//
//  SignUpViewModelTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 10/02/25.
//

import XCTest
@testable import Quiz_App

final class SignUpViewModelTests: XCTestCase {
    var viewModel: SignUpViewModel!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManager()
        viewModel = SignUpViewModel()
        viewModel.viewmodel = mockCoreDataManager
    }
    
    override func tearDown() {
        viewModel = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    
    func test_EmptyFields_ShouldShowAlert() {
        viewModel.handleRegistration()
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "All fields are required")
    }
    
    func test_PasswordMismatch_ShouldShowAlert() {
        viewModel.name = "Test User"
        viewModel.email = "test@example.com"
        viewModel.password = "Password123!"
        viewModel.cpassword = "Different123!"
        
        viewModel.handleRegistration()
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Both Passwords not matched")
    }
    
    func test_InvalidEmail_ShouldShowAlert() {
        viewModel.name = "Test User"
        viewModel.email = "invalidemail"
        viewModel.password = "Password123!"
        viewModel.cpassword = "Password123!"
        
        viewModel.handleRegistration()
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Enter valid email-id")
    }
    
    func test_ShortPassword_ShouldShowAlert() {
        viewModel.name = "Test User"
        viewModel.email = "test@example.com"
        viewModel.password = "Short1!"
        viewModel.cpassword = "Short1!"
        
        viewModel.handleRegistration()
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Password must be more than 8 letters")
    }
    
    
    func test_WeakPassword_ShouldShowAlert() {
        viewModel.name = "Test User"
        viewModel.email = "test@example.com"
        viewModel.password = "Password123"
        viewModel.cpassword = "Password123"
        
        viewModel.handleRegistration()
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Password must contain at least one special character")
    }
    func test_PasswordMissingUppercase_ShouldShowAlert() {
        viewModel.name = "Test User"
        viewModel.email = "test@example.com"
        viewModel.password = "password123!"
        viewModel.cpassword = "password123!"
        
        viewModel.handleRegistration()
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Password must contain at least one Uppercase character")
    }
    
    func test_PasswordMissingLowercase_ShouldShowAlert() {
        viewModel.name = "Test User"
        viewModel.email = "test@example.com"
        viewModel.password = "PASSWORD123!"
        viewModel.cpassword = "PASSWORD123!"
        
        viewModel.handleRegistration()
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Password must contain at least one Lowercase character")
    }
    
    func test_PasswordMissingNumber_ShouldShowAlert() {
        viewModel.name = "Test User"
        viewModel.email = "test@example.com"
        viewModel.password = "Password!"
        viewModel.cpassword = "Password!"
        
        viewModel.handleRegistration()
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Password must contain at least one number")
    }
    
    func test_EmailMissingDotCom_ShouldShowAlert() {
        viewModel.name = "Test User"
        viewModel.email = "test@example"
        viewModel.password = "Password123!"
        viewModel.cpassword = "Password123!"
        
        viewModel.handleRegistration()
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Enter valid email-id")
    }
    
    func test_EmailMissingAtSymbol_ShouldShowAlert() {
        viewModel.name = "Test User"
        viewModel.email = "testexample.com"
        viewModel.password = "Password123!"
        viewModel.cpassword = "Password123!"
        
        viewModel.handleRegistration()
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Enter valid email-id")
    }
    
    func test_AlreadyRegisteredEmail_ShouldShowAlert() {
       // mockCoreDataManager.shouldReturnRegisteredEmail = true
        viewModel.name = "Test User"
        viewModel.email = "registered@example.com"
        viewModel.password = "Password123!"
        viewModel.cpassword = "Password123!"
        
        viewModel.handleRegistration()
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Email-id already registered")
    }
    
    func test_SuccessfulRegistration_ShouldSetRegisterStatus() {
        
        viewModel.name = "Test User"
        viewModel.email = "newuser@example.com"
        viewModel.password = "Password123!"
        viewModel.cpassword = "Password123!"
        
        viewModel.handleRegistration()
        XCTAssertTrue(viewModel.userregisterstatus)
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Successfully Registered")
        XCTAssertTrue(mockCoreDataManager.isUserLoggedIn(), "User should be logged in after successful registration")
    }
    
}

class MockCoreDataManager: CoreDataManager {
    var isEmailReg = false
    var saveSuccessfully = false
    
    override func isEmailRegistered(email: String) -> Bool {
        if email == "registered@example.com"{
            isEmailReg = true
        }else{
            isEmailReg = false
        }
        return isEmailReg
    }
    
    override func saveUser(name: String, email: String, password: String) -> Bool {
        saveSuccessfully = true
        return saveSuccessfully
    }
}

