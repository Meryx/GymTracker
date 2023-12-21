//
//  ProgramListView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 08/06/1445 AH.
//

import SwiftUI

struct ProgramListView: View {
    @EnvironmentObject private var databaseManager: DatabaseManager
    @State private var programs: [Program] = []
    var body: some View {
        VStack {
            Text("Program List")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
                print("hello")
            }, label: {
                Text("+ New Program")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            })
            .buttonStyle(.borderedProminent)
            List(programs.indices, id: \.self)
            { index in
                Text(programs[index].name)
            }
            .listStyle(PlainListStyle())
            .onAppear(perform: {
                self.programs = self.databaseManager.fetchPrograms()
            })
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

//#Preview {
//    ProgramListView()
//}
