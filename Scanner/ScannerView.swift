//
//  ScannerView.swift
//

import SwiftUI
import AVFoundation

enum ScanMode: String, CaseIterable {
    case barcode = "Barcode"
    case label = "Label (OCR)"
}

struct ScannerView: View {

    @Environment(\.userSession) var user

    @State private var showTip = true
    @State private var scanMode: ScanMode = .barcode

    // OCR mode states
    @State private var showPicker = false
    @State private var capturedImage: UIImage?

    // Barcode mode states
    @State private var showBarcodeScanner = false
    @State private var showManualEntry = false
    @State private var scannedBarcode: String?
    @State private var productName: String = ""

    // Check if running on simulator
    private var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    // Shared states
    @State private var scannedText: String = ""
    @State private var detectedMatches: [String] = []
    @State private var ingredientWords: [String] = []
    @State private var isLoadingProduct = false

    private let speechSynthesizer = AVSpeechSynthesizer()
    @State private var selectedCategory: IngredientCategory = .veg
    @State private var isScanButtonPressed = false
    
    var body: some View {
        ZStack {
            Theme.backColor.ignoresSafeArea()
            ScrollView{

                VStack(spacing: 28) {
                    titleView
                        .padding(.bottom, -20)
                        .padding(.top, 1) // Minimal top padding
                    scanControlsBox

                    // Show results if we have OCR image or barcode scan data
                    if capturedImage != nil || (scannedBarcode != nil && !scannedText.isEmpty && scannedText != "Loading...") {
                        resultsBox
                    }

                    if showTip {tipBox}
                    Spacer()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .sheet(isPresented: $showPicker) {
            CameraOrPhotoPicker { (image: UIImage) in
                capturedImage = image
                scanImage(image)
            }
        }
        .sheet(isPresented: $showBarcodeScanner) {
            BarcodeScannerView(isPresented: $showBarcodeScanner) { barcode in
                handleBarcodeScanned(barcode)
            }
        }
        .sheet(isPresented: $showManualEntry) {
            ManualBarcodeEntryView(isPresented: $showManualEntry) { barcode in
                handleBarcodeScanned(barcode)
            }
        }
    }
        
    private var titleView: some View {
        VStack(spacing: 12) {
            PageHeader(
                title: "Food Scanner",
                subtitle: scanMode == .barcode
                    ? "Scan product barcodes for instant ingredient analysis"
                    : "Take a photo of any ingredient label and instantly find out if it fits your dietary needs"
            )

            // Scan mode toggle
            Picker("Scan Mode", selection: $scanMode) {
                ForEach(ScanMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .onChange(of: scanMode) {
                clearScreen()
            }
        }
    }
    
    private var scanControlsBox: some View {
        DarkCard {
            if isLoadingProduct {
                VStack(spacing: 16) {
                    ProgressView()
                        .tint(Theme.primaryGreen)
                        .scaleEffect(1.5)
                    Text("Fetching product data...")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 50)
            } else {
                Text("Select Category to Scan For")
                    .font(.headline)
                    .foregroundColor(Theme.primaryGreen)
                    .padding(.top, 10)
                categoryPicker
                scanButton
            }
        }
        .padding()
    }
    
    private var categoryPicker: some View {
        Picker("Select Category", selection: $selectedCategory) {
            Text("Nut-Free").tag(IngredientCategory.nut_free)
            Text("Dairy-Free").tag(IngredientCategory.dairy_free)
            Text("Gluten-Free").tag(IngredientCategory.gluten_free)
            Text("Vegetarian").tag(IngredientCategory.veg)
            Text("Vegan").tag(IngredientCategory.vegan)
            Text("Soy-Free").tag(IngredientCategory.soy_free)
            Text("Shellfish-Free").tag(IngredientCategory.shellfish_free)
            Text("Halal").tag(IngredientCategory.halal)
            Text("Kosher").tag(IngredientCategory.kosher)
            if user.accountType == "Premium" {
                Text("Preservatives").tag(IngredientCategory.preservatives_free)
                Text("Palm Oil").tag(IngredientCategory.palm_oil_free)
                Text("Added Sugars").tag(IngredientCategory.added_sugars_free)
            }
        }
        .onChange(of: selectedCategory) {
            clearScreen()
        }
        .pickerStyle(.wheel)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Theme.lightGreen.opacity(1))
                .shadow(color: Theme.glowGreen.opacity(0.3), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    private var scanButton: some View {
        Button(action: {
            if scanMode == .barcode {
                // Use manual entry on simulator, camera on real device
                if isSimulator {
                    showManualEntry = true
                } else {
                    showBarcodeScanner = true
                }
            } else {
                showPicker = true
            }
        }) {
            Label(
                scanMode == .barcode
                    ? (isSimulator ? "Enter Barcode (Simulator)" : "Scan Barcode")
                    : "Scan / Select Photo",
                systemImage: scanMode == .barcode
                    ? (isSimulator ? "keyboard" : "barcode.viewfinder")
                    : "camera"
            )
            .font(.custom("Verdana", size: 18))
            .frame(maxWidth: .infinity)
            .padding()
            .bold()
            .foregroundColor(Theme.backColor)
            .background(
                Theme.greenGradient
                    .cornerRadius(14)
                    .shadow(color: Theme.glowGreen.opacity(isScanButtonPressed ? 0.8 : 0.5), radius: 12)
            )
            .scaleEffect(isScanButtonPressed ? 0.95 : 1.0)
        }
        .padding(.horizontal)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isScanButtonPressed = true }
                .onEnded { _ in isScanButtonPressed = false }
        )
    }
    
    private var resultsBox: some View {
        DarkCard{
            resultStatus
            ingredientsList
            
        }
        .padding()
        .padding(.top, -30)
    }
    
    private var resultStatus: some View {
        HStack(alignment: .top) {
            if detectedMatches.isEmpty {
                Image(systemName: "checkmark.circle.fill")
                    .padding(10)
                    .foregroundColor(Theme.primaryGreen)
                    .font(.system(size: 30))

                
                Text("Food is \(selectedCategory.rawValue.capitalized)")
                    .font(.headline)
                    .foregroundColor(Theme.primaryGreen)
                    .bold()
                    .padding(10)
                    .cornerRadius(12)
            } else {
                VStack(spacing: 6) {
                    Text("⚠️ Not \(selectedCategory.rawValue.capitalized)")
                        .font(.headline)
                        .foregroundColor(.red)
                        .bold()
                    
                    Text("Contains: \(detectedMatches.map { $0.capitalized }.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(10)
                .background(Color.black.opacity(0.25))
                .cornerRadius(12)
            }
            
            Button(action: { speakResult() }) {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(.white)
                    .padding(12)
                    .background(
                        LinearGradient(
                            colors: [Theme.primaryGreen, Theme.accentColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: Theme.glowGreen.opacity(0.5), radius: 5, x: 0, y: 0)
            }
        }
    }
    
    private var ingredientsList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredients Detected:")
                .font(.headline)
                .foregroundStyle(Theme.primaryGreen)
                .multilineTextAlignment(.leading)

            if !ingredientWords.isEmpty {
                ScrollView {
                    Text(buildHighlightedIngredientsText())
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.25))
                        )
                        .onTapGesture {
                            let ingredientText = ingredientWords.joined(separator: ", ")
                            speak("Ingredients detected: \(ingredientText)")
                        }
                }
                .frame(maxHeight: 250)
            } else if !scannedText.isEmpty && scannedText != "Loading..." {
                // Show raw text if parsing failed or returned empty
                ScrollView {
                    Text(scannedText)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.25))
                        )
                }
                .frame(maxHeight: 250)
            } else {
                Text("No ingredients information available")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.25))
                    )
            }
        }
    }
    
    private var instructionsBox: some View {
        Text("Take/Upload a Picture of Your Ingredient List")
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.white.opacity(0.9))
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Theme.lightGreen.opacity(0.35))
            )
            .padding(.horizontal)
            .padding(.top, -25)
    }
    
    private var tipBox: some View {
        
//        HStack{
//            Image(systemName: "lightbulb")
//                .foregroundColor(Theme.primaryGreen)
//                .padding()
//                .font(Font.system(size: 30))
//            
//            Spacer()
//                            
//            Text("Tip: Use good lighting and a clear image of the ingredient label. *Scanner may make mistakes.")
//            
//                .font(.subheadline)
//                .foregroundColor(.white.opacity(0.5))
//                .fixedSize(horizontal: false, vertical: true)
//                .padding()
//        }
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(Theme.primaryGreen)
                    .font(.system(size: 22))
                    

                Text("Use good lighting and a clear image of the ingredient label. The scanner may make mistakes.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()

                Button(action: {
                    showTip = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            .padding()
            .padding(.horizontal)
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
        
    }
    
    // MARK: - Functions
    
    private func speakResult() {
        if detectedMatches.isEmpty {
            speak("Food is \(selectedCategory.rawValue.capitalized)")
        } else {
            let items = detectedMatches.map { $0.capitalized }.joined(separator: ", ")
            speak("Not \(selectedCategory.rawValue.capitalized). Contains: \(items)")
        }
    }
    
    private func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-AU")
        utterance.rate = 0.4
        speechSynthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer.speak(utterance)
    }
    
    private func clearScreen() {
        scannedText = ""
        detectedMatches = []
        ingredientWords = []
        capturedImage = nil
        scannedBarcode = nil
        productName = ""
    }

    private func handleBarcodeScanned(_ barcode: String) {
        scannedBarcode = barcode
        isLoadingProduct = true

        // Show loading state
        scannedText = "Loading..."
        ingredientWords = []
        detectedMatches = []

        // Fetch from Open Food Facts API
        OpenFoodFactsService.shared.fetchProduct(barcode: barcode) { result in
            DispatchQueue.main.async {
                self.isLoadingProduct = false

                switch result {
                case .success(let product):
                    // Update product name with brand
                    self.productName = product.name
                    if let brand = product.brand, !brand.isEmpty {
                        self.productName = "\(product.name) - \(brand)"
                    }

                    // Use ingredients text from API
                    self.scannedText = product.ingredients.isEmpty
                        ? "No ingredients information available for this product."
                        : product.ingredients

                    // Parse ingredients into words (same as OCR)
                    if !product.ingredients.isEmpty {
                        self.ingredientWords = product.ingredients
                            .components(separatedBy: CharacterSet(charactersIn: ",\n"))
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                            .filter { !$0.isEmpty }
                    } else {
                        self.ingredientWords = []
                    }

                    // Run ingredient matching against selected category
                    self.detectedMatches = IngredientScanner.matchKeywords(
                        in: product.ingredients,
                        category: self.selectedCategory
                    )

                    // Save to scan history
                    self.user.addScan(category: self.selectedCategory, matches: self.detectedMatches)

                    // Show results (set capturedImage to trigger resultsBox display)
                    // Since we don't have an actual image, we'll rely on scannedText being populated

                    print("✅ Product: \(product.name)")
                    print("📦 Brand: \(product.brand ?? "none")")
                    print("📝 Ingredients text length: \(product.ingredients.count) characters")
                    if !product.ingredients.isEmpty {
                        print("📝 Ingredients (first 100 chars): \(product.ingredients.prefix(100))...")
                        print("📝 Parsed words count: \(self.ingredientWords.count)")
                        if self.ingredientWords.count > 0 {
                            print("📝 First few words: \(self.ingredientWords.prefix(5).joined(separator: ", "))")
                        }
                    } else {
                        print("⚠️ Ingredients text is EMPTY")
                    }
                    print("⚠️ Detected matches: \(self.detectedMatches)")
                    print("🎯 scannedText: \(self.scannedText.prefix(100))...")

                case .failure(let error):
                    // Handle different error types with user-friendly messages
                    self.productName = "Error"

                    switch error {
                    case .productNotFound:
                        self.scannedText = "Product not found in database.\n\nTry:\n• Scanning from a different angle\n• Using OCR mode for the ingredients label"
                        self.ingredientWords = ["Product", "not", "found"]

                    case .rateLimitExceeded:
                        self.scannedText = "Too many scans in a short time.\n\nPlease wait a few seconds and try again."
                        self.ingredientWords = ["Rate", "limit", "exceeded"]

                    case .networkError:
                        self.scannedText = "No internet connection.\n\nPlease check your network and try again.\n\nTip: Use OCR mode to scan offline!"
                        self.ingredientWords = ["Network", "error"]

                    case .invalidBarcode:
                        self.scannedText = "Invalid barcode format.\n\nTry scanning again or use OCR mode."
                        self.ingredientWords = ["Invalid", "barcode"]

                    default:
                        self.scannedText = "Error loading product.\n\n\(error.localizedDescription)\n\nTry using OCR mode instead."
                        self.ingredientWords = ["Error"]
                    }

                    self.detectedMatches = []
                    print("❌ Error fetching product: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func scanImage(_ image: UIImage) {
        IngredientScanner.scanIngredientsWithMatches(from: image) { (text: String, results: [IngredientCategory: [String]]) in
            DispatchQueue.main.async {
                scannedText = text
                detectedMatches = results[selectedCategory] ?? []
                
                ingredientWords = text
                    .components(separatedBy: CharacterSet(charactersIn: ",\n"))
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                
                user.addScan(category: selectedCategory, matches: detectedMatches)
            }
        }
    }
    
    private func buildHighlightedIngredientsText() -> AttributedString {
        var result = AttributedString("")
        
        for (index, word) in ingredientWords.enumerated() {
            var attributedWord = AttributedString(word)
            
            if detectedMatches.contains(where: { word.lowercased().contains($0.lowercased()) }) {
                attributedWord.foregroundColor = .red
                attributedWord.font = .subheadline.bold()
            } else {
                attributedWord.foregroundColor = .white
            }
            
            if index < ingredientWords.count - 1 {
                attributedWord.append(AttributedString(", "))
            }
            
            result.append(attributedWord)
        }
        
        return result
    }
}

#Preview{
    ScannerView()
}
