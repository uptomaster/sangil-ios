import SwiftUI

struct MountainCardView: View {
    let mountain: Mountain
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationLink { MountainDetailView(mountain: mountain) } label: {
                MountainArtwork(mountain: mountain).frame(height: 180)
            }.buttonStyle(.plain)
                .overlay(alignment: .topTrailing) { FavoriteButton(mountain: mountain).padding(10) }
            NavigationLink { MountainDetailView(mountain: mountain) } label: {
                VStack(alignment: .leading, spacing: 12) {
                    HStack { Text(mountain.name).font(AppTypography.title); Spacer(); DifficultyBadge(difficulty: mountain.difficulty) }
                    Text("\(mountain.region)  ·  \(mountain.heightText) m").font(.subheadline).foregroundStyle(AppColors.textSecondary)
                    Divider().overlay(AppColors.surfaceSecondary)
                    HStack { Label(mountain.distanceText, systemImage: "point.topleft.down.to.point.bottomright.curvepath"); Spacer(); Text(mountain.duration) }.font(.caption).foregroundStyle(AppColors.textSecondary)
                }.padding(16)
            }.buttonStyle(.plain)
        }.background(AppColors.surface).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct FeaturedMountainCard: View {
    let mountain: Mountain
    var body: some View {
        NavigationLink { MountainDetailView(mountain: mountain) } label: {
            ZStack(alignment: .bottomLeading) {
                MountainArtwork(mountain: mountain)
                LinearGradient(colors: [.clear, AppColors.background.opacity(0.35), AppColors.background.opacity(0.96)], startPoint: .top, endPoint: .bottom)
                VStack(alignment: .leading, spacing: 14) {
                    HStack { Text("TODAY’S PICK").font(AppTypography.eyebrow).tracking(3); Spacer(); Image(systemName: "location.north.circle") }.foregroundStyle(AppColors.primary)
                    Spacer()
                    Text("도시를 벗어나,\n능선 위로.").font(.title3.bold())
                    HStack(alignment: .firstTextBaseline) {
                        Text(mountain.name).font(.system(size: 44, weight: .heavy))
                        Text("\(mountain.heightText)m").font(.title2.weight(.light))
                    }.minimumScaleFactor(0.7).lineLimit(1)
                    Text("\(mountain.region)  /  \(mountain.difficulty)  /  \(mountain.duration)").font(.caption)
                    Rectangle().fill(AppColors.textSecondary.opacity(0.4)).frame(height: 1)
                    HStack { Text("VIEW ROUTE").tracking(2); Spacer(); Image(systemName: "arrow.right") }.font(.caption.bold()).foregroundStyle(AppColors.primary)
                }.padding(24)
            }.frame(height: 420).clipShape(RoundedRectangle(cornerRadius: 8))
        }.buttonStyle(.plain)
    }
}
