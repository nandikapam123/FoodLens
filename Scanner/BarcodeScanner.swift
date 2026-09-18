//
//  BarcodeScanner.swift
//  FoodLens
//
//  Barcode scanner using AVFoundation for EAN-13, UPC-A, etc.
//

import AVFoundation
import UIKit

protocol BarcodeScannerDelegate: AnyObject {
    func barcodeScanner(_ scanner: BarcodeScanner, didScanBarcode code: String)
    func barcodeScanner(_ scanner: BarcodeScanner, didFailWithError error: BarcodeScannerError)
}

enum BarcodeScannerError: Error {
    case cameraUnavailable
    case permissionDenied
    case setupFailed(String)

    var localizedDescription: String {
        switch self {
        case .cameraUnavailable:
            return "Camera is not available on this device"
        case .permissionDenied:
            return "Camera permission denied. Please enable it in Settings."
        case .setupFailed(let reason):
            return "Scanner setup failed: \(reason)"
        }
    }
}

class BarcodeScanner: NSObject {

    weak var delegate: BarcodeScannerDelegate?

    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    private var isScanning = false
    private var lastScannedCode: String?
    private var lastScanTime: Date?

    // Debounce interval to prevent duplicate scans
    private let scanDebounceInterval: TimeInterval = 2.0

    // MARK: - Setup

    func setup(previewView: UIView) {
        // Check camera availability
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            delegate?.barcodeScanner(self, didFailWithError: .cameraUnavailable)
            return
        }

        // Request camera permission
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if granted {
                    self.setupCaptureSession(previewView: previewView)
                } else {
                    self.delegate?.barcodeScanner(self, didFailWithError: .permissionDenied)
                }
            }
        }
    }

    private func setupCaptureSession(previewView: UIView) {
        let session = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            delegate?.barcodeScanner(self, didFailWithError: .setupFailed("No video capture device found"))
            return
        }

        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)

            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            } else {
                delegate?.barcodeScanner(self, didFailWithError: .setupFailed("Could not add video input"))
                return
            }

            let metadataOutput = AVCaptureMetadataOutput()

            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)

                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

                // Support common barcode types
                metadataOutput.metadataObjectTypes = [
                    .ean8,
                    .ean13,
                    .upce,
                    .code39,
                    .code128,
                    .qr
                ]
            } else {
                delegate?.barcodeScanner(self, didFailWithError: .setupFailed("Could not add metadata output"))
                return
            }

            // Setup preview layer
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.frame = previewView.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            previewView.layer.addSublayer(previewLayer)

            self.previewLayer = previewLayer
            self.captureSession = session

        } catch {
            delegate?.barcodeScanner(self, didFailWithError: .setupFailed(error.localizedDescription))
        }
    }

    // MARK: - Control

    func startScanning() {
        guard !isScanning else { return }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }

        isScanning = true
    }

    func stopScanning() {
        guard isScanning else { return }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.stopRunning()
        }

        isScanning = false
    }

    func reset() {
        lastScannedCode = nil
        lastScanTime = nil
    }

    // MARK: - Cleanup

    func cleanup() {
        stopScanning()
        previewLayer?.removeFromSuperlayer()
        captureSession = nil
        previewLayer = nil
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension BarcodeScanner: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue else {
            return
        }

        // Debounce: prevent scanning the same code multiple times in quick succession
        let now = Date()
        if let lastCode = lastScannedCode,
           let lastTime = lastScanTime,
           lastCode == stringValue,
           now.timeIntervalSince(lastTime) < scanDebounceInterval {
            return
        }

        // Update scan history
        lastScannedCode = stringValue
        lastScanTime = now

        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        // Play system sound
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

        // Notify delegate
        delegate?.barcodeScanner(self, didScanBarcode: stringValue)
    }
}
