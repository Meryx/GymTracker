//
//  ProgramListView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 08/06/1445 AH.
//

import SwiftUI

struct ProgramView: View {
    @State var name: String
    var body: some View {
        Text(name)
    }
}

struct ProgramListView: View {
    @EnvironmentObject private var databaseManager: DatabaseManager
    @ObservedObject private var viewModel = ProgramListViewModel()
    var body: some View {
        VStack {
            Text("Program List")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
                self.databaseManager.addProgramIfTableEmpty(name: "demo")
                self.viewModel.programs = self.databaseManager.fetchPrograms()
            }, label: {
                Text("+ New Program")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            })
            .buttonStyle(.borderedProminent)
            List(viewModel.programs.indices, id: \.self)
            { index in
                NavigationLink(destination: ProgramView(name: viewModel.programs[index].name))
                {
                    Text(viewModel.programs[index].name)
                }
            }
            .listStyle(PlainListStyle())
            .onAppear(perform: {
                self.viewModel.programs = self.databaseManager.fetchPrograms()
            })
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

//#Preview {
//    ProgramListView()
//}
