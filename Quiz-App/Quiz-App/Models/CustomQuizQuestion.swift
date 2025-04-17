//
//  CustomQuizQuestion.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 07/04/25.
//

import Foundation

struct CustomQuizQuestion: Identifiable {
    let id: UUID
    let questionText: String
    let options: [String]
    let correctIndex: Int
}
