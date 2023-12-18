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
    @State var name2: String = "Anwar"
    @ObservedObject var viewModel: WorkoutPlanViewModel
    var body: some View {
        ZStack {
            if !viewModel.isWarningPromptShown() {
                HStack {
                    Text(name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "trash")
                        .onTapGesture {
                            viewModel.markForDeletion = index
                            viewModel.handleTrashWorkoutPlanClick()
                        }
                        .padding(5)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
        }
    }
}

#Preview {
    WorkoutPlanRowView(name: "Anwar", index: 0, viewModel: WorkoutPlanViewModel())
}
