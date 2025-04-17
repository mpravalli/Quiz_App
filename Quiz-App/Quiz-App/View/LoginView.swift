//
//  LoginView.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 21/01/25.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewmodel = LoginViewModel()
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                themeManager.backgroundColor.ignoresSafeArea()
                
                
                VStack(spacing: 20){
                    
                    Text(LocalizedString("Login"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    TextField("",text:$viewmodel.email,prompt: Text(LocalizedString("Email-id")).foregroundColor(.indigo))
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                    
                    SecureField("",text:$viewmodel.password,prompt: Text(LocalizedString("Password")).foregroundColor(.indigo))
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                    
                    
                    Button(action: {viewmodel.handleLogin()}){
                        Text(LocalizedString("Login"))
                            .padding()
                            .frame(width:150,height: 40)
                            .background(Color.indigo)
                            .foregroundColor(Color.white)
                            .bold()
                            .cornerRadius(15)
                        NavigationLink(destination: HomeView().toolbar(.hidden),isActive: $viewmodel.loggedin){
                            EmptyView()
                        }
                    }
                    .alert(isPresented:$viewmodel.showAlert){
                        Alert(title: Text(LocalizedString("Login Status")),message: Text(LocalizedString(viewmodel.alertMessage)),dismissButton: .default(Text(LocalizedString("OK"))))
                    }
                    NavigationLink(destination:
                                    SignUpView()
                        .toolbar(.hidden)
                    ) {
                        Text(LocalizedString("Don't have an account? Sign Up"))
                            .foregroundColor(.indigo)
                    }
                    
                }
                .padding(.horizontal,30)
                
            }
            
            .toolbar(.hidden)
        }.tint(.white)
    }
}

#Preview {
    LoginView()
        .environmentObject(ThemeManager())
}
