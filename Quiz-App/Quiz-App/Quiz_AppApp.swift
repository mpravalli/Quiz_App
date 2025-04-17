//
//  Quiz_AppApp.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 21/01/25.
//

import SwiftUI

@main
struct Quiz_AppApp: App {
    @State private var isLoggedIn: Bool = CoreDataManager.shared.isUserLoggedIn()
    @StateObject var themeManager = ThemeManager()
    @StateObject var languageManager = LanguageManager.shared
    var body: some Scene {
        WindowGroup {
            
            ZStack{
                themeManager.backgroundColor.ignoresSafeArea()
                VStack {
                    if isLoggedIn {
                        HomeView()
                            .environmentObject(themeManager)
                            .environmentObject(languageManager)
                            .id(languageManager.selectedLanguage)
                    } else {
                        SplashScreenView()
                            .environmentObject(themeManager)
                            .environmentObject(languageManager)
                            .id(languageManager.selectedLanguage)
                    }
                }
            }
            .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}
