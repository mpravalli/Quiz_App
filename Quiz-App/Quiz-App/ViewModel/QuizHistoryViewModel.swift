//
//  QuizHistoryViewModel.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 03/02/25.
//

import Foundation

class QuizHistoryViewModel: ObservableObject {
    @Published var quizHistory: [QuizResultt] = []
    @Published var totalQuizzes: Int = 0
    @Published var bestScore: Int = 0
    @Published var earnedBadges: [Badge] = []
    
    var currentUserEmail: String?
    
    private var coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared, userEmail: String? = nil) {
        self.coreDataManager = coreDataManager
        self.currentUserEmail = userEmail
        fetchQuizHistory()
    }
    
    func fetchQuizHistory() {
        let allResults = coreDataManager.fetchQuizResults()
        
        // Filter by user email if provided
        if let userEmail = currentUserEmail {
            quizHistory = allResults.filter { $0.useremail == userEmail }
        } else {
            quizHistory = allResults
        }
        
        calculateUserProgress()
    }
    
    func calculateUserProgress() {
        totalQuizzes = quizHistory.count
        bestScore = quizHistory.map { Int($0.score) }.max() ?? 0
        updateBadges()
    }
    
    //badges
    func updateBadges() {
        var newBadges: [Badge] = []
        
        if totalQuizzes >= 1 && !coreDataManager.isBadgeAlreadyAwarded(.firstQuiz) {
            newBadges.append(.firstQuiz)
            coreDataManager.saveBadge(.firstQuiz)
        }
      
        if bestScore > 10 && !coreDataManager.isBadgeAlreadyAwarded(.scoreAbove10) {
            newBadges.append(.scoreAbove10)
            coreDataManager.saveBadge(.scoreAbove10)
        }
        
        if totalQuizzes >= 100 && !coreDataManager.isBadgeAlreadyAwarded(.hundredQuizzes) {
            newBadges.append(.hundredQuizzes)
            coreDataManager.saveBadge(.hundredQuizzes)
        }

        //Fetch badges for the logged-in user
        earnedBadges = coreDataManager.fetchEarnedBadges()
    }

    
}


