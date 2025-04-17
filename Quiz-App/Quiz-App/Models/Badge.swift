//
//  Badge.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 24/02/25.
//

import Foundation
import SwiftUI

enum Badge: String, CaseIterable, Identifiable {
    case firstQuiz = "First Quiz Completed"
    case scoreAbove10 = "Best Score > 10"
    case hundredQuizzes = "100 Quizzes Completed"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .firstQuiz: return "star.fill"
        case .scoreAbove10: return "trophy.fill"
        case .hundredQuizzes: return "crown.fill"
        }
    }

    var color: Color {
        switch self {
        case .firstQuiz: return .yellow
        case .scoreAbove10: return .green
        case .hundredQuizzes: return .orange
        }
    }
}

