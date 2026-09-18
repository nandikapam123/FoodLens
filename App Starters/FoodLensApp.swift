//
//  FoodLensApp.swift
//

import SwiftUI
import SwiftData
@main
struct FoodLensApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @State var user = UserSession()
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                Start()
                    .environment(\.userSession, user)
            } else {
                SplashView()
                    .environment(\.userSession, user)
            }
        }
        .modelContainer(for: RecipeEntity.self)
    }
}
