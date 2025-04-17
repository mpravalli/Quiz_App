//
//  AddCustomQuestionView.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 07/04/25.
//

import SwiftUI

struct AddCustomQuestionView: View {
    @ObservedObject var viewModel: CustomQuestionsViewModel
    @State private var showAlert = false
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack{
            themeManager.backgroundColor.ignoresSafeArea()
            Form {
                Section(header: Text("Question").foregroundColor(.white)) {
                    TextField("Enter your question", text: $viewModel.questionText)
                }
                
                Section(header: Text("Options").foregroundColor(.white)) {
                    ForEach(0..<4, id: \.self) { index in
                        TextField("Option \(index + 1)", text: $viewModel.options[index])
                    }
                }
                
                Text("Choose correct Index")
                    .font(.caption)
                
                Picker("Correct Answer", selection: $viewModel.correctIndex) {
                    ForEach(0..<4) { index in
                        Text("Option \(index + 1)").tag(index)
                    }
                }
                .pickerStyle(.segmented)
                
                Button("Add Question") {
                    if viewModel.validateAndAddQuestion() {
                        showAlert = false
                    } else {
                        showAlert = true
                    }
                }.foregroundColor(.indigo)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid input"), message: Text("Please fill all fields"), dismissButton: .default(Text("OK")))
                }
                
                NavigationLink("Play Quiz", destination: CustomQuizPlayView(questions: viewModel.customQuestions))
                    .disabled(viewModel.customQuestions.isEmpty)
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Add Question")
        }
    }
}


#Preview {
    AddCustomQuestionView(viewModel: CustomQuestionsViewModel())
        .environmentObject(ThemeManager())
}
