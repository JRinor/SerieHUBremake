import SwiftUI

struct SearchResultsView: View {
    let series: [Series]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                ForEach(series) { serie in
                    SerieItemView(serie: serie)
                }
            }
            .padding()
        }
    }
}
