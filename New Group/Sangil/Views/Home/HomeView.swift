import SwiftUI

struct HomeView: View {
    @Environment(AdventureStore.self) private var store
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                header
                FeaturedMountainCard(mountain: MountainData.all[0])
                HStack(spacing: 12) {
                    Image(systemName: "sun.horizon.fill").font(.title2).foregroundStyle(AppColors.primary)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("밖으로 나갈 준비, 되셨나요?").font(.subheadline.bold())
                        Text("출발 전 현지 날씨와 탐방로를 확인하세요").font(.caption).foregroundStyle(AppColors.textSecondary)
                    }
                }
                section("이번 주 추천 산", eyebrow: "CURATED FOR YOUR WEEK", mountains: Array(MountainData.all[2...4]))
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "나에게 맞는 높이", subtitle: "FIND YOUR PACE")
                    HStack(spacing: 8) {
                        heightLink("600m 미만", caption: "LOW SUMMITS", symbol: "figure.walk")
                        heightLink("600~999m", caption: "MID SUMMITS", symbol: "figure.hiking")
                        heightLink("1,000m 이상", caption: "HIGH SUMMITS", symbol: "mountain.2")
                    }
                }
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "먼저 만나볼 명산", subtitle: "TRAIL SPOTLIGHT · 에디터 선정")
                    ForEach(Array(MountainData.all.sorted { $0.popularity > $1.popularity }.prefix(3).enumerated()), id: \.element.id) { index, mountain in
                        NavigationLink { MountainDetailView(mountain: mountain) } label: {
                            HStack(spacing: 16) {
                                Text("0\(index + 1)").font(.title.bold()).foregroundStyle(AppColors.primary)
                                Text(mountain.name).font(.headline)
                                Spacer()
                                Text("\(mountain.heightText) m").font(.subheadline.monospacedDigit()).foregroundStyle(AppColors.textSecondary)
                                Image(systemName: "arrow.up.right")
                            }.padding(.vertical, 14).overlay(alignment: .bottom) { Divider() }
                        }.buttonStyle(.plain)
                    }
                }
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "어디로 떠날까요?", subtitle: "EXPLORE BY REGION")
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(["서울", "경기", "강원", "제주", "전남"], id: \.self) { region in
                                NavigationLink { ExploreView(initialRegion: region) } label: {
                                    Label(region, systemImage: "location.north").font(.headline).padding(20).background(AppColors.surface)
                                }.buttonStyle(.plain)
                            }
                        }
                    }.scrollIndicators(.hidden)
                }
                GoalPanel()
                if store.demoEnabled { DemoNotice() }
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "도전은 계속된다", subtitle: "SANGIL CHALLENGES")
                    ForEach(store.challenges) { ChallengeCard(challenge: $0) }
                }
                VStack(alignment: .leading, spacing: 10) {
                    SectionHeader(title: "최근의 발자국", subtitle: "YOUR TRAIL JOURNAL")
                    if store.visibleRecords.isEmpty { Text("첫 산행을 시작하고 나만의 발자국을 남겨보세요.").foregroundStyle(AppColors.textSecondary) }
                    ForEach(store.visibleRecords.prefix(2)) { ActivityRow(record: $0) }
                }
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "다음 주말의 목적지", subtitle: "A SUMMIT TO REMEMBER")
                    MountainCardView(mountain: MountainData.all[1])
                }
                Text("LEAVE THE CITY. FIND YOUR TRAIL.").font(AppTypography.eyebrow).tracking(1).foregroundStyle(AppColors.textSecondary).padding(.vertical, 16)
            }.padding(20).frame(maxWidth: 760)
                .frame(maxWidth: .infinity)
        }.sangilScreen().sangilHiddenNavigationBar()
    }
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 9) { Image(systemName: "mountain.2.fill").foregroundStyle(AppColors.primary); Text("SANGIL").tracking(4) }.font(.title.bold())
                Text("산을 발견하고, 도전하고, 기록하다.").font(.caption).foregroundStyle(AppColors.textSecondary)
            }
            Spacer()
            NavigationLink { MountainCollectionView(title: "저장한 산", mountains: MountainData.all.filter { store.favorites.contains($0.id) }) } label: {
                Image(systemName: "bookmark").frame(width: 44, height: 44).background(AppColors.surface, in: Circle())
            }.accessibilityLabel("저장한 산")
        }.padding(.top, 8)
    }
    private func section(_ title: String, eyebrow: String, mountains: [Mountain]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: title, subtitle: eyebrow)
            ScrollView(.horizontal) {
                HStack(spacing: 14) { ForEach(mountains) { MountainCardView(mountain: $0).frame(width: 280) } }
            }.scrollIndicators(.hidden)
        }
    }
    private func heightLink(_ height: String, caption: String, symbol: String) -> some View {
        NavigationLink { ExploreView(initialHeight: height) } label: {
            VStack(alignment: .leading, spacing: 14) {
                Image(systemName: symbol).font(.title2).foregroundStyle(AppColors.primary)
                Text(height).font(.subheadline.bold())
                Text(caption).font(.system(size: 9, weight: .bold, design: .monospaced)).foregroundStyle(AppColors.textSecondary)
            }.frame(maxWidth: .infinity, alignment: .leading).padding(14).background(AppColors.surface)
        }.buttonStyle(.plain)
    }
}

#Preview { NavigationStack { HomeView() }.environment(AdventureStore()).preferredColorScheme(.dark) }
