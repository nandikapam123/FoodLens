//
//  OnBoardingView.swift
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    
    @Binding var isLoggedIn: Bool
    @Environment(\.userSession) var user
    @Environment(\.modelContext) private var context
    @State private var step = 1
    
    // For Step 1
    @State private var name = ""
    @State private var username = ""
    
    // For Step 2
    @State private var selectedPreferences: [String] = []
    @State private var searchText = ""
    @State private var accountType = "Basic"

    private let accountTypes = ["Basic", "Premium"]
    private let preferenceOptions = [
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
        "Mediterranean",
        "High Protein",
        "Diabetic Friendly"
    ]

    private var filteredPreferences: [String] {
        guard !searchText.isEmpty else {
            return []
        }

        return preferenceOptions
            .filter { !selectedPreferences.contains($0) }
            .filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    private var customPreference: String? {
        let value = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !value.isEmpty,
              !preferenceOptions.contains(where: {
                  $0.localizedCaseInsensitiveCompare(value) == .orderedSame
              }),
              !selectedPreferences.contains(where: {
                  $0.localizedCaseInsensitiveCompare(value) == .orderedSame
              }) else {
            return nil
        }

        return value
    }
    
    var isStep1Valid: Bool {
        !name.isEmpty && !username.isEmpty
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Theme.backColor, Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                if step == 1 {
                    stepOne
                } else {
                    stepTwo
                }
                
                Spacer()
                
                actionButton
            }
            .padding()
        }
    }

    var stepOne: some View {
        VStack(spacing: 25) {
            Text("FoodLens")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(Theme.primaryGreen)
            
            Text("Scan food. Find recipes. Eat smarter.")
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            inputField(icon: "person", placeholder: "Name", text: $name)
            inputField(icon: "at", placeholder: "Username", text: $username)
        }
    }
    

    var stepTwo: some View {
        VStack(spacing: 20) {
            Text("Your Preferences")
                .font(.title2.bold())
                .foregroundColor(Theme.primaryGreen)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Theme.primaryGreen)

                    TextField("Search or add preference...", text: $searchText)
                        .foregroundColor(.white)
                        .textInputAutocapitalization(.words)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Theme.lightGreen.opacity(0.25))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.primaryGreen.opacity(0.4), lineWidth: 1)
                )

                if !selectedPreferences.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(selectedPreferences, id: \.self) { preference in
                                HStack(spacing: 6) {
                                    Text(preference)
                                        .font(.subheadline.bold())

                                    Button {
                                        selectedPreferences.removeAll { $0 == preference }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                    }
                                    .accessibilityLabel("Remove \(preference)")
                                }
                                .foregroundStyle(Theme.backColor)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Theme.primaryGreen)
                                .clipShape(Capsule())
                            }
                        }
                    }
                }

                if !searchText.isEmpty {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(filteredPreferences, id: \.self) { preference in
                                Button {
                                    addPreference(preference)
                                } label: {
                                    HStack {
                                        Text(preference)
                                        Spacer()
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundStyle(Theme.primaryGreen)
                                    }
                                    .padding()
                                }

                                Divider()
                            }

                            if let customPreference {
                                Button {
                                    addPreference(customPreference)
                                } label: {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundStyle(Theme.primaryGreen)
                                        Text("Add \"\(customPreference)\"")
                                        Spacer()
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 180)
                    .foregroundStyle(.white)
                    .background(Theme.lightGreen.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Theme.primaryGreen.opacity(0.35), lineWidth: 1)
                    )
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Account Type")
                    .foregroundColor(Theme.primaryGreen)
                    .bold()

                HStack {
                    ForEach(accountTypes, id: \.self) { type in
                        accountCard(type: type)
                    }
                }
            }
        }
    }
    
    func inputField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Theme.primaryGreen)
            
            TextField(placeholder, text: text)
                .foregroundColor(.white)
                .autocapitalization(.none)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.lightGreen.opacity(0.25))
        )
    }
    
    func accountCard(type: String) -> some View {
        let isSelected = accountType == type
        
        return Text(type)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Theme.primaryGreen : Theme.lightGreen.opacity(0.2))
            )
            .foregroundColor(isSelected ? Theme.backColor : .white)
            .onTapGesture {
                accountType = type
            }
    }
    
    private func addPreference(_ preference: String) {
        guard !selectedPreferences.contains(where: {
            $0.localizedCaseInsensitiveCompare(preference) == .orderedSame
        }) else {
            return
        }

        selectedPreferences.append(preference)
        searchText = ""
    }

    var actionButton: some View {
        Button(action: {
            if step == 1 {
                withAnimation {
                    step = 2
                }
            } else {
                clearRecipesOnLogin(context: context)
                user.name = name
                user.username = username
                user.preferences = selectedPreferences.joined(separator: ", ")
                user.accountType = accountType
                user.selectedTab = .contentView
                
                withAnimation {
                    isLoggedIn = true
                }
            }
        }) {
            Text(step == 1 ? "Continue" : "Get Started")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.greenGradient)
                .foregroundColor(Theme.backColor)
                .cornerRadius(16)
                .bold()
        }
        .disabled(step == 1 && !isStep1Valid)
        .opacity(step == 1 && !isStep1Valid ? 0.6 : 1)
    }
}
