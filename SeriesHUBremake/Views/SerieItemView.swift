import SwiftUI

struct SerieItemView: View {
    let serie: Series
    
    var body: some View {
        NavigationLink(destination: SeriesDetailView(series: serie)) {
            VStack {
                AsyncImage(url: serie.imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure(_):
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 100, height: 150)
                .cornerRadius(10)
                
                Text(serie.name)
                    .font(.caption)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 100)
        }
    }
}
