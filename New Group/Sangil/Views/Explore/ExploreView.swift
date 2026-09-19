import SwiftUI

struct ExploreView: View {
    @State private var query = ""
    @State private var region: String
    @State private var difficulty: String
    @State private var height: String
    @State private var sort = "추천순"
    init(initialRegion: String = "전체", initialDifficulty: String = "전체", initialHeight: String = "모든 높이") {
        _height = State(initialValue: initialHeight)
        _region = State(initialValue: initialRegion)
        _difficulty = State(initialValue: initialDifficulty)
    }
    private var filtered: [Mountain] {
        let mountains = MountainData.all.filter { mountain in
            (query.isEmpty || "\(mountain.name) \(mountain.region) \(mountain.courseName)".localizedCaseInsensitiveContains(query)) &&
            (region == "전체" || mountain.region.contains(region)) &&
            (difficulty == "전체" || mountain.difficulty == difficulty) &&
            matchesHeight(mountain.height)
        }
        switch sort {
        case "높은순": return mountains.sorted { $0.height > $1.height }
        case "이름순": return mountains.sorted { $0.name < $1.name }
        default: return mountains
        }
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("FIND YOUR\nNEXT SUMMIT.").font(AppTypography.display)
                    Text("익숙한 도시 너머, 새로운 산길을 찾아보세요.").font(.subheadline).foregroundStyle(AppColors.textSecondary)
                }
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(AppColors.primary)
                    TextField("산, 지역 또는 코스 검색", text: $query).autocorrectionDisabled()
                    if !query.isEmpty { Button { query = "" } label: { Image(systemName: "xmark.circle.fill") }.accessibilityLabel("검색 지우기") }
                }.padding(16).background(AppColors.surface, in: RoundedRectangle(cornerRadius: 8))
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        FilterChip(title: "ALL", selected: region == "전체" && difficulty == "전체" && height == "모든 높이") { resetFilters() }
                        ForEach(Array(zip(["서울", "경기", "강원", "제주"], ["SEOUL", "GYEONGGI", "GANGWON", "JEJU"])), id: \.0) { value, label in
                            FilterChip(title: label, selected: region == value) { region = region == value ? "전체" : value }
                        }
                        FilterChip(title: "UNDER 600M", selected: height == "600m 미만") { height = height == "600m 미만" ? "모든 높이" : "600m 미만" }
                        FilterChip(title: "1000M+", selected: height == "1,000m 이상") { height = height == "1,000m 이상" ? "모든 높이" : "1,000m 이상" }
                    }
                }.scrollIndicators(.hidden)
                ViewThatFits(in: .horizontal) {
                    HStack { regionMenu; difficultyMenu; heightMenu }
                    VStack(alignment: .leading) { HStack { regionMenu; difficultyMenu }; heightMenu }
                }.font(.caption).tint(AppColors.textPrimary)
                HStack {
                    Text("\(filtered.count)개의 목적지").font(.subheadline.bold())
                    Spacer()
                    Picker("정렬", selection: $sort) { Text("추천순").tag("추천순"); Text("높은순").tag("높은순"); Text("이름순").tag("이름순") }.tint(AppColors.primary)
                }
                Text("산림청 명산 50곳 · 높이는 공식 목록 기준 · 코스 난이도 미확인").font(.caption2).foregroundStyle(AppColors.textSecondary)
                LazyVStack(spacing: 20) {
                    if filtered.isEmpty {
                        ContentUnavailableView("조건에 맞는 산이 없어요", systemImage: "magnifyingglass", description: Text(difficulty == "전체" ? "검색어나 필터를 바꿔보세요." : "현재 코스 난이도는 미확인입니다. 난이도를 전체로 바꿔보세요."))
                        Button("검색 및 필터 초기화") { query = ""; resetFilters() }.tint(AppColors.primary)
                    }
                    ForEach(filtered) { MountainCardView(mountain: $0) }
                }
            }.padding(20).frame(maxWidth: 760).frame(maxWidth: .infinity)
        }.navigationTitle("Explore").sangilInlineTitle().sangilScreen()
    }
    private var regionMenu: some View {
        Menu { Picker("지역", selection: $region) { ForEach(["전체", "서울", "경기", "인천", "강원", "충북", "충남", "대전", "전북", "전남", "광주", "경북", "경남", "대구", "울산", "부산", "제주"], id: \.self) { Text($0) } } }
        label: { Label(region == "전체" ? "지역 전체" : region, systemImage: "location").padding(10).background(AppColors.surface) }
    }
    private var difficultyMenu: some View {
        Menu { Picker("난이도", selection: $difficulty) { ForEach(["전체", "초급", "중급", "상급", "코스별 상이"], id: \.self) { Text($0) } } }
        label: { Label(difficulty == "전체" ? "난이도 전체" : difficulty, systemImage: "slider.horizontal.3").padding(10).background(AppColors.surface) }
    }
    private var heightMenu: some View {
        Menu { Picker("높이", selection: $height) { ForEach(["모든 높이", "600m 미만", "600~999m", "1,000m 미만", "1,000m 이상"], id: \.self) { Text($0) } } }
        label: { Label(height, systemImage: "mountain.2").padding(10).background(AppColors.surface) }
    }
    private func matchesHeight(_ value: Double) -> Bool {
        switch height {
        case "600m 미만": value < 600
        case "600~999m": value >= 600 && value < 1000
        case "1,000m 미만": value < 1000
        case "1,000m 이상": value >= 1000
        default: true
        }
    }
    private func resetFilters() { region = "전체"; difficulty = "전체"; height = "모든 높이" }
}

#Preview { NavigationStack { ExploreView() }.environment(AdventureStore()).preferredColorScheme(.dark) }
