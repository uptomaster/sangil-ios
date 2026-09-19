import SwiftUI

struct HikeSessionView: View {
    @Environment(AdventureStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var distance = 0.0
    @State private var elevation = 0.0
    @State private var confirmCancel = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    if let session = store.activeHike,
                       let mountain = MountainData.all.first(where: { $0.id == session.mountainID }) {
                        SectionHeader(title: mountain.name, subtitle: "ON THE TRAIL")
                        MountainArtwork(mountain: mountain).frame(height: 200).clipShape(RoundedRectangle(cornerRadius: 8))
                        Text(session.startedAt, style: .timer).font(.system(size: 48, weight: .bold, design: .monospaced)).foregroundStyle(AppColors.primary)
                        Text("수동 산행 기록").font(.title2.bold())
                        Text("경과 시간을 기록합니다. GPS 경로·거리·고도는 자동 측정하지 않으므로 완료 시 실제 수치를 입력하세요.").foregroundStyle(AppColors.textSecondary)
                        VStack(alignment: .leading, spacing: 14) {
                            Text("실제 이동 거리 (km)").font(.headline)
                            TextField("거리", value: $distance, format: .number.precision(.fractionLength(1))).textFieldStyle(.roundedBorder)
                                .sangilDecimalKeyboard()
                            Text("실제 상승고도 (m)").font(.headline)
                            TextField("상승고도", value: $elevation, format: .number.precision(.fractionLength(0))).textFieldStyle(.roundedBorder)
                                .sangilDecimalKeyboard()
                        }
                        NeonButton(title: "산행 완료 · 기록 저장", symbol: "checkmark") {
                            store.finishHike(distance: distance, elevation: Int(elevation)); dismiss()
                        }.disabled(!validMetrics).opacity(validMetrics ? 1 : 0.45)
                        Button("이번 산행 취소", role: .destructive) { confirmCancel = true }.frame(maxWidth: .infinity)
                    } else {
                        ContentUnavailableView("진행 중인 산행이 없어요", systemImage: "figure.hiking")
                    }
                }.padding(24)
            }.sangilScreen().navigationTitle("산행 기록").sangilInlineTitle()
                .toolbar { ToolbarItem(placement: .confirmationAction) { Button("닫기") { dismiss() } } }
                .confirmationDialog("진행 중인 산행을 취소할까요? 기록이 저장되지 않습니다.", isPresented: $confirmCancel, titleVisibility: .visible) {
                    Button("산행 취소", role: .destructive) { store.activeHike = nil; dismiss() }
                }
        }.tint(AppColors.primary).preferredColorScheme(.dark)
    }
    private var validMetrics: Bool { distance.isFinite && elevation.isFinite && distance > 0 && distance <= 300 && elevation >= 0 && elevation <= 20000 }
}
