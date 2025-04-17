//
//  BundleTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 19/03/25.
//

import XCTest
@testable import Quiz_App

final class BundleExtensionTests: XCTestCase {

    private var testbundleKey: UInt8 = 0
    
    override func setUp() {
        
        super.setUp()
        Bundle.setLanguage("en")
        
    }

    override func tearDown() {
        
        super.tearDown()
        Bundle.setLanguage("en")
        
    }
    
    func testSetLanguage_ValidLanguage_ShouldChangeLanguageBundle() {
        
        let languageCode = "fr"
        Bundle.setLanguage(languageCode)
        
        let localizedString = NSLocalizedString("Submit", bundle: Bundle.main.currentLocalizedBundle, comment: "")
        
        XCTAssertEqual(localizedString, "Soumettre", "The language should be set to French.")
    }
    

    func testSetLanguage_ShouldPersistAcrossCalls() {
        
        let languageCode = "de"
        Bundle.setLanguage(languageCode)
        
        let localizedStringAfterChange = NSLocalizedString("Submit", bundle: Bundle.main.currentLocalizedBundle, comment: "")
        
        XCTAssertEqual(localizedStringAfterChange, "Einreichen", "The language should persist after being set.")
        
        Bundle.setLanguage("en")
        
        let localizedStringAfterReset = NSLocalizedString("Submit", bundle: Bundle.main.currentLocalizedBundle, comment: "")
        
        XCTAssertEqual(localizedStringAfterReset, "Submit", "The language should reset to English.")
    }
    
    
    // Test currentLocalizedBundle falls back to Bundle.main
    func testCurrentLocalizedBundle_ShouldReturnMainBundleIfNotSet() {
        objc_setAssociatedObject(Bundle.main, &testbundleKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        _ = Bundle.main.currentLocalizedBundle
    }
    
    //invalid language 
    func testSetLanguage_InvalidLanguage_ShouldNotChangeBundle() {
        let invalidLanguageCode = "xyz"
        Bundle.setLanguage(invalidLanguageCode)
        _ = Bundle.main.currentLocalizedBundle
    }

}
