//
//  QuizViewModel.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 03/02/25.
//

import Foundation
import SwiftUICore
import Combine

@MainActor
class QuizViewModel: ObservableObject {
    @Published var categories: [TriviaCategory] = []
    @Published var levels: [String] = ["easy", "medium", "hard"]
    @Published var selectedCategory: String = "9"
    @Published var selectedLevel: String = "easy"
    @Published var questions: [TriviaQuestion] = []
    @Published var currentQuestionIndex: Int = 0
    
    
    @Published var selectedAnswer: String? = nil
    @Published var score: Int = 0
    @Published var timerRemaining: Int = 20
    @Published var showResult: Bool = false
    @Published var progress: CGFloat = 0.0
    @Published var navigateToSummary:Bool = false
    @Published var navigateToHome:Bool = false
    @Published var navigateToQuiz:Bool = false
    @Published var selectedCategoryName: String = "General Knowledge"
    
    @Published var animateQuestion: Bool = false
    @Published var animateAnswers: Bool = false
    
    
    var timer: Timer?
    var timeWhenPaused: Int?
    var quizCompleted: Bool = false
    
    @Published var lastQuestionIndexBeforeRestart: Int = 0
    @Published var scoreBeforeRestart: Int = 0
    
    
    var coredatamanager = CoreDataManager()
    
    private var session: NetworkSession
    
    
    init(session: NetworkSession = URLSession.shared) { // Inject URLSession
        self.session = session
        Task{
            await fetchCategories()
        }
    }
    
    func fetchCategories() async {
            let urlString = "https://opentdb.com/api_category.php"
            guard let url = URL(string: urlString) else { return }
            
            do {
                let (data, _) = try await session.data(from: url) // Use injected session
                let response = try JSONDecoder().decode(TriviaCategoryResponse.self, from: data)
                categories = response.trivia_categories
            } catch {
                print("Error fetching categories: \(error)")
                categories = []
            }
        }
    
    func fetchQuestions() async {
            let categoryCountUrlString = "https://opentdb.com/api_count.php?category=\(selectedCategory)"
            guard let categoryCountUrl = URL(string: categoryCountUrlString) else { return }
            
            do {
                let (countData, _) = try await session.data(from: categoryCountUrl)
                let countResponse = try JSONDecoder().decode(CategoryCountResponse.self, from: countData)
                
                let totalQuestions: Int
                switch selectedLevel {
                case "easy":
                    totalQuestions = countResponse.category_question_count.total_easy_question_count
                case "medium":
                    totalQuestions = countResponse.category_question_count.total_medium_question_count
                case "hard":
                    totalQuestions = countResponse.category_question_count.total_hard_question_count
                default:
                    totalQuestions = countResponse.category_question_count.total_question_count
                }

                let amount = min(totalQuestions, 25)
                let urlString = "https://opentdb.com/api.php?amount=\(amount)&category=\(selectedCategory)&difficulty=\(selectedLevel)"
                guard let url = URL(string: urlString) else { return }

                let (data, _) = try await session.data(from: url) // Use injected session
                let response = try JSONDecoder().decode(TriviaResponse.self, from: data)

                questions = response.results.map { question in
                    var decodedQuestion = question
                    decodedQuestion.question = decodedQuestion.question.decodedHTML
                    decodedQuestion.correct_answer = decodedQuestion.correct_answer.decodedHTML
                    decodedQuestion.incorrect_answers = decodedQuestion.incorrect_answers.map { $0.decodedHTML }
                    decodedQuestion.allAnswers = ([decodedQuestion.correct_answer] + decodedQuestion.incorrect_answers).shuffled()
                    return decodedQuestion
                }
            } catch {
                print("Error fetching questions: \(error)")
            }
        }
    
    func startTimer() {
        
        timer?.invalidate()  // Stop any existing timer
        
        // Resume from paused time if available, otherwise start fresh
        if let timeWhenPaused = timeWhenPaused {
            timerRemaining = timeWhenPaused
            self.timeWhenPaused = nil  // Clear pause time after resuming
        } else {
            if selectedAnswer != nil{
                timerRemaining = 0
            }else{
                timerRemaining = 20 } // Default time for a new question
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            Task { @MainActor in
                DispatchQueue.main.async{
                    if self.timerRemaining > 0 {
                        self.timerRemaining -= 1
                    } else {
                        self.timer?.invalidate()
                        
                        if self.currentQuestionIndex == self.questions.count - 1 {
                            self.completeTest()
                        } else {
                            self.moveToNextQuestion()
                        }
                    }
                }
            }
        }
    }
    
    
    func pauseTimer() {
        // Pause the timer and store the current remaining time
        if selectedAnswer == nil{
            timeWhenPaused = timerRemaining
            timer?.invalidate()
        }
    }
    
    func moveToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
            progress = CGFloat(currentQuestionIndex + 1) / CGFloat(questions.count)
            startTimer()
        } else {
            completeTest()
        }
        /*//print(progress)
        DispatchQueue.main.async {
               self.animateQuestion = false // Reset question animation
               self.animateAnswers = false  // Reset answers animation
           }
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               if self.currentQuestionIndex < self.questions.count - 1 {
                   self.currentQuestionIndex += 1
                   self.selectedAnswer = nil
                   self.progress = CGFloat(self.currentQuestionIndex + 1) / CGFloat(self.questions.count)
                   self.startTimer()
                   
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                       withAnimation(.easeInOut(duration: 1.0)) {
                           self.animateQuestion = true // Animate question first
                       }
                       
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                           withAnimation(.easeInOut(duration: 2.0)) {
                               self.animateAnswers = true // Animate options AFTER question
                           }
                       }
                   }
               } else {
                   self.completeTest()
               }
           }
        print(progress)*/
        
    }
    
    func checkAnswer(_ answer: String) {
        selectedAnswer = answer
        questions[currentQuestionIndex].userSelectedAnswer = answer
        if answer == questions[currentQuestionIndex].correct_answer {
            score += 1
        }
        timer?.invalidate()
    }
    
    func completeTest(){
        
        pauseTimer()
        showResult = true
        
    }
    
    func restartQuiz(){
        lastQuestionIndexBeforeRestart = currentQuestionIndex
        scoreBeforeRestart = score
        
        if lastQuestionIndexBeforeRestart == questions.count-1{
            currentQuestionIndex = 0
            score = 0  // Reset score
            timerRemaining = 20  // Reset timer
            showResult = false  // Hide results screen
            selectedAnswer = nil
            progress = CGFloat(currentQuestionIndex + 1) / CGFloat(questions.count)
            
            startTimer()
            navigateToQuiz = true
        }else{
            // Resume from the last question index
            currentQuestionIndex = lastQuestionIndexBeforeRestart
            
            // Accumulate the score (sum of before + after)
            score = scoreBeforeRestart
            
            // Reset the timer and UI state
            timerRemaining = 20
            showResult = false
            selectedAnswer = nil
            progress = CGFloat(currentQuestionIndex + 1) / CGFloat(questions.count)
            
            // Start the timer and navigate to the quiz
            startTimer()
            navigateToQuiz = true
        }
    }
    
    func returnToHome(){
        navigateToHome = true
    }
    
    func saveResult(category: String,level: String,score: Int16,totalquestions: Int16){
        
        coredatamanager.saveQuizResult(category: category, level: level, score: score, totalquestions: totalquestions)
        
    }
    
}

