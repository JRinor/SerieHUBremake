import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Logo avec animation de fondu
                if let logo = UIImage(named: "Logo") ?? UIImage(named: "IMG/Track-R.png") {
                    Image(uiImage: logo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                } else {
                    Text("SeriesHUB")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                }
                
                // Animation de points de chargement
                HStack(spacing: 10) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 10, height: 10)
                            .scaleEffect(isAnimating ? 1 : 0.5)
                            .opacity(isAnimating ? 1 : 0.3)
                            .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(Double(index) * 0.2), value: isAnimating)
                    }
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}
