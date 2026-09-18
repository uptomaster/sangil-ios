import SwiftUI

struct MountainDetailView: View {

    let mountain: Mountain

    @State private var isSaved = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // MARK: - Mountain Image

                Image(mountain.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 320)
                    .frame(maxWidth: .infinity)
                    .clipped()

                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - Mountain Info

                    VStack(alignment: .leading, spacing: 10) {

                        HStack(alignment: .center) {

                            Text(mountain.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            Spacer()

                            Text(mountain.difficulty)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.green)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(
                                    Color.green.opacity(0.12)
                                )
                                .clipShape(Capsule())
                        }

                        HStack(spacing: 6) {

                            Image(systemName: "location.fill")

                            Text(mountain.region)

                            Text("·")

                            Text("\(mountain.height)m")
                        }
                        .foregroundStyle(.secondary)
                    }

                    // MARK: - Description

                    Text(mountain.summary)
                        .font(.body)
                        .lineSpacing(5)

                    Divider()

                    // MARK: - Course

                    VStack(alignment: .leading, spacing: 16) {

                        Text("대표 코스")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(mountain.courseName)
                            .font(.headline)

                        HStack(spacing: 12) {

                            DetailInfoBox(
                                icon: "figure.hiking",
                                title: "거리",
                                value: "\(mountain.distance, default: "%.1f")km"
                            )

                            DetailInfoBox(
                                icon: "clock.fill",
                                title: "예상 시간",
                                value: mountain.duration
                            )
                        }
                    }

                    Divider()

                    // MARK: - Save Button

                    Button {
                        isSaved.toggle()
                    } label: {

                        HStack(spacing: 8) {

                            Image(
                                systemName:
                                    isSaved
                                    ? "heart.fill"
                                    : "heart"
                            )

                            Text(
                                isSaved
                                ? "가고 싶은 산에 저장됨"
                                : "가고 싶은 산"
                            )
                            .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundStyle(.white)
                        .background(
                            isSaved
                            ? Color.orange
                            : Color.green
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle(mountain.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Detail Info Box

struct DetailInfoBox: View {

    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.green)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.headline)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(
            Color.secondary.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
}

#Preview {
    NavigationStack {
        MountainDetailView(
            mountain: MountainData.all[2]
        )
    }
}
