import SwiftUI

struct FileUploadViewBottomForm: View {
    @EnvironmentObject var fileUploadFormData: FileUploadFormData
    @State private var shouldPaddingBeApplied = false
    var body: some View {
        VStack(spacing: 12) {
            UploadForm(shouldPaddingBeApplied: $shouldPaddingBeApplied)
                .environmentObject(fileUploadFormData as UploadFormData)
            FileUploadViewBottomButtons(shouldPaddingBeApplied: $shouldPaddingBeApplied)
        }
    }
}

#Preview {
    FileUploadViewBottomForm()
        .environmentObject(FileUploadFormData(filename: "", location: .splatoon))
}
