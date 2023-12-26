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
                            if(setD.setId != -1)
                            {
                                databaseManager.modifySet(setD: setD)
                                continue
                            }
                            databaseManager.addSet(setD: setD)
                            
                        }
                    
                    viewModel.updateSets(databaseManager: databaseManager, dayID: dayID)
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
                
                List(viewModel.exercises.indices, id: \.self) { index in
                    ExerciseRowView(name: viewModel.exercises[index].exerciseName, id: viewModel.exercises[index].exerciseId)
                        .padding(.top)
                }
                .id(refreshKey) // Use the dynamic key here
                .onAppear(perform: {
                    viewModel.exercises = self.databaseManager.fetchExercisesByDayId(id: self.dayID)
                    viewModel.sets = self.databaseManager.fetchSetByDayId(id: self.dayID)
                })
                .listStyle(PlainListStyle())

            }
            if showPrompt {
                AddExerciseView(show: $showPrompt, id: dayID)
            }
        }
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
                List(viewModel.days.indices, id: \.self)
                { index in
                    NavigationLink(destination: DayView(name: viewModel.days[index].dayName, dayID: viewModel.days[index].dayId)
                        .padding(.horizontal)
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                        })
                    {
                        Text(viewModel.days[index].dayName)
                    }
                }
                .onAppear(perform: {
                    viewModel.days = self.databaseManager.fetchWorkoutDaysByProgramId(id: self.programsID)
                })
                .listStyle(PlainListStyle())
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            if showPrompt {
                AddDayView(show: $showPrompt, id: programsID)
            }
        }
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
                List(viewModel.programs.indices, id: \.self)
                { index in
                    NavigationLink(destination: ProgramView(name: viewModel.programs[index].name, programsID: viewModel.programs[index].id)
                        .padding(.horizontal)
                    )
                    {
                        Text(viewModel.programs[index].name)
                    }
                }
                .listStyle(PlainListStyle())
                .onAppear(perform: {
                    self.viewModel.programs = self.databaseManager.fetchPrograms()
                })
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            if showPrompt {
                AddProgramPrompt(show: $showPrompt)
            }
        }
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
    @State var name: String = ""
    @State var sets: [SetDetail] = []
    @State var counter: Int = 1
    @State var id: Int64
    
    
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("\(name)")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "trash")
                    .onTapGesture {
                        //                        viewModel.exercises.remove(at: index)
                        //                        onMutation()
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
                    ExerciseRowDetail(index: index, prevWeight: String(viewModel.sets[index].prevWeight), prevReps: String(viewModel.sets[index].prevReps), weight: String(viewModel.sets[index].setWeight), reps: String(viewModel.sets[index].setReps))
                }
            }
            
            
            Button(action: {
                viewModel.sets.append(SetDetail(setId: -1, setWeight: 0, setReps: 0, prevWeight: 0, prevReps: 0, setExerciseId: id))
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
    @State var strIndex: String
    
    init(index: Int, prevWeight: String, prevReps: String, weight: String, reps: String) {
        self.index = index
        self.prevWeight = prevWeight
        self.prevReps = prevReps
        self.weight = weight
        self.reps = reps
        self.strIndex = String(index + 1)
    }
    
    var body: some View {
        HStack {
            TextField("", text: $strIndex)
                .fontWeight(.bold)
                .frame(width: 30)
                .multilineTextAlignment(.center)
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
                .disabled(true)
            
            TextField("", text: $prevWeight)
                .fontWeight(.bold)
                .frame(width: 90)
                .multilineTextAlignment(.center)
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
                .disabled(true)
            
            TextField("", text: $prevReps)
                .fontWeight(.bold)
                .frame(width: 90)
                .multilineTextAlignment(.center)
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
                .disabled(true)
            
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
            //                .focused($nameIsFocused)
            
        }
    }
}

//#Preview {
//    ProgramListView()
//}
