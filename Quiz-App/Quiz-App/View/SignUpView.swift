//
//  SignUpView.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 21/01/25.
//


import SwiftUI

struct SignUpView: View {
    
    @StateObject private var viewmodel = SignUpViewModel()
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.backgroundColor.ignoresSafeArea()
                VStack(spacing: 20) {
                    
                    Text(LocalizedString("Sign Up"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top,30)
                    
                    TextField("", text: $viewmodel.name,prompt: Text(LocalizedString("Username")).foregroundColor(.indigo))
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                    
                    TextField("", text: $viewmodel.email,prompt:Text(LocalizedString("Email-id")).foregroundColor(.indigo))
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(15)
                        .keyboardType(.emailAddress)
                        .foregroundColor(.black)
                    
                    SecureField("", text: $viewmodel.password,prompt:Text(LocalizedString("Password")).foregroundColor(.indigo))
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                    
                    SecureField("", text: $viewmodel.cpassword,prompt: Text(LocalizedString("Confirm Password")).foregroundColor(.indigo))
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                    
                    Button(action: { viewmodel.handleRegistration() }) {
                        Text(LocalizedString("Submit"))
                            .padding()
                            .frame(width: 150, height: 40)
                            .background(Color.indigo)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                        NavigationLink(destination: HomeView().toolbar(.hidden),isActive: $viewmodel.registerstatus){
                            EmptyView()
                        }
                    }
                    NavigationLink(
                        destination:
                            LoginView()
                            .toolbar(.hidden)
                    ) {
                        Text(LocalizedString("Already have an account? Login"))
                            .foregroundColor(.indigo)
                    }
                    .alert(isPresented: $viewmodel.showAlert) {
                        Alert(
                            title: Text(LocalizedString("Registration Status")),
                            message: Text(LocalizedString(viewmodel.alertMessage)),
                            dismissButton: .default(Text(LocalizedString("OK"))))
                    }
                }
                .padding(.horizontal, 30)
                
            }
        }.tint(.white)
    }
}

#Preview {
    SignUpView()
        .environmentObject(ThemeManager())
}
