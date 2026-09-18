import SwiftUI

struct HomeView: View {

    private let mountains = MountainData.all

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {

                    header

                    featuredMountain

                    difficultySection

                    mountainSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text("산길")
                .font(
                    .system(
                        size: 34,
                        weight: .bold
                    )
                )

            Text("오늘은 어떤 산을 걸어볼까요?")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 20)
    }

    // MARK: - Featured Mountain

    private var featuredMountain: some View {

        let mountain = mountains[2]

        return NavigationLink {
            MountainDetailView(
                mountain: mountain
            )
        } label: {

            ZStack(alignment: .bottomLeading) {

                Image(mountain.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 260)
                    .frame(maxWidth: .infinity)
                    .clipped()

                LinearGradient(
                    colors: [
                        .clear,
                        .black.opacity(0.8)
                    ],
                    startPoint: .center,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 7) {

                    Text("오늘의 산")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(
                            .white.opacity(0.8)
                        )

                    Text(mountain.name)
                        .font(.system(
                            size: 30,
                            weight: .bold
                        ))
                        .foregroundStyle(.white)

                    Text(
                        "\(mountain.region) · \(mountain.height)m"
                    )
                    .font(.subheadline)
                    .foregroundStyle(
                        .white.opacity(0.85)
                    )

                    Text(mountain.difficulty)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            .white.opacity(0.2)
                        )
                        .clipShape(Capsule())
                }
                .padding(22)
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Difficulty

    private var difficultySection: some View {
        VStack(alignment: .leading, spacing: 15) {

            Text("난이도로 찾기")
                .font(.title2)
                .fontWeight(.bold)

            HStack(spacing: 10) {

                DifficultyCard(
                    title: "초급",
                    subtitle: "가볍게",
                    icon: "figure.walk"
                )

                DifficultyCard(
                    title: "중급",
                    subtitle: "적당하게",
                    icon: "figure.hiking"
                )

                DifficultyCard(
                    title: "상급",
                    subtitle: "도전하기",
                    icon: "mountain.2.fill"
                )
            }
        }
    }

    // MARK: - Mountains

    private var mountainSection: some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack {

                Text("추천 명산")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Text("전체보기")
                    .font(.subheadline)
                    .foregroundStyle(.green)
            }

            ForEach(
                mountains.prefix(3)
            ) { mountain in

                NavigationLink {
                    MountainDetailView(
                        mountain: mountain
                    )
                } label: {

                    MountainCardView(
                        mountain: mountain
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}


// MARK: - Difficulty Card

struct DifficultyCard: View {

    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.green)

            Text(title)
                .font(.headline)

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(
            Color.green.opacity(0.07)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
    }
}

#Preview {
    HomeView()
}
