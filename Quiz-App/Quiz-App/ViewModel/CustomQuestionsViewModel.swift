//
//  CustomQuestionsViewModel.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 07/04/25.
//

import Foundation
import SwiftUI

class CustomQuestionsViewModel: ObservableObject {
    @Published var customQuestions: [CustomQuizQuestion] = []

    @Published var questionText = ""
    @Published var options: [String] = ["", "", "", ""]
    @Published var correctIndex = 0

    @Published var showAddForm = false
    @Published var showPlayView = false
    
    var coredatamanager = CoreDataManager()

    init() {
        fetchQuestions()
    }

    func fetchQuestions() {
        let saved = coredatamanager.fetchCustomQuestions()
        self.customQuestions = saved.map {
            CustomQuizQuestion(
                id: $0.id ?? UUID(),
                questionText: $0.questionText ?? "",
                options: [$0.option1 ?? "", $0.option2 ?? "", $0.option3 ?? "", $0.option4 ?? ""],
                correctIndex: Int($0.correctIndex)
            )
        }
    }

    func validateAndAddQuestion() -> Bool {
        guard !questionText.isEmpty, options.allSatisfy({ !$0.isEmpty }) else { return false }

        coredatamanager.saveCustomQuestion(
            question: questionText,
            option1: options[0],
            option2: options[1],
            option3: options[2],
            option4: options[3],
            correctIndex: correctIndex
        )

        resetForm()
        fetchQuestions()
        return true
    }

    func deleteQuestion(at offsets: IndexSet) {
        let saved = coredatamanager.fetchCustomQuestions()
        offsets.forEach { index in
            coredatamanager.deleteCustomQuestion(saved[index])
        }
        fetchQuestions()
    }

    func resetForm() {
        questionText = ""
        options = ["", "", "", ""]
        correctIndex = 0
    }
}
