//
//  WorkoutPlanListView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 05/06/1445 AH.
//

import SwiftUI

struct WorkoutPlanView: View {
    @StateObject private var viewModel = WorkoutPlanViewModel()
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
                    Button(action: viewModel.handleNewWorkoutPlanClick) {
                        Text("New Workout Plan")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    if !viewModel.isPromptShown() {
                        
                        List(viewModel.publicWorkoutPlans.indices, id: \.self) { index in
                            NavigationLink(destination: WorkoutView(name: viewModel.publicWorkoutPlans[index].name, workoutDays: viewModel.publicWorkoutPlans[index].days, onMutation: viewModel.saveWorkoutDays)) {
                                WorkoutPlanRowView(name: viewModel.publicWorkoutPlans[index].name, index: index, viewModel: viewModel)
                                
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
                .background(viewModel.isPromptShown() ? .gray.opacity(0.5) : .white)
                
                if viewModel.isPromptShown() {
                    WorkoutPlanPromptView(viewModel: viewModel)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.85)
                        .padding([.horizontal, .top])
                        .background(.white)
                        .cornerRadius(15)
                }
                if viewModel.isWarningPromptShown() {
                    VStack {
                        HStack {
                            Text("Delete this item?")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Button (action: {
                            viewModel.removeWorkoutPlan()
                            viewModel.saveWorkoutDays()
                            viewModel.hideWarningPrompt()
                        }) {
                            Text("Ok")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.bold)
                        }
                        .buttonStyle(.bordered)
                        Button (action: {
                            viewModel.hideWarningPrompt()
                        }) {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.bold)
                        }
                        .buttonStyle(.bordered)
                    }
                    .frame(height: 150, alignment: .topLeading)
                    .cornerRadius(15)
                    .padding(.top, 20)
                }
            }
        }
        .environmentObject(globalData)
    }
}

#Preview {
    WorkoutPlanView()
}
