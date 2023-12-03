//
//  NewWorkoutView.swift
//  GymTracker
//
//  Created by Anwar Haredy on 19/05/1445 AH.
//

import SwiftUI

struct NewWorkoutView: View {
    @State private var showBottomSheet = false
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
            if showBottomSheet {
                            BottomSheetView()
                        }
            
        }
        .background(Color.white)
        .onTapGesture {
            print("hi")
            self.showBottomSheet.toggle()
                }
    }
    
    struct BottomSheetView: View {
        var body: some View {
            VStack {
                Spacer() // Pushes the content to the bottom
                Rectangle()
                    .fill(Color.white)
                    .frame(height: UIScreen.main.bounds.height * 0.95)
                    .cornerRadius(15)
                    .shadow(radius: 10)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    func handleNewDayClick() {
        print("hello")
    }
}

#Preview {
    NewWorkoutView()
}
