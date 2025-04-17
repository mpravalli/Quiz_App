//
//  CoreDataManager.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 21/01/25.
//

//core data
import CoreData
import Foundation
 
class CoreDataManager {
    static let shared = CoreDataManager()
    
    public init() {}
    
    // Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Quiz_App")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError(
                    "Core Data stack failed: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Check if email is registered
    func isEmailRegistered(email: String) -> Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print(
                "Failed to fetch user with email \(email): \(error.localizedDescription)"
            )
            return false
        }
    }
    
    // Login function
    func validateUser(email: String, password: String) -> Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "email == %@ AND password == %@", email, password)
        
        do {
            let users = try context.fetch(fetchRequest)
            return !users.isEmpty
        } catch {
            print("Error validating user: \(error.localizedDescription)")
            return false
        }
    }
    
    
    
    // to save user
    func saveUser(name: String, email: String, password: String) -> Bool {
        let context = persistentContainer.viewContext
        let user = User(context: context)
        user.name = name
        user.email = email
        user.password = password
        
        do {
            try context.save()
            return true
        } catch {
            print("Failed to save user: \(error)")
            return false
        }
    }
    
    // to get loginned user data
    func getUserData() -> User? {
        guard let email = getLoggedInUserEmail() else { return nil}
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let users = try context.fetch(fetchRequest)
            return users.first
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
            return nil
        }
    }
    
    //Session Management
    
    //save the logged-in user's email to UserDefaults
    func loginUser(email: String){
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(email, forKey: "loggedInUserEmail")
    }
    
    //Clear the session data from userdefaults
    func logoutUser(){
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "loggedInUserEmail")
    }
    
    //check if a user is currently logged in
    
    func isUserLoggedIn() -> Bool{
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    //Get the email of the currently logged - in user
    
    func getLoggedInUserEmail() -> String?{
        return UserDefaults.standard.string(forKey: "loggedInUserEmail")
    }
    
    //QuizResult
    
    //to save quiz result
    
    func saveQuizResult(category: String, level: String,score: Int16,totalquestions: Int16){
        
        guard let email = getLoggedInUserEmail() else {
            print("No logged-in user found")
            return
        }
        
        let context = persistentContainer.viewContext
        let quizResult = QuizResultt(context: context)
        quizResult.id = UUID()
        quizResult.category = category
        quizResult.level = level
        quizResult.score = score
        quizResult.date = Date()
        quizResult.useremail = email
        quizResult.totalquestions = totalquestions
        
        do{
            try context.save()
        }catch{
            print("Failed to save quiz result:\(error.localizedDescription)")
        }
    }
    
    //user quiz history
    func fetchQuizResults() ->[QuizResultt]{
        guard let email = getLoggedInUserEmail()else { return []}
        
        let fetchRequest: NSFetchRequest<QuizResultt> = QuizResultt.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "useremail == %@", email)
        let sortDescriptor = NSSortDescriptor(key:"date",ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            return try context.fetch(fetchRequest)
        }catch {
            print("Failed to fetch quiz results:\(error.localizedDescription)")
            return []
        }
    }
    
    //Badge
    
    //  Save a new badge for a specific user
    func saveBadge(_ badge: Badge) {
        guard let email = getLoggedInUserEmail() else {
            print("No logged-in user")
            return
        }

        let context = persistentContainer.viewContext

        if !isBadgeAlreadyAwarded(badge) {
            let newBadge = BadgeAwarded(context: context)
            newBadge.id = UUID()
            newBadge.name = badge.rawValue
            newBadge.useremail = email // Associate with user
            
            do {
                try context.save()
                //("Badge \(badge.rawValue) saved for user: \(email)")
            } catch {
                print("Failed to save badge: \(error.localizedDescription)")
            }
        }
    }
    
    // here checking if badge is already awarded to the registered email or not
    func isBadgeAlreadyAwarded(_ badge: Badge) -> Bool {
        guard let email = getLoggedInUserEmail() else {
            print("No logged-in user")
            return false
        }

        let context = persistentContainer.viewContext
        let request: NSFetchRequest<BadgeAwarded> = BadgeAwarded.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@ AND useremail == %@", badge.rawValue, email)

        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Error checking badge: \(error)")
            return false
        }
    }
    
    
    //fetching the badges for registered email
    func fetchEarnedBadges() -> [Badge] {
        guard let email = getLoggedInUserEmail() else {
            print("No logged-in user")
            return []
        }

        let context = persistentContainer.viewContext
        let request: NSFetchRequest<BadgeAwarded> = BadgeAwarded.fetchRequest()
        request.predicate = NSPredicate(format: "useremail == %@", email) // Filter by user

        do {
            let results = try context.fetch(request)
            return results.compactMap { Badge(rawValue: $0.name ?? "") }
        } catch {
            print("Error fetching badges: \(error)")
            return []
        }
    }
    
    // Save with email
    func saveCustomQuestion(question: String, option1: String, option2: String, option3: String, option4: String, correctIndex: Int) {
        guard let email = getLoggedInUserEmail() else { return }

        let entity = CustomQuestion(context: context)
        entity.id = UUID()
        entity.questionText = question
        entity.option1 = option1
        entity.option2 = option2
        entity.option3 = option3
        entity.option4 = option4
        entity.correctIndex = Int16(correctIndex)
        entity.useremail = email

        do {
            try context.save()
        } catch {
            print("Failed to save custom question: \(error)")
        }
    }

    // Fetch only user's questions
    func fetchCustomQuestions() -> [CustomQuestion] {
        guard let email = getLoggedInUserEmail() else { return [] }

        let request: NSFetchRequest<CustomQuestion> = CustomQuestion.fetchRequest()
        request.predicate = NSPredicate(format: "useremail == %@", email)
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch custom questions: \(error)")
            return []
        }
    }

    // Delete specific question
    func deleteCustomQuestion(_ question: CustomQuestion) {
        context.delete(question)
        do {
            try context.save()
        } catch {
            print("Failed to delete question: \(error)")
        }
    }


    
}

