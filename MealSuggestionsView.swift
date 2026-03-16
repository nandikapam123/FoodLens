//
//  MealSuggestionsView.swift
//  Savaura
//

import SwiftUI
struct MealSuggestionsView: View {
    
    @StateObject var user = UserSession() // keep this
    @State private var suggestedMeals: [String] = []
    
    var body: some View {
        ZStack{
            Theme.backColor.ignoresSafeArea()
            ScrollView{
                VStack(spacing: 24) {
                    Text("AI Meal Suggestions")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Theme.primaryGreen)
                        .padding(.top, 40)
                    
                    Text("Based on your preferences: \(user.preferences)")
                        .font(.custom("Verdana", size: 16))
                        .foregroundStyle(Theme.lightGreen)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("Generate Meals") {
                        // **Wrap state update in DispatchQueue.main.async**
                        DispatchQueue.main.async {
                            generateMeals()
                        }
                    }
                    .font(.custom("Verdana", size: 20))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.primaryGreen)
                    .foregroundColor(Theme.backColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    if !suggestedMeals.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(suggestedMeals, id: \.self) { meal in
                                    Text("• \(meal)")
                                        .font(.custom("Verdana", size: 16))
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Theme.lightGreen)
                                        .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
                .background(Theme.backColor.ignoresSafeArea())
                .padding(.vertical)
            }
        }
    }
    
    func generateMeals() {
        let prefs = user.preferences.lowercased()
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        
        // safer Swift array generation
        var meals: [String] = []
        for pref in prefs {
            meals.append("\(pref.capitalized) Salad Bowl")
            meals.append("\(pref.capitalized) Stir Fry")
        }
        
        if meals.isEmpty {
            meals = ["Veggie Wrap", "Fruit Smoothie", "Quinoa Bowl"]
        }
        
        suggestedMeals = meals
    }
}

#Preview{
    MealSuggestionsView(user: UserSession())
}


