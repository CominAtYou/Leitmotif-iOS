import SwiftUI

struct UploadForm: View {
    @Binding var shouldPaddingBeApplied: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            VStack {
                UploadFormTextField(label: "File Name", shouldPaddingBeApplied: $shouldPaddingBeApplied)
                UploadFormLocationPicker()
            }
            .padding(.vertical, 18)
            .background(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : .white)
            .clipShape(RoundedRectangle(cornerRadius: 26))
            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 5)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    UploadForm(shouldPaddingBeApplied: .constant(false))
        .environmentObject(UploadFormData(filename: "", location: .splatoon))
}
