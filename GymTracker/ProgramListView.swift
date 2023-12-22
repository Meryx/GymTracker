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
    @EnvironmentObject private var viewModel: ProgramListViewModel
    @State var name: String
    @State var dayID: Int64
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
                    Text("+ New Exercise")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                })
                .buttonStyle(.borderedProminent)
                List(viewModel.exercises.indices, id: \.self)
                { index in
                    Text(viewModel.exercises[index].exerciseName)
                }
                .onAppear(perform: {
                    viewModel.exercises = self.databaseManager.fetchExercisesByDayId(id: self.dayID)
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
                        .padding(.horizontal))
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

//#Preview {
//    ProgramListView()
//}
