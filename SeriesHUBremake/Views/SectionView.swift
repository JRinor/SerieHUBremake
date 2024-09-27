import SwiftUI

struct SectionView: View {
    var title: String
    var series: [Series]
    
    @State private var isExpanded = false
    
    private var previewSeries: [Series] {
        Array(series.prefix(7))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white) // Couleur du texte en blanc
                    .padding(.leading)
                
                Spacer()
                
                if series.count > 7 {
                    NavigationLink(destination: FullSectionView(title: title, series: series)) {
                        HStack {
                            Text("Voir tout")
                                .foregroundColor(.white)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                }
            }
            
            if !isExpanded {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(previewSeries) { serie in
                            SerieItemView(serie: serie)
                        }
                    }
                }
            }
        }
    }
}
