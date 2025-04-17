//
//  ProfileViewModel.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 22/01/25.
//

import Combine

class ProfileViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var user: User?
    
    private var coredatamanager: CoreDataManager
    @Published var isLoggedIn: Bool
    
    init(manager: CoreDataManager = CoreDataManager.shared) {
        self.coredatamanager = manager
        self.isLoggedIn = manager.isUserLoggedIn()
    }
    
    func fetchUserProfile() {
        user = coredatamanager.getUserData()
        self.username = user?.name ?? ""
        self.email = user?.email ?? ""
    }
    
    func logout() {
        coredatamanager.logoutUser()
        isLoggedIn = false
    }
}


