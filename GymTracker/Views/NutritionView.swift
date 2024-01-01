//
//  NutritionView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 19/06/1445 AH.
//

import SwiftUI

struct ProgressBar: View {
    var value: Double

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .frame(width: geometry.size.width * CGFloat(min(self.value, 1.0)), height: geometry.size.height)
                .foregroundColor(self.barColor)
                .cornerRadius(geometry.size.height / 2)
                .animation(.linear, value: value)
        }
    }

    private var barColor: Color {
        if value < 1 {
            // Interpolate color between green and yellow based on progress
            let progress = CGFloat(value)
            return Color(red: progress, green: 1.0, blue: 0)
        } else {
            // Progress exceeds limit, turn red
            return Color.red
        }
    }
}

struct AddCaloriesPrompt: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var viewModel: ProgramListViewModel
    @State var name: String = ""
    @Binding var show: Bool
    @State var myVar = ""
    var onMutation: (Double) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Amount:")
                    .frame(alignment: .leading)
                TextField("e.g. 250", text: self.$name)
                    .textFieldStyle(.roundedBorder)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .horizontal])
            Button (action: {
                onMutation(Double(name)!)
                self.show = false

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


struct NutritionView: View {
    @State private var currentCalories: Double = 0
    @State private var currentProtein: Double = 0
    @State private var maxCalories: Double = 2000
    @State private var targetProtein: Double = 160
    @State private var showPrompt = false
    @State private var showSetPrompt = false
    @State private var showProteinPrompt = false
    @State private var showProteinSetPrompt = false
    
    func addCalories(_ calories: Double) {
            currentCalories = currentCalories + calories
        }
    
    func setCalories(_ calories: Double) {
            maxCalories = calories
        }
    
    func addProtein(_ calories: Double) {
            currentProtein = currentProtein + calories
        }
    
    func setProtein(_ calories: Double) {
        targetProtein = calories
        }
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Calories")
                        .frame(alignment: .leading)
                        .foregroundColor(.white)
                    GeometryReader { geometry in

                            Text(String(Int(currentCalories)))
                            .fontWeight(.bold)
                            .animation(.linear, value: currentCalories/maxCalories)
                            .frame(width: geometry.size.width * (currentCalories/maxCalories) < 50 ? 50 : min(geometry.size.width, geometry.size.width * CGFloat(currentCalories/maxCalories)), alignment: .trailing)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: 20)
                    
                }
                HStack {
                    Text("Calories")

                                // Displaying the progress bar
                                ProgressBar(value: currentCalories / maxCalories)
                                    .frame(height: 20)

                                // Add buttons or inputs to update `currentCalories`
                                // For example, a button to simulate calorie consumption
                                
                            
                }
                HStack {
                    Button(action: {
                        showSetPrompt = true
                    }, label: {
                        Text("Set Daily Calories")
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.borderedProminent)
                    Button(action: {
                        showPrompt = true
                    }, label: {
                        Text("Add Calories")
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.borderedProminent)
                }
                HStack {
                    Text("Protein  ")
                        .frame(alignment: .leading)
                        .foregroundColor(.white)
                    GeometryReader { geometry in

                            Text(String(Int(currentProtein)))
                            .fontWeight(.bold)
                            .animation(.linear, value: currentProtein/targetProtein)
                            .frame(width: geometry.size.width * (currentProtein/targetProtein) < 50 ? 50 : min(geometry.size.width, geometry.size.width * CGFloat(currentProtein/targetProtein)), alignment: .trailing)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: 20)
                    
                }
                HStack {
                    Text("Protein  ")

                                // Displaying the progress bar
                                ProgressBar(value: currentProtein / targetProtein)
                                    .frame(height: 20)

                                // Add buttons or inputs to update `currentCalories`
                                // For example, a button to simulate calorie consumption
                                
                            
                }
                HStack {
                    Button(action: {
                        showProteinSetPrompt = true
                    }, label: {
                        Text("Set Daily Protein")
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.borderedProminent)
                    Button(action: {
                        showProteinPrompt = true
                    }, label: {
                        Text("Add Protein")
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.borderedProminent)
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
            
            if showPrompt {
                AddCaloriesPrompt(show: $showPrompt, onMutation: addCalories)
            }
            
            if showSetPrompt {
                AddCaloriesPrompt(show: $showSetPrompt, onMutation: setCalories)
            }
            
            if showProteinPrompt {
                AddCaloriesPrompt(show: $showProteinPrompt, onMutation: addProtein)
            }
            
            if showProteinSetPrompt {
                AddCaloriesPrompt(show: $showProteinSetPrompt, onMutation: setProtein)
            }
            
            
        }
    }
}

#Preview {
    NutritionView()
}
