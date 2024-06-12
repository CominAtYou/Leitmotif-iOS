import SwiftUI
import GameController

struct UploadFormNameField: View {
    @EnvironmentObject var uploadFormData: UploadFormData
    @Binding var shouldPaddingBeApplied: Bool
    @FocusState private var isNameInputFocused: Bool // Used to add padding to the view when the keyboard is visible
    
    var body: some View {
        LabeledContent {
            TextField("", text: $uploadFormData.fileName)
                .multilineTextAlignment(.trailing)
                .font(Font.custom("UrbanistRoman-Medium", size: 16, relativeTo: .body))
                .foregroundStyle(Color(UIColor.label).opacity(0.4))
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .focused($isNameInputFocused)
                .submitLabel(.done)
                .onChange(of: isNameInputFocused) {
                    withAnimation {
                        #if !targetEnvironment(simulator)
                        shouldPaddingBeApplied = isNameInputFocused && GCKeyboard.coalesced == nil
                        #endif
                    }
                }
        } label: {
            Text("File Name")
                .font(Font.custom("UrbanistRoman-SemiBold", size: 17, relativeTo: .body))
        }
        .padding(.bottom, 8)
        .padding(.horizontal, 24)
        
        Divider()
            .padding(.leading, 24)
    }
}

#Preview {
    UploadFormNameField(shouldPaddingBeApplied: .constant(false))
        .environmentObject(UploadFormData(fileName: "", selectedLocation: .splatoon))
}
