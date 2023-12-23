import SwiftUI



@main
struct GymTrackerApp: App {
    let databaseManager = DatabaseManager()
    @StateObject private var viewModel = ProgramListViewModel()
    var body: some Scene {
        WindowGroup {
            GymTrackerView()
                .environment(\.colorScheme, .light)
                .environmentObject(databaseManager)
                .environmentObject(viewModel)
        }
    }
}

//#Preview {
//    WorkoutPlanView()
//}
