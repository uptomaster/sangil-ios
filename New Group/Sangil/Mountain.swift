import Foundation

struct Mountain: Identifiable {
    let id = UUID()
    
    let name: String
    let region: String
    let height: Int
    let difficulty: String
}
