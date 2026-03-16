//
//  SavauraApp.swift
//  Savaura
//
//  Created by Prasadu Pampana on 3/11/26.
//

import SwiftUI
@main
struct SavauraApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @StateObject var user = UserSession()
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainTabView(user: user)
                    .background(Theme.backColor.ignoresSafeArea())
            } else {
                SplashView(user: user)
            }
        }
    }
}
