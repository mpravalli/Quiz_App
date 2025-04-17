//
//  QuizView.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 27/01/25.
//
import SwiftUI

struct QuizView: View {
    @ObservedObject var viewModel: QuizViewModel
    @StateObject var quizhistoryviewmodel = QuizHistoryViewModel()
    
    @State var showingActionSheet: Bool = false
    @State var showQuitAlert = false
    @EnvironmentObject var themeManager: ThemeManager
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.backgroundColor.ignoresSafeArea()
                
                VStack {
                    // Header and Timer
                    VStack(spacing: 10) {
                        HStack {
                            Text(LocalizedString("Quiz"))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Text(LocalizedString("\(viewModel.currentQuestionIndex + 1) \(LocalizedString("out of")) \(viewModel.questions.count)"))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        Text("\(LocalizedString("Time Remaining:")) \(viewModel.timerRemaining)")
                            .font(.headline)
                        ProgressView(value: viewModel.progress)
                    }
                    .padding()
                    .padding(.top, 40)
                    
                    // Questions and Answers
                    ScrollView {
                        VStack(spacing: 20) {
                            if !viewModel.questions.isEmpty && viewModel.currentQuestionIndex < viewModel.questions.count {
                                Text(viewModel.questions[viewModel.currentQuestionIndex].question)
                                    .font(.title2)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                                    //.fixedSize(horizontal: false, vertical: true)
                                    //.offset(x: viewModel.animateQuestion ? 0 : -300)
                                    //.opacity(viewModel.animateQuestion ? 1 : 0)
                            } else {
                                Text("Loading questions....")
                            }
                            
                            if viewModel.currentQuestionIndex < viewModel.questions.count {
                                ForEach(viewModel.questions[viewModel.currentQuestionIndex].allAnswers, id: \.self) { answer in
                                    Button(action: {
                                        viewModel.checkAnswer(answer)
                                    }) {
                                        Text(answer)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                viewModel.selectedAnswer == answer
                                                ? (answer == viewModel.questions[viewModel.currentQuestionIndex].correct_answer ? Color.green : Color.red.opacity(0.7))
                                                : Color.gray.opacity(0.1)
                                            )
                                            .cornerRadius(8)
                                    }
                                    .disabled(viewModel.selectedAnswer != nil)
                                    .background(.white.opacity(0.6))
                                    .cornerRadius(15)
                                    .foregroundColor(.black)
                                    //.offset(x: viewModel.animateAnswers ? 0 : -350) // Slide from bottom
                                    //.opacity(viewModel.animateAnswers ? 1 : 0)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    // Buttons
                    VStack {
                        Button(action: {
                            if viewModel.currentQuestionIndex < viewModel.questions.count - 1 {
                                viewModel.moveToNextQuestion()
                            }
                        }) {
                            Text(LocalizedString("Next Question"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(viewModel.currentQuestionIndex >= viewModel.questions.count - 1 ? Color.gray : Color.indigo)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.currentQuestionIndex >= viewModel.questions.count - 1)
                        .padding()
                        
                        Button(action: {
                            viewModel.pauseTimer()
                            showQuitAlert = true
                        }) {
                            Text(LocalizedString("Complete Test"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.indigo)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                    .padding()
                    
                    // Sheet for Results
                    .fullScreenCover(isPresented: $showingActionSheet) {
                        resultSheet
                    }
                    
                    // Navigation Links
                    NavigationLink(destination: SummaryView(viewModel: viewModel).toolbar(.hidden), isActive: $viewModel.navigateToSummary) {
                        EmptyView()
                    }
                    NavigationLink(destination: QuizView(viewModel: viewModel).toolbar(.hidden), isActive: $viewModel.navigateToQuiz) {
                        EmptyView()
                    }
                    NavigationLink(destination: HomeView().toolbar(.hidden), isActive: $viewModel.navigateToHome) {
                        EmptyView()
                    }
                }
                .alert(isPresented: $showQuitAlert) {
                    Alert(
                        title: Text(LocalizedString("Are you sure you want to quit the quiz?")),
                        message: Text(LocalizedString("Your Score will be saved.")),
                        primaryButton: .destructive(Text(LocalizedString("Yes"))) {
                            viewModel.saveResult(
                                category: viewModel.selectedCategoryName,
                                level: viewModel.selectedLevel,
                                score: Int16(viewModel.score),
                                totalquestions: Int16(viewModel.questions.count)
                            )
                            viewModel.showResult = true
                        },
                        secondaryButton: .cancel {
                            viewModel.startTimer()
                        }
                    )
                }
                .onAppear {
                    viewModel.startTimer()
                    withAnimation(.easeInOut(duration: 1.0)) {
                        viewModel.animateQuestion = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 2.0)) {
                            viewModel.animateAnswers = true
                        }
                    }
                }
                .onChange(of: viewModel.showResult) {
                    if viewModel.showResult {
                        showingActionSheet = true
                    }
                }
                
            }
        }
    }
    
    // Custom Bottom Sheet for Result
    private var resultSheet: some View {
        VStack(spacing: 20) {
            Text(LocalizedString("Quiz Completed"))
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("\(LocalizedString("Score:")) \(viewModel.score) / \(viewModel.questions.count)")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            if viewModel.score<10{
                Text(LocalizedString("Result: Fail"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(LocalizedString("Try again"))
                    .font(.headline)
            }else{
                Text(LocalizedString("Result: Pass"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            
            Text(LocalizedString("Earned Badges"))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.cyan)
            
            //badge
            VStack(alignment: .leading, spacing: 10) {
                
                if quizhistoryviewmodel.earnedBadges.isEmpty {
                    Text(LocalizedString("No badges earned yet. Keep playing!"))
                        .foregroundColor(.white)
                        .italic()
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(quizhistoryviewmodel.earnedBadges) { badge in
                                BadgeView(badge: badge)
                            }
                        }
                    }
                }
            }
            .padding()
            .padding(.leading,15)
            .padding(.trailing,15)
            
            //buttons
            VStack(spacing: 12) {
                Button(action: {
                    viewModel.navigateToSummary = true
                    showingActionSheet = false
                }) {
                    Text(LocalizedString("Summary"))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    viewModel.restartQuiz()
                    showingActionSheet = false
                }) {
                    Text(LocalizedString("Retry Quiz"))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    viewModel.returnToHome()
                    showingActionSheet = false
                }) {
                    Text(LocalizedString("Return to Home"))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
            }
            .padding(.horizontal)
        }
        .padding()
        .background(themeManager.backgroundColor)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
        .padding(.bottom,70)
    }
}

#Preview {
    QuizView(viewModel: QuizViewModel())
        .environmentObject(ThemeManager())
}

