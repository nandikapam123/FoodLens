//
//  Config.swift
//

import Foundation

// GROQ API KEY - Now loaded from Config.xcconfig via Info.plist
struct Config {
    static let groqAPIKey: String = {
        guard let key = Bundle.main.infoDictionary?["GROQ_API_KEY"] as? String,
              !key.isEmpty else {
            fatalError("⚠️ GROQ_API_KEY not found in Info.plist. Make sure Config.xcconfig is properly configured.")
        }
        return key
    }()
}


