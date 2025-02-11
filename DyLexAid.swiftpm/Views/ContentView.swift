import SwiftUI

struct ContentView: View {
    @State private var selectedView: SelectedView = .typewrite
        @StateObject private var settings = AppSettings()
        @StateObject private var viewModel = TextProcessingViewModel()
        
        @ViewBuilder
        private var mainContent: some View {
            switch selectedView {
            case .typewrite:
                TypeWriterView()
                    .environmentObject(viewModel)
            case .documentupload:
                TextScan(selectedView: $selectedView)
                    .environmentObject(viewModel)
            case .information:
                DyslexiaInfoView()
            }
        }
        
    var body: some View {
        ZStack(alignment: .bottom) {
            mainContent
                .environmentObject(settings)
                .font(Font.custom(settings.fontName.rawValue, size: CGFloat(settings.fontSize)))
                .lineSpacing(CGFloat(settings.lineSpacing))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                HStack {
                    Spacer()
                    
                    Image("FirstPage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            withAnimation { selectedView = .typewrite }
                        }
                        .opacity(selectedView == .typewrite ? 1 : 0.5)
                    
                    Spacer()
                    
                    Image("SecondPage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            withAnimation { selectedView = .documentupload }
                        }
                        .opacity(selectedView == .documentupload ? 1 : 0.5)
                    
                    Spacer()
                    
                    Image("ThirdPage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            withAnimation { selectedView = .information }
                        }
                        .opacity(selectedView == .information ? 1 : 0.5)
                    
                    Spacer()
                }
                
                .padding(.bottom, 10)
                .padding(.vertical, 10)
                .ignoresSafeArea(edges: .bottom)
                .background(Color(.systemBackground) )
            }
           
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
        .sheet(isPresented: Binding(
            get: { settings.firstTimeOpen },
            set: { newValue in
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
