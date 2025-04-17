//
//  CustomQuizPlayView.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 07/04/25.
//
import SwiftUI

struct CustomQuizPlayView: View {
    let questions: [CustomQuizQuestion]
    @State private var selectedIndices: [UUID: Int] = [:]
    @State private var isCompleted = false
    @EnvironmentObject var themeManager: ThemeManager

    var score: Int {
        questions.reduce(0) { result, question in
            result + (selectedIndices[question.id] == question.correctIndex ? 1 : 0)
        }
    }

    var body: some View {
        ZStack {
            themeManager.backgroundColor.ignoresSafeArea()
            VStack {
                if isCompleted {
                    VStack {
                        Text("Quiz Completed!")
                            .font(.title)
                            .bold()
                        Text("Your score: \(score)/\(questions.count)")
                            .font(.headline)
                    }
                    .padding()
                }

                List {
                    ForEach(questions) { question in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(question.questionText)
                                .font(.headline)
                            
                            ForEach(0..<question.options.count, id: \.self) { index in
                                let isSelected = selectedIndices[question.id] == index
                                let isCorrect = question.correctIndex == index
                                let wasUserCorrect = selectedIndices[question.id] == question.correctIndex

                                HStack {
                                    Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                                    Text(question.options[index])
                                }
                                .padding(6)
                                .background(
                                    isCompleted ?
                                        (isCorrect ? Color.green.opacity(0.3) :
                                         isSelected ? Color.red.opacity(0.3) : Color.clear)
                                    : Color.clear
                                )
                                .cornerRadius(8)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if !isCompleted {
                                        selectedIndices[question.id] = index
                                    }
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 6)
                    }
                }
                .scrollContentBackground(.hidden)

                if !isCompleted {
                    Button("Submit Quiz") {
                        isCompleted = true
                    }
                    .disabled(selectedIndices.count < questions.count)
                    .padding()
                    .background(.indigo)
                }
            }
        }
        .navigationTitle("Custom Quiz")
        .toolbarBackground(themeManager.backgroundColor.opacity(0.8), for: .navigationBar)
    }
}
