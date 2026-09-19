import SwiftUI

struct ContentView: View {
    @State private var store = AdventureStore()
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") { NavigationStack { HomeView() } }
            Tab("Explore", systemImage: "safari") { NavigationStack { ExploreView() } }
            Tab("Activity", systemImage: "waveform.path.ecg") { NavigationStack { ActivityView() } }
            Tab("Profile", systemImage: "person.crop.circle") { NavigationStack { ProfileView() } }
        }.environment(store).tint(AppColors.primary).preferredColorScheme(.dark)
    }
}

#Preview { ContentView() }
