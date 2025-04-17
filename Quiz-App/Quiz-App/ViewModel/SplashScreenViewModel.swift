//
//  SplashScreenViewModel.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 21/01/25.
//

import SwiftUI

class SplashScreenViewModel: ObservableObject {
    @Published var isActive = false
    @Published var size=0.8
    @Published var opacity=0.5
    
    func splashanimation()  {
        withAnimation(.easeIn(duration: 1.2)){
            self.size=0.9
            self.opacity=1.0
        }
    }
    
}

#Preview {
    SplashScreenView()
}

