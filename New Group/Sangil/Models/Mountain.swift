import Foundation

struct Mountain: Identifiable, Hashable {
    var id: String { imageName }
    let name: String
    let region: String
    let height: Double
    let imageName: String
    let summary: String
    let location: String
    let sourceURL: URL
    let photo: MountainPhoto
    var difficulty: String = "코스별 상이"
    var courseName: String = "공식 탐방 정보"
    var distance: Double? = nil
    var duration: String = "코스 확인 필요"
    var elevation: Int? = nil
    var popularity: Int = 0
    var features: [String] = ["산림청 100대 명산"]
    var season: String = "탐방 시기별 개방 현황 확인"
    var tip: String = "출발 전 공식 안내에서 날씨와 탐방로 개방 여부를 확인하세요. 거리·시간·난이도는 선택한 코스에 따라 달라집니다."
    var imageURL: URL? = nil

    var heightText: String { height.formatted(.number.precision(.fractionLength(0...1)).grouping(.never)) }
    var distanceText: String { distance.map { String(format: "%.1f km", $0) } ?? "코스별 거리 확인" }
}

struct MountainPhoto: Hashable {
    let title: String
    let author: String
    let sourceURL: URL
    let license: String
    let licenseURL: URL
    let caption: String
}
