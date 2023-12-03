import SwiftUI

struct InputView: View {
    @Binding var titles: [String]
    @State private var inputTitle: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter title", text: $inputTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("OK") {
                if !inputTitle.isEmpty {
                    titles.append(inputTitle)
                }
                presentationMode.wrappedValue.dismiss()
            }

            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding()
    }
}
