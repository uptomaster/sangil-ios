import Foundation

struct Mountain: Identifiable, Hashable {
    let id = UUID()

    let name: String
    let region: String
    let height: Int
    let difficulty: String

    let imageName: String
    let summary: String

    let courseName: String
    let distance: Double
    let duration: String
}
