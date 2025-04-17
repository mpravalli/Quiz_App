//
//  TriviaQuestionTests.swift
//  Quiz-AppTests
//
//  Created by Makula Pravallika on 20/02/25.
//

import XCTest
@testable import Quiz_App
final class TriviaQuestionTests: XCTestCase {

    func testTriviaQuestionDecoding() {
            let json = """
            {
                "question": "What is the capital of France?",
                "correct_answer": "Paris",
                "incorrect_answers": ["London", "Berlin", "Madrid"]
            }
            """.data(using: .utf8)!
            
            let decoder = JSONDecoder()
            let question = try? decoder.decode(TriviaQuestion.self, from: json)
            
            XCTAssertNotNil(question)
            XCTAssertEqual(question?.question, "What is the capital of France?")
            XCTAssertEqual(question?.correct_answer, "Paris")
            XCTAssertEqual(question?.incorrect_answers, ["London", "Berlin", "Madrid"])
        }
    func testTriviaResponseDecoding() {
            let json = """
            {
                "results": [
                    {
                        "question": "What is 2+2?",
                        "correct_answer": "4",
                        "incorrect_answers": ["3", "5", "6"]
                    }
                ]
            }
            """.data(using: .utf8)!
            
            let decoder = JSONDecoder()
            let response = try? decoder.decode(TriviaResponse.self, from: json)
            
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.results.count, 1)
            XCTAssertEqual(response?.results.first?.question, "What is 2+2?")
            XCTAssertEqual(response?.results.first?.correct_answer, "4")
        }
}

