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

}

class ExerciseListModel: ObservableObject {
    @Published var items: [ListItem] = []

    func addItem(name: String, sets: Int, reps: Int) {
        let newItem = ListItem(name: name, sets: sets, reps: reps)
        print(reps)
        items.append(newItem)
    }
}



struct ExerciseList: View {
    @StateObject var viewModel = ExerciseListModel()
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.items) { item in
                    ExerciseRowView(name: item.name, sets: item.sets, reps: item.reps)
                }
            }
        }
    }
}

#Preview {
    ExerciseList()
}
