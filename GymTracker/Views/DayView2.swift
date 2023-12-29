//
//  DayView2.swift
//  GymTracker
//
//  Created by Anwar Haredy on 16/06/1445 AH.
//

import SwiftUI

class ExerciseViewModel: ObservableObject {
    @Published var description: String = ""
    var exercises: [Exercise]

    init(exercises: [Exercise]) {
        self.exercises = exercises
        updateDescription()
    }

    func updateDescription() {
        self.description = exercises.map { $0.exerciseName }.joined(separator: ", ")
    }
}

struct DescriptionView: View {
    @ObservedObject var viewModel: ExerciseViewModel
    
    var body: some View {
        Text(viewModel.description)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
    }
}

struct DayPane: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @State var name = "Hello"
    @State var dayId: Int64
    @State var exercises: [Exercise] = []
    var body: some View {
        VStack {
            Text(name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.bold)
            DescriptionView(viewModel: ExerciseViewModel(exercises: exercises))
                .onAppear() {
                    exercises = databaseManager.fetchExercisesByDayId(id: dayId)
                }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45, alignment: .topLeading)
        .overlay(
            RoundedRectangle(cornerRadius: 10) // Set the corner radius
                .strokeBorder(Color.gray.opacity(0.5), lineWidth: 1) // Set border color and line width
        )
    }
}

//#Preview {
//    DayPane()
//}
