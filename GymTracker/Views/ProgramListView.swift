//
//  ProgramListView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 08/06/1445 AH.
//

import SwiftUI

struct AddProgramPrompt: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var viewModel: ProgramListViewModel
    @State var name: String = ""
    @Binding var show: Bool
    @State var myVar = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Name:")
                    .frame(alignment: .leading)
                TextField("e.g. Starting Strength", text: self.$name)
                    .textFieldStyle(.roundedBorder)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .horizontal])
            Button (action: {
                self.show = false
                self.databaseManager.addProgram(name: self.name)
                self.viewModel.programs = self.databaseManager.fetchPrograms()
            }) {
                Text("Ok")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            }
            .buttonStyle(.bordered)
            .padding(.horizontal)
            Button (action: {
                self.show = false
            }) {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            }
            .buttonStyle(.bordered)
            .padding([.bottom, .horizontal])
        }
        .frame(height: 175, alignment: .center)
        .background(.white)
        .cornerRadius(15)
    }
}

struct ProgramListView: View {
    @EnvironmentObject private var databaseManager: DatabaseManager
    @EnvironmentObject private var viewModel: ProgramListViewModel
    @State var showPrompt: Bool = false
    
    var body: some View {
        
        ZStack {
            
            VStack {
                Text("Program List")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    showPrompt = true
                }, label: {
                    Text("+ New Program")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                })
                .padding(.top)
                .buttonStyle(.borderedProminent)
                
                if !showPrompt {
                    List(self.viewModel.programs.indices, id: \.self)
                    { index in
                        ZStack {
                            NavigationLink(destination: ProgramView(name: self.viewModel.programs[index].name, programsID: self.viewModel.programs[index].id))
                            {
                                EmptyView()
                            }.opacity(0.0)
                            
                            HStack {
                                Text(self.viewModel.programs[index].name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    self.databaseManager.deleteProgram(id: self.viewModel.programs[index].id)
                                    self.viewModel.programs = self.databaseManager.fetchPrograms()
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .onAppear(perform: {
                        self.viewModel.programs = self.databaseManager.fetchPrograms()
                    })
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            if showPrompt {
                AddProgramPrompt(show: $showPrompt)
            }
        }
        .padding(.horizontal)
        .padding(.top, 38)
        .background(showPrompt ? Color.gray.opacity(0.5) : Color.white)
    }
}
