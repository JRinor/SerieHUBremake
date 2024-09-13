import SwiftUI

struct SectionView: View {
    var title: String
    var series: [Series]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(series) { serie in
                        SerieItemView(serie: serie)
                    }
                }
            }
        }
    }
}
