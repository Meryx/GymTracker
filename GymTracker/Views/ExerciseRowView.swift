//
//  ExerciseRowView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 15/06/1445 AH.
//

import SwiftUI

struct ExerciseRowDetail: View {
    @EnvironmentObject private var viewModel: ProgramListViewModel
    @State var index: Int
    @State var prevWeight: String
    @State var prevReps: String
    @State var weight: String
    @State var reps: String
    @State var setNum: String = "1"
    
    var body: some View {
        HStack {
            TextField("", text: $setNum)
                .fontWeight(.bold)
                .frame(width: 30)
                .multilineTextAlignment(.center)
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
                .disabled(true)
            
            if(prevWeight != "0.0"){
                TextField("", text: $prevWeight)
                    .fontWeight(.bold)
                    .frame(width: 90)
                    .multilineTextAlignment(.center)
                    .background(.gray.opacity(0.5))
                    .cornerRadius(10)
                    .disabled(true)
            } else {
                Text("-")
                    .fontWeight(.bold)
                    .frame(width: 90, alignment: .center)
            }
            
            if(prevReps != "0"){
                TextField("", text: $prevReps)
                    .fontWeight(.bold)
                    .frame(width: 90)
                    .multilineTextAlignment(.center)
                    .background(.gray.opacity(0.5))
                    .cornerRadius(10)
                    .disabled(true)
            } else {
                Text("-")
                    .fontWeight(.bold)
                    .frame(width: 90, alignment: .center)
            }
            
            TextField("", text: $weight)
                .fontWeight(.bold)
                .frame(width: 50)
                .multilineTextAlignment(.center)
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
                .keyboardType(.decimalPad)
                .onChange(of: weight, {
                    viewModel.sets[index].setWeight = Double(weight) ?? 0.0
                })
            TextField("", text: $reps)
                .fontWeight(.bold)
                .frame(width: 50)
                .multilineTextAlignment(.center)
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
                .keyboardType(.decimalPad)
                .onChange(of: reps, {
                    viewModel.sets[index].setReps = Int64(reps) ?? 0
                })
            
        }
    }
}

struct ExerciseRowView: View {
    @EnvironmentObject private var viewModel: ProgramListViewModel
    @EnvironmentObject private var databaseManager: DatabaseManager
    @State var name: String = ""
    @State var sets: [SetDetail] = []
    @State var counter: Int = 0
    @State var id: Int64
    @State var dayId: Int64
    var onMutation: (_ id: Int64) -> Void
    
    
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("\(name)")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "trash")
                    .onTapGesture {
                        onMutation(id)
                    }
                    .padding(5)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            
            
            
            HStack {
                Text("Set")
                    .fontWeight(.bold)
                    .frame(width: 30, alignment: .leading)
                Text("Prev. kg")
                    .fontWeight(.bold)
                    .frame(width: 90, alignment: .center)
                Text("Prev. Reps")
                    .fontWeight(.bold)
                    .frame(width: 90, alignment: .center)
                Text("kg")
                    .fontWeight(.bold)
                    .frame(width: 50, alignment: .center)
                Text("Reps")
                    .fontWeight(.bold)
                    .frame(width: 50, alignment: .center)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(viewModel.sets.indices, id: \.self) { index in
                if viewModel.sets[index].setExerciseId == id {
                    ExerciseRowDetail(index: index, prevWeight: String(viewModel.sets[index].prevWeight), prevReps: String(viewModel.sets[index].prevReps), weight: String(viewModel.sets[index].setWeight), reps: String(viewModel.sets[index].setReps), setNum: String(viewModel.sets[index].setNum))
                }
            }
            .onAppear() {
                counter = viewModel.sets.filter({$0.setExerciseId == id}).count
            }
            
            
            Button(action: {
                viewModel.sets.append(SetDetail(setId: -1, setWeight: 0, setReps: 0, prevWeight: 0, prevReps: 0, setExerciseId: id, setNum: counter + 1))
                
                databaseManager.addSet(setD: SetDetail(setId: -1, setWeight: 0, setReps: 0, prevWeight: 0, prevReps: 0, setExerciseId: id, setNum: counter + 1))
                viewModel.sets = databaseManager.fetchSetByDayId(id: dayId)
                counter = counter + 1
            }) {
                Text("+")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            
        }
    }
}
