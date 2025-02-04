import SwiftUI

struct ContentView: View {
    @State private var selectedView: SelectedView = .typewrite
    
    @StateObject private var settings = AppSettings()

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedView {
                case .typewrite:
                    TypeWriterView()
                case .documentupload:
                    DocumentUploadView()
                case .information:
                    EmptyView()
                }
            }
            .environmentObject(settings)
            .font(Font.custom(settings.fontName.rawValue, size: CGFloat(settings.fontSize)))
            .lineSpacing(CGFloat(settings.lineSpacing))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Image("TypeWriter")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            withAnimation { selectedView = .typewrite }
                        }
                        .opacity(selectedView == .typewrite ? 1 : 0.5)
                    
                    Spacer()
                    
                    Image("DocumentUpload")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            withAnimation { selectedView = .documentupload }
                        }
                        .opacity(selectedView == .documentupload ? 1 : 0.5)
                    
                    Spacer()
                    
                    Image("Information")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            withAnimation { selectedView = .information }
                        }
                        .opacity(selectedView == .information ? 1 : 0.5)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.bottom, 20)
                .background(Color(.systemBackground).shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: -2))
                .ignoresSafeArea()
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
        .sheet(isPresented: Binding(
            get: { settings.firstTimeOpen },
            set: { newValue in
                // When the sheet is dismissed, update firstTimeOpen
                settings.firstTimeOpen = newValue == false ? false : settings.firstTimeOpen
            }
        )) {
            OnboardingPopupView()
                .environmentObject(settings)
                .font(Font.custom(settings.fontName.rawValue, size: CGFloat(settings.fontSize)))
                .lineSpacing(CGFloat(settings.lineSpacing))
            
        }
    }
}


enum SelectedView {
    case typewrite
    case documentupload
    case information
}
