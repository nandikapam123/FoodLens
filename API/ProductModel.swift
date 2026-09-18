//
//  ProductModel.swift
//  FoodLens
//
//  Product data model for Open Food Facts API
//

import Foundation

// MARK: - Product Response Model

struct OpenFoodFactsResponse: Codable {
    let code: String
    let product: ProductData?
    let errors: [String]?

    enum CodingKeys: String, CodingKey {
        case code
        case product
        case errors
    }

    // Computed property to check if product exists
    var status: Int {
        return product != nil ? 1 : 0
    }
}

struct ProductData: Codable {
    let productName: String?
    let brands: String?
    let ingredientsText: String?
    let allergens: String?
    let imageURL: String?
    let nutriments: Nutriments?

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brands
        case ingredientsText = "ingredients_text"
        case allergens
        case imageURL = "image_url"
        case nutriments
    }
}

struct Nutriments: Codable {
    let energyKcal: Double?
    let proteins: Double?
    let carbohydrates: Double?
    let fat: Double?
    let fiber: Double?
    let salt: Double?
    let sugars: Double?

    enum CodingKeys: String, CodingKey {
        case energyKcal = "energy-kcal_100g"
        case proteins = "proteins_100g"
        case carbohydrates = "carbohydrates_100g"
        case fat = "fat_100g"
        case fiber = "fiber_100g"
        case salt = "salt_100g"
        case sugars = "sugars_100g"
    }
}

// MARK: - Simplified Product Model for UI

struct Product {
    let code: String
    let name: String
    let brand: String?
    let ingredients: String
    let allergens: [String]
    let imageURL: String?

    // Nutrition (per 100g)
    let calories: Double?
    let protein: Double?
    let carbs: Double?
    let fat: Double?

    init(from response: OpenFoodFactsResponse) {
        self.code = response.code
        self.name = response.product?.productName ?? "Unknown Product"
        self.brand = response.product?.brands
        self.ingredients = response.product?.ingredientsText ?? ""

        // Parse allergens (comma-separated string to array)
        if let allergensString = response.product?.allergens {
            self.allergens = allergensString
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
        } else {
            self.allergens = []
        }

        self.imageURL = response.product?.imageURL
        self.calories = response.product?.nutriments?.energyKcal
        self.protein = response.product?.nutriments?.proteins
        self.carbs = response.product?.nutriments?.carbohydrates
        self.fat = response.product?.nutriments?.fat
    }
}
