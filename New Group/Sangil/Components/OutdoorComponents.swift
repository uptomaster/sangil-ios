import SwiftUI

struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let subtitle { Text(subtitle).font(AppTypography.eyebrow).tracking(2).foregroundStyle(AppColors.primary) }
            Text(title).font(AppTypography.title)
        }
    }
}

struct FilterChip: View {
    let title: String
    let selected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).font(.system(.caption, weight: .bold)).padding(.horizontal, 17).frame(minHeight: 44)
                .background(selected ? AppColors.primary : AppColors.surface)
                .foregroundStyle(selected ? AppColors.background : AppColors.textSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }.buttonStyle(.plain).accessibilityAddTraits(selected ? .isSelected : [])
    }
}

struct DifficultyBadge: View {
    let difficulty: String
    var color: Color { difficulty == "코스별 상이" ? AppColors.textSecondary : (difficulty == "상급" ? AppColors.accentYellow : AppColors.primary) }
    var body: some View {
        Label(difficulty, systemImage: "chart.bar.fill").font(.caption.bold())
            .padding(.horizontal, 9).padding(.vertical, 6).foregroundStyle(color)
            .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 4))
    }
}

struct NeonButton: View {
    let title: String
    var symbol = "arrow.up.right"
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack { Text(title).font(.headline); Spacer(); Image(systemName: symbol).font(.headline) }
                .padding(20).foregroundStyle(AppColors.background).background(AppColors.primary, in: RoundedRectangle(cornerRadius: 8))
        }.buttonStyle(.plain)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    var unit: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(title).font(AppTypography.eyebrow).foregroundStyle(AppColors.textSecondary)
            Text(value).font(AppTypography.number).foregroundStyle(AppColors.primary).minimumScaleFactor(0.6).lineLimit(1)
            Text(unit).font(.caption).foregroundStyle(AppColors.textSecondary)
        }.frame(maxWidth: .infinity, alignment: .leading).padding(18).background(AppColors.surface)
    }
}

struct FavoriteButton: View {
    @Environment(AdventureStore.self) private var store
    let mountain: Mountain
    var body: some View {
        Button { store.toggleFavorite(mountain) } label: {
            Image(systemName: store.favorites.contains(mountain.id) ? "bookmark.fill" : "bookmark")
                .frame(width: 44, height: 44).foregroundStyle(AppColors.primary)
                .background(AppColors.background.opacity(0.8), in: Circle())
        }.buttonStyle(.plain).accessibilityLabel("\(mountain.name) 즐겨찾기 \(store.favorites.contains(mountain.id) ? "해제" : "추가")")
    }
}

struct ChallengeCard: View {
    @Environment(AdventureStore.self) private var store
    let challenge: PeakChallenge
    var completed: Int { challenge.mountainIDs.filter { store.completedIDs.contains($0) }.count }
    var body: some View {
        NavigationLink {
            MountainCollectionView(title: challenge.title, mountains: MountainData.all.filter { challenge.mountainIDs.contains($0.id) })
        } label: {
            VStack(alignment: .leading, spacing: 18) {
                HStack { Image(systemName: challenge.symbol).font(.title); Spacer(); Image(systemName: "arrow.up.right") }.foregroundStyle(AppColors.primary)
                VStack(alignment: .leading, spacing: 6) {
                    Text(challenge.title).font(.headline)
                    Text(challenge.subtitle).font(.caption).foregroundStyle(AppColors.textSecondary)
                }
                ProgressView(value: Double(completed), total: Double(challenge.mountainIDs.count)).tint(AppColors.primary)
                Text("\(completed) / \(challenge.mountainIDs.count) COMPLETED").font(AppTypography.eyebrow)
            }.padding(20).background(AppColors.surface).overlay(alignment: .leading) { Rectangle().fill(AppColors.primary).frame(width: 2) }
        }.buttonStyle(.plain)
    }
}

struct ActivityRow: View {
    let record: HikeRecord
    var body: some View {
        if let mountain = MountainData.all.first(where: { $0.id == record.mountainID }) {
            NavigationLink { MountainDetailView(mountain: mountain) } label: {
                HStack(spacing: 14) {
                    MountainArtwork(mountain: mountain).frame(width: 66, height: 72).clipShape(RoundedRectangle(cornerRadius: 5))
                    VStack(alignment: .leading, spacing: 6) {
                        Text(mountain.name).font(.headline)
                        Text(record.date, format: .dateTime.month().day()).font(.caption).foregroundStyle(AppColors.textSecondary)
                        Text("\(record.distance, specifier: "%.1f") km · ↑ \(record.elevation) m · \(record.minutes)분").font(.caption).foregroundStyle(AppColors.textSecondary)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "arrow.up.right").foregroundStyle(AppColors.primary)
                }.padding(.vertical, 10)
            }.buttonStyle(.plain)
        }
    }
}

struct GoalPanel: View {
    @Environment(AdventureStore.self) private var store
    var body: some View {
        HStack(spacing: 22) {
            ZStack {
                Circle().stroke(AppColors.surfaceSecondary, lineWidth: 7)
                Circle().trim(from: 0, to: min(1, Double(store.monthRecords.count) / Double(store.monthlyGoal)))
                    .stroke(AppColors.primary, style: StrokeStyle(lineWidth: 7, lineCap: .round)).rotationEffect(.degrees(-90))
                Text("\(store.monthRecords.count)/\(store.monthlyGoal)").font(.title2.bold())
            }.frame(width: 78, height: 78).accessibilityLabel("이번 달 목표 \(store.monthlyGoal)회 중 \(store.monthRecords.count)회")
            VStack(alignment: .leading, spacing: 7) {
                Text("YOUR NEXT SUMMIT").font(AppTypography.eyebrow).foregroundStyle(AppColors.primary)
                Text("이번 달도, 한 걸음 더").font(.headline)
                Text("월 \(store.monthlyGoal)회 산행 목표").font(.caption).foregroundStyle(AppColors.textSecondary)
            }
            Spacer(minLength: 0)
        }.padding(22).background(AppColors.surface)
    }
}

struct DemoNotice: View {
    var body: some View {
        Label("데모 활동 포함 · 프로필 설정에서 변경", systemImage: "sparkles")
            .font(.caption).foregroundStyle(AppColors.textSecondary)
    }
}

struct MountainCollectionView: View {
    let title: String
    let mountains: [Mountain]
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 18) {
                if mountains.isEmpty { ContentUnavailableView("아직 산이 없어요", systemImage: "mountain.2", description: Text("Explore에서 다음 목적지를 찾아보세요.")) }
                ForEach(mountains) { MountainCardView(mountain: $0) }
            }.padding(20)
        }.navigationTitle(title).sangilScreen()
    }
}
