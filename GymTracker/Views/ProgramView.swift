//
//  ProgramView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 15/06/1445 AH.
//

import SwiftUI

struct AddDayPrompt: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var viewModel: ProgramListViewModel
    @State var name: String = ""
    @Binding var show: Bool
    @State var id: Int64
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Name:")
                    .frame(alignment: .leading)
                TextField("e.g. Leg Day", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .horizontal])
            Button (action: {
                show = false
                self.databaseManager.addDay(name: name, id: id)
                self.viewModel.days = self.databaseManager.fetchWorkoutDaysByProgramId(id: id)
            }) {
                Text("Ok")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            }
            .buttonStyle(.bordered)
            .padding(.horizontal)
            Button (action: {
                show = false
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

struct ProgramView: View {
    @EnvironmentObject private var databaseManager: DatabaseManager
    @EnvironmentObject private var viewModel: ProgramListViewModel
    @State var name: String
    @State var programsID: Int64
    @State var showPrompt: Bool = false
    
    
    var body: some View {
        ZStack {
            VStack {
                Text(name)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    showPrompt = true
                }, label: {
                    Text("+ New Day")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                })
                .buttonStyle(.borderedProminent)
                if !showPrompt {
                    List(viewModel.days.indices, id: \.self)
                    { index in
                        NavigationLink(destination: DayView(name: viewModel.days[index].dayName, dayID: viewModel.days[index].dayId)
                                       
                            .onTapGesture {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            })
                        {
                            HStack {
                                Text(viewModel.days[index].dayName)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "trash")
                                    .onTapGesture {
                                        databaseManager.deleteDay(id: viewModel.days[index].dayId)
                                        self.viewModel.days = self.databaseManager.fetchWorkoutDaysByProgramId(id: programsID)
                                    }
                                    .padding(5)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                        }
                    }
                    
                    .onAppear(perform: {
                        viewModel.days = self.databaseManager.fetchWorkoutDaysByProgramId(id: self.programsID)
                    })
                    .listStyle(PlainListStyle())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            if showPrompt {
                AddDayPrompt(show: $showPrompt, id: programsID)
            }
        }
        .padding(.horizontal)
        .background(showPrompt ? Color.gray.opacity(0.5) : Color.white)
    }
}

