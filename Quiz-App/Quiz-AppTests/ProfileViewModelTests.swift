//
//  ProfileViewModelTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 10/02/25.
//

import XCTest
import CoreData
@testable import Quiz_App

class ProfileViewModelTests: XCTestCase {
    
    var viewModel: ProfileViewModel!
    var coreDataManager: CoreDataManager!
    var testContext: NSManagedObjectContext!
    
    override func setUp() {
        /*super.setUp()
        coreDataManager = CoreDataManager.shared
        
        // Use an in-memory store for testing
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        coreDataManager.persistentContainer = NSPersistentContainer(name: "Quiz_App")
        coreDataManager.persistentContainer.persistentStoreDescriptions = [description]

        coreDataManager.persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }*/
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
        
        viewModel = ProfileViewModel(manager: coreDataManager)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        testContext = nil
        coreDataManager = nil
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.username, "", "Initial username should be empty")
        XCTAssertEqual(viewModel.email, "", "Initial email should be empty")
        XCTAssertNil(viewModel.user, "Initial user should be nil")
    }
    
    // Helper function to create a mock user in Core Data
    func createMockUser(name: String, email: String) {
        
        let context = coreDataManager.context
        let user = User(context: context)
        user.name = name
        user.email = email
        
        do {
            try context.save()
        } catch {
            print("Failed to save mock user: \(error.localizedDescription)")
        }
    }
    
    // Test fetching user profile
    func testFetchUserProfile() {
        
        createMockUser(name: "John Doe", email: "john.doe@example.com")
        
        coreDataManager.loginUser(email: "john.doe@example.com")
        
        viewModel.fetchUserProfile()
        
        XCTAssertEqual(viewModel.username, "John Doe", "Username should be John Doe")
        XCTAssertEqual(viewModel.email, "john.doe@example.com", "Email should be john.doe@example.com")
        XCTAssertNotNil(viewModel.user,"user data stored")
    }
    
    func testFetchUserProfileWhenNotLoggedIn() {
        // Ensure no user is logged in
        coreDataManager.logoutUser()
        
        viewModel.fetchUserProfile()
        
        XCTAssertEqual(viewModel.username, "", "Username should be empty when not logged in")
        XCTAssertEqual(viewModel.email, "", "Email should be empty when not logged in")
        XCTAssertNil(viewModel.user, "User should be nil when not logged in")
    }
    
    func test_Logout_Successfully() {
        viewModel.logout()
        XCTAssertFalse(viewModel.isLoggedIn,"User successfully log out")
    }
 
 
}

