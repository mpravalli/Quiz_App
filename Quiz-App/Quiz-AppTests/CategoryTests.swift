//
//  CategoryTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 20/02/25.
//
import XCTest
@testable import Quiz_App

class CategoryTests: XCTestCase {

    func testTriviaCategoryResponseDecoding() {
        let json = """
        {
            "trivia_categories": [
                {"id": 9, "name": "General Knowledge"},
                {"id": 10, "name": "Entertainment: Books"}
            ]
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try? decoder.decode(TriviaCategoryResponse.self, from: json)
        
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.trivia_categories.count, 2)
        XCTAssertEqual(response?.trivia_categories.first?.id, 9)
        XCTAssertEqual(response?.trivia_categories.first?.name, "General Knowledge")
    }
    
    func testCategoryHashable() {
        let category1 = TriviaCategory(id: 9, name: "General Knowledge")
        let category2 = TriviaCategory(id: 9, name: "General Knowledge")
        let category3 = TriviaCategory(id: 10, name: "Entertainment: Books")
        
        XCTAssertEqual(category1, category2)
        XCTAssertNotEqual(category1, category3)
    }
    
    func testCategoryEncoding() {
        let category = TriviaCategory(id: 12, name: "Science")
        let encoder = JSONEncoder()
        let data = try? encoder.encode(category)
        XCTAssertNotNil(data)
    }
    
    func testCategoryCountResponseDecoding() {
        let json = """
        {
            "category_id": 9,
            "category_question_count": {
                "total_question_count": 100,
                "total_easy_question_count": 40,
                "total_medium_question_count": 30,
                "total_hard_question_count": 30
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try? decoder.decode(CategoryCountResponse.self, from: json)
        
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.category_id, 9)
        XCTAssertEqual(response?.category_question_count.total_question_count, 100)
        XCTAssertEqual(response?.category_question_count.total_easy_question_count, 40)
        XCTAssertEqual(response?.category_question_count.total_medium_question_count, 30)
        XCTAssertEqual(response?.category_question_count.total_hard_question_count, 30)
    }
    
    func testCategoryQuestionCountEncoding() {
        let questionCount = CategoryQuestionCount(
            total_question_count: 200,
            total_easy_question_count: 80,
            total_medium_question_count: 70,
            total_hard_question_count: 50
        )
        let encoder = JSONEncoder()
        let data = try? encoder.encode(questionCount)
        XCTAssertNotNil(data)
    }
}


