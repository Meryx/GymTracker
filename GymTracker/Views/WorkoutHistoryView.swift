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
        WorkoutHistoryPaneView(history: globalData.myArray[0])
    }
}

//#Preview {
//    WorkoutHistoryView()
//}
