//
//  GymTrackerView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 08/06/1445 AH.
//

import SwiftUI

struct GymTrackerView: View {
    var body: some View {
        VStack {
            NavigationStack {
                ProgramListView()
                    .padding(.horizontal)
            }
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
    }
}

#Preview {
    GymTrackerView()
}
