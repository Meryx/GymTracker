import SwiftUI

struct testView: View {
    @State var myVar = ""
    var body: some View {
        VStack {
            TextField("Hello world", text: $myVar)
                .textFieldStyle(.roundedBorder)
                .font(.callout)
            TextField("Hello world", text: $myVar)
                .textFieldStyle(.roundedBorder)
                .font(.callout)
        }
    }
}


@main
struct GymTrackerApp: App {
    let databaseManager = DatabaseManager()
    @StateObject private var viewModel = ProgramListViewModel()
    @State var myVar = ""
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
