import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Start Workout")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding([.top, .leading])
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: handleNewWorkoutClick) {
                        Text("New Workout Plan")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            Spacer()
        }
    }
    func handleNewWorkoutClick() {
            print("Button was tapped")
        }
}

#Preview {
    ContentView()
}
