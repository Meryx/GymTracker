//
//  DayView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 15/06/1445 AH.
//

import SwiftUI

struct AddExercisePrompt: View {
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
                AddExercisePrompt(show: $showPrompt, id: dayID)
            }
        }
        .padding(.horizontal)
        .background(showPrompt ? Color.gray.opacity(0.5) : Color.white)
        
    }
}

