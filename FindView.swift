//
//  FindView.swift
//  Savaura
//

import SwiftUI
import CoreLocation
struct FindView: View {
    
    @StateObject var user = UserSession()
    
    @State private var zipCode: String = ""
    @State private var showMap = false
    @State private var coordinates: CLLocationCoordinate2D?
    
    @State private var isButtonPressed = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                Theme.backColor.ignoresSafeArea()
                
                ScrollView{
                    VStack(spacing: 24) {
                        
                        Spacer()
                        
                        // MARK: Title
                        Text("Find Food")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Theme.primaryGreen)
                            .shadow(color: Theme.glowGreen.opacity(0.5), radius: 8)
                        
                        Text("""
                Enter your ZIP code to find nearby grocery stores, food pantries, vegetarian, and vegan options.
                """)
                        .multilineTextAlignment(.center)
                        .font(.custom("Verdana", size: 16))
                        .foregroundColor(Theme.lightGreen)
                        .padding(.horizontal)
                        
                        // MARK: ZIP Code Input
                        TextField("Enter ZIP Code", text: $zipCode)
                            .padding()
                            .background(Theme.lightGreen.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .keyboardType(.numberPad)
                            .padding(.horizontal)
                        
                        // MARK: Show Map Button
                        Button {
                            Task {
                                coordinates = await geocode(zipCode: zipCode)
                                if coordinates != nil { showMap = true }
                            }
                        } label: {
                            Text("Show on Map")
                                .font(.custom("Verdana", size: 20))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .bold()
                                .foregroundColor(Theme.backColor)
                                .background(
                                    LinearGradient(
                                        colors: [Theme.primaryGreen, Theme.accentColor],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    .cornerRadius(14)
                                    .shadow(color: Theme.glowGreen.opacity(isButtonPressed ? 0.8 : 0.5), radius: 12, x: 0, y: 4)
                                )
                                .scaleEffect(isButtonPressed ? 0.95 : 1.0)
                        }
                        .padding(.horizontal)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in isButtonPressed = true }
                                .onEnded { _ in isButtonPressed = false }
                        )
                        
                        // MARK: Legend Boxes
                        VStack(spacing: 16) {
                            
                            // Grocery Box
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Grocery / Pantry")
                                    .font(.custom("Verdana-Bold", size: 18))
                                    .foregroundColor(Theme.backColor)
                                
                                HStack(spacing: 16) {
                                    Image(systemName: "cart.circle.fill")
                                        .foregroundStyle(.green)
                                    Text("Grocery Stores")
                                        .font(.custom("Verdana", size: 16))
                                    
                                    Image(systemName: "leaf.fill")
                                        .foregroundStyle(.orange)
                                    Text("Food Pantries")
                                        .font(.custom("Verdana", size: 16))
                                    
                                    Spacer()
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.lightGreen)
                            .cornerRadius(20)
                            .shadow(color: Theme.glowGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            // Restaurants / Specialty Box
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Restaurants / Specialty")
                                    .font(.custom("Verdana-Bold", size: 18))
                                    .foregroundColor(Theme.backColor)
                                
                                HStack(spacing: 16) {
                                    Image(systemName: "leaf.circle.fill")
                                        .foregroundStyle(.purple)
                                    Text("Vegetarian")
                                        .font(.custom("Verdana", size: 16))
                                    
                                    Image(systemName: "leaf.circle")
                                        .foregroundStyle(.pink)
                                    Text("Vegan")
                                        .font(.custom("Verdana", size: 16))
                                    
                                    Spacer()
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.lightGreen)
                            .cornerRadius(20)
                            .shadow(color: Theme.glowGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                        }
                        .padding(.horizontal)
                        
                        
                        Spacer()
                        
                        Text("Use the button above to view nearby options based on your ZIP code!")
                            .font(.custom("Verdana", size: 15))
                            .foregroundColor(.white.opacity(0.9))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Theme.lightGreen.opacity(0.25))
                                    .shadow(color: Theme.glowGreen.opacity(0.25), radius: 5, x: 0, y: 2)
                            )
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    .navigationTitle("")
                    .navigationDestination(isPresented: $showMap) {
                        if let coordinates = coordinates {
                            MapResultsView(center: coordinates, user: user)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - ZIP → Coordinates
    func geocode(zipCode: String) async -> CLLocationCoordinate2D? {
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.geocodeAddressString(zipCode)
            return placemarks.first?.location?.coordinate
        } catch {
            print("Geocoding failed:", error)
            return nil
        }
    }
}

#Preview{
    FindView(
        user: UserSession()
        
    )
}

