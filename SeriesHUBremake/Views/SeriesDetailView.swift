import SwiftUI

struct SeriesDetailView: View {
    let series: Series
    @State private var selectedTab = 0
    @StateObject private var viewModel = SeriesViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var showActorSeries = false
    @State private var selectedActor: CastMember?

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header with background image and poster
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: series.backdropUrl ?? series.imageUrl) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable().aspectRatio(contentMode: .fill)
                            default:
                                Color.gray
                            }
                        }
                        .frame(height: 200)
                        .overlay(
                            LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                        )

                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .bottom, spacing: 15) {
                                AsyncImage(url: series.imageUrl) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image.resizable().aspectRatio(contentMode: .fill)
                                    default:
                                        Color.gray
                                    }
                                }
                                .frame(width: 80, height: 120)
                                .cornerRadius(10)
                                .shadow(radius: 10)

                                VStack(alignment: .leading, spacing: 5) {
                                    Text(series.name)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)

                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                        Text(String(format: "%.1f", series.voteAverage))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(.bottom, 20)
                        }
                        .padding(.horizontal)
                    }

                    // Synopsis
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Synopsis")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top)

                        Text(series.overview)
                            .foregroundColor(.gray)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                    }
                    .padding()

                    // Tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            TabButton(title: "Détails", isSelected: selectedTab == 0) { selectedTab = 0 }
                            TabButton(title: "Genres", isSelected: selectedTab == 1) { selectedTab = 1 }
                            TabButton(title: "Cast", isSelected: selectedTab == 2) { selectedTab = 2 }
                            TabButton(title: "Production", isSelected: selectedTab == 3) { selectedTab = 3 }
                        }
                        .padding(.horizontal)
                    }

                    TabContent(series: series, selectedTab: selectedTab, cast: viewModel.cast, onActorSelected: { actor in
                        selectedActor = actor
                        viewModel.fetchSeriesByActor(actorId: actor.id)
                        showActorSeries.toggle()
                    })
                    .frame(minHeight: 150)
                }
                .frame(width: geometry.size.width)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .onAppear {
                viewModel.fetchCast(for: series.id)
            }
            .sheet(isPresented: $showActorSeries) {
                if let actor = selectedActor {
                    ActorSeriesView(actor: actor) // Ne pas passer `series`
                }
            }
        }
    }

    private var backButton: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .padding(10)
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(isSelected ? .bold : .regular)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.orange : Color.clear)
                .cornerRadius(20)
                .foregroundColor(.white)
        }
    }
}

struct DetailsView: View {
    let series: Series

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            DetailRow(title: "Première diffusion", value: series.formattedFirstAirDate)
            DetailRow(title: "Note moyenne", value: String(format: "%.1f", series.voteAverage))
            if let numberOfSeasons = series.numberOfSeasons {
                DetailRow(title: "Nombre de saisons", value: "\(numberOfSeasons)")
            }
            if let status = series.status {
                DetailRow(title: "Statut", value: status)
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
    }
}

struct CastView: View {
    let cast: [CastMember]
    let onActorSelected: (CastMember) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(cast.prefix(10)) { member in
                    VStack {
                        AsyncImage(url: member.profileUrl) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 150)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        onActorSelected(member)
                                    }
                            case .failure(_):
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 150)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 100, height: 150)

                        Text(member.name)
                            .font(.caption)
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)

                        Text(member.character)
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    .frame(width: 100)
                }
            }
        }
    }
}

struct TabContent: View {
    let series: Series
    let selectedTab: Int
    let cast: [CastMember]
    let onActorSelected: (CastMember) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            switch selectedTab {
            case 0:
                DetailsView(series: series)
            case 1:
                GenresView(genres: series.genreNames)
            case 2:
                CastView(cast: cast, onActorSelected: onActorSelected)
            case 3:
                ProductionView(series: series)
            default:
                Text("Contenu non disponible")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
    }
}
