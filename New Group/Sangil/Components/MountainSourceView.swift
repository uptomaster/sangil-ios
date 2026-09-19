import SwiftUI

struct MountainSourceView: View {
    let mountain: Mountain
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "정보 · 사진 출처", subtitle: "SOURCES & CREDITS")
            Link(destination: mountain.sourceURL) {
                Label("산림청 100대 명산 · 공식 정보", systemImage: "arrow.up.right.square")
            }
            Text("산 이름·높이·소재지는 산림청 목록 기준입니다. 표기 기준에 따라 다른 기관의 높이와 차이가 있을 수 있습니다.")
                .font(.caption).foregroundStyle(AppColors.textSecondary)
            Divider()
            Text(mountain.photo.caption).font(.subheadline)
            Text("사진: \(mountain.photo.author)").font(.caption).foregroundStyle(AppColors.textSecondary)
            Text(mountain.photo.title).font(.caption2).foregroundStyle(AppColors.textSecondary)
            HStack(spacing: 20) {
                Link("Wikimedia 원본", destination: mountain.photo.sourceURL)
                Link(mountain.photo.license, destination: mountain.photo.licenseURL)
            }.font(.caption)
            Text("사진은 앱 표시용으로 축소되며 화면 비율에 따라 잘립니다. 사진의 재사용에는 표시된 원본 라이선스가 적용됩니다.")
                .font(.caption2).foregroundStyle(AppColors.textSecondary)
        }.tint(AppColors.primary).padding(18).background(AppColors.surface)
    }
}
