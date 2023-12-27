//
//  WorkoutHistoryPaneView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 06/06/1445 AH.
//

import SwiftUI
import Foundation

struct WorkoutHistoryPaneView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var viewModel: ProgramListViewModel
    var history: ExerciseHistory
    @State var sets: [SetHistory] = []
    @State private var refreshKey = UUID()
    @State var ind: Int
    
    var body: some View {
        VStack {
            Text(history.dayName)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading], 5)

            Text(history.date.formatted())
                .padding(.top, 3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading], 5)


            Text("Exercise")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.bottom, .leading], 5)
            ForEach(viewModel.setHistory[ind].indices, id: \.self) { index in
                Text("\(viewModel.setHistory[ind][index].count)x \(viewModel.setHistory[ind][index].name)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading], 5)
                    .padding(.bottom, index == viewModel.setHistory.endIndex - 1 ? 5 : 0)
            }


        }
        .frame(width: UIScreen.main.bounds.width * 0.9 ,alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 10) // Set the corner radius
                .strokeBorder(Color.gray.opacity(0.5), lineWidth: 1) // Set border color and line width
        )
        

    }
}

//#Preview {
//    WorkoutHistoryPaneView()
//}
