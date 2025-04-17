//
//  HomeView.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 21/01/25.
//

import SwiftUI

struct HomeView: View {
    
    @Namespace private var animation
    
    @State private var selectedTab: Tab = .home
    @EnvironmentObject var themeManager:ThemeManager
    
    var body: some View{
        NavigationStack{
            TabView(selection:$selectedTab){
                //home tab
                VStack{
                    //profile button
                    HStack{
                        Spacer()
                        NavigationLink(destination: ProfileView()){
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width:40,height:40)
                                .padding()
                        }
                        .tint(.white)
                    }
                    Spacer()
                    //text
                    VStack{
                        Text(LocalizedString("Welcome to Quiz App"))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                            .multilineTextAlignment(.center)

                        NavigationLink(destination: CategoryView(viewModel: QuizViewModel())){
                            Text(LocalizedString("Start Quiz"))
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width:200,height: 50)
                                .background(Color.indigo)
                                .cornerRadius(10)
                        }
                    }
                    Spacer()
                }
                .tabItem{
                    Label(LocalizedString("Home"),systemImage:"house.fill")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .tag(Tab.home)
                .background(themeManager.backgroundColor.ignoresSafeArea())
                
                VStack {
                    //Text("")
                    QuizHistoryView()
                        .background(themeManager.backgroundColor.ignoresSafeArea())
                }
                .tabItem {
                    Label(LocalizedString("Leaderboard"), systemImage: "list.number")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .tag(Tab.leaderboard)
                .background(themeManager.backgroundColor.ignoresSafeArea())
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Color.indigo.opacity(0.5).gradient, for: .tabBar)
            }
        }.tint(.white)
        
    }
}

#Preview {
    HomeView()
}

