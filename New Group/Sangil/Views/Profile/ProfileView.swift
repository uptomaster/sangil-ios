import SwiftUI

struct ProfileView: View {
    @Environment(AdventureStore.self) private var store
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                HStack(alignment: .top, spacing: 18) {
                    Image(systemName: "figure.hiking").font(.system(size: 40)).foregroundStyle(AppColors.primary)
                        .frame(width: 80, height: 90).background(AppColors.surfaceSecondary)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SANGIL EXPLORER").font(AppTypography.eyebrow).tracking(2).foregroundStyle(AppColors.primary)
                        Text(store.displayName.isEmpty ? "EXPLORER" : store.displayName).font(AppTypography.display)
                        Text(String(format: "LEVEL %02d", 1 + store.visibleRecords.count / 3)).font(.caption.monospaced().bold()).foregroundStyle(AppColors.textSecondary)
                    }
                }
                if store.demoEnabled { DemoNotice() }
                HStack(spacing: 8) {
                    StatCard(title: "PEAKS", value: "\(store.completedIDs.count)", unit: "산")
                    StatCard(title: "DISTANCE", value: String(format: "%.0f", store.totalDistance), unit: "km")
                }
                VStack(alignment: .leading, spacing: 12) {
                    HStack { Text("다음 레벨까지").font(.subheadline.bold()); Spacer(); Text("\(store.visibleRecords.count % 3) / 3 HIKES").font(AppTypography.eyebrow).foregroundStyle(AppColors.primary) }
                    ProgressView(value: Double(store.visibleRecords.count % 3), total: 3).tint(AppColors.primary)
                    Text("산행 3회마다 레벨 업 · 누적 상승고도 \(store.totalElevation)m").font(.caption).foregroundStyle(AppColors.textSecondary)
                }
                VStack(spacing: 0) {
                    collectionLink("즐겨찾기한 산", symbol: "bookmark", mountains: MountainData.all.filter { store.favorites.contains($0.id) })
                    Divider()
                    collectionLink("완료한 산", symbol: "flag.checkered", mountains: MountainData.all.filter { store.completedIDs.contains($0.id) })
                }.padding(.horizontal, 18).background(AppColors.surface)
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "산길 위에서 얻은 것들", subtitle: "YOUR BADGES")
                    HStack(spacing: 8) {
                        badge("첫 발자국", icon: "shoeprints.fill", earned: !store.visibleRecords.isEmpty)
                        badge("세 개의 산", icon: "mountain.2.fill", earned: store.completedIDs.count >= 3)
                        badge("30 KM", icon: "figure.walk", earned: store.totalDistance >= 30)
                    }
                }
                GoalPanel()
                ForEach(store.challenges) { ChallengeCard(challenge: $0) }
                NavigationLink { ProfileSettingsView() } label: {
                    HStack { Label("프로필 및 앱 설정", systemImage: "gearshape"); Spacer(); Image(systemName: "chevron.right") }.padding(20).background(AppColors.surface)
                }.buttonStyle(.plain)
                Text("SANGIL / OUTDOOR IS A WAY OF LIFE").font(AppTypography.eyebrow).foregroundStyle(AppColors.textSecondary).padding(.vertical)
            }.padding(20).frame(maxWidth: 760).frame(maxWidth: .infinity)
        }.navigationTitle("Profile").sangilInlineTitle().sangilScreen()
    }
    private func collectionLink(_ title: String, symbol: String, mountains: [Mountain]) -> some View {
        NavigationLink { MountainCollectionView(title: title, mountains: mountains) } label: {
            HStack { Label(title, systemImage: symbol); Spacer(); Text("\(mountains.count)").foregroundStyle(AppColors.primary); Image(systemName: "chevron.right") }.padding(.vertical, 20)
        }.buttonStyle(.plain)
    }
    private func badge(_ title: String, icon: String, earned: Bool) -> some View {
        VStack(spacing: 12) {
            Image(systemName: earned ? icon : "lock").font(.title2)
            Text(title).font(.caption.bold())
            Text(earned ? "EARNED" : "LOCKED").font(.system(size: 9, design: .monospaced))
        }.foregroundStyle(earned ? AppColors.primary : AppColors.textSecondary)
            .frame(maxWidth: .infinity).padding(.vertical, 20).background(AppColors.surface)
    }
}

struct ProfileSettingsView: View {
    @Environment(AdventureStore.self) private var store
    var body: some View {
        @Bindable var store = store
        Form {
            Section("아웃도어 프로필") { TextField("이름", text: $store.displayName) }
            Section("이번 달 목표") { Stepper("월 \(store.monthlyGoal)회 산행", value: $store.monthlyGoal, in: 1...30) }
            Section {
                Toggle("데모 활동 표시", isOn: $store.demoEnabled)
            } footer: { Text("예시 산행 3건을 대시보드에 포함합니다. 꺼도 직접 저장한 기록과 즐겨찾기는 유지됩니다.") }
            Section("앱 정보") {
                LabeledContent("Sangil", value: "1.0")
                Text("산행 기록은 이 기기에 저장됩니다. GPS 추적과 계정 동기화는 아직 제공하지 않습니다.").font(.caption).foregroundStyle(AppColors.textSecondary)
            }
        }.scrollContentBackground(.hidden).sangilScreen().navigationTitle("설정")
    }
}

#Preview { NavigationStack { ProfileView() }.environment(AdventureStore()).preferredColorScheme(.dark) }
