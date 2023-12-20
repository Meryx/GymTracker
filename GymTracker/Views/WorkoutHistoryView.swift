//
//  WorkoutHistoryView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 06/06/1445 AH.
//

import SwiftUI

struct WorkoutHistoryView: View {
    @EnvironmentObject var globalData: GlobalData
    var body: some View {
        
        VStack{
            ForEach(globalData.myArray.indices, id: \.self) {index in
                WorkoutHistoryPaneView(history: globalData.myArray[globalData.myArray.endIndex - 1 - index])
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

//#Preview {
//    WorkoutHistoryView()
//}
