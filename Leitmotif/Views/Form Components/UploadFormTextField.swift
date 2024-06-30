import SwiftUI
import GameController

struct UploadFormTextField: View {
    @EnvironmentObject var uploadFormData: UploadFormData
    @State private var keyboardType = UIKeyboardType.asciiCapable
    @State private var textContentType: UITextContentType? = nil
    var label: String
    @Binding var value: String
    @Binding var shouldPaddingBeApplied: Bool
    @FocusState private var isNameInputFocused: Bool // Used to add padding to the view when the keyboard is visible
    
    var body: some View {
        VStack {
            LabeledContent {
                TextField("", text: $value)
                    .multilineTextAlignment(.trailing)
                    .font(Font.custom("UrbanistRoman-Medium", size: 16, relativeTo: .body))
                    .foregroundStyle(Color(UIColor.label).opacity(0.4))
                    .keyboardType(keyboardType)
                    .textContentType(textContentType)
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
                Text(label)
                    .font(Font.custom("UrbanistRoman-SemiBold", size: 17, relativeTo: .body))
            }
            .padding(.bottom, 8)
            .padding(.horizontal, 24)
            
            Divider()
                .padding(.leading, 24)
        }
    }
    
    func keyboardType(_ type: UIKeyboardType) -> some View {
        self.keyboardType = keyboardType
        return self
    }
    
    func textContentType(_ textContentType: Optional<UITextContentType>) -> some View {
        self.textContentType = textContentType
        
        return self
    }
}

struct UploadFormTextField_Preview: PreviewProvider {
    struct UploadFormTextFieldPreviewContainer: View {
        @StateObject var formData = UploadFormData(filename: "", location: .splatoon)
        
        var body: some View {
            UploadFormTextField(label: "File Name", value: $formData.filename, shouldPaddingBeApplied: .constant(false))
                .environmentObject(formData)
        }
    }
    
    static var previews: some View {
        UploadFormTextFieldPreviewContainer()
    }
}
