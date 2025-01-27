import SwiftUI

struct ContentView: View {
    @State private var userText: String = """
In the present state of society, it appears necessary to go back to first principles in search of the most simple truths, and to dispute with some prevailing prejudice every inch of ground. To render women truly virtuous and independent, they must be educated in a manner that does not merely fit them for engaging the affections of a lover, but for developing their own faculties and gaining their own subsistence. For this, they must be permitted to study and understand the world, to reflect on the duties of life, and to be recognized as rational beings whose happiness depends not on the caprice of another, but on their own conduct and choices.
"""
    @State private var simplifiedText: String = ""
    
    private let simplifier = Simplifier()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("DyLexAid - Enhanced with Dictionary")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            TextEditor(text: $userText)
                .border(Color.gray, width: 1)
                .padding()
                .frame(minHeight: 200)
            
            Button("Simplify") {
                simplifiedText = simplifier.simplify(text: userText)
            }
            .font(.headline)
            .padding()
            
            Text("Simplified Version:")
                .font(.headline)
            
            ScrollView {
                Text(simplifiedText)
                    .padding()
            }
            .border(Color.gray, width: 1)
            .frame(minHeight: 180)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}
