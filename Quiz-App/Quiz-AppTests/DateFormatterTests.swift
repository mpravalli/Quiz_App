//
//  DateFormatterTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 17/03/25.
//

import XCTest

final class DateFormatterTests: XCTestCase {

    func test_ShortDateFormatter_ShouldReturnShortDateFormat() {
        let date = Date(timeIntervalSince1970: 0) // 1970-01-01
        let formattedDate = DateFormatter.shortDate.string(from: date)
        
        // Example output might be "1/1/70" or "01/01/1970" depending on the locale.
        XCTAssertFalse(formattedDate.isEmpty, "Short date formatter should return a non-empty string")
    }
    
    func test_ShortDateFormatter_ShouldReturnConsistentFormat() {
        let date = Date(timeIntervalSince1970: 0) // 1970-01-01
        let formattedDate = DateFormatter.shortDate.string(from: date)
        
        // Test consistency for a known date format
        let expectedDate = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        
        XCTAssertEqual(formattedDate, expectedDate, "Short date formatter should match localized format")
    }
}
