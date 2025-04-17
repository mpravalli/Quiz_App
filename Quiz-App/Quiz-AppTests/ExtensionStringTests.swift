//
//  ExtentionStringTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 21/02/25.
//

import XCTest
@testable import Quiz_App
final class ExtentionStringTests: XCTestCase {

    func testDecodedHTML_BasicExample() {
        //Create a string with HTML entities
        let htmlString = "This is a &amp; test &lt;string&gt;."
        
        let decodedString = htmlString.decodedHTML
        XCTAssertEqual(decodedString, "This is a & test <string>.", "HTML entities should be decoded correctly")
    }
    
    func testDecodedHTML_MultipleEntities() {
        //Create a string with multiple HTML entities
        let htmlString = "&lt;div&gt;Hello &amp; Welcome&lt;/div&gt;"
        
        let decodedString = htmlString.decodedHTML
        XCTAssertEqual(decodedString, "<div>Hello & Welcome</div>", "Multiple HTML entities should be decoded correctly")
    }
    
    func testDecodedHTML_NoEntities() {
        //Create a string without HTML entities
        let plainString = "This is a plain string."
        
        let decodedString = plainString.decodedHTML
        XCTAssertEqual(decodedString, plainString, "String without HTML entities should remain unchanged")
    }
    
    func testDecodedHTML_EmptyString() {
        //Create an empty string
        let emptyString = ""
        
        let decodedString = emptyString.decodedHTML
        XCTAssertEqual(decodedString, "", "Empty string should remain empty")
    }
    
    func testDecodedHTML_SpecialCharacters() {
        //Create a string with special character HTML entities
        let htmlString = "&quot;Hello&apos;s World&quot;"
        
        let decodedString = htmlString.decodedHTML
        XCTAssertEqual(decodedString, "\"Hello's World\"", "Special character HTML entities should be decoded correctly")
    }
    
    func testDecodedHTML_NumericEntities() {
        //Create a string with numeric HTML entities
        let htmlString = "The character &#65; is &#x41;."
        
        let decodedString = htmlString.decodedHTML
        XCTAssertEqual(decodedString, "The character A is A.", "Numeric HTML entities should be decoded correctly")
    }
    
    func testDecodedHTML_MixedEntities() {
        //Create a string with mixed HTML entities
        let htmlString = "&lt;div&gt;Hello &amp; Welcome &#65;&lt;/div&gt;"
        
        let decodedString = htmlString.decodedHTML
        XCTAssertEqual(decodedString, "<div>Hello & Welcome A</div>", "Mixed HTML entities should be decoded correctly")
    }

}

