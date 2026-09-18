//
//  ManualBarcodeEntryView.swift
//  FoodLens
//
//  Manual barcode entry for testing on simulator
//

import SwiftUI

struct ManualBarcodeEntryView: View {
    @Binding var isPresented: Bool
    var onBarcodeEntered: (String) -> Void

    @State private var barcodeInput: String = ""
    @FocusState private var isFocused: Bool

    // Sample test barcodes
    private let sampleBarcodes = [
        ("Coca-Cola", "0049000050103"),
        ("Nutella", "8000500037713"),
        ("Jif Peanut Butter", "0016000275270"),
        ("Cheerios", "0016000275287"),
        ("Not Found Test", "9999999999999")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.backColor.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {

                        // Header
                        VStack(spacing: 8) {
                            Image(systemName: "keyboard")
                                .font(.system(size: 50))
                                .foregroundColor(Theme.primaryGreen)

                            Text("Simulator Mode")
                                .font(.title2.bold())
                                .foregroundColor(.white)

                            Text("Enter a barcode manually or select a sample product")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 20)

                        // Manual input
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Enter Barcode")
                                .font(.headline)
                                .foregroundColor(Theme.primaryGreen)

                            TextField("e.g., 0049000050103", text: $barcodeInput)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .keyboardType(.numberPad)
                                .focused($isFocused)

                            Button(action: submitBarcode) {
                                Text("Scan This Barcode")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(Theme.backColor)
                                    .background(
                                        LinearGradient(
                                            colors: [Theme.primaryGreen, Theme.accentColor],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(12)
                            }
                            .disabled(barcodeInput.isEmpty)
                            .opacity(barcodeInput.isEmpty ? 0.5 : 1.0)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(16)
                        .padding(.horizontal)

                        // Sample products
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Sample Products")
                                .font(.headline)
                                .foregroundColor(Theme.primaryGreen)
                                .padding(.horizontal)

                            VStack(spacing: 12) {
                                ForEach(sampleBarcodes, id: \.1) { name, barcode in
                                    Button(action: {
                                        selectSampleBarcode(barcode)
                                    }) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(name)
                                                    .font(.subheadline.bold())
                                                    .foregroundColor(.white)

                                                Text(barcode)
                                                    .font(.caption)
                                                    .foregroundColor(.white.opacity(0.6))
                                            }

                                            Spacer()

                                            Image(systemName: "barcode.viewfinder")
                                                .foregroundColor(Theme.primaryGreen)
                                        }
                                        .padding()
                                        .background(Color.white.opacity(0.08))
                                        .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        Spacer()
                    }
                }
            }
            .navigationTitle("Manual Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(Theme.primaryGreen)
                }
            }
        }
        .onAppear {
            isFocused = true
        }
    }

    private func submitBarcode() {
        guard !barcodeInput.isEmpty else { return }
        onBarcodeEntered(barcodeInput)
        isPresented = false
    }

    private func selectSampleBarcode(_ barcode: String) {
        onBarcodeEntered(barcode)
        isPresented = false
    }
}

#Preview {
    ManualBarcodeEntryView(isPresented: .constant(true)) { barcode in
        print("Barcode entered: \(barcode)")
    }
}
