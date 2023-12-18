//
//  WorkoutPlanRowView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 05/06/1445 AH.
//

import SwiftUI

struct WorkoutPlanRowView: View {
    var name: String
    var index: Int
    @ObservedObject var viewModel: WorkoutPlanViewModel
    var body: some View {
        HStack {
            Text(name)
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "trash")
                .onTapGesture {
                    viewModel.removeWorkoutPlan(at: index)
                    viewModel.saveWorkoutDays()
                }
                .padding(5)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(5)
        }
    }
}

//#Preview {
//    WorkoutPlanRowView()
//}
