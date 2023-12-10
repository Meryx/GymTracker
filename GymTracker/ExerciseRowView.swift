//
//  ExerciseRowView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 20/05/1445 AH.
//

import SwiftUI

struct ExerciseRowDetailsItem: Identifiable {
    let id = UUID()
    var setsText: String
    var repsText: String
    var kgText: String
    
}

class ExerciseRowDetailsModel: ObservableObject {
    @Published var items2: [ExerciseRowDetailsItem] = []
    
    func addItem(setsText: String, repsText: String, kgText: String) {
        let newItem = ExerciseRowDetailsItem(setsText: setsText, repsText: repsText, kgText: kgText)
        items2.append(newItem)
    }
}

struct ExerciseRowDetailsList: View {
    @ObservedObject var viewModel: ExerciseRowDetailsModel
    @ObservedObject var exerciseModel: ExerciseViewModel
    @State var counter = 1
    var body: some View {
        VStack {
            
            List {
                ForEach(viewModel.items2) {item in
                    ExerciseRowDetails(setsText: item.setsText, kgText: item.kgText, repsText: item.repsText)
                        .listRowInsets(EdgeInsets())
                }
            }
            .listStyle(PlainListStyle())
            Button(action: {
                viewModel.addItem(setsText: "\(counter) ", repsText: "", kgText: "")
                exerciseModel.data.name = "Hello"
                self.counter+=1
            }) {
                Text("+")
            }
        }
        .frame(height: 220)
    }
}

struct ExerciseRowDetails: View {
    @State var setsText: String
    @State var kgText: String
    @State var repsText: String
    var body: some View {
        HStack {
            TextField("", text: $setsText)
                .fontWeight(.bold)
                .frame(width: 30)
                .padding(.leading, 20)
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
                .disabled(true)
            
            TextField("", text: $kgText)
                .fontWeight(.bold)
                .frame(width: 80)
                .padding([.leading])
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
            TextField("", text: $repsText)
                .fontWeight(.bold)
                .frame(width: 80)
                .padding([.leading])
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
            
        }
    }
}

struct ExerciseRowView: View {
    var name: String
    @ObservedObject var ExerciseDetailsModel: ExerciseRowDetailsModel
    @ObservedObject var exerciseModel: ExerciseViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("\(name)")
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            HStack {
                Text("Set")
                    .fontWeight(.bold)
                    .frame(width: 30, alignment: .leading)
                    .padding(.trailing, 20)
                Text("kg")
                    .fontWeight(.bold)
                    .frame(width: 80, alignment: .leading)
                    .padding([.trailing])
                Text("Reps")
                    .fontWeight(.bold)
                    .frame(width: 80, alignment: .leading)
            }
            ExerciseRowDetailsList(viewModel: ExerciseDetailsModel, exerciseModel: exerciseModel)
        }
    }
}

//#Preview {
//    ExerciseRowView(name: "Squat", ExerciseDetailsModel: ExerciseRowDetailsModel(), exerciseModel)
//}

