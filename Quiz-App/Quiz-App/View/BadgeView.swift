//
//  BadgeView.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 24/02/25.
//

import SwiftUI

struct BadgeView: View {
    let badge: Badge
    
    var body: some View {
        VStack {
            Image(systemName: badge.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(badge.color)
                .padding()
                .background(Circle().fill(badge.color.opacity(0.2)))
            
            Text(LocalizedString(badge.rawValue))
                .font(.caption)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                //.frame(width: 80)
        }
        .padding()
    }
}
#Preview {
    BadgeView(badge: Badge(rawValue: "First Quiz Completed")!)
}
