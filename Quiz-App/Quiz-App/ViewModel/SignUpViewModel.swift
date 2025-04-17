//
//  SignUpViewModel.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 21/01/25.
//

import Foundation

class SignUpViewModel:ObservableObject{
    @Published var name:String=""
    @Published var email:String=""
    @Published var password:String=""
    @Published var cpassword:String=""
    
    @Published var emailregistered:Bool=false
    @Published var userregisterstatus:Bool=false
    
    @Published var showAlert:Bool=false
    @Published var alertMessage:String=""
    @Published var registerstatus:Bool = false
    
     var viewmodel = CoreDataManager()
    
    func handleRegistration(){
        if name.isEmpty || email.isEmpty || password.isEmpty || cpassword.isEmpty{
            alertMessage="All fields are required"
            showAlert=true
            return
        }
        
        if password != cpassword{
            alertMessage="Both Passwords not matched"
            showAlert=true
            return
        }
        if !email.contains("@") || !email.contains(".com"){
            alertMessage="Enter valid email-id"
            showAlert=true
            return
        }
        if(password.count<8){
            alertMessage="Password must be more than 8 letters"
            showAlert=true
            return
        }
        
        //password validation
        
        let specialCharacterRegex = ".*[!@#$%^&*(),.?\":{}|<>].*"
        let numberRegex=".*[0-9].*"
        let uppercaseRegex=".*[A-Z].*"
        let lowercaseRegex=".*[a-z].*"
    
        if !NSPredicate(format:"SELF MATCHES %@",specialCharacterRegex).evaluate(with: password){
        alertMessage="Password must contain at least one special character"
        showAlert=true
        }else if !NSPredicate(format:"SELF MATCHES %@",numberRegex).evaluate(with: password){
        alertMessage="Password must contain at least one number"
        showAlert=true
        }else if !NSPredicate(format:"SELF MATCHES %@",uppercaseRegex).evaluate(with: password){
        alertMessage="Password must contain at least one Uppercase character"
        showAlert=true
        }else if !NSPredicate(format:"SELF MATCHES %@",lowercaseRegex).evaluate(with: password){
            alertMessage="Password must contain at least one Lowercase character"
            showAlert=true
        }else{
            emailregistered = viewmodel.isEmailRegistered(email: email)
            if(emailregistered){
                alertMessage="Email-id already registered"
                showAlert=true
                return
            }
            userregisterstatus = viewmodel.saveUser(name: name, email: email, password: password)
            if(userregisterstatus){
                alertMessage="Successfully Registered"
                showAlert=true
                registerstatus=true
                viewmodel.loginUser(email: email)
                return
            }
        }
    }
}

