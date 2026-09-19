import Foundation

@main
struct AdventureStoreChecks {
    @MainActor static func main() {
        let suite = "SangilChecks.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        let store = AdventureStore(defaults: defaults)
        let mountain = MountainData.all[0]
        precondition(MountainData.all.count == 50)
        precondition(mountain.id == "bukhansan" && mountain.height == 835.6)
        precondition(MountainData.all[5].id == "dobongsan")
        precondition(Set(MountainData.all.map { $0.photo.sourceURL }).count == 50)
        precondition(MountainData.all.allSatisfy { $0.height > 0 && !$0.location.isEmpty && !$0.photo.author.isEmpty })
        precondition(MountainData.all.allSatisfy { $0.distance == nil && $0.elevation == nil })
        precondition(Set(MountainData.all.map(\.id)).count == MountainData.all.count)
        precondition(store.visibleRecords.count == 3)
        precondition(store.visibleRecords.map(\.id) == store.visibleRecords.map(\.id), "Demo identities must remain stable")
        store.toggleFavorite(mountain)
        precondition(AdventureStore(defaults: defaults).favorites.contains(mountain.id))
        store.toggleFavorite(mountain)
        precondition(!AdventureStore(defaults: defaults).favorites.contains(mountain.id))
        store.demoEnabled = false
        precondition(store.visibleRecords.isEmpty)
        store.monthlyGoal = 7
        store.displayName = "TRAIL WALKER"
        store.activeHike = ActiveHike(mountainID: mountain.id, startedAt: Date.now.addingTimeInterval(-600))
        let restored = AdventureStore(defaults: defaults)
        precondition(restored.activeHike?.mountainID == mountain.id)
        precondition(restored.monthlyGoal == 7 && restored.displayName == "TRAIL WALKER")
        restored.finishHike(distance: 4.2, elevation: 320)
        precondition(restored.activeHike == nil)
        precondition(restored.records.count == 1 && restored.totalDistance == 4.2)
        precondition(restored.totalElevation == 320 && restored.completedIDs == [mountain.id])
        precondition(restored.monthRecords.count == 1)
        restored.finishHike(distance: 10, elevation: 1000)
        precondition(restored.records.count == 1, "Completing twice must not duplicate a hike")
        let persisted = AdventureStore(defaults: defaults)
        precondition(persisted.records.count == 1 && persisted.activeHike == nil && !persisted.demoEnabled)
        persisted.demoEnabled = true
        precondition(persisted.visibleRecords.count == 4)
        persisted.demoEnabled = false
        precondition(persisted.visibleRecords.count == 1, "Demo toggle must preserve personal records")
        print("PASS: catalog IDs, demo stability, favorites, settings, session restoration, completion, aggregates, persistence, demo isolation")
    }
}
