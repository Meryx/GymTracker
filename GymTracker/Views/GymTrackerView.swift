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
    
    func findCount(_ arr: [MonthSection], _ ind: Int) -> Int {
        if ind == 0 {
            return 0;
        }
        var sum = 0
        for i in 0..<ind {
            sum = sum + arr[arr.count - i - 1].items.count
        }
        return sum
    }
    
    

    
    
    var body: some View {
        let x = groupItemsByMonth()
        VStack{
            Text("History")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                
                ForEach(x.indices, id: \.self) { uIndex in
                    Section(header:
                                
                                Text("\(x[x.count - uIndex - 1].month.uppercased()) \(x[x.count - uIndex - 1].year)")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                    ) {
                        ForEach(x[x.count - uIndex - 1].items.indices, id: \.self) { index in
                            WorkoutHistoryPaneView(history: x[x.count - uIndex - 1].items[x[x.count - uIndex - 1].items.count - index - 1], ind: index + findCount(x,uIndex))
                            
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
                    let his = viewModel.history[viewModel.history.count - i - 1]
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
