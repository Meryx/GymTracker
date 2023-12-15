import SwiftUI
import Foundation

class NumbersOnly: ObservableObject, Codable {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { !$0.isNumber && $0 != "." }
            if value != filtered {
                value = filtered
            }
        }
    }

    enum CodingKeys: CodingKey {
        case value
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .value)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
    }

    init() {}

    init(value: String) {
        self.value = value
    }
}


struct WorkoutDay: Codable, Identifiable {
    var id = UUID()
    var name: String
    var days: WorkoutSubDayViewModel
}

class WorkoutDayViewModel: ObservableObject {
    @Published var workoutDays: [WorkoutDay] = []
    
    init() {
        loadWorkoutDays()
    }
    
    func addItem(name: String) {
        let newItem = WorkoutDay(name: name, days: WorkoutSubDayViewModel())
        workoutDays.append(newItem)
        saveWorkoutDays()
    }
    
    func saveWorkoutDays() {
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

struct NewDayPrompt: View {
    @State var name: String = ""
    @Binding var showPrompt: Bool
    @ObservedObject var workoutDayViewModel: WorkoutSubDayViewModel
    var onMutation: () -> Void
    var body: some View {
        VStack {
            HStack {
                Text("Name:")
                    .frame(alignment: .leading)
                TextField("e.g. Leg Day", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .font(.callout)
                    .frame(width: 200)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button (action: {
                showPrompt = false
                workoutDayViewModel.addItem(name: name)
                onMutation()
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
    @State var name: String = ""
    @State var showPrompt: Bool = false
    @ObservedObject var workoutDays: WorkoutSubDayViewModel
    
    var onMutation: () -> Void
    var body: some View {
        ZStack {
            VStack {
                Text(name)
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                Button(action: {
                    showPrompt.toggle()
                }) {
                    Text("New Workout Day")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                if !showPrompt {
                    List(workoutDays.workoutDays) { item in
 
                            NavigationLink(destination: DayView(name: item.name, exerciseViewModel: item.exerciseViewModel, onMutation: onMutation)) {
                                Text(item.name)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.white)
                            .foregroundColor(.black)
                        
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal)
            .background(showPrompt ? .gray.opacity(0.5) : .white)
            if showPrompt {
                NewDayPrompt(showPrompt: $showPrompt, workoutDayViewModel: workoutDays, onMutation: onMutation)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.85)
                    .padding([.horizontal, .top])
                    .background(.white)
                    .cornerRadius(15)
            }
        }
    }
}

struct WorkoutSubDay: Codable, Identifiable {
    var id = UUID()
    var name: String
    var exerciseViewModel: ExerciseViewModel
}

class WorkoutSubDayViewModel: ObservableObject, Codable {
    @Published var workoutDays: [WorkoutSubDay] = []
    
    init() {
        
    }
    
    enum CodingKeys: CodingKey {
        case workoutDays
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        workoutDays = try container.decode([WorkoutSubDay].self, forKey: .workoutDays)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(workoutDays, forKey: .workoutDays)
    }
    
    func addItem(name: String) {
        let newItem = WorkoutSubDay(name: name, exerciseViewModel: ExerciseViewModel())
        workoutDays.append(newItem)
    }
}

struct Exercise: Codable, Identifiable {
    var id = UUID()
    var name: String
    var exerciseViewModels: ExerciseRowDetailViewModel
}

class ExerciseViewModel: ObservableObject, Codable {
    @Published var exercises: [Exercise] = []
    
    func updateAllExerciseDetails() {
            for exercise in exercises {
                exercise.exerciseViewModels.updatePreviousValues()
            }
        }
    
    init() {
        
    }
    
    enum CodingKeys: CodingKey {
        case exercises
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        exercises = try container.decode([Exercise].self, forKey: .exercises)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(exercises, forKey: .exercises)
    }
    
    func addItem(name: String) {
        let newItem = Exercise(name: name, exerciseViewModels: ExerciseRowDetailViewModel())
        exercises.append(newItem)
    }
}

struct NewExercisePrompt: View {
    @State var name: String = ""
    @Binding var showPrompt: Bool
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    var onMutation: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Name:")
                    .frame(alignment: .leading)
                TextField("e.g. Squat", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .font(.callout)
                    .frame(width: 200)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button (action: {
                showPrompt = false
                exerciseViewModel.addItem(name: name)
                onMutation()
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

struct DayView: View {
    @State var name: String = ""
    @State var showPrompt: Bool = false
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    var onMutation: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                Text(name)
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                Button(action: {
                    showPrompt.toggle()
                }) {
                    Text("+ Add Exercise")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                Button(action: {
                    exerciseViewModel.updateAllExerciseDetails()
                    onMutation()
                    
                }) {
                    Text("Save Workout")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 35)
                .background(.green)
                .foregroundColor(.white)
                .cornerRadius(5)
                if !showPrompt {
                    List(exerciseViewModel.exercises) {item in

                            ExerciseRowView(name: item.name, exerciseDetails: item.exerciseViewModels,
                                            onMutation: onMutation)
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.white)
                                .foregroundColor(Color.black)
                                .listRowSeparator(.hidden)
                        
                    }
                    .listStyle(PlainListStyle())
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal)
            .background(showPrompt ? .gray.opacity(0.5) : .white)
            if showPrompt {
                NewExercisePrompt(showPrompt: $showPrompt, exerciseViewModel: exerciseViewModel, onMutation: onMutation)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.85)
                    .padding([.horizontal, .top])
                    .background(.white)
                    .cornerRadius(15)
            }
        }
    }
}

class ExerciseRowDetailViewModel: ObservableObject, Codable {
    var counter: Int = 1
    @Published var exerciseDetail: [ExerciseDetail] = []
    
    func updatePreviousValues() {
            for i in 0..<exerciseDetail.count {

                    exerciseDetail[i].prevKg = exerciseDetail[i].kgText
                    exerciseDetail[i].prevReps = exerciseDetail[i].repsText
                exerciseDetail[i].kgText = ""
                exerciseDetail[i].repsText = ""
                
            }
        }
    
    init() {
        
    }
    
    enum CodingKeys: CodingKey {
        case exerciseDetail
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        exerciseDetail = try container.decode([ExerciseDetail].self, forKey: .exerciseDetail)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(exerciseDetail, forKey: .exerciseDetail)
    }
    
    func addItem() {
        exerciseDetail.append(ExerciseDetail(setsText: "\(counter)"))
        counter = counter + 1
    }
}

struct ExerciseDetail: Codable, Identifiable {
    var id = UUID()
    var setsText: String = ""
    var kgText: String = ""
    var repsText: String = ""
    var prevKg: String = "N/A"
    var prevReps: String = "N/A"
}

struct ExerciseRowDetail: View {
    @Binding var item: ExerciseDetail;
    @State var one: String = ""
    @State var two: String = ""
    @ObservedObject var kgText = NumbersOnly()
    @ObservedObject var repsText = NumbersOnly()
    var onMutation: () -> Void
    var body: some View {
        HStack {
            TextField("", text: $item.setsText)
                .fontWeight(.bold)
                .frame(width: 30)
                .multilineTextAlignment(.center)
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
                .disabled(true)
            
            TextField("", text: $item.prevKg)
                .fontWeight(.bold)
                .frame(width: 90)
                .multilineTextAlignment(.center)
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
                .disabled(true)
            
            TextField("", text: $item.prevReps)
                .fontWeight(.bold)
                .frame(width: 90)
                .multilineTextAlignment(.center)
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
                .disabled(true)
            
            TextField("", text: $item.kgText)
                .fontWeight(.bold)
                .frame(width: 50)
                .multilineTextAlignment(.center)
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
                .onChange(of: item.kgText, {
                    onMutation()
                })
                .keyboardType(.decimalPad)
            TextField("", text: $item.repsText)
                .fontWeight(.bold)
                .frame(width: 50)
                .multilineTextAlignment(.center)
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
                .onChange(of: item.repsText, {
                    onMutation()
                })
                .keyboardType(.decimalPad)
            
        }
    }
}

struct ExerciseRowView: View {
    @State var name: String = ""

    @ObservedObject var exerciseDetails: ExerciseRowDetailViewModel
    var onMutation: () -> Void
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(name)")
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            
            HStack {
                Text("Set")
                    .fontWeight(.bold)
                    .frame(width: 30, alignment: .leading)
                Text("Prev. kg")
                    .fontWeight(.bold)
                    .frame(width: 90, alignment: .center)
                Text("Prev. Reps")
                    .fontWeight(.bold)
                    .frame(width: 90, alignment: .center)
                Text("kg")
                    .fontWeight(.bold)
                    .frame(width: 50, alignment: .center)
                Text("Reps")
                    .fontWeight(.bold)
                    .frame(width: 50, alignment: .center)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
                ForEach($exerciseDetails.exerciseDetail) {$item in
                    ExerciseRowDetail(item: $item, onMutation: onMutation)
                }
            
            Button(action: {
                exerciseDetails.addItem()
                onMutation()
            }) {
                Text("+")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            
        }
    }
}




struct ExerciseHistory: Codable, Identifiable {
    var id = UUID()
    var name: String
    var rows: [ExerciseRowHistory] = []
    var date = Date()
}

struct ExerciseRowHistory: Codable, Identifiable {
    var id = UUID()
    var set: Int
    var kg: Double
    var reps: Int
}

struct ContentView: View {
    @StateObject private var workoutDayViewModel = WorkoutDayViewModel()
    @State private var showPrompt = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack() {
                    Text("Start Workout")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                    Button(action: handleNewWorkoutDayClick) {
                        Text("New Workout Plan")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    if !showPrompt {
                        
                        List(workoutDayViewModel.workoutDays) {item in
                                NavigationLink(destination: WorkoutView(name: item.name, workoutDays: item.days, onMutation: workoutDayViewModel.saveWorkoutDays)) {
                                    Text(item.name)
                                       
                            }
                                .listRowBackground(Color.white)
                                .listRowInsets(EdgeInsets())
                                .foregroundColor(.black)

                        }
                        .listStyle(PlainListStyle())
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal)
                .padding(.top, 38)
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
        .environment(\.colorScheme, .light) // Force light mode
    
}
