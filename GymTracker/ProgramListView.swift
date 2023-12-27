//
//  ProgramListView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 08/06/1445 AH.
//

import SwiftUI

struct AddExerciseView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var viewModel: ProgramListViewModel
    @State var name: String = ""
    @Binding var show: Bool
    @State var id: Int64
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Name:")
                    .frame(alignment: .leading)
                TextField("e.g. Squat", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .horizontal])
            Button (action: {
                show = false
                self.databaseManager.addExercise(name: name, id: id)
                self.viewModel.exercises = self.databaseManager.fetchExercisesByDayId(id: id)
            }) {
                Text("Ok")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            }
            .buttonStyle(.bordered)
            .padding(.horizontal)
            Button (action: {
                show = false
            }) {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            }
            .buttonStyle(.bordered)
            .padding([.bottom, .horizontal])
        }
        .frame(height: 150, alignment: .topLeading)
        .background(.white)
        .cornerRadius(15)
        
    }
}

struct AddDayView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var viewModel: ProgramListViewModel
    @State var name: String = ""
    @Binding var show: Bool
    @State var id: Int64
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Name:")
                    .frame(alignment: .leading)
                TextField("e.g. Leg Day", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .horizontal])
            Button (action: {
                show = false
                self.databaseManager.addDay(name: name, id: id)
                self.viewModel.days = self.databaseManager.fetchWorkoutDaysByProgramId(id: id)
            }) {
                Text("Ok")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            }
            .buttonStyle(.bordered)
            .padding(.horizontal)
            Button (action: {
                show = false
            }) {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            }
            .buttonStyle(.bordered)
            .padding([.bottom, .horizontal])
        }
        .frame(height: 150, alignment: .topLeading)
        .background(.white)
        .cornerRadius(15)
    }
}

struct DayView: View {
    @EnvironmentObject private var databaseManager: DatabaseManager
    @EnvironmentObject var viewModel: ProgramListViewModel
    @State var name: String
    @State var dayID: Int64
    @State var showPrompt: Bool = false
    @State private var refreshKey = UUID()
    
    func onMutation(id: Int64) {
        databaseManager.deleteExercise(id: id)
        viewModel.exercises = databaseManager.fetchExercisesByDayId(id: dayID)
        refreshKey = UUID()
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text(name)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    showPrompt = true
                }, label: {
                    Text("+ New Exercise")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                })
                .buttonStyle(.borderedProminent)
                Button(action: {
                    
                    for setD in viewModel.sets {
                        databaseManager.modifySet(setD: setD)
                    }
                    
                    viewModel.updateSets(databaseManager: databaseManager, dayID: dayID)
                    
                    let name = name
                    let date = Date()
                    let toAdd = ExerciseHistory(historyId: 0, dayName: name, date: date)
                    var historyId: Int64
                    do {
                        historyId = try databaseManager.addExerciseHistory(toAdd)
                        for e in viewModel.exercises {
                            let id = e.exerciseId
                            let sets = databaseManager.fetchSetByExerciseId(id: id)
                            let count = sets.count
                            let setToAdd = SetHistory(setHistoryId: 0, setExerciseHistoryId: historyId, name: e.exerciseName, count: Int64(count))
                            do {
                                try databaseManager.addSetHistory(setToAdd)
                                
                            } catch {
                                print("\(error)")
                            }
                        }
                    } catch {
                        print("\(error)")
                    }
                    
                    
                    
                    
                    
                    
                    
                    refreshKey = UUID()
                    
                    
                }, label: {
                    Text("Save Workout")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                })
                .padding(6)
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                if !showPrompt {
                    List(viewModel.exercises.indices, id: \.self) { index in
                        ExerciseRowView(name: viewModel.exercises[index].exerciseName, id: viewModel.exercises[index].exerciseId, dayId: dayID, onMutation: onMutation)
                            .padding(.top)
                    }
                    .id(refreshKey) // Use the dynamic key here
                    .onAppear(perform: {
                        viewModel.exercises = self.databaseManager.fetchExercisesByDayId(id: self.dayID)
                        viewModel.sets = self.databaseManager.fetchSetByDayId(id: self.dayID)
                    })
                    .listStyle(PlainListStyle())
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            if showPrompt {
                AddExerciseView(show: $showPrompt, id: dayID)
            }
        }
        .padding(.horizontal)
        .background(showPrompt ? Color.gray.opacity(0.5) : Color.white)
        
    }
}

struct ProgramView: View {
    @EnvironmentObject private var databaseManager: DatabaseManager
    @EnvironmentObject private var viewModel: ProgramListViewModel
    @State var name: String
    @State var programsID: Int64
    @State var showPrompt: Bool = false
    
    
    var body: some View {
        ZStack {
            VStack {
                Text(name)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    showPrompt = true
                }, label: {
                    Text("+ New Day")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                })
                .buttonStyle(.borderedProminent)
                if !showPrompt {
                    List(viewModel.days.indices, id: \.self)
                    { index in
                        NavigationLink(destination: DayView(name: viewModel.days[index].dayName, dayID: viewModel.days[index].dayId)
                                       
                            .onTapGesture {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                            })
                        {
                            HStack {
                                Text(viewModel.days[index].dayName)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "trash")
                                    .onTapGesture {
                                        databaseManager.deleteDay(id: viewModel.days[index].dayId)
                                        self.viewModel.days = self.databaseManager.fetchWorkoutDaysByProgramId(id: programsID)
                                    }
                                    .padding(5)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                        }
                    }
                    
                    .onAppear(perform: {
                        viewModel.days = self.databaseManager.fetchWorkoutDaysByProgramId(id: self.programsID)
                    })
                    .listStyle(PlainListStyle())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            if showPrompt {
                AddDayView(show: $showPrompt, id: programsID)
            }
        }
        .padding(.horizontal)
        .background(showPrompt ? Color.gray.opacity(0.5) : Color.white)
    }
}

struct ProgramListView: View {
    @EnvironmentObject private var databaseManager: DatabaseManager
    @EnvironmentObject private var viewModel: ProgramListViewModel
    @State var showPrompt: Bool = false
    var body: some View {
        ZStack {
            VStack {
                Text("Program List")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    showPrompt = true
                }, label: {
                    Text("+ New Program")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                })
                .buttonStyle(.borderedProminent)
                
                if !showPrompt || false {
                    List(viewModel.programs.indices, id: \.self)
                    { index in
                        NavigationLink(destination: ProgramView(name: viewModel.programs[index].name, programsID: viewModel.programs[index].id)
                        )
                        {
                            HStack {
                                Text(viewModel.programs[index].name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "trash")
                                    .onTapGesture {
                                        databaseManager.deleteProgram(id: viewModel.programs[index].id)
                                        self.viewModel.programs = self.databaseManager.fetchPrograms()
                                    }
                                    .padding(5)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .onAppear(perform: {
                        self.viewModel.programs = self.databaseManager.fetchPrograms()
                    })
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            if showPrompt {
                AddProgramPrompt(show: $showPrompt)
            }
        }
        .padding(.horizontal)
        .background(showPrompt ? Color.gray.opacity(0.5) : Color.white)
    }
}

struct AddProgramPrompt: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var viewModel: ProgramListViewModel
    @State var name: String = ""
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Name:")
                    .frame(alignment: .leading)
                TextField("e.g. Starting Strength", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .horizontal])
            Button (action: {
                show = false
                self.databaseManager.addProgram(name: name)
                self.viewModel.programs = self.databaseManager.fetchPrograms()
            }) {
                Text("Ok")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            }
            .buttonStyle(.bordered)
            .padding(.horizontal)
            Button (action: {
                show = false
            }) {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            }
            .buttonStyle(.bordered)
            .padding([.bottom, .horizontal])
        }
        .frame(height: 150, alignment: .topLeading)
        .background(.white)
        .cornerRadius(15)
        
    }
}

struct ExerciseRowView: View {
    @EnvironmentObject private var viewModel: ProgramListViewModel
    @EnvironmentObject private var databaseManager: DatabaseManager
    @State var name: String = ""
    @State var sets: [SetDetail] = []
    @State var counter: Int = 0
    @State var id: Int64
    @State var dayId: Int64
    var onMutation: (_ id: Int64) -> Void
    
    
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("\(name)")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "trash")
                    .onTapGesture {
                        onMutation(id)
                    }
                    .padding(5)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            
            
            
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
            ForEach(viewModel.sets.indices, id: \.self) { index in
                if viewModel.sets[index].setExerciseId == id {
                    ExerciseRowDetail(index: index, prevWeight: String(viewModel.sets[index].prevWeight), prevReps: String(viewModel.sets[index].prevReps), weight: String(viewModel.sets[index].setWeight), reps: String(viewModel.sets[index].setReps), setNum: String(viewModel.sets[index].setNum))
                }
            }
            .onAppear() {
                counter = viewModel.sets.filter({$0.setExerciseId == id}).count
            }
            
            
            Button(action: {
                viewModel.sets.append(SetDetail(setId: -1, setWeight: 0, setReps: 0, prevWeight: 0, prevReps: 0, setExerciseId: id, setNum: counter + 1))
                
                databaseManager.addSet(setD: SetDetail(setId: -1, setWeight: 0, setReps: 0, prevWeight: 0, prevReps: 0, setExerciseId: id, setNum: counter + 1))
                viewModel.sets = databaseManager.fetchSetByDayId(id: dayId)
                counter = counter + 1
            }) {
                Text("+")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            
        }
    }
}

struct ExerciseRowDetail: View {
    @EnvironmentObject private var viewModel: ProgramListViewModel
    @State var index: Int
    @State var prevWeight: String
    @State var prevReps: String
    @State var weight: String
    @State var reps: String
    @State var setNum: String = "1"
    
    var body: some View {
        HStack {
            TextField("", text: $setNum)
                .fontWeight(.bold)
                .frame(width: 30)
                .multilineTextAlignment(.center)
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
                .disabled(true)
            
            if(prevWeight != "0.0"){
                TextField("", text: $prevWeight)
                    .fontWeight(.bold)
                    .frame(width: 90)
                    .multilineTextAlignment(.center)
                    .background(.gray.opacity(0.5))
                    .cornerRadius(10)
                    .disabled(true)
            } else {
                Text("-")
                    .fontWeight(.bold)
                    .frame(width: 90, alignment: .center)
            }
            
            if(prevReps != "0"){
                TextField("", text: $prevReps)
                    .fontWeight(.bold)
                    .frame(width: 90)
                    .multilineTextAlignment(.center)
                    .background(.gray.opacity(0.5))
                    .cornerRadius(10)
                    .disabled(true)
            } else {
                Text("-")
                    .fontWeight(.bold)
                    .frame(width: 90, alignment: .center)
            }
            
            TextField("", text: $weight)
                .fontWeight(.bold)
                .frame(width: 50)
                .multilineTextAlignment(.center)
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
                .keyboardType(.decimalPad)
                .onChange(of: weight, {
                    viewModel.sets[index].setWeight = Double(weight) ?? 0.0
                })
            TextField("", text: $reps)
                .fontWeight(.bold)
                .frame(width: 50)
                .multilineTextAlignment(.center)
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
                .keyboardType(.decimalPad)
                .onChange(of: reps, {
                    viewModel.sets[index].setReps = Int64(reps) ?? 0
                })
            
        }
    }
}
