//
//  LoginViewModel.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 21/01/25.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var emailregistered:Bool=false
    @Published var loginstatus:Bool=false
    
    @Published var showAlert:Bool=false
    @Published var alertMessage:String=""
    
    @Published var loggedin: Bool = false
    
    var viewmodel = CoreDataManager()
    
    
    func handleLogin(){
        if email.isEmpty || password.isEmpty{
            alertMessage="All fields are required"
            showAlert=true
            return
        }
        if !email.contains("@") || !email.contains(".com"){
            alertMessage="Enter valid email-id"
            showAlert=true
            return
        }
        emailregistered = viewmodel.isEmailRegistered(email: email)
        if(!emailregistered){
            alertMessage="Email-id not registered.Please sign up"
            showAlert=true
            return
        }
        if(emailregistered){
            loginstatus = viewmodel.validateUser(email: email, password: password)
            if(!loginstatus){
                alertMessage = "Invalid credentials"
                showAlert=true
                return
            }
        }
        loggedin = true
        viewmodel.loginUser(email: email)
    }
    
}

