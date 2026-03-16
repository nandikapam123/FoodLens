//
//  MainTabView.swift
//  Savaura
//

import SwiftUI
struct MainTabView: View {
    
    @ObservedObject var user: UserSession
    
    var body: some View {
        TabView {
            ContentView(user: user)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            ScannerView(user: user)
                .tabItem {
                    Image(systemName: "barcode.viewfinder")
                    Text("Scanner")
                }
            
            FindViewWrapper(user: user)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Find Food")
                }
            
            MealSuggestionsViewWrapper(user: user)
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Meals")
                }
            
            CommunityBoardView(user: user)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Community")
                }
            
            ProfileView(user: user)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}
struct MealSuggestionsViewWrapper: View {
    @ObservedObject var user: UserSession
    var body: some View {
        if user.accountType == "Premium" {
            MealSuggestionsView(user: user)
        } else {
            LockedPremiumView(
                feature: "AI Meal Suggestions",
                description: "Generate personalized meal ideas based on your dietary preferences."
            )
            .padding()
        }
    }
}
struct FindViewWrapper: View {
    @ObservedObject var user: UserSession
    var body: some View {
        FindView(user: user)
    }
}

