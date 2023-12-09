//
//  NewWorkoutView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 19/05/1445 AH.
//

import SwiftUI



struct NewWorkoutView: View {
    @State private var showBottomSheet = false
    @State private var showPrompt = false
    @State private var showList = true
    @ObservedObject var viewModel: ExerciseListModel
    @ObservedObject var viewModel2: ExerciseRowDetailsModel
    
    
    @State private var position: CGFloat = 0.0
    @State private var dimOpacity: Double = 0.0
    
    @State private var name: String = ""
    @State private var sets: String = ""
    @State private var reps: String = ""
    @State private var kg: String = ""

    
    struct prompt: View {
        @Binding var name: String
        @Binding var sets: String
        @Binding var reps: String
        @Binding var kg: String
        @Binding var showPrompt: Bool
        @Binding var showList: Bool
        @ObservedObject var viewModel: ExerciseListModel
        
        func handleOKClick() {
            viewModel.addItem(name: name, sets: Int(sets)!, reps: Int(reps)!, kg: Int(kg)!, setsText: "", repsText: "", kgText: "")
            showPrompt = false
            showList.toggle()
        }
        
        func handleCancelClick() {
            showPrompt = false
            showList.toggle()
        }

        var body: some View {
            VStack (alignment: .leading) {
                HStack {
                    Text("Name")
                        .frame(width: 60, alignment: .leading)
                    TextField("Exercise Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .font(.callout)
                        .padding()
                        .frame(maxWidth: 300)
                        .cornerRadius(40)
                }
                HStack {
                    Text("Sets")
                        .frame(width: 60, alignment: .leading)
                    TextField("Sets", text: $sets)
                        .textFieldStyle(.roundedBorder)
                        .font(.callout)
                        .padding()
                        .frame(maxWidth: 300)
                        .cornerRadius(40)
                }
                HStack {
                    Text("Reps")
                        .frame(width: 60, alignment: .leading)
                    TextField("Reps", text: $reps)
                        .textFieldStyle(.roundedBorder)
                        .font(.callout)
                        .padding()
                        .frame(maxWidth: 300)
                        .cornerRadius(40)
                }
                HStack {
                    Text("Weight")
                        .frame(width: 60, alignment: .leading)
                    TextField("Weight in kg", text: $kg)
                        .textFieldStyle(.roundedBorder)
                        .font(.callout)
                        .padding()
                        .frame(maxWidth: 300)
                        .cornerRadius(40)
                }
                Button (action: handleOKClick) {
                    Text("OK")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                }
                .buttonStyle(.bordered)
                .padding(.top)
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom, 0)
                Button (action: handleCancelClick) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                }
                .buttonStyle(.bordered)
                .padding(.top)
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom, 0)
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .background(.white)
            .cornerRadius(15)
        }
    }
    
    
    
    func handleAddExerciseClick() {
        showPrompt.toggle()
        showList.toggle()
    }
    func handleCancelExerciseClick() {
        dimOpacity = 0
        self.showBottomSheet.toggle()
        showPrompt = false
        showList = true

    }
    func handleSaveWorkoutClick() {
//        viewModel.addItem(name: name, sets: Int(sets)!, reps: Int(reps)!, kg: Int(kg)!)
        print("save")
//        showPrompt = false
//        showList.toggle()

    }
    var body: some View {
        ZStack {
            VStack {
                Button (action: handleNewDayClick) {
                    Text("New Workout Day")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                }
                .buttonStyle(.borderedProminent)
            .padding()
                Spacer()
            }
            .overlay(Color.black.opacity(dimOpacity))
            if showBottomSheet {
                BottomSheetView(handleAddExercise: self.handleAddExerciseClick,
                                toggleShowBottomSheet: self.$showBottomSheet,
                                handleCancelExercise: self.handleCancelExerciseClick,
                                handleSaveWorkout: self.handleSaveWorkoutClick,
                                exercises: self.viewModel,
                                viewModel2: self.viewModel2,
                                positionVar: $position,
                                dimOpacityVar: $dimOpacity,
                                showList: $showList,
                                showPrompt: $showPrompt)

                        }
            if showPrompt {
                prompt(name: $name, sets: $sets, reps: $reps, kg: $kg, showPrompt: $showPrompt, showList: $showList, viewModel: viewModel)
            }
            
        }
        .background(Color.white)

    }
    
    struct BottomSheetHandle: View {
        var body: some View {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 60, height: 5)
                .foregroundColor(.gray)
                .opacity(0.5)
                .padding(.top, 10)
        }
    }
    
    struct BottomSheetView: View {
        let handleAddExercise: () -> Void
        @Binding var toggleShowBottomSheet: Bool
        let handleCancelExercise: () -> Void
        let handleSaveWorkout: () -> Void
        @ObservedObject var exercises: ExerciseListModel
        @ObservedObject var viewModel2: ExerciseRowDetailsModel
        @Binding var positionVar: CGFloat
        @Binding var dimOpacityVar: Double
        @Binding var showList: Bool
        @Binding var showPrompt: Bool
        @State private var rectHeight: CGFloat = 0.75
        @State private var dragOffset = CGSize.zero
        @State private var totalDrag: CGFloat = 0.0

        
        var body: some View {
            VStack {
                Spacer() // Pushes the content to the bottom
                    .background(.red)
                ZStack {
                    Rectangle()
                        .fill(Color.white.opacity(showPrompt ? 0.5 : 1.0))
                    .shadow(radius: 10)
                    VStack {
                        BottomSheetHandle()
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let dragAmount = value.translation.height
                                        totalDrag += dragAmount
                                        if dragAmount > 0 || rectHeight < 0.75 {
                                                                    self.dragOffset.height = totalDrag
                                            rectHeight -= dragAmount / 600
                                                                } else {
                                                                    self.dragOffset.height = 0
                                                                }
                                    }
                                    .onEnded { _ in
                                        totalDrag = 0.0
                                        let referenceViewHeight = UIScreen.main.bounds.height * 0.75
                                        withAnimation {
                                                                    // Check if drag exceeds 50% of the reference view's height
                                                                    if self.dragOffset.height > referenceViewHeight / 3 {
                                                                        rectHeight = 0.15
                                                                        dimOpacityVar = 0.0
                                                                    } else {
                                                                        rectHeight = 0.75
                                                                        dimOpacityVar = 0.5
                                                                    }
                                                                }
                                    }
                            )
//                            .onTapGesture {
//                                rectHeight = rectHeight > 0.20 ? 0.15 : 0.75
//                            }
                        Button (action: handleAddExercise) {
                            Text("+ Add Exercise")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.bold)
                        }
                        .buttonStyle(.bordered)
                        .padding(.top)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom, 0)
                        if showList {
                            ExerciseList(viewModel: exercises, viewModel2: viewModel2)
                        } else {
                            Spacer()
                                .frame(maxHeight: .infinity)
                        }
                        HStack {
                            Button (action: handleSaveWorkout) {
                                Text("Save")
                                    .frame(maxWidth: .infinity)
                                    .fontWeight(.bold)
                                    .frame(height: 35)
                                    
                            }
                            .foregroundColor(.green)
                            .background(.green.opacity(0.2))
                            .cornerRadius(5)

                            Button (action: handleCancelExercise) {
                                Text("Cancel")
                                    .frame(maxWidth: .infinity)
                                    .fontWeight(.bold)
                                    .frame(height: 35)
                            }
                            .foregroundColor(.red)
                            .background(.red.opacity(0.2))
                            .cornerRadius(5)
                        }
                        .padding(.top, 0)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing])
                        
                        Spacer()
                    }
                }
                .frame(height: UIScreen.main.bounds.height * rectHeight)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    func handleNewDayClick() {
        self.showBottomSheet.toggle()
        dimOpacity = 0.5
    }
    
}

#Preview {
    NewWorkoutView(viewModel: ExerciseListModel(), viewModel2: ExerciseRowDetailsModel())
}
