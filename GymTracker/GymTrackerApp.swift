import SwiftUI

@main
struct GymTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, .light) // Force light mode
        }
    }
}

#Preview {
    ContentView()
}
