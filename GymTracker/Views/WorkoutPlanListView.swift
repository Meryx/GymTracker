//
//  WorkoutPlanListView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 05/06/1445 AH.
//

import SwiftUI

struct WorkoutPlanListView: View {
    @StateObject private var workoutDayViewModel = WorkoutDayViewModel()
    @State private var showPrompt = false
    @StateObject var globalData = GlobalData()

    
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
                        
                        List(workoutDayViewModel.workoutDays.indices, id: \.self) {index in
                            NavigationLink(destination: WorkoutView(name: self.workoutDayViewModel.workoutDays[index].name, workoutDays: self.workoutDayViewModel.workoutDays[index].days, onMutation: workoutDayViewModel.saveWorkoutDays)) {
                                WorkoutPlanRow(name: self.workoutDayViewModel.workoutDays[index].name, index: index, viewModel: workoutDayViewModel)
                                       
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
        .environmentObject(globalData)
    }
    
    
    
    func handleNewWorkoutDayClick() {
        showPrompt = true
    }
}

#Preview {
    WorkoutPlanListView()
}
