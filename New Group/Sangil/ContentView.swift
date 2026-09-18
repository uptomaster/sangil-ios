import SwiftUI

struct ContentView: View {

    @State private var searchText = ""
    @State private var selectedDifficulty = "전체"

    let difficulties = ["전체", "초급", "중급", "상급"]

    let mountains = [
        Mountain(
            name: "북한산",
            region: "서울 · 경기",
            height: 836,
            difficulty: "중급"
        ),
        Mountain(
            name: "관악산",
            region: "서울",
            height: 632,
            difficulty: "초급"
        ),
        Mountain(
            name: "설악산",
            region: "강원",
            height: 1708,
            difficulty: "상급"
        )
    ]

    var filteredMountains: [Mountain] {
        mountains.filter { mountain in

            let matchesDifficulty =
                selectedDifficulty == "전체"
                || mountain.difficulty == selectedDifficulty

            let matchesSearch =
                searchText.isEmpty
                || mountain.name.localizedCaseInsensitiveContains(searchText)

            return matchesDifficulty && matchesSearch
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - Header

                    VStack(alignment: .leading, spacing: 8) {
                        Text("산길")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("나에게 맞는 산을 찾아보세요.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // MARK: - Search

                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)

                        TextField("산 이름 검색", text: $searchText)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    // MARK: - Difficulty

                    VStack(alignment: .leading, spacing: 12) {
                        Text("난이도")
                            .font(.headline)

                        HStack(spacing: 8) {
                            ForEach(difficulties, id: \.self) { difficulty in
                                Button {
                                    selectedDifficulty = difficulty
                                } label: {
                                    Text(difficulty)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundStyle(
                                            selectedDifficulty == difficulty
                                                ? Color.white
                                                : Color.primary
                                        )
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(
                                            selectedDifficulty == difficulty
                                                ? Color.green
                                                : Color(.secondarySystemBackground)
                                        )
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 20)
                                        )
                                }
                            }
                        }
                    }

                    // MARK: - Mountains

                    VStack(alignment: .leading, spacing: 16) {
                        Text("명산")
                            .font(.title2)
                            .fontWeight(.bold)

                        if filteredMountains.isEmpty {
                            Text("조건에 맞는 산이 없습니다.")
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 30)
                        } else {
                            ForEach(filteredMountains) { mountain in
                                MountainCard(
                                    name: mountain.name,
                                    region: mountain.region,
                                    height: mountain.height,
                                    difficulty: mountain.difficulty
                                )
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}


// MARK: - Mountain Card

struct MountainCard: View {

    let name: String
    let region: String
    let height: Int
    let difficulty: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .frame(height: 180)
                .overlay {
                    Image(systemName: "mountain.2.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.green)
                }

            Text(name)
                .font(.title3)
                .fontWeight(.bold)

            HStack {
                Text(region)
                Text("·")
                Text("\(height)m")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Text(difficulty)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.green.opacity(0.15))
                .foregroundStyle(.green)
                .clipShape(Capsule())
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 10,
            x: 0,
            y: 4
        )
    }
}


#Preview {
    ContentView()
}
