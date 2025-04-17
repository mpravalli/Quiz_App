//
//  SplashScreenView.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 21/01/25.
//


import SwiftUI

struct SplashScreenView: View {
    @StateObject private var viewModel = SplashScreenViewModel()
    @EnvironmentObject var themeManager:ThemeManager
    var body: some View {
        ZStack{
            themeManager.backgroundColor.ignoresSafeArea()
            if viewModel.isActive{
                SignUpView()
            }else{
                VStack{
                    VStack{
                        
                        if let path = Bundle.main.path(forResource: "brain3", ofType: "jpg"),
                           let uiImage = UIImage(contentsOfFile: path) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 170, height: 150)
                                .clipShape(Circle()) // Clips the image into a circle shape
                                .overlay(Circle().stroke(Color.white, lineWidth: 4)) // Optional: Adds a border around the circle
                                .shadow(radius: 10)
                        } else {
                            Text("Image not found")
                                .foregroundColor(.red)
                        }
                        Text("Quiz Game")
                            .bold()
                            .font(.system(size:30))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(viewModel.size)
                    .opacity(viewModel.opacity)
                    .onAppear{
                        viewModel.splashanimation()
                    }
                }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        withAnimation{
                            self.viewModel.isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(ThemeManager())
}

