import SwiftUI

struct HikeRecord: Identifiable, Codable {
    var id = UUID()
    let mountainID: String
    let date: Date
    let distance: Double
    let elevation: Int
    let minutes: Int
}

struct ActiveHike: Codable {
    let mountainID: String
    let startedAt: Date
}

struct PeakChallenge: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let mountainIDs: [String]
    let symbol: String
}

@Observable final class AdventureStore {
    private let defaults: UserDefaults
    private let demoRecords: [HikeRecord]
    var favorites: Set<String> { didSet { save(favorites, key: "favorites") } }
    var records: [HikeRecord] { didSet { save(records, key: "records") } }
    var activeHike: ActiveHike? { didSet { save(activeHike, key: "activeHike") } }
    var demoEnabled: Bool { didSet { defaults.set(demoEnabled, forKey: "demoEnabled") } }
    var monthlyGoal: Int { didSet { defaults.set(monthlyGoal, forKey: "monthlyGoal") } }
    var displayName: String { didSet { defaults.set(displayName, forKey: "displayName") } }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        demoRecords = Self.makeDemoRecords()
        favorites = Self.read(Set<String>.self, key: "favorites", defaults: defaults) ?? []
        records = Self.read([HikeRecord].self, key: "records", defaults: defaults) ?? []
        activeHike = Self.read(ActiveHike.self, key: "activeHike", defaults: defaults)
        demoEnabled = defaults.object(forKey: "demoEnabled") as? Bool ?? true
        monthlyGoal = max(1, defaults.object(forKey: "monthlyGoal") as? Int ?? 4)
        displayName = defaults.string(forKey: "displayName") ?? "NAMHYUK"
    }
    private static func read<T: Decodable>(_ type: T.Type, key: String, defaults: UserDefaults) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
    private func save<T: Encodable>(_ value: T, key: String) {
        if let data = try? JSONEncoder().encode(value) { defaults.set(data, forKey: key) }
    }
    var visibleRecords: [HikeRecord] {
        (records + (demoEnabled ? demoRecords : [])).sorted { $0.date > $1.date }
    }
    private static func makeDemoRecords() -> [HikeRecord] {
        [0, 1, 5].enumerated().map { index, mountainIndex in
            let mountain = MountainData.all[mountainIndex]
            return HikeRecord(mountainID: mountain.id,
                date: Calendar.current.date(byAdding: .day, value: -(index * 6 + 2), to: .now) ?? .now,
                distance: [6.8, 4.7, 7.0][index], elevation: [700, 480, 650][index], minutes: 150 + index * 35)
        }
    }
    var totalDistance: Double { visibleRecords.reduce(0) { $0 + $1.distance } }
    var totalElevation: Int { visibleRecords.reduce(0) { $0 + $1.elevation } }
    var completedIDs: Set<String> { Set(visibleRecords.map(\.mountainID)) }
    var monthRecords: [HikeRecord] {
        visibleRecords.filter { Calendar.current.isDate($0.date, equalTo: .now, toGranularity: .month) }
    }
    var challenges: [PeakChallenge] {
        [PeakChallenge(id: "seoul", title: "SEOUL SUMMITS", subtitle: "가까운 곳에서 시작하는 도전", mountainIDs: ["bukhansan", "gwanaksan", "dobongsan"], symbol: "building.2.crop.circle"),
         PeakChallenge(id: "high", title: "1000M+ CLUB", subtitle: "더 높은 곳으로, 한 걸음 더", mountainIDs: ["seoraksan", "hallasan", "jirisaan"], symbol: "mountain.2.fill")]
    }
    func toggleFavorite(_ mountain: Mountain) {
        if favorites.contains(mountain.id) { favorites.remove(mountain.id) } else { favorites.insert(mountain.id) }
    }
    func finishHike(distance: Double, elevation: Int) {
        guard let activeHike else { return }
        records.insert(HikeRecord(mountainID: activeHike.mountainID, date: .now, distance: distance,
                                  elevation: elevation, minutes: max(1, Int(Date.now.timeIntervalSince(activeHike.startedAt) / 60))), at: 0)
        self.activeHike = nil
    }
}
