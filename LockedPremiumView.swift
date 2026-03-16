//
//  LockedPremiumView.swift
//  Savaura
//

import SwiftUI
struct LockedPremiumView: View {
    
    let feature: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            
            Image(systemName: "lock.fill")
                .font(.system(size: 60))
                .foregroundColor(Theme.primaryGreen)
            
            Text("\(feature) is Premium")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
            
            Text(description)
                .multilineTextAlignment(.center)
                .foregroundColor(Theme.lightGreen)
                .padding(.horizontal)
            
            Text("Upgrade your account to unlock.")
                .font(.caption)
                .foregroundColor(.white)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.backColor)
        .cornerRadius(16)
        .shadow(radius: 6)
        .padding()
    }
}


