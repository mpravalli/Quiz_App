//
//  ThemeManager.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 05/02/25.
//

//Dark mode
import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("isDarkMode")  var isDarkMode = false  //  Save user preference
    @Published var colorScheme: ColorScheme = .light
    /*var backgroundColor:Color{
     isDarkMode ? Color.black : Color.indigo
     }*/
    
    var backgroundColor: LinearGradient {
        isDarkMode ?
        LinearGradient(colors: [Color.indigo, Color.black], startPoint: .top, endPoint: .bottom) :
        LinearGradient(colors: [Color.indigo, Color.pink.opacity(0.3)], startPoint: .topTrailing, endPoint: .bottomLeading)
    }
    
    init() {
        colorScheme = isDarkMode ? .dark : .light
    }
}

