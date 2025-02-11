//
//  TextScan.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 2/11/25.
//

import SwiftUI
import RealityKit
import ARKit
import Vision

struct TextScan: View {
    @EnvironmentObject var viewModel: TextProcessingViewModel
    
    @Binding var selectedView: SelectedView
    
    @State private var recognizedText: String = ""
    @State private var scannedText: String = ""
    @State private var isScanning: Bool = false
    @State private var showSheet: Bool = false
    
    var body: some View {
        VStack {
            ARTextScannerView(recognizedText: $recognizedText,
                              isScanning: $isScanning,
                              onTextRecognized: { text in
                if !text.isEmpty {
                    scannedText = text
                    showSheet = true
                } else {
                    isScanning = true
                }
            })
            .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                scannedText = ""
                isScanning = true
            }) {
                Text("Start Text Scan")
                    .font(.headline)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.bottom, 100)
        }
        .sheet(isPresented: $showSheet) {
            VStack {
                Text("Scanned Text")
                    .font(.headline)
                    .padding(.top)
                
                ScrollView {
                    Text(scannedText)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 200)
                
                HStack {
                    Button(action: {
                        showSheet = false
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    
                    Button(action: {
                        recognizedText = scannedText
                        viewModel.userText = scannedText
                        selectedView = .typewrite
                        showSheet = false
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding()
            }
            .padding()
        }
    }
}
