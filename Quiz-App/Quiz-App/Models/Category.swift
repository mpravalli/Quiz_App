//
//  Category.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 27/01/25.
//

struct TriviaCategoryResponse: Codable {
    let trivia_categories: [TriviaCategory]
}

struct TriviaCategory: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
}

// Define the CategoryCountResponse struct to match the API response for category count
struct CategoryCountResponse: Codable {
    let category_id: Int
    let category_question_count: CategoryQuestionCount
}

struct CategoryQuestionCount: Codable {
    let total_question_count: Int
    let total_easy_question_count: Int
    let total_medium_question_count: Int
    let total_hard_question_count: Int
}
