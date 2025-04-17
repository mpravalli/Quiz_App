//
//  CustomQuestionsView.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 07/04/25.
//

import SwiftUI

struct CustomQuestionsView: View {
    @StateObject private var viewModel = CustomQuestionsViewModel()
    @EnvironmentObject var themeManager:ThemeManager
    
    var body: some View {
        NavigationStack {
            ZStack{
                themeManager.backgroundColor.ignoresSafeArea()
                VStack {
                    if viewModel.customQuestions.isEmpty {
                        Text("No custom questions added")
                            .font(.title2)
                            .padding()
                    } else {
                        List {
                            ForEach(viewModel.customQuestions) { question in
                                VStack(alignment: .leading) {
                                    Text(question.questionText).bold()
                                    ForEach(0..<question.options.count, id: \.self) { index in
                                        Text("\(["A", "B", "C", "D"][index]). \(question.options[index])")
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .padding(.vertical, 6)
                            }
                            .onDelete(perform: viewModel.deleteQuestion)
                        }
                        .scrollContentBackground(.hidden)
                    }
                    
                    HStack {
                        NavigationLink("Add", destination: AddCustomQuestionView(viewModel: viewModel))
                            .frame(width:100,height:50)
                            .background(.indigo)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        NavigationLink("Play Quiz", destination: CustomQuizPlayView(questions: viewModel.customQuestions))
                            .disabled(viewModel.customQuestions.isEmpty)
                            .frame(width:100,height:50)
                            .background(.indigo)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .padding()
                    .padding()
                }.padding()
                
            }
            .navigationTitle("Custom Questions")
            .toolbarBackground(themeManager.backgroundColor.opacity(0.8), for: .navigationBar)
        }
    }
}
#Preview {
    CustomQuestionsView()
        .environmentObject(ThemeManager())
}
