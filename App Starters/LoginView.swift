//
//  LoginView.swift
//

// OLD LOGIN VIEWWWWW, NOW USING ONBOARDING VIEEWWWWW

import SwiftUI
import Combine
struct LoginView: View {
    
    @Environment(\.modelContext) private var context
    @Binding var isLoggedIn: Bool
    @Environment(\.userSession) var user
    @State private var selectedAccount = "Basic"
    let accountTypes = ["Basic", "Premium"]
    
    @State private var nameInput = ""
    @State private var usernameInput = ""
    
    @State private var selectedPreferences: [String] = []
    @State private var searchText = ""
    
    let preferenceOptions = [
        "Vegetarian",
        "Vegan",
        "Gluten-Free",
        "Dairy-Free",
        "Nut-Free",
        "Peanut Allergy",
        "Tree Nut Allergy",
        "Egg-Free",
        "Soy-Free",
        "Shellfish Allergy",
        "Fish Allergy",
        "Sesame Allergy",
        "Halal",
        "Kosher",
        "Low Sodium",
        "Low Sugar",
        "Low Carb",
        "Keto",
        "Paleo",
        "High Protein",
        "Diabetic Friendly"
    ]
    
    var filteredPreferences: [String] {
            if searchText.isEmpty {
                return preferenceOptions
            }

            return preferenceOptions.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    
    @FocusState private var focusedName: String?
    @FocusState private var focusedUsername: String?
    @FocusState private var focusedPreferences: String?
    
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
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .bold()
                            .foregroundColor(Theme.primaryGreen)
                            .shadow(color: Theme.glowGreen.opacity(0.5), radius: 5)
                        
                        Group {
                            TextField("Name", text: $nameInput)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Theme.lightGreen.opacity(0.25))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    focusedName == "name"
                                                    ? Theme.primaryGreen
                                                    : Theme.primaryGreen.opacity(0.3),
                                                    lineWidth: 2
                                                )
                                        )
                                        .shadow(
                                            color: focusedName == "name"
                                            ? Theme.primaryGreen.opacity(0.8)
                                            : .clear,
                                            radius: 10
                                        )
                                )
                                .foregroundColor(.white)
                                .tint(Theme.primaryGreen)
                                .focused($focusedName, equals: "name")
                                .padding(.horizontal)
                                .textContentType(.name)

                            
                            TextField("Username", text: $usernameInput)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Theme.lightGreen.opacity(0.25))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    focusedUsername == "username"
                                                    ? Theme.primaryGreen
                                                    : Theme.primaryGreen.opacity(0.3),
                                                    lineWidth: 2
                                                )
                                        )
                                        .shadow(
                                            color: focusedUsername == "username"
                                            ? Theme.primaryGreen.opacity(0.8)
                                            : .clear,
                                            radius: 10
                                        )
                                )
                                .foregroundColor(.white)
                                .tint(Theme.primaryGreen)
                                .focused($focusedUsername, equals: "username")
                                .padding(.horizontal)
                                .textContentType(.username)
                                .autocapitalization(.none)
                            
                            
                            VStack(alignment: .leading) {
                                
                                Text("Dietary Preferences")
                                    .font(.headline)
                                    .foregroundColor(Theme.primaryGreen)
                                    .padding(.horizontal)

                                HStack {

                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(Theme.primaryGreen)

                                    TextField("Search or add preference...", text: $searchText)
                                        .foregroundColor(.white)

                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Theme.lightGreen.opacity(0.25))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    focusedPreferences == "preferences"
                                                    ? Theme.primaryGreen
                                                    : Theme.primaryGreen.opacity(0.3),
                                                    lineWidth: 2
                                                )
                                        )
                                )
                                .focused($focusedPreferences, equals: "preferences")
                                .padding(.horizontal)

                                ScrollView(.horizontal, showsIndicators: false) {

                                    HStack {

                                        ForEach(selectedPreferences, id: \.self) { preference in

                                            HStack {

                                                Text(preference)
                                                    .foregroundColor(.black)
                                                    .font(.subheadline.bold())

                                                Button {

                                                    selectedPreferences.removeAll {
                                                        $0 == preference
                                                    }

                                                } label: {

                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.black.opacity(0.7))

                                                }

                                            }

                                            .padding(.horizontal,12)
                                            .padding(.vertical,8)
                                            .background(Theme.primaryGreen)
                                            .cornerRadius(20)

                                        }

                                    }

                                }

                                if !filteredPreferences.isEmpty || !searchText.isEmpty {

                                    VStack(spacing: 0) {

                                        ForEach(filteredPreferences, id: \.self) { preference in

                                            Button {

                                                if !selectedPreferences.contains(preference) {
                                                    selectedPreferences.append(preference)
                                                }

                                                searchText = ""

                                            } label: {

                                                HStack {

                                                    Text(preference)
                                                        .foregroundColor(.white)

                                                    Spacer()

                                                    Image(systemName: "plus.circle.fill")
                                                        .foregroundColor(Theme.primaryGreen)

                                                }
                                                .padding()

                                            }

                                            Divider()
                                                .background(Color.white.opacity(0.2))

                                        }

                                        // Allow custom entries
                                        if !searchText.isEmpty &&
                                            !preferenceOptions.contains(where: {
                                                $0.localizedCaseInsensitiveCompare(searchText) == .orderedSame
                                            }) {

                                            Button {

                                                selectedPreferences.append(searchText)
                                                searchText = ""

                                            } label: {

                                                HStack {

                                                    Image(systemName: "plus.circle.fill")
                                                        .foregroundColor(Theme.primaryGreen)

                                                    Text("Add \"\(searchText)\"")
                                                        .foregroundColor(.white)

                                                    Spacer()

                                                }
                                                .padding()

                                            }

                                        }

                                    }
                                    .frame(maxHeight: 220)
                                    .background(Theme.lightGreen.opacity(0.25))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Theme.primaryGreen.opacity(0.4), lineWidth: 1)
                                    )
                                    .padding(.horizontal)
                                }
                                
                            }
                        }
                        
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
                            user.preferences = selectedPreferences.joined(separator: ", ")
                            user.accountType = selectedAccount
                            
                            user.selectedTab = .contentView
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
                        .disabled(nameInput.isEmpty || usernameInput.isEmpty)
                        .opacity(nameInput.isEmpty || usernameInput.isEmpty ? 0.6 : 1)
                        
                        Spacer()
                    }
                    .padding(.top,100)
                }
                
            }
            
        }
}






