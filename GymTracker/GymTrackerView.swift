//
//  GymTrackerView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 08/06/1445 AH.
//

import SwiftUI

struct WorkoutHistoryView: View {
    @EnvironmentObject var viewModel: ProgramListViewModel
    @EnvironmentObject var databaseManager: DatabaseManager
    var body: some View {
        VStack{
            ForEach(viewModel.history.indices, id: \.self) {index in
                WorkoutHistoryPaneView(history: viewModel.history[viewModel.history.endIndex - 1 - index], ind: index)
                
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear() {
            viewModel.setHistory = []
            viewModel.history = databaseManager.fetchAllExerciseHistory()
            if viewModel.history.count > 0 {
                for i in 0...viewModel.history.count - 1 {
                    let his = viewModel.history[viewModel.history.endIndex - 1 - i]
                    viewModel.setHistory.append(databaseManager.fetchAllSetHistories(historyId: his.historyId))
                    
                }
            }
        }
    }
}


struct GymTrackerView: View {
    var body: some View {
        TabView
        {
            VStack {
                NavigationStack {
                    ProgramListView()
                }
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            WorkoutHistoryView()
                .tabItem {
                    Label("History", systemImage: "hourglass")
                }
        }
        
    }
}

#Preview {
    GymTrackerView()
}
