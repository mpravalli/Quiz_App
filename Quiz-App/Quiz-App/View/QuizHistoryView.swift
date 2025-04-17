//
//  QuizHistoryView.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 03/02/25.
//

//Leader board

import SwiftUI

struct QuizHistoryView: View {
    @StateObject var viewModel = QuizHistoryViewModel()
    @EnvironmentObject var themeManager:ThemeManager
    var body: some View {
        NavigationView{
            ZStack{
                themeManager.backgroundColor.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 10){
                        Text(LocalizedString("Leader Board"))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        UserProgressView(viewModel: viewModel).environmentObject(themeManager)
                        
                        VStack(){
                            Spacer()
                            Text(LocalizedString("Quiz History"))
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        ForEach(viewModel.quizHistory, id: \.id) { quiz in
                            QuizHistoryCard(quiz: quiz)
                        }
                        .onAppear{
                            viewModel.fetchQuizHistory()
                        }
                    }.padding()
                }.padding(.top,35)
            }
        }
    }
}
struct QuizHistoryCard: View{
    let quiz: QuizResultt
    var body: some View{
        VStack(alignment: .leading){
            Text("\(LocalizedString("Category:")), \(LocalizedString(quiz.category ?? ""))")
                .font(.headline)
                .foregroundColor(.black)
            Text("\(LocalizedString("Level:")), \(LocalizedString(quiz.level ?? ""))")
                .font(.subheadline)
                .foregroundColor(.black)
            Text("\(LocalizedString("Score:")), \(quiz.score)/\(quiz.totalquestions)")
                .font(.subheadline)
                .foregroundColor(.black)
            Text("\(LocalizedString("Date:")) \(quiz.date!,formatter: DateFormatter.shortDate)")
                .font(.caption)
                .foregroundColor(.black)
        }
        .padding(.leading,5)
        .padding()
        .frame(maxWidth: .infinity,alignment: .leading)
        .background(Color.white.opacity(0.6))
        .cornerRadius(10)
        .padding(.leading,30)
        .padding(.trailing,30)
    }
}

#Preview {
    QuizHistoryView()
        .environmentObject(ThemeManager())
}
