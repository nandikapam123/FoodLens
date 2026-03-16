//
//  NewCommunityPostView.swift
//  Savaura
//

import SwiftUI
import UIKit
struct NewCommunityPostView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var user: UserSession
    var onPost: (CommunityPost) -> Void
    
    // POST TYPE
    enum PostType: String, CaseIterable {
        case recipe = "Recipe"
        case foodDrive = "Food Drive"
        case advertisement = "Store Promotion"
    }
    
    @State private var selectedType: PostType = .recipe
    
    // COMMON FIELDS
    @State private var title = ""
    @State private var description = ""
    @State private var contactInfo = ""
    
    // RECIPE FIELDS
    @State private var ingredients: [String] = []
    @State private var steps: [String] = []
    
    // FOOD DRIVE FIELDS
    @State private var volunteerInfo = ""
    @State private var location = ""
    @State private var mission = ""
    
    // STORE PROMOTION FIELDS
    @State private var discountInfo = ""
    @State private var storeLocation = ""
    
    // IMAGE
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    // INPUT FIELDS
    @State private var newIngredient = ""
    @State private var newStep = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // POST TYPE PICKER
                    Picker("Post Type", selection: $selectedType) {
                        ForEach(PostType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .background(Theme.lightGreen)
                    .cornerRadius(12)
                    .padding()
                    
                    // TITLE
                    TextField("Title", text: $title)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    
                    // DESCRIPTION
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    
                    // CONTACT
                    TextField("Contact Info", text: $contactInfo)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    
                    // RECIPE ONLY FIELDS
                    if selectedType == .recipe {
                        VStack(spacing: 12) {
                            
                            // INGREDIENTS
                            VStack(alignment: .leading) {
                                Text("Ingredients")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                HStack {
                                    TextField("Add ingredient", text: $newIngredient)
                                        .textFieldStyle(.roundedBorder)
                                    
                                    Button("Add") {
                                        let trimmed = newIngredient.trimmingCharacters(in: .whitespaces)
                                        guard !trimmed.isEmpty else { return }
                                        ingredients.append(trimmed)
                                        newIngredient = ""
                                    }
                                    .padding(.horizontal)
                                    .background(Theme.primaryGreen)
                                    .foregroundColor(Theme.backColor)
                                    .cornerRadius(8)
                                }
                                
                                ForEach(ingredients, id: \.self) { item in
                                    Text("• \(item)")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal)
                            
                            // STEPS
                            VStack(alignment: .leading) {
                                Text("Directions")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                HStack {
                                    TextField("Add step", text: $newStep)
                                        .textFieldStyle(.roundedBorder)
                                    
                                    Button("Add") {
                                        let trimmed = newStep.trimmingCharacters(in: .whitespaces)
                                        guard !trimmed.isEmpty else { return }
                                        steps.append(trimmed)
                                        newStep = ""
                                    }
                                    .padding(.horizontal)
                                    .background(Theme.primaryGreen)
                                    .foregroundColor(Theme.backColor)
                                    .cornerRadius(8)
                                }
                                
                                ForEach(steps.indices, id: \.self) { i in
                                    Text("\(i+1). \(steps[i])")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // FOOD DRIVE ONLY FIELDS
                    if selectedType == .foodDrive {
                        VStack(spacing: 12) {
                            
                            TextField("Volunteer Responsibilities", text: $volunteerInfo)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .padding(.horizontal)
                            
                            TextField("Location", text: $location)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .padding(.horizontal)
                            
                            TextField("Mission / Goal", text: $mission)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                    }
                    
                    // STORE PROMOTION ONLY FIELDS
                    if selectedType == .advertisement {
                        VStack(spacing: 12) {
                            
                            TextField("Discount / Offer Details", text: $discountInfo)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .padding(.horizontal)
                            
                            TextField("Store Location", text: $storeLocation)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                    }
                    
                    // IMAGE PICKER
                    VStack(alignment: .leading) {
                        Text("Image (Optional)")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Button {
                            showImagePicker = true
                        } label: {
                            if let img = selectedImage {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.3))
                                        .frame(height: 150)
                                    
                                    Text("Select Image")
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // POST BUTTON
                    Button {
                        postNewCommunityPost()
                    } label: {
                        Text("Post")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canPost() ? Theme.primaryGreen : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .padding(.horizontal)
                    }
                    .disabled(!canPost())
                }
                .padding(.vertical)
            }
            .background(Theme.backColor.ignoresSafeArea())
            .padding(.top)
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                CameraOrPhotoPicker { image in
                    selectedImage = image
                }
            }
        }
    }
    
    // CHECK IF POST IS VALID
    private func canPost() -> Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !description.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // CREATE POST
    private func postNewCommunityPost() {
        
        let postType: CommunityPostType
        
        switch selectedType {
        case .recipe:
            postType = .recipe
        case .foodDrive:
            postType = .foodDrive
        case .advertisement:
            postType = .advertisement
        }
        
        let newPost = CommunityPost(
            type: postType,
            title: title,
            description: description,
            contactInfo: contactInfo,
            image: selectedImage,
            ingredients: selectedType == .recipe ? ingredients : nil,
            steps: selectedType == .recipe ? steps : nil,
            volunteerDetails: volunteerInfo,
            driveLocation: location,
            missionDescription: mission,
            storeLocation: storeLocation,
            dicountDetails: discountInfo,
            postedByPremium: true
        )
        
        onPost(newPost)
        dismiss()
    }
}

#Preview{
    NewCommunityPostView(user:UserSession(), onPost: { _ in })
}


