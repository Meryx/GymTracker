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
        print(items2)
    }
}

struct ExerciseRowDetailsList: View {
    @StateObject var viewModel: ExerciseRowDetailsModel
    @State private var listKey = UUID()
    var body: some View {
        VStack {

                    List(viewModel.items2) { item in
                        ExerciseRowDetails(setsText: item.setsText, kgText: item.kgText, repsText: item.repsText)
                }
            
            .navigationTitle("Title")
            Button(action: {
                viewModel.addItem(setsText: "11", repsText: "1", kgText: "1")
                print("hello")
                listKey = UUID()
            }) {
                Text("+")
            }
        }
        .frame(height: 300)
    }
}

struct ExerciseRowDetails: View {
    @State var setsText: String
    @State var kgText: String
    @State var repsText: String
    var body: some View {
        HStack {
            TextField("", text: $setsText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.bold)
                .padding([.trailing])
                .padding(.leading, 35)
                .background(.gray.opacity(0.5))
                            .cornerRadius(10)
                
            TextField("", text: $kgText)
                .frame(maxWidth: .infinity, alignment: .center)
                .fontWeight(.bold)
                .padding([.trailing])
                .padding(.leading, 35)
                .background(.gray.opacity(0.5))
                            .cornerRadius(10)
            TextField("", text: $repsText)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .fontWeight(.bold)
                .padding([.trailing])
                .padding(.leading, 35)
                .background(.gray.opacity(0.5))
                            .cornerRadius(10)

        }
        .frame(maxWidth: .infinity)
    }
}

struct ExerciseRowView: View {
    var name: String
    var sets: Int
    var reps: Int
    var kg: Int
    @State var setsText: String
    @State var kgText: String
    @State var repsText: String
    @ObservedObject var ExerciseDetailsModel: ExerciseRowDetailsModel

        var body: some View {
            HStack {
                VStack {
                    HStack {
                        VStack (alignment: .leading) {
                            
                                Text("\(name)")
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
//                                Text("\(sets) sets x \(reps) reps x \(kg) kg")
                            HStack {
                                Text("Set")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .fontWeight(.bold)
                                    .padding([.leading, .trailing])
                                Text("kg")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .fontWeight(.bold)
                                Text("Reps")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .fontWeight(.bold)

                            }
                            .frame(maxWidth: .infinity)
                            
//                            HStack {
//                                TextField("", text: $setsText)
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .fontWeight(.bold)
//                                    .padding([.trailing])
//                                    .padding(.leading, 35)
//                                    .background(.gray.opacity(0.5))
//                                                .cornerRadius(10)
//                                    
//                                TextField("", text: $kgText)
//                                    .frame(maxWidth: .infinity, alignment: .center)
//                                    .fontWeight(.bold)
//                                    .padding([.trailing])
//                                    .padding(.leading, 35)
//                                    .background(.gray.opacity(0.5))
//                                                .cornerRadius(10)
//                                TextField("", text: $repsText)
//                                    .frame(maxWidth: .infinity, alignment: .trailing)
//                                    .fontWeight(.bold)
//                                    .padding([.trailing])
//                                    .padding(.leading, 35)
//                                    .background(.gray.opacity(0.5))
//                                                .cornerRadius(10)
//
//                            }
//                            .frame(maxWidth: .infinity)
                            ExerciseRowDetailsList(viewModel: ExerciseDetailsModel)
                            
                        }
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            
        }
}

#Preview {
    ExerciseRowView(name: "Anwar", sets: 3, reps: 12, kg: 5, setsText: "1", kgText: "100", repsText: "5", ExerciseDetailsModel: ExerciseRowDetailsModel())
}
