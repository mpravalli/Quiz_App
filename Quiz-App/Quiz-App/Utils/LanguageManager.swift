//
//  LanguageManager.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 18/03/25.
//

import Foundation

class LanguageManager: ObservableObject {
    @Published var selectedLanguage: String = UserDefaults.standard.string(forKey: "selectedLanguage") ?? Locale.current.language.languageCode?.identifier ?? "en"
    
    // Make the initializer private to enforce singleton
    private init() {
        setLanguage(selectedLanguage)
    }
    
    // The shared instance
    static let shared = LanguageManager()
    
    func setLanguage(_ languageCode: String) {
        selectedLanguage = languageCode
        UserDefaults.standard.set(languageCode, forKey: "selectedLanguage")
        UserDefaults.standard.synchronize()
        Bundle.setLanguage(languageCode)
        objectWillChange.send()
    }
}
func LocalizedString(_ key: String, comment: String = "") -> String {
    return Bundle.main.currentLocalizedBundle.localizedString(forKey: key, value: nil, table: nil)
}
