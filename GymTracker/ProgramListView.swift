//
//  ProgramListView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 08/06/1445 AH.
//

import SwiftUI

struct DayView: View {
    @EnvironmentObject private var databaseManager: DatabaseManager
    @State var name: String
    @State var dayID: Int64
    @State var exercises: [Exercise] = []
    
    var body: some View {
        List(exercises.indices, id: \.self)
        { index in
            Text(exercises[index].exerciseName)
        }
        .onAppear(perform: {
            exercises = self.databaseManager.fetchExercisesByDayId(id: self.dayID)
        })
    }
}

struct ProgramView: View {
    @EnvironmentObject private var databaseManager: DatabaseManager
    @State var name: String
    @State var programsID: Int64
    @State var workoutDays: [WorkoutDay] = []
    
    
    var body: some View {
        List(workoutDays.indices, id: \.self)
        { index in
            NavigationLink(destination: DayView(name: workoutDays[index].dayName, dayID: workoutDays[index].dayId))
            {
                Text(workoutDays[index].dayName)
            }
        }
        .onAppear(perform: {
            workoutDays = self.databaseManager.fetchWorkoutDaysByProgramId(id: self.programsID)
        })
    }
}

struct ProgramListView: View {
    @EnvironmentObject private var databaseManager: DatabaseManager
    @ObservedObject private var viewModel = ProgramListViewModel()
    var body: some View {
        VStack {
            Text("Program List")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
                self.databaseManager.addProgramIfTableEmpty(name: "demo")
                self.viewModel.programs = self.databaseManager.fetchPrograms()
            }, label: {
                Text("+ New Program")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            })
            .buttonStyle(.borderedProminent)
            List(viewModel.programs.indices, id: \.self)
            { index in
                NavigationLink(destination: ProgramView(name: viewModel.programs[index].name, programsID: viewModel.programs[index].id))
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
    }
}

//#Preview {
//    ProgramListView()
//}
