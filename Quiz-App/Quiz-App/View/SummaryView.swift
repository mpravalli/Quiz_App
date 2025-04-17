//
//  SummaryView.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 28/01/25.
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel: QuizViewModel
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View{
        ZStack{
            themeManager.backgroundColor.ignoresSafeArea()
            VStack{
                Text(LocalizedString("Quiz Summary"))
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                ScrollView {
                    
                    ForEach(viewModel.questions.indices, id: \.self) { index in
                        let question = viewModel.questions[index]
                        
                        VStack(alignment: .leading){
                            Text("\(index + 1). \(question.question)")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            Text("\(LocalizedString("Correct Answer:")) \(question.correct_answer)")
                                .bold()
                                .foregroundColor(.indigo)
                            
                            HStack{
                                Text("\(LocalizedString("Selected Answer:")) \(question.userSelectedAnswer ?? LocalizedString("Not Answered"))")
                                    .bold()
                                    .foregroundColor(.cyan)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(10)
                        
                    }.padding()
                    //.background(Color.green.opacity(0.2))
                }
                //NavigationView{
                NavigationLink(destination: HomeView().toolbar(.hidden)){
                    Text(LocalizedString("Goto Home"))
                        .frame(width:170,height: 50)
                        .cornerRadius(10)
                        .font(.headline)
                        .background(Color.indigo)
                        .foregroundColor(.white)
                }
                // }
                .frame(width:150,height:40)
                .background(Color.indigo)
            }
        }
    }
}

