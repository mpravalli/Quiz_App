//
//  TriviaQuestion.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 28/01/25.
//
// Question
import Foundation
struct TriviaQuestion: Identifiable, Decodable {
    let id = UUID() // For Identifiable conformance
    var question: String
    var correct_answer: String
    var incorrect_answers: [String]
    var allAnswers: [String] = []
    var userSelectedAnswer: String?
    
    enum CodingKeys: String, CodingKey {
    case question
    case correct_answer
    case incorrect_answers
    }
}

struct TriviaResponse: Decodable {
    var results: [TriviaQuestion]
}
