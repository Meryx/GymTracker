import SwiftUI

struct WorkoutDay: Codable, Identifiable {
    var id = UUID()
    var name: String
}

class WorkoutDayViewModel: ObservableObject {
    @Published var workoutDays: [WorkoutDay] = []
    
    init() {
        loadWorkoutDays()
    }
    
    func addItem(name: String) {
        let newItem = WorkoutDay(name: name)
        workoutDays.append(newItem)
        saveWorkoutDays()
    }
    
    private func saveWorkoutDays() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let archiveURL = documentsDirectory.appendingPathComponent("workout_days.plist")
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml
            
            do {
                let data = try encoder.encode(workoutDays)
                try data.write(to: archiveURL)
            } catch {
                print("Error saving workout days: \(error)")
            }
        }
    }
    
    private func loadWorkoutDays() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let archiveURL = documentsDirectory?.appendingPathComponent("workout_days.plist")
        
        if let archiveURL = archiveURL,
           let data = try? Data(contentsOf: archiveURL),
           let decodedWorkoutDays = try? PropertyListDecoder().decode([WorkoutDay].self, from: data) {
            workoutDays = decodedWorkoutDays
        }
    }
}

struct NewWorkoutPlanPrompt: View {
    @State var name: String = ""
    @Binding var showPrompt: Bool
    @ObservedObject var workoutDayViewModel: WorkoutDayViewModel
    var body: some View {
        VStack {
            HStack {
                Text("Name:")
                    .frame(alignment: .leading)
                TextField("e.g. Starting Strength", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .font(.callout)
                    .frame(width: 200)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button (action: {
                showPrompt = false
                workoutDayViewModel.addItem(name: name)
            }) {
                Text("Ok")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            }
            .buttonStyle(.bordered)
            Button (action: {
                showPrompt = false
            }) {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            }
            .buttonStyle(.bordered)
        }
        .frame(height: 150, alignment: .topLeading)
        .cornerRadius(15)
    }
}

struct WorkoutView: View {
    @State var name: String
    var body: some View {
        ZStack {
            VStack {
                Text(name)
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    print("Action1")
                }) {
                    Text("New Workout Day")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal)
        }
    }
}

struct ContentView: View {
    @StateObject private var workoutDayViewModel = WorkoutDayViewModel()
    @State private var showPrompt = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack() {
                    Text("Start Workout")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: handleNewWorkoutDayClick) {
                        Text("New Workout Plan")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    if !showPrompt {
                        
                        List {
                            ForEach(workoutDayViewModel.workoutDays) {item in
                                NavigationLink(destination: WorkoutView(name: item.name)) {
                                    Text(item.name)
                                        .listRowInsets(EdgeInsets())
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal)
                .background(showPrompt ? .gray.opacity(0.5) : .white)
                
                if showPrompt {
                    NewWorkoutPlanPrompt(showPrompt: $showPrompt, workoutDayViewModel: workoutDayViewModel)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.85)
                        .padding([.horizontal, .top])
                        .background(.white)
                        .cornerRadius(15)
                }
            }
        }
    }
    func handleNewWorkoutDayClick() {
        showPrompt = true
    }
}

#Preview {
    ContentView()
}

#Preview {
    WorkoutView(name: "demo")
}
