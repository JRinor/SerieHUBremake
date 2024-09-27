import SwiftUI

struct FullSectionView: View {
    var title: String
    var series: [Series]
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    // 1. Add the presentationMode environment variable
    @Environment(\.presentationMode) var presentationMode
    
    // 2. Define the backButton view
    private var backButton: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .padding(10)
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(series) { serie in
                        SerieItemView(serie: serie)
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        // 3. Hide the default back button and add the custom one
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
}
