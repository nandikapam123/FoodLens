//
//  BarcodeScannerView.swift
//  FoodLens
//
//  SwiftUI wrapper for BarcodeScanner
//

import SwiftUI
import AVFoundation

struct BarcodeScannerView: UIViewControllerRepresentable {

    @Binding var isPresented: Bool
    var onBarcodeScanned: (String) -> Void

    func makeUIViewController(context: Context) -> BarcodeScannerViewController {
        let controller = BarcodeScannerViewController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: BarcodeScannerViewController, context: Context) {
        // No updates needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, BarcodeScannerViewControllerDelegate {
        let parent: BarcodeScannerView

        init(parent: BarcodeScannerView) {
            self.parent = parent
        }

        func barcodeScannerViewController(
            _ controller: BarcodeScannerViewController,
            didScanBarcode code: String
        ) {
            parent.onBarcodeScanned(code)
            parent.isPresented = false
        }

        func barcodeScannerViewController(
            _ controller: BarcodeScannerViewController,
            didFailWithError error: BarcodeScannerError
        ) {
            print("❌ Barcode scanner error: \(error.localizedDescription)")
            parent.isPresented = false
        }

        func barcodeScannerViewControllerDidCancel(_ controller: BarcodeScannerViewController) {
            parent.isPresented = false
        }
    }
}

// MARK: - UIKit View Controller

protocol BarcodeScannerViewControllerDelegate: AnyObject {
    func barcodeScannerViewController(_ controller: BarcodeScannerViewController, didScanBarcode code: String)
    func barcodeScannerViewController(_ controller: BarcodeScannerViewController, didFailWithError error: BarcodeScannerError)
    func barcodeScannerViewControllerDidCancel(_ controller: BarcodeScannerViewController)
}

class BarcodeScannerViewController: UIViewController {

    weak var delegate: BarcodeScannerViewControllerDelegate?

    private var scanner: BarcodeScanner?
    private var previewView: UIView!
    private var scanAreaView: UIView!
    private var instructionLabel: UILabel!
    private var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupScanner()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scanner?.startScanning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scanner?.stopScanning()
    }

    private func setupUI() {
        view.backgroundColor = .black

        // Preview view (full screen)
        previewView = UIView(frame: view.bounds)
        view.addSubview(previewView)

        // Scan area overlay (center square)
        let scanSize: CGFloat = 250
        scanAreaView = UIView()
        scanAreaView.layer.borderColor = UIColor.systemGreen.cgColor
        scanAreaView.layer.borderWidth = 2
        scanAreaView.layer.cornerRadius = 12
        scanAreaView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scanAreaView)

        NSLayoutConstraint.activate([
            scanAreaView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanAreaView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scanAreaView.widthAnchor.constraint(equalToConstant: scanSize),
            scanAreaView.heightAnchor.constraint(equalToConstant: scanSize)
        ])

        // Instruction label
        instructionLabel = UILabel()
        instructionLabel.text = "Position barcode in the frame"
        instructionLabel.textColor = .white
        instructionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        instructionLabel.textAlignment = .center
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionLabel)

        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: scanAreaView.bottomAnchor, constant: 32),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        // Cancel button
        cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        cancelButton.layer.cornerRadius = 12
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 200),
            cancelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupScanner() {
        scanner = BarcodeScanner()
        scanner?.delegate = self
        scanner?.setup(previewView: previewView)
    }

    @objc private func cancelButtonTapped() {
        delegate?.barcodeScannerViewControllerDidCancel(self)
    }

    deinit {
        scanner?.cleanup()
    }
}

// MARK: - BarcodeScannerDelegate

extension BarcodeScannerViewController: BarcodeScannerDelegate {

    func barcodeScanner(_ scanner: BarcodeScanner, didScanBarcode code: String) {
        // Animate scan area to indicate success
        UIView.animate(withDuration: 0.2, animations: {
            self.scanAreaView.layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.8).cgColor
            self.scanAreaView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.scanAreaView.transform = .identity
            }
        }

        // Notify delegate
        delegate?.barcodeScannerViewController(self, didScanBarcode: code)
    }

    func barcodeScanner(_ scanner: BarcodeScanner, didFailWithError error: BarcodeScannerError) {
        // Show error alert
        let alert = UIAlertController(
            title: "Scanner Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.barcodeScannerViewController(self, didFailWithError: error)
        })

        present(alert, animated: true)
    }
}
