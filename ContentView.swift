//
//  ContentView.swift
//  Savaura
//
//  Created by Prasadu Pampana on 3/11/26.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var user: UserSession
    
    var body: some View {
        NavigationStack {
            ZStack{
                Theme.backColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 10) {
                        Theme.backColor.ignoresSafeArea()
                        
                        // Greeting
                        Text("Welcome, \(user.name)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Theme.primaryGreen)
                            .shadow(color: Theme.glowGreen.opacity(0.5), radius: 8)
                        //                        .padding(.top)
                        
                        
                        // Feature Cards
                        FeatureCard(
                            title: "AI Recipe Generator",
                            description: "AI-powered meals based on your preferences.",
                            isPremium: false,
                            isUnlocked: true
                        )
                        .cardStyle()
                        
                        FeatureCard(
                            title: "Food Finder",
                            description: "Find Nutritious, Affordable, and Delicious Food In Your Local Community",
                            isPremium: false,
                            isUnlocked: true
                        )
                        .cardStyle()
                        
                        FeatureCard(
                            title: "Community Board",
                            description: "Stay Updated on Local Food Drives and Events",
                            isPremium: true,
                            isUnlocked: user.accountType == "Premium"
                        )
                        .cardStyle()
                        
                        FeatureCard(
                            title: "Food Scanner",
                            description: "Scan product labels for allergens and dietary conflicts.",
                            isPremium: true,
                            isUnlocked: user.accountType == "Premium"
                        )
                        .cardStyle()
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
    }
}
// MARK: - FeatureCard Visual Modifier
extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Theme.primaryGreen.opacity(0.4), Theme.accentColor.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .shadow(color: Theme.glowGreen.opacity(0.4), radius: 10, x: 0, y: 5)
    }
}


#Preview {
    ContentView(user: UserSession())
}
