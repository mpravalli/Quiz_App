//
//  LanguageManagerTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 19/03/25.
//

import XCTest
@testable import Quiz_App

final class LanguageManagerTests: XCTestCase {

    var languageManager: LanguageManager!

    override func setUp() {
        super.setUp()
        languageManager = LanguageManager.shared
    }

    override func tearDown() {
        languageManager = nil
        super.tearDown()
    }


    // Test default language is set correctly
    func testDefaultLanguage_ShouldBeSystemLanguageOrEnglish() {
        
        let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        
        XCTAssertEqual(systemLanguage, "en", "Default language should match system language or fallback to English.")
    }

    
    // Test UserDefaults should persist language
    func testSetLanguage_ShouldPersistLanguageInUserDefaults() {
        
        languageManager.setLanguage("de")
        
        let storedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage")
        XCTAssertEqual(storedLanguage, "de", "Language should persist in UserDefaults.")
    }
    
    func testLocalizedString_ShouldReturnCorrectValueForExistingKey() {
        
        let key = "Submit"
        let expectedValue = "Einreichen"
        Bundle.setLanguage("de")
        let localizedString = LocalizedString(key)
        
        XCTAssertEqual(localizedString, expectedValue, "Localized string should match the expected value.")
    }
    
    func testLocalizedString_ShouldReturnKeyIfNoLocalizationExists() {
        
        let key = "NonExistentKey"
        let localizedString = LocalizedString(key)
        
        XCTAssertEqual(localizedString, key, "Should return key if localization is missing.")
    }
    
    func testLocalizedString_ShouldReturnCorrectValueAfterLanguageChange() {
        
        let key = "Submit"
        let expectedValueInFrench = "Soumettre"
        
        Bundle.setLanguage("fr")
        let localizedString = LocalizedString(key)
        
        XCTAssertEqual(localizedString, expectedValueInFrench, "Localized string should reflect the changed language.")
    }
    
      
    func testSingletonInstance() {
    
        UserDefaults.standard.removeObject(forKey: "selectedLanguage")
        
        let instance1 = LanguageManager.shared
        let instance2 = LanguageManager.shared
        
        XCTAssertTrue(instance1 === instance2,
                    "shared property should return the same instance")
        
        XCTAssertTrue(type(of: instance1).shared === instance1,
                    "shared property should return the same instance")
        
        instance1.setLanguage("fr")
        XCTAssertEqual(instance2.selectedLanguage, "fr",
                     "State should be shared between instances")
    
        let newInstance = LanguageManager.shared
        XCTAssertEqual(newInstance.selectedLanguage, "fr",
                     "New instances should get persisted state")
    }
    
    func testDefaultLanguageFromLocale() {
        UserDefaults.standard.removeObject(forKey: "selectedLanguage")

        // Force LanguageManager to reset its value
        let selectedLanguage: String = UserDefaults.standard.string(forKey: "selectedLanguage") ?? Locale.current.language.languageCode?.identifier ?? "en"

        XCTAssertEqual(selectedLanguage,"en",
                       "Should fallback to system locale language")
    }


    
}
