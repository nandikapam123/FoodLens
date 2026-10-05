//
//  ProfileView.swift
//

import SwiftUI
struct ProfileView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @Environment(\.userSession) var user
    
    @State private var showPreferencesEditor = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Theme.backColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        // Navigation Header as Text Box
                        Text("Profile")
                            .font(.largeTitle.bold())
                            .foregroundColor(Theme.primaryGreen)
                            .shadow(color: Theme.glowGreen.opacity(0.5), radius: 8)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.lightGreen.opacity(0.2))
                            .cornerRadius(16)
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        // 1. Profile Header
                        VStack(spacing: 8) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(Theme.lightGreen)
                                .background(Circle().fill(.white.opacity(0.1)))
                            
                            Text(user.name)
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            
                            Text("@\(user.username)")
                                .font(.subheadline)
                                .foregroundColor(Theme.lightGreen.opacity(0.8))
                        }
                        .padding(.top, 20)
                        
                        // 2. Info Card
                        VStack(spacing: 0) {
                            // Preferences Row (now tappable)
                            Button {
                                showPreferencesEditor = true
                            } label: {
                                InfoRow(icon: "fork.knife", label: "Preferences", value: user.preferences)
                            }
                            
                            Divider().background(.white.opacity(0.2)).padding(.horizontal)
                            
                            HStack {
                                Label("Account Status", systemImage: "star.fill")
                                    .foregroundColor(.white)
                                Spacer()
                                Text(user.accountType)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.primaryGreen)
                                    .foregroundColor(Theme.backColor)
                                    .cornerRadius(20)
                            }
                            .padding()
                        }
                        .background(RoundedRectangle(cornerRadius: 16).fill(.white.opacity(0.08)))
                        .padding(.horizontal)
                        
                        // 3. Scan History
                        VStack(alignment: .leading, spacing: 15) {
                            Label("Scan History", systemImage: "clock.arrow.circlepath")
                                .font(.headline)
                                .foregroundColor(Theme.backColor)
                            
                            if user.scanHistory.isEmpty {
                                Text("No scans yet...")
                                    .foregroundColor(Theme.backColor)
                            } else {
                                ForEach(user.scanHistory.indices, id: \.self) { i in
                                    let scan = user.scanHistory[i]
                                    Text("\(scan.date.formatted(.dateTime.hour().minute())) - \(scan.category.rawValue.capitalized): \(scan.matches.joined(separator: ", "))")
                                        .font(.subheadline)
                                        .foregroundColor(Theme.backColor)
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.lightGreen)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        // 4. Logout Button
                        Button(role: .destructive) {
                            isLoggedIn = false
                            
                            
                        } label: {
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                                .bold()
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 16).stroke(Color.red, lineWidth: 1))
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationTitle("")
            .sheet(isPresented: $showPreferencesEditor) {
                PreferencesEditorView(user: user)
            }
        }
    }
}
struct InfoRow: View {
    var icon: String
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Label(label, systemImage: icon)
                .foregroundColor(.white)
            Spacer()
            Text(value.isEmpty ? "None" : value)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
    }
}
// MARK: - Preferences Editor
struct PreferencesEditorView: View {
    let user: UserSession

    @Environment(\.dismiss) private var dismiss
    @State private var selectedPreferences: [String] = []
    @State private var searchText = ""

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
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSearchText.isEmpty,
              !preferenceOptions.contains(where: {
                  $0.localizedCaseInsensitiveCompare(trimmedSearchText) == .orderedSame
              }),
              !selectedPreferences.contains(where: {
                  $0.localizedCaseInsensitiveCompare(trimmedSearchText) == .orderedSame
              }) else {
            return nil
        }

        return trimmedSearchText
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Edit Preferences")
                        .font(.title2.bold())

                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Theme.primaryGreen)

                        TextField("Search or add preference...", text: $searchText)
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
                        VStack(spacing: 0) {
                            ForEach(filteredPreferences, id: \.self) { preference in
                                preferenceButton(preference)
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
                        .foregroundStyle(.primary)
                        .background(Theme.lightGreen.opacity(0.18))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Theme.primaryGreen.opacity(0.35), lineWidth: 1)
                        )
                    }

                    Button("Save") {
                        user.preferences = selectedPreferences.joined(separator: ", ")
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.backColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }
            .navigationTitle("Your Preferences")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                selectedPreferences = user.preferences
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
            }
        }
    }

    private func preferenceButton(_ preference: String) -> some View {
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
}

#Preview{
    ProfileView(
        isLoggedIn: false
    )
}

