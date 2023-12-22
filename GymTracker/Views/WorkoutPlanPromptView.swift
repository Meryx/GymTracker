////
////  WorkoutPlanPromptView.swift
////  GymTracker
////
////  Created by Anwar Haredy on 05/06/1445 AH.
////
//
//import SwiftUI
//
//struct WorkoutPlanPromptView: View {
//    @State var name: String = ""
//    @ObservedObject var viewModel: WorkoutPlanViewModel
//    var body: some View {
//        VStack {
//            HStack {
//                Text("Name:")
//                    .frame(alignment: .leading)
//                TextField("e.g. Starting Strength", text: $name)
//                    .textFieldStyle(.roundedBorder)
//                    .font(.callout)
//                    .frame(width: 200)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            Button (action: {
//                viewModel.hidePrompt()
//                viewModel.addItem(name: name)
//            }) {
//                Text("Ok")
//                    .frame(maxWidth: .infinity)
//                    .fontWeight(.bold)
//            }
//            .buttonStyle(.bordered)
//            Button (action: {
//                viewModel.hidePrompt()
//            }) {
//                Text("Cancel")
//                    .frame(maxWidth: .infinity)
//                    .fontWeight(.bold)
//            }
//            .buttonStyle(.bordered)
//        }
//        .frame(height: 150, alignment: .topLeading)
//        .cornerRadius(15)
//    }
//}
