//
//  ExerciseList.swift
//  GymTracker
//
//  Created by Anwar Haredy on 20/05/1445 AH.
//

import SwiftUI

struct ListItem: Identifiable {
    let id = UUID()
    var name: String
    var sets: Int
    var reps: Int
    var kg: Int
    var setsText: String
    var repsText: String
    var kgText: String

}

class ExerciseListModel: ObservableObject {
    @Published var items: [ListItem] = []

    func addItem(name: String, sets: Int, reps: Int, kg: Int, setsText: String, repsText: String, kgText: String) {
        let newItem = ListItem(name: name, sets: sets, reps: reps, kg: kg, setsText: setsText, repsText: repsText, kgText: kgText)
        items.append(newItem)
    }
}



struct ExerciseList: View {
    @StateObject var viewModel: ExerciseListModel
    @ObservedObject var viewModel2: ExerciseRowDetailsModel
    var body: some View {
        NavigationView {
                List(viewModel.items) { item in
                    ExerciseRowView(name: item.name, sets: item.sets, reps: item.reps, kg: item.kg, setsText: item.setsText, kgText: item.kgText, repsText: item.repsText, ExerciseDetailsModel: viewModel2)
            }
        }
    }
}
