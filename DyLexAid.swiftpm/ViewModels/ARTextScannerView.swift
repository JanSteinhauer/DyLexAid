//
//  ARTextScannerView.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 2/11/25.
//

import SwiftUI
import RealityKit
import ARKit
import Vision

struct ARTextScannerView: UIViewRepresentable {
    
    @Binding var recognizedText: String
    @Binding var isScanning: Bool
    var onTextRecognized: (String) -> Void
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let configuration = ARWorldTrackingConfiguration()
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
        arView.session.delegate = context.coordinator
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(recognizedText: $recognizedText,
                           isScanning: $isScanning,
                           onTextRecognized: onTextRecognized)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        @Binding var recognizedText: String
        @Binding var isScanning: Bool
        var onTextRecognized: (String) -> Void
        
        init(recognizedText: Binding<String>,
             isScanning: Binding<Bool>,
             onTextRecognized: @escaping (String) -> Void) {
            _recognizedText = recognizedText
            _isScanning = isScanning
            self.onTextRecognized = onTextRecognized
            super.init()
        }
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            guard isScanning else { return }
            recognizeTextFromARFrame(frame)
        }
        
        private func recognizeTextFromARFrame(_ arFrame: ARFrame) {
            let pixelBuffer = arFrame.capturedImage
            let imageRequestHandler = VNImageRequestHandler(
                cvPixelBuffer: pixelBuffer,
                orientation: .right,
                options: [:]
            )
            
            let request = VNRecognizeTextRequest { [weak self] request, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error from text recognition request: \(error)")
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                let recognizedStrings = observations.compactMap {
                    $0.topCandidates(1).first?.string
                }
                let allText = recognizedStrings.joined(separator: "\n")
                
                DispatchQueue.main.async {
                    if !allText.isEmpty {
                        self.onTextRecognized(allText)
                        self.isScanning = false
                    } else {
                        self.isScanning = true
                    }
                }
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            request.recognitionLanguages = ["en-US"]
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try imageRequestHandler.perform([request])
                } catch {
                    print("Failed to perform text recognition: \(error)")
                }
            }
        }
    }
}
