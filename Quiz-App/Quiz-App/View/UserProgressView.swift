//
//  UserProgressView.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 04/02/25.
//

import SwiftUI

struct UserProgressView: View {
    @ObservedObject var viewModel: QuizHistoryViewModel
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 10) {
                    Text(LocalizedString("User Progress"))
                        .foregroundColor(.black)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text(LocalizedString("Total Quizzes Played:"))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(viewModel.totalQuizzes)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Text(LocalizedString("Best Score:"))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(viewModel.bestScore)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.6)))
                .padding(.horizontal)
                .padding(15)
                // Badges Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(LocalizedString("Earned Badges"))
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if viewModel.earnedBadges.isEmpty {
                        Text(LocalizedString("No badges earned yet. Keep playing!"))
                            .foregroundColor(.gray)
                            .italic()
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(viewModel.earnedBadges) { badge in
                                    BadgeView(badge: badge)
                                }
                            }
                        }
                    }
                }
                .padding()
                .padding(.leading,15)
                .padding(.trailing,15)
            }
            .onAppear { viewModel.updateBadges() }
        }
    }
}

#Preview {
    UserProgressView(viewModel: QuizHistoryViewModel())
}
