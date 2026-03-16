//
//  LoginView.swift
//  Savaura
//

import SwiftUI
import Combine
struct LoginView: View {
    
    @Binding var isLoggedIn: Bool
    @ObservedObject var user: UserSession
    @State private var selectedAccount = "Basic"
    let accountTypes = ["Basic", "Premium"]
    
    @State private var nameInput = ""
    @State private var usernameInput = ""
    @State private var preferencesInput = ""
    
    @State private var isButtonPressed = false
    
    var body: some View {
        
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Theme.backColor, Color.black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView{
                    
                    VStack(spacing: 25) {
                        
                        Text("Welcome to Food Lens")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Theme.primaryGreen)
                            .shadow(color: Theme.glowGreen.opacity(0.5), radius: 5)
                        
                        Group {
                            TextField("Name", text: $nameInput)
                            TextField("Username", text: $usernameInput)
                            TextField("Food Preferences (comma-separated)", text: $preferencesInput)
                        }
                        .padding()
                        .background(Theme.lightGreen.opacity(0.9))
                        .foregroundColor(Theme.backColor)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("Choose Account Type")
                                .bold()
                                .foregroundColor(Theme.primaryGreen)
                                .padding(.horizontal)
                            
                            Picker("Account", selection: $selectedAccount) {
                                ForEach(accountTypes, id: \.self) { type in
                                    Text(type)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(.vertical, 5)
                            .background(Theme.lightGreen.opacity(0.6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        
                        Button("Create Account") {
                            user.name = nameInput
                            user.username = usernameInput
                            user.preferences = preferencesInput
                            user.accountType = selectedAccount
                            isLoggedIn = true
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.greenGradient)
                        .foregroundColor(Theme.backColor)
                        .bold()
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .shadow(color: Theme.glowGreen.opacity(isButtonPressed ? 0.8 : 0.5), radius: 10)
                        .scaleEffect(isButtonPressed ? 0.95 : 1.0)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in isButtonPressed = true }
                                .onEnded { _ in isButtonPressed = false }
                        )
                        
                        Spacer()
                    }
                    .padding(.top,100)
                }
                
            }
            
        }
}


#Preview {
    LoginView(
        isLoggedIn: .constant(false),
        user: UserSession()
    )
}




