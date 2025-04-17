//
//  CategoryView.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 17/02/25.
//

import SwiftUI

struct CategoryView: View {
    @ObservedObject var viewModel: QuizViewModel
    @State private var navigateToQuiz = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.backgroundColor.ignoresSafeArea()
                VStack(spacing: 40) {
                    HStack {
                        Text(LocalizedString("Select Options"))
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top)
                    }
                    
                    HStack {
                        Text(LocalizedString("Category:"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(width: 150, alignment: .leading)
                        
                        Spacer()
                        Spacer()
                        
                        Picker("Category", selection: $viewModel.selectedCategory) {
                            ForEach(viewModel.categories, id: \.id) { category in
                                Text(LocalizedString(category.name)).tag(String(category.id))
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        .onChange(of: viewModel.selectedCategory) { newCategoryId in
                            if let newCategoryIdInt = Int(newCategoryId), // If you convert to Int
                               let selectedCategory = viewModel.categories.first(where: { $0.id == newCategoryIdInt }) {
                                viewModel.selectedCategoryName = selectedCategory.name
                            }
                        }
                        .onAppear{
                            if viewModel.selectedCategory.isEmpty, let firstCategory = viewModel.categories.first {
                                viewModel.selectedCategory = String(firstCategory.id)
                            }
                        }
                    }
                    
                    HStack {
                        Text(LocalizedString("Level:"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(width: 150, alignment: .leading)
                        
                        Spacer()
                        Spacer()
                        
                        Picker("Level", selection: $viewModel.selectedLevel) {
                            ForEach(viewModel.levels, id: \.self) { level in
                                Text(LocalizedString(level.capitalized)).tag(level)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onAppear {
                            // Set a default level if none is selected
                            if viewModel.selectedLevel.isEmpty, let firstLevel = viewModel.levels.first {
                                viewModel.selectedLevel = firstLevel
                            }
                        }
                        
                    }.padding(.horizontal)
                    
                    Button(LocalizedString("Start Quiz")) {
                        Task {
                            await viewModel.fetchQuestions()
                            navigateToQuiz = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(15)
                    
                    NavigationLink(destination: QuizView(viewModel: viewModel).toolbar(.hidden), isActive: $navigateToQuiz) {
                        EmptyView()
                    }
                }.padding(.horizontal,40)
            }
        }.tint(.indigo)
        
    }
}

#Preview {
    CategoryView(viewModel: QuizViewModel())
        .environmentObject(ThemeManager())
}
