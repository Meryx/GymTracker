//
//  ExerciseRowView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 20/05/1445 AH.
//

import SwiftUI

struct ExerciseRowView: View {
    var name: String
    var sets: Int
    var reps: Int
    var kg: Int
    @State var setsText: String
    @State var kgText: String
    @State var repsText: String

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
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            
        }
}

#Preview {
    ExerciseRowView(name: "Anwar", sets: 3, reps: 12, kg: 5, setsText: "1", kgText: "100", repsText: "5")
}
