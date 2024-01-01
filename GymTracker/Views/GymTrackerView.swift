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
    
    struct MonthYear: Hashable {
        let month: Int
        let year: Int
    }
    
    struct MonthSection {
        let month: String
        let year: String
        let items: [ExerciseHistory]
    }
    
    func groupItemsByMonth() -> [MonthSection] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM" // Format for full month name

        let groupedDictionary = Dictionary(grouping: viewModel.history) { item -> MonthYear in
            let month = calendar.component(.month, from: item.date)
            let year = calendar.component(.year, from: item.date)
            return MonthYear(month: month, year: year)
        }

        return groupedDictionary.map { key, items in
            let monthName = dateFormatter.monthSymbols[key.month - 1]
            // Convert year to String without comma
            let yearString = String(key.year)
            return MonthSection(month: monthName, year: yearString, items: items)
        }.sorted { $0.year < $1.year || ($0.year == $1.year && $0.month < $1.month) }
    }


    
    
    var body: some View {
        VStack{
            Text("History")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                
                ForEach(groupItemsByMonth(), id: \.month) { monthSection in
                    Section(header:
                                
                                Text("\(monthSection.month.uppercased()) \(monthSection.year)")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                    ) {
                        ForEach(monthSection.items.indices, id: \.self) { index in
                            WorkoutHistoryPaneView(history: monthSection.items[index], ind: index)
                            
                        }
                    }
                }
                
            }
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal)
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
            
            NavigationStack {
                ProgramListView()
            }
            
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NutritionView()
                .tabItem {
                    Label("Nutrition", systemImage: "person")
                }
            
            WorkoutHistoryView()
                .tabItem {
                    Label("History", systemImage: "hourglass")
                }
        }
        
    }
}
