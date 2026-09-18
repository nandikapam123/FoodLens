//
//  OpenFoodFactsService.swift
//  FoodLens
//
//  Service for fetching product data from Open Food Facts API
//

import Foundation

enum OpenFoodFactsError: Error, LocalizedError {
    case invalidBarcode
    case productNotFound
    case rateLimitExceeded
    case networkError(Error)
    case decodingError(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidBarcode:
            return "Invalid barcode format"
        case .productNotFound:
            return "Product not found in database"
        case .rateLimitExceeded:
            return "Too many requests. Please wait a moment."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to parse product data: \(error.localizedDescription)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

class OpenFoodFactsService {

    static let shared = OpenFoodFactsService()

    private let baseURL = "https://world.openfoodfacts.org/api/v3/product"
    private let session: URLSession

    // Rate limiting: 15 requests/minute = 1 request every 4 seconds
    private var lastRequestTime: Date?
    private let minimumRequestInterval: TimeInterval = 4.0

    // Simple cache (expires after 24 hours)
    private var cache: [String: (product: Product, timestamp: Date)] = [:]
    private let cacheExpirationInterval: TimeInterval = 86400 // 24 hours

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.waitsForConnectivity = true
        self.session = URLSession(configuration: config)
    }

    // MARK: - Public API

    /// Fetch product by barcode
    func fetchProduct(
        barcode: String,
        completion: @escaping (Result<Product, OpenFoodFactsError>) -> Void
    ) {
        // Validate barcode format (numeric, 8-13 digits)
        guard barcode.allSatisfy({ $0.isNumber }),
              (8...13).contains(barcode.count) else {
            completion(.failure(.invalidBarcode))
            return
        }

        // Check cache first
        if let cached = cache[barcode],
           Date().timeIntervalSince(cached.timestamp) < cacheExpirationInterval {
            print("✅ Returning cached product for barcode: \(barcode)")
            completion(.success(cached.product))
            return
        }

        // Rate limiting
        if let lastRequest = lastRequestTime,
           Date().timeIntervalSince(lastRequest) < minimumRequestInterval {
            let waitTime = minimumRequestInterval - Date().timeIntervalSince(lastRequest)
            print("⏳ Rate limiting: waiting \(String(format: "%.1f", waitTime))s")
            DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
                self.performFetch(barcode: barcode, completion: completion)
            }
            return
        }

        performFetch(barcode: barcode, completion: completion)
    }

    // MARK: - Private Methods

    private func performFetch(
        barcode: String,
        completion: @escaping (Result<Product, OpenFoodFactsError>) -> Void
    ) {
        let fields = "code,product_name,brands,ingredients_text,allergens,image_url,nutriments"
        let urlString = "\(baseURL)/\(barcode)?fields=\(fields)"

        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidBarcode))
            return
        }

        print("🔍 Fetching product: \(barcode)")
        lastRequestTime = Date()

        let task = session.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                // Handle network error
                if let error = error {
                    completion(.failure(.networkError(error)))
                    return
                }

                // Check HTTP status
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        break // Success
                    case 404:
                        completion(.failure(.productNotFound))
                        return
                    case 429:
                        completion(.failure(.rateLimitExceeded))
                        return
                    default:
                        completion(.failure(.unknown))
                        return
                    }
                }

                // Parse JSON
                guard let data = data else {
                    completion(.failure(.unknown))
                    return
                }

                // Debug: Print raw JSON
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📡 Raw API Response: \(jsonString.prefix(500))...")
                }

                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OpenFoodFactsResponse.self, from: data)

                    // Check if product exists
                    guard response.status == 1, response.product != nil else {
                        completion(.failure(.productNotFound))
                        return
                    }

                    let product = Product(from: response)

                    // Cache the result
                    self?.cache[barcode] = (product, Date())

                    print("✅ Product fetched: \(product.name)")
                    completion(.success(product))

                } catch {
                    print("❌ Decoding error: \(error)")
                    completion(.failure(.decodingError(error)))
                }
            }
        }

        task.resume()
    }

    // MARK: - Cache Management

    /// Clear expired cache entries
    func cleanCache() {
        let now = Date()
        cache = cache.filter { _, value in
            now.timeIntervalSince(value.timestamp) < cacheExpirationInterval
        }
        print("🧹 Cache cleaned. \(cache.count) entries remaining.")
    }

    /// Clear all cache
    func clearCache() {
        cache.removeAll()
        print("🗑️ Cache cleared.")
    }
}
