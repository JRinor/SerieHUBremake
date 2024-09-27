import SwiftUI

struct SearchResultsView: View {
    let series: [Series]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
                ForEach(series) { serie in
                    SerieItemView(serie: serie)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
}
