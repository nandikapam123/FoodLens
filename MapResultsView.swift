//
//  MapResultsView.swift
//  Savaura
//

import SwiftUI
import MapKit
import CoreLocation
enum PlaceFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case grocery = "Grocery"
    case pantry = "Pantry"
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case halal = "Halal"       // premium-only
    case kosher = "Kosher"     // premium-only
    case glutenFree = "Gluten-Free" // premium-only
    
    var id: String { rawValue }
}
struct MapResultsView: View {
    
    @ObservedObject var user: UserSession
    
    @State private var region: MKCoordinateRegion
    @State private var selectedFilter: PlaceFilter = .all
    @State private var selectedLocation: PantryLocation?
    
    let allLocations: [PantryLocation]
    
    init(center: CLLocationCoordinate2D, user: UserSession) {
        self.user = user
        self.allLocations = pantryLocations
        
        _region = State(initialValue: MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    // MARK: FILTERED LOCATIONS
    
    var filteredLocations: [PantryLocation] {
        switch selectedFilter {
        case .all:
            return allLocations.filter { isAccessible(location: $0) }
        case .grocery:
            return allLocations.filter { $0.type.lowercased() == "grocery" }
        case .pantry:
            return allLocations.filter { $0.type.lowercased() == "pantry" }
        case .vegetarian:
            return allLocations.filter { $0.type.lowercased() == "vegetarian" }
        case .vegan:
            return allLocations.filter { $0.type.lowercased() == "vegan" }
        case .halal:
            guard user.accountType == "Premium" else { return [] }
            return allLocations.filter { $0.type.lowercased() == "halal" }
        case .kosher:
            guard user.accountType == "Premium" else { return [] }
            return allLocations.filter { $0.type.lowercased() == "kosher" }
        case .glutenFree:
            guard user.accountType == "Premium" else { return [] }
            return allLocations.filter { $0.type.lowercased() == "gluten-free" }
        }
    }
    
    private func isAccessible(location: PantryLocation) -> Bool {
        if user.accountType == "Premium" { return true }
        // Basic users see only common locations (exclude premium-only)
        return !["halal", "kosher", "gluten-free"].contains(location.type.lowercased())
    }
    
    // MARK: FOOD ACCESS ANALYSIS
    
    var nearbyLocations: [PantryLocation] {
        let centerLocation = CLLocation(
            latitude: region.center.latitude,
            longitude: region.center.longitude
        )
        
        return allLocations.filter { location in
            let locationPoint = CLLocation(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            
            return centerLocation.distance(from: locationPoint) < 3200 // ~2 miles
        }
    }
    
    var groceryCount: Int {
        nearbyLocations.filter { $0.type == "grocery" }.count
    }
    
    var pantryCount: Int {
        nearbyLocations.filter { $0.type == "pantry" }.count
    }
    
    var restaurantCount: Int {
        nearbyLocations.filter {
            $0.type == "vegetarian" || $0.type == "vegan"
        }.count
    }
    
    var accessMessage: String {
        if groceryCount == 0 {
            return "⚠️ Limited grocery store access detected."
        } else if groceryCount == 1 {
            return "⚠️ Only one grocery store nearby. Food access may be limited."
        } else {
            return "✅ Multiple grocery stores available nearby."
        }
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            VStack(spacing: 12) {
                
                // MARK: FOOD ACCESS INSIGHT CARD
                Spacer()
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text("Food Access Insights")
                        .font(.headline)
                        .foregroundColor(Theme.backColor)
                    
                    Text("🛒 Grocery Stores Nearby: \(groceryCount)")
                    Text("🥫 Food Pantries Nearby: \(pantryCount)")
                    Text("🥗 Healthy Restaurants Nearby: \(restaurantCount)")
                    
                    Divider()
                    
                    Text(accessMessage)
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                }
                .padding()
                .background(Theme.lightGreen)
                .cornerRadius(14)
                .padding(.horizontal)
                
                
                // MARK: FILTER
                
                Picker("Filter", selection: $selectedFilter) {
                    Text("All").tag(PlaceFilter.all)
                    Text("Grocery").tag(PlaceFilter.grocery)
                    Text("Pantry").tag(PlaceFilter.pantry)
                    Text("Vegetarian").tag(PlaceFilter.vegetarian)
                    Text("Vegan").tag(PlaceFilter.vegan)
                    
                    if user.accountType == "Premium" {
                        Text("Halal").tag(PlaceFilter.halal)
                        Text("Kosher").tag(PlaceFilter.kosher)
                        Text("Gluten-Free").tag(PlaceFilter.glutenFree)
                    }
                }
                .pickerStyle(.segmented)
                .foregroundStyle(Theme.lightGreen)
                .background(Theme.lightGreen)
                .cornerRadius(12)
                .padding(.horizontal)
                
                
                // MARK: MAP
                
                Map(coordinateRegion: $region, annotationItems: filteredLocations) { location in
                    
                    MapAnnotation(coordinate: location.coordinate) {
                        Button {
                            selectedLocation = location
                        } label: {
                            Image(systemName: icon(for: location.type))
                                .foregroundColor(.white)
                                .padding(8)
                                .padding(.bottom)
                                .background(color(for: location.type))
                                .clipShape(Circle())
                        }
                    }
                }
                .cornerRadius(16)
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Theme.backColor.ignoresSafeArea())
            .padding(.vertical)
            
            
            // MARK: LOCATION INFO CARD
            
            if let location = selectedLocation {
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(location.name)
                        .font(.headline)
                        .foregroundColor(Theme.backColor)
                    
                    Text(location.address)
                        .font(.subheadline)
                    
                    Text("Hours: \(location.hours)")
                        .font(.subheadline)
                    
                    Button("Close") {
                        selectedLocation = nil
                    }
                    .padding(6)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .background(.red)
                    .cornerRadius(8)
                }
                .padding()
                .background(Theme.lightGreen)
                .cornerRadius(16)
                .padding()
                .shadow(radius: 4)
            }
        }
        .navigationTitle("Nearby Food")
    }
    
    
    // MARK: ICONS
    
    private func icon(for type: String) -> String {
        switch type {
        case "grocery": return "cart.fill"
        case "pantry": return "leaf.fill"
        case "vegetarian": return "leaf.circle.fill"
        case "vegan": return "leaf.circle"
        case "halal": return "staroflife.fill"
        case "kosher": return "star.fill"
        case "Gluten-Free": return "drop.triangle.fill"
        default: return "mappin"
        }
    }
    
    // MARK: COLORS
    
    private func color(for type: String) -> Color {
        switch type {
        case "grocery": return .green
        case "pantry": return .orange
        case "vegetarian": return .purple
        case "vegan": return .pink
        case "halal": return .yellow
        case "kosher": return .blue
        case "Gluten-Free": return .teal
        default: return .blue
        }
    }
}


