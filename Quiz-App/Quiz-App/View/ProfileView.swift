//
//  ProfileView.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 22/01/25.
//

import SwiftUI


struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var isLoggedOut: Bool = false
    @EnvironmentObject var themeManager:ThemeManager
    
    @ObservedObject var languageManager = LanguageManager.shared
    
    let languages = [
        "en": "English",
        "fr": "French",
        "de": "German"
    ]
    
    var body: some View {
        NavigationView{
            ZStack{
                themeManager.backgroundColor.ignoresSafeArea()
                VStack(spacing: 20) {
                    Text(LocalizedString("My Profile"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 40)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(LocalizedString("Name:")) \(viewModel.username)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("\(LocalizedString("Email:")) \(viewModel.email)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    //Dark Mode
                    
                    VStack {
                        // Dark Mode Toggle
                        Toggle(isOn: $themeManager.isDarkMode) {
                            Text(LocalizedString("Dark Mode"))
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        
                        //language
                        HStack{
                            
                            Text(LocalizedString("Select Language"))
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Picker("Select Language", selection: $languageManager.selectedLanguage) {
                                ForEach(languages.keys.sorted(), id: \.self) { code in
                                    Text(languages[code] ?? code).tag(code)
                                }
                            }
                            .frame(width:120,height:50)
                            .pickerStyle(MenuPickerStyle())
                            .onChange(of: languageManager.selectedLanguage) { newLanguage in
                                Bundle.setLanguage(newLanguage)
                            }
                        }
                        .padding(.leading,15)
                        
                        //customQuiz
                        HStack{
                            Text("Add Custom Question")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink(destination: CustomQuestionsView()) {
                                Label("Custom Quiz", systemImage: "pencil.and.outline")
                            }
                            
                        }.padding()
                    }.padding()
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        viewModel.logout()
                        isLoggedOut = true
                    }) {
                        Text(LocalizedString("Logout"))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color.indigo)
                            .cornerRadius(15)
                    }
                    
                    NavigationLink(destination: LoginView().toolbar(.hidden),isActive: $isLoggedOut, label: {EmptyView()})
                    
                    Spacer()
                    
                }.onAppear {
                    viewModel.fetchUserProfile()
                }
            }
        }
    }
    
}


#Preview {
    ProfileView()
        .environmentObject(ThemeManager())
}

