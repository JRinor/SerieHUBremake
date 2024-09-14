import SwiftUI

struct ContinuousScrollingSection: View {
    let title: String
    let series: [Series]
    let scrollDuration: Double
    
    @State private var offset: CGFloat = 0
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.leading)
            
            GeometryReader { geometry in
                let itemWidth: CGFloat = 110
                let totalWidth = CGFloat(series.count) * itemWidth
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(series + series) { serie in
                            SerieItemView(serie: serie)
                        }
                    }
                    .offset(x: isAnimating ? -totalWidth : 0)
                    .animation(Animation.linear(duration: scrollDuration).repeatForever(autoreverses: false), value: isAnimating)
                }
            }
            .frame(height: 200)
            .clipped()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isAnimating = true
            }
        }
    }
}
