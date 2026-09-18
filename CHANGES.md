# FoodLens Setup and Configuration Changes

This branch adds real-world barcode scanning, Open Food Facts product lookup,
and safer configuration for the Groq API key. Use this guide after cloning or
merging `rima-food-scanner`.

> Repository note: the current GitHub repository contains the app's source
> files but does not contain `FoodLens.xcodeproj`. A new developer must also
> obtain the project file from the team or add these sources to an existing
> FoodLens Xcode project before following the Xcode-specific steps below.

## Requirements

- A recent version of Xcode with an iOS SDK compatible with the project
- An Apple Development team for running on a physical device
- Internet access for Open Food Facts and AI recipe requests
- A Groq API key for the AI Recipe Generator

## 1. Create the local API-key configuration

`Config.xcconfig` is intentionally excluded from Git. Create it inside the
app's `FoodLens` source folder, next to `Info.plist`:

```xcconfig
GROQ_API_KEY = your_groq_api_key_here
```

Do not commit this file. The repository's `.gitignore` ignores all
`*.xcconfig` files.

The app target must use this file as its base configuration for both Debug and
Release:

1. Open the project settings in Xcode.
2. Select the FoodLens project and open the **Info** tab.
3. Under **Configurations**, set the FoodLens target's Debug and Release base
   configuration to `Config.xcconfig`.

`Info.plist` passes the build setting into the app bundle as `GROQ_API_KEY`,
and `AI Recipe Generator/Config.swift` reads it at runtime.

> Important: An API key embedded in an iOS application can be extracted from
> the built app. For production, use a backend service to keep the Groq key
> private. If a real key was ever committed previously, revoke and rotate it.

## 2. Use the committed Info.plist

The FoodLens target should have these build settings:

```text
Generate Info.plist File = No
Info.plist File = FoodLens/Info.plist
```

The committed `Info.plist` contains:

- `GROQ_API_KEY` mapped to `$(GROQ_API_KEY)`
- `NSCameraUsageDescription` for barcode and ingredient-label scanning
- `NSPhotoLibraryUsageDescription` for selecting ingredient-label images

Do not remove the camera or photo-library usage descriptions. iOS terminates
an app that accesses protected resources without the corresponding purpose
string.

## 3. Confirm target membership

If the project uses Xcode's synchronized folders, the files are discovered
automatically. Otherwise, add the following folders/files to the FoodLens app
target:

- `API/OpenFoodFactsService.swift`
- `API/ProductModel.swift`
- `Scanner/BarcodeScanner.swift`
- `Scanner/BarcodeScannerView.swift`
- `Scanner/ManualBarcodeEntryView.swift`
- `Scanner/ScannerView.swift`
- `Info.plist`

No third-party package is required for barcode scanning. It uses
AVFoundation, UIKit, and SwiftUI. Open Food Facts also does not require an API
key.

## 4. Configure signing

In **Signing & Capabilities**:

1. Select your Apple Development team.
2. Change the bundle identifier if the existing identifier is unavailable to
   your team.
3. Let Xcode manage signing automatically unless your organization requires a
   manual profile.

No special camera entitlement is required beyond the Info.plist purpose
string.

## 5. Build and test

1. Clean the build folder with **Product > Clean Build Folder**.
2. Build with **Product > Build**.
3. Test barcode camera scanning on a physical iPhone or iPad.
4. Allow camera access when prompted.
5. Keep the device online so the scanned code can be looked up in Open Food
   Facts.

The iOS Simulator uses manual barcode entry because it does not provide the
physical camera workflow. Sample barcodes are available in the manual-entry
screen. Label (OCR) mode can use a camera photo or a photo-library image.

## Troubleshooting

### `GROQ_API_KEY not found in Info.plist`

- Confirm `Config.xcconfig` exists locally.
- Confirm it is assigned to both Debug and Release for the app target.
- Confirm `Info.plist` contains `GROQ_API_KEY = $(GROQ_API_KEY)`.
- Clean the build folder and rebuild.

### Camera permission was denied

Open **Settings > Apps > FoodLens > Camera** and enable camera access, or
delete and reinstall the development build to see the permission prompt again.

### Product not found

The barcode may be valid but absent from Open Food Facts, or the database may
not include its ingredients. Try Label (OCR) mode and scan the printed
ingredient list instead.

### Invalid barcode

Center only the product's UPC/EAN bars in the frame. Avoid nearby QR codes.
The product service currently accepts numeric barcodes containing 8–13
digits.

## Main changes in this branch

- Added live camera barcode recognition.
- Added simulator-friendly manual barcode entry.
- Added Open Food Facts lookup, caching, and rate limiting.
- Added ingredient analysis for fetched products.
- Added camera and photo-library privacy descriptions.
- Removed the hard-coded Groq key from Swift source.
- Added `.gitignore` rules for local configuration and Xcode-generated files.
