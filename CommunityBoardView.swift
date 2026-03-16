//
//  CommunityBoardView.swift
//  Savaura
//

import SwiftUI
import UIKit
struct CommunityBoardView: View {
    
    @StateObject var user: UserSession
    @State private var posts: [CommunityPost] = [
        CommunityPost(
            type: .recipe,
            title: "Vegan Pasta",
            description: "Delicious vegan pasta.",
            contactInfo: "veganchef@example.com",
            image: UIImage(named: "VeganPasta"),
            ingredients: ["Pasta", "Tomatoes", "Basil"],
            steps: ["Boil pasta", "Mix Sauce", "Top with Basil"],
            volunteerDetails: "",
            driveLocation: "",
            missionDescription: "",
            storeLocation: "",
            dicountDetails: "",
            postedByPremium: true
        ),
        CommunityPost(
            type: .foodDrive,
            title: "Community Food Drive",
            description: "Help distribute meals!",
            contactInfo: "fooddrive@example.com",
            image: UIImage(named: "FoodDrive"),
            ingredients: nil,
            steps: nil,
            volunteerDetails: "Help set up and hand count food at the food drive.",
            driveLocation: "123 Anytown Food Bank",
            missionDescription: "Togther we can makes sure every child has access to consistent, nutrious food!",
            storeLocation: "",
            dicountDetails: "",
            postedByPremium: true
        ),
        CommunityPost(
            type: .advertisement,
            title: "Green Grocery",
            description: "20% Off All Fruits this Weekend",
            contactInfo: "foodStore@example.com",
            image: UIImage(named: "Grocery"),
            ingredients: nil,
            steps: nil,
            volunteerDetails: "",
            driveLocation: "",
            missionDescription: "",
            storeLocation: "456 BestTown Street",
            dicountDetails: "Only at select stores Green Grocery is offering 20% off all fruits this weekend to encourage fresh, healthy eating for the whole community.",
            postedByPremium: true
        ),
    ]
    
    @State private var showNewPost = false
    @State private var selectedPost: CommunityPost?
    
    var body: some View {
        NavigationStack {
            VStack {
                // Header
                HStack {
                    Text("Community Board")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Theme.primaryGreen)
                        .shadow(color: Theme.glowGreen.opacity(0.5), radius: 8)
                    Spacer()
                    
                    if user.accountType == "Premium" {
                        Button(action: { showNewPost = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(Theme.primaryGreen)
                                .shadow(color: Theme.glowGreen.opacity(0.5), radius: 4)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Posts List
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(posts, id: \.id) { post in
                            CommunityPostRow(post: post, selectedPost: $selectedPost)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .background(Image("SplashPic").overlay(Theme.backColor.opacity(0.7)))
            .padding(.vertical)
            
            // New Post Sheet
            .sheet(isPresented: $showNewPost) {
                NewCommunityPostView(user: user) { newPost in
                    posts.insert(newPost, at: 0)
                    showNewPost = false
                }
            }
            
            // Full Post Sheet
            .sheet(item: $selectedPost) { post in
                FullPostView(post: post)
            }
        }
    }
}
/// Post Row
struct CommunityPostRow: View {
    
    let post: CommunityPost
    @Binding var selectedPost: CommunityPost?
    
    @State private var isButtonPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Post Type Badge
            HStack {
                
                if post.type == .advertisement {
                    Text("SPONSORED")
                        .font(.caption2)
                        .bold()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.greenGradient.overlay(Theme.backColor.opacity(0.4)))
                        .foregroundColor(Theme.lightGreen)
                        .cornerRadius(6)
                }
                
                Text(post.type.rawValue)
                    .font(.caption)
                    .bold()
                    .padding(6)
                    .background(Color.white.opacity(0.85))
                    .foregroundColor(.black)
                    .cornerRadius(6)
                
                Spacer()
            }
            
            // Post Title & Description
            Text(post.title)
                .font(.headline)
                .foregroundColor(.black)
            Text(post.description)
                .font(.subheadline)
                .foregroundColor(.black)
                .lineLimit(2)
            
            // Post Actions
            // Post Actions
            if post.type == .recipe {
                Button {
                    selectedPost = post
                } label: {
                    Text("View Full Recipe")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white) // text is white
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(Theme.backColor.opacity(0.8)) // button background is backColor
                        .cornerRadius(12)
                        .shadow(color: Theme.glowGreen.opacity(isButtonPressed ? 0.8 : 0.4), radius: 6, x: 0, y: 3)
                        .scaleEffect(isButtonPressed ? 0.95 : 1.0)
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isButtonPressed = true }
                        .onEnded { _ in isButtonPressed = false }
                )
            } else if post.type == .foodDrive {
                Button {
                    selectedPost = post
                } label: {
                    Text("Sign Up / Donate")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white) // text is white
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(Theme.backColor.opacity(0.8)) // button background is backColor
                        .cornerRadius(12)
                        .shadow(color: Theme.glowGreen.opacity(isButtonPressed ? 0.8 : 0.4), radius: 6, x: 0, y: 3)
                        .scaleEffect(isButtonPressed ? 0.95 : 1.0)
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isButtonPressed = true }
                        .onEnded { _ in isButtonPressed = false }
                )
            } else {
                Button {
                    selectedPost = post
                } label: {
                    Text("See Details")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white) // text is white
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(Theme.backColor.opacity(0.8)) // button background is backColor
                        .cornerRadius(12)
                        .shadow(color: Theme.glowGreen.opacity(isButtonPressed ? 0.8 : 0.4), radius: 6, x: 0, y: 3)
                        .scaleEffect(isButtonPressed ? 0.95 : 1.0)
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isButtonPressed = true }
                        .onEnded { _ in isButtonPressed = false }
                )
            }
            
        }
        .padding()
        .background(
            Theme.lightGreen
                .cornerRadius(16)
                .shadow(
                    color: post.type == .advertisement
                    ? Theme.primaryGreen.opacity(0.8)
                    : Theme.primaryGreen.opacity(0.4),
                    radius: post.type == .advertisement ? 18 : 12,
                    x: 0,
                    y: 0
                )
        )
        .padding(.horizontal)
    }
}


#Preview{
    CommunityBoardView(user: UserSession())
}


