import SwiftUI

struct MountainDetailView: View {
    @Environment(AdventureStore.self) private var store
    let mountain: Mountain
    @State private var showingHike = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    MountainArtwork(mountain: mountain)
                    LinearGradient(colors: [.clear, AppColors.background], startPoint: .center, endPoint: .bottom)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("THE SUMMIT IS CALLING").font(AppTypography.eyebrow).tracking(2).foregroundStyle(AppColors.primary)
                        Text(mountain.name).font(.system(size: 46, weight: .heavy))
                        Label(mountain.region, systemImage: "location").font(.subheadline).foregroundStyle(AppColors.textSecondary)
                    }.padding(24)
                }.frame(height: 360)
                VStack(alignment: .leading, spacing: 28) {
                    HStack { DifficultyBadge(difficulty: mountain.difficulty); Spacer(); FavoriteButton(mountain: mountain) }
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        StatCard(title: "SUMMIT", value: "\(mountain.heightText)", unit: "m · 해발고도")
                        StatCard(title: "DISTANCE", value: mountain.distance.map { String(format: "%.1f", $0) } ?? "—", unit: "km · 코스 거리")
                        StatCard(title: "ASCENT", value: mountain.elevation.map(String.init) ?? "—", unit: "m · 예상 상승고도")
                        StatCard(title: "DURATION", value: mountain.duration.replacingOccurrences(of: "약 ", with: ""), unit: "예상 소요시간")
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "이 산을 걷는 이유", subtitle: "ABOUT THE MOUNTAIN")
                        Text(mountain.summary).lineSpacing(6).foregroundStyle(AppColors.textSecondary)
                        Label(mountain.location, systemImage: "mappin.and.ellipse").font(.caption).foregroundStyle(AppColors.textSecondary)
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: "탐방 정보", subtitle: "PLAN YOUR ROUTE")
                        HStack(spacing: 15) {
                            Image(systemName: "point.topleft.down.to.point.bottomright.curvepath").font(.largeTitle).foregroundStyle(AppColors.primary)
                            VStack(alignment: .leading, spacing: 7) {
                                Text(mountain.courseName).font(.headline)
                                Text("\(mountain.distanceText) · \(mountain.duration)").font(.caption).foregroundStyle(AppColors.textSecondary)
                            }
                        }.padding(20).frame(maxWidth: .infinity, alignment: .leading).background(AppColors.surface)
                        Text("검증된 코스 수치가 없는 항목은 표시하지 않습니다. 거리·시간·상승고도는 공식 코스 안내를 확인하세요.").font(.caption).foregroundStyle(AppColors.textSecondary)
                    }
                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeader(title: "산길의 매력")
                        ForEach(mountain.features, id: \.self) { Label($0, systemImage: "sparkle").foregroundStyle(AppColors.textSecondary) }
                        Label("추천 계절  ·  \(mountain.season)", systemImage: "leaf").foregroundStyle(AppColors.primary)
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "출발 전 체크", subtitle: "TRAIL NOTES")
                        Text(mountain.tip).lineSpacing(5).foregroundStyle(AppColors.textSecondary)
                    }
                    MountainSourceView(mountain: mountain)
                }.padding(20).frame(maxWidth: 760).frame(maxWidth: .infinity)
            }
        }.sangilScreen().navigationTitle(mountain.name).sangilInlineTitle()
            .safeAreaInset(edge: .bottom) {
                NeonButton(title: store.activeHike == nil ? "START HIKE" : "진행 중인 산행 보기", symbol: "figure.hiking") {
                    if store.activeHike == nil { store.activeHike = ActiveHike(mountainID: mountain.id, startedAt: .now) }
                    showingHike = true
                }.padding(16).background(AppColors.background)
            }
            .sheet(isPresented: $showingHike) { HikeSessionView() }
    }
}

#Preview { NavigationStack { MountainDetailView(mountain: MountainData.all[0]) }.environment(AdventureStore()).preferredColorScheme(.dark) }
