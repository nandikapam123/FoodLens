//
//  FullPostView.swift
//  Savaura
//

import SwiftUI
struct FullPostView: View {
    let post: CommunityPost
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            Theme.backColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    
                    Spacer().frame(height: 20)
                    
                    // SPONSORED BADGE
                    if post.type == .advertisement {
                        HStack {
                            Spacer()
                            Text("SPONSORED")
                                .font(.caption.bold())
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Theme.greenGradient)
                                .foregroundColor(Theme.backColor)
                                .cornerRadius(6)
                        }
                    }
                    
                    // HEADER
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text(post.type.rawValue.uppercased())
                            .font(.caption2.bold())
                            .tracking(1.5)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Theme.primaryGreen.opacity(0.2))
                            .foregroundColor(Theme.primaryGreen)
                            .clipShape(Capsule())
                        
                        Text(post.title)
                            .font(.system(.largeTitle).bold())
                            .foregroundColor(Theme.primaryGreen)
                            .shadow(color: Theme.primaryGreen.opacity(0.5), radius: 8)
                        
                        if let emailURL = URL(string: "mailto:\(post.contactInfo)") {
                            Link(destination: emailURL) {
                                Label(post.contactInfo, systemImage: "envelope.fill")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundColor(Theme.primaryGreen)
                            }
                        }
                    }
                    .padding(.top, 60)
                    
                    //IMAGE
                    if let image = post.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 220)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .cornerRadius(18)
                            .shadow(color: Theme.primaryGreen.opacity(0.4), radius: 10)
                    }
                    
                    // DESCRIPTION
                    ContentCard(title: "Description", systemImage: "text.alignleft") {
                        Text(post.description)
                            .lineSpacing(4)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    
                    // RECIPE CONTENT
                    if post.type == .recipe {
                        
                        if let ingredients = post.ingredients {
                            ContentCard(title: "Ingredients", systemImage: "leaf.fill") {
                                VStack(alignment: .leading, spacing: 10) {
                                    ForEach(ingredients, id: \.self) { item in
                                        Label(item, systemImage: "circle.fill")
                                            .font(.subheadline)
                                            .imageScale(.small)
                                            .foregroundColor(.white.opacity(0.9))
                                    }
                                }
                            }
                        }
                        
                        if let steps = post.steps {
                            ContentCard(title: "Preparation", systemImage: "checklist") {
                                VStack(alignment: .leading, spacing: 16) {
                                    
                                    ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                                        
                                        HStack(alignment: .top, spacing: 12) {
                                            
                                            Text("\(index + 1)")
                                                .font(.caption.bold())
                                                .foregroundColor(Theme.primaryGreen)
                                                .frame(width: 24, height: 24)
                                                .background(Theme.primaryGreen.opacity(0.15))
                                                .clipShape(Circle())
                                            
                                            Text(step)
                                                .font(.subheadline)
                                                .foregroundColor(.white.opacity(0.9))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // FOOD DRIVE CONTENT
                    if post.type == .foodDrive {
                        
                        if !post.volunteerDetails.isEmpty {
                            ContentCard(title: "Volunteer Details", systemImage: "person.3.fill") {
                                Text(post.volunteerDetails)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        
                        if !post.driveLocation.isEmpty {
                            ContentCard(title: "Drive Location", systemImage: "mappin.and.ellipse") {
                                Text(post.driveLocation)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        
                        if !post.missionDescription.isEmpty {
                            ContentCard(title: "Mission", systemImage: "heart.fill") {
                                Text(post.missionDescription)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                    }
                    
                    // STORE PROMOTION CONTENT
                    if post.type == .advertisement {
                        
                        if !post.storeLocation.isEmpty {
                            ContentCard(title: "Store Location", systemImage: "building.2.fill") {
                                Text(post.storeLocation)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        
                        if !post.dicountDetails.isEmpty {
                            ContentCard(title: "Promotion Details", systemImage: "tag.fill") {
                                Text(post.dicountDetails)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                    }
                    
                    Spacer(minLength: 60)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            
            // BACK BUTTON
            Button(action: { dismiss() }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                        .fontWeight(.semibold)
                }
                .foregroundColor(Theme.backColor)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Theme.greenGradient)
                .clipShape(Capsule())
                .shadow(color: Theme.primaryGreen.opacity(0.6), radius: 8)
            }
            .padding(.leading, 20)
            .padding(.top, 50)
        }
    }
}
struct ContentCard<Content: View>: View {
    
    let title: String
    let systemImage: String
    let content: Content
    
    init(title: String, systemImage: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.systemImage = systemImage
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundColor(Theme.primaryGreen)
            
            content
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Theme.lightGreen.opacity(0.25))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Theme.lightGreen.opacity(0.4), lineWidth: 1)
                )
                .shadow(
                    color: Theme.primaryGreen.opacity(0.35),
                    radius: 14
                )
        )
    }
}



