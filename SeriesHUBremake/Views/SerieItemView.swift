import SwiftUI

struct SerieItemView: View {
    let serie: Series
    
    var body: some View {
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
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text(String(format: "%.1f", serie.voteAverage))
                .font(.caption2)
                .foregroundColor(.yellow)
        }
        .frame(width: 100)
    }
}
