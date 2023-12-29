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
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    func deleteMutation() {
        viewModel.days = self.databaseManager.fetchWorkoutDaysByProgramId(id: self.programsID)
    }
    
    
    var body: some View {
        ZStack {
            VStack {
                Text(name)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if !showPrompt {
                    Button(action: {
                        showPrompt = true
                    }, label: {
                        Text("Tap to Add New Day")
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10) // Set the corner radius
                                    .strokeBorder(Color.gray.opacity(0.5), lineWidth: 1))
                        
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                if !showPrompt {

                    Text("Exercise Days")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.bold)
                        .padding(.top)
                        
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewModel.days.indices, id: \.self)
                            { index in
                                NavigationLink(destination: DayView(name: viewModel.days[index].dayName, dayID: viewModel.days[index].dayId)
        
                                    .onTapGesture {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    })
                                {
                                    DayPane(name: viewModel.days[index].dayName, dayId: viewModel.days[index].dayId, onMutation: deleteMutation)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    .onAppear(perform: {
                        viewModel.days = self.databaseManager.fetchWorkoutDaysByProgramId(id: self.programsID)
                    })
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

