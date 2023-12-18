import SwiftUI



@main
struct GymTrackerApp: App {
    
    var body: some Scene {
        WindowGroup {
            WorkoutPlanView()
                .environment(\.colorScheme, .light) // Force light mode
        }
    }
}

#Preview {
    ContentView()
}
