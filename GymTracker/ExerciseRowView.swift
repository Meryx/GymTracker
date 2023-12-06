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

        var body: some View {
            HStack {
                VStack {
                    HStack {
                        VStack (alignment: .leading) {
                            
                                Text("\(name)")
                                    .fontWeight(.bold)
                                Text("\(sets) sets x \(reps) reps x \(kg) kg")
                                
                            
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
    ExerciseRowView(name: "Anwar", sets: 3, reps: 12, kg: 5)
}
