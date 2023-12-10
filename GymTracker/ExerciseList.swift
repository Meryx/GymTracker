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
    var row: ExerciseRowDetailsModel
    
}

class ExerciseListModel: ObservableObject {
    @Published var items: [ListItem] = []
    
    func addItem(name: String) {
        let newItem = ListItem(name: name, row: ExerciseRowDetailsModel())
        items.append(newItem)
    }
}



struct ExerciseList: View {
    @StateObject var viewModel: ExerciseListModel
    @ObservedObject var exerciseModel: ExerciseViewModel
    var body: some View {
        NavigationView {
            List(viewModel.items) { item in
                ExerciseRowView(name: item.name, ExerciseDetailsModel: item.row, exerciseModel: exerciseModel)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
