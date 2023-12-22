import SwiftUI



@main
struct GymTrackerApp: App {
    let databaseManager = DatabaseManager()
    
    var body: some Scene {
        WindowGroup {
            GymTrackerView()
                .environment(\.colorScheme, .light)
                .environmentObject(databaseManager)
        }
    }
}

//#Preview {
//    WorkoutPlanView()
//}
