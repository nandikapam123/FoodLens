//
//  UserSession.swift
//  Savaura
//


import SwiftUI
import Combine
class UserSession: ObservableObject {
    @AppStorage("name") var name: String = ""
    @AppStorage("username") var username: String = ""
    @AppStorage("preferences") var preferences: String = ""
    @AppStorage("accountType") var accountType: String = "Basic"
    
    @Published var scanHistory: [(date: Date, category: IngredientCategory, matches: [String])] = []
    
    // AddScan safely on main thread
    func addScan(category: IngredientCategory, matches: [String]) {
        DispatchQueue.main.async {
            self.scanHistory.append((date: Date(), category: category, matches: matches))
        }
    }
}

