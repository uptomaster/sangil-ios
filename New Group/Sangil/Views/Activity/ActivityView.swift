import SwiftUI

struct ActivityView: View {
    @Environment(AdventureStore.self) private var store
    @State private var showingHike = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                SectionHeader(title: "EVERY STEP\nCOUNTS.", subtitle: "YOUR ACTIVITY")
                if store.demoEnabled { DemoNotice() }
                if store.activeHike != nil {
                    NeonButton(title: "진행 중인 산행으로 돌아가기", symbol: "figure.hiking") { showingHike = true }
                }
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    StatCard(title: "TOTAL HIKES", value: "\(store.visibleRecords.count)", unit: "번의 도전")
                    StatCard(title: "TOTAL DISTANCE", value: String(format: "%.1f", store.totalDistance), unit: "km · 걸어온 길")
                    StatCard(title: "TOTAL ELEVATION", value: "\(store.totalElevation)", unit: "m · 누적 상승고도")
                    StatCard(title: "PEAKS", value: "\(store.completedIDs.count)", unit: "개의 기록한 산")
                }
                GoalPanel()
                ActivityCalendar(records: store.visibleRecords)
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "최근 등산 기록", subtitle: "TRAIL JOURNAL")
                    if store.visibleRecords.isEmpty {
                        ContentUnavailableView("첫 발자국을 남겨보세요", systemImage: "figure.hiking", description: Text("산 상세에서 START HIKE로 기록을 시작하세요."))
                    }
                    ForEach(store.visibleRecords) { ActivityRow(record: $0) }
                }
                NavigationLink { MountainCollectionView(title: "기록한 산", mountains: MountainData.all.filter { store.completedIDs.contains($0.id) }) } label: {
                    HStack { Label("내가 걸어온 산", systemImage: "flag.checkered"); Spacer(); Text("\(store.completedIDs.count)"); Image(systemName: "chevron.right") }.padding(20).background(AppColors.surface)
                }.buttonStyle(.plain)
                SectionHeader(title: "다음 도전", subtitle: "KEEP GOING")
                ForEach(store.challenges) { ChallengeCard(challenge: $0) }
            }.padding(20).frame(maxWidth: 760).frame(maxWidth: .infinity)
        }.navigationTitle("Activity").sangilInlineTitle().sangilScreen()
            .sheet(isPresented: $showingHike) { HikeSessionView() }
    }
}

struct ActivityCalendar: View {
    let records: [HikeRecord]
    private let calendar = Calendar.current
    private var month: Date { calendar.dateInterval(of: .month, for: .now)?.start ?? .now }
    private var days: Int { calendar.range(of: .day, in: .month, for: month)?.count ?? 30 }
    private var offset: Int { (calendar.component(.weekday, from: month) - calendar.firstWeekday + 7) % 7 }
    private var weekdays: [String] {
        let symbols = calendar.veryShortWeekdaySymbols
        let index = calendar.firstWeekday - 1
        return Array(symbols[index...] + symbols[..<index])
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack { Text("활동 캘린더").font(.headline); Spacer(); Text(month, format: .dateTime.year().month()).font(.caption).foregroundStyle(AppColors.textSecondary) }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(Array(weekdays.enumerated()), id: \.offset) { _, day in Text(day).font(.caption2).foregroundStyle(AppColors.textSecondary) }
                ForEach(0..<(days + offset), id: \.self) { index in
                    if index < offset { Color.clear.frame(height: 30) }
                    else {
                        let day = index - offset + 1
                        let date = calendar.date(byAdding: .day, value: day - 1, to: month) ?? month
                        let active = records.contains { calendar.isDate($0.date, inSameDayAs: date) }
                        Text("\(day)").font(.caption.monospacedDigit()).frame(maxWidth: .infinity).frame(height: 30)
                            .foregroundStyle(active ? AppColors.background : AppColors.textSecondary)
                            .background(active ? AppColors.primary : AppColors.surfaceSecondary, in: RoundedRectangle(cornerRadius: 4))
                            .accessibilityLabel("\(day)일 \(active ? "산행 기록 있음" : "산행 기록 없음")")
                    }
                }
            }
            Label("산행을 기록한 날", systemImage: "square.fill").font(.caption2).foregroundStyle(AppColors.primary)
        }.padding(20).background(AppColors.surface)
    }
}

#Preview { NavigationStack { ActivityView() }.environment(AdventureStore()).preferredColorScheme(.dark) }
