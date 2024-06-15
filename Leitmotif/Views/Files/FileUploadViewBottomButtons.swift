import SwiftUI

struct FileUploadViewBottomButtons: View {
    @EnvironmentObject var fileUploadFormData: FileUploadFormData
    @EnvironmentObject var topBarStateController: TopBarStateController
    @State private var isFileImporterPresented = false
    @Binding var shouldPaddingBeApplied: Bool
    var body: some View {
        VStack {
            HStack {
                LargeButton(labelText: fileUploadFormData.selectedFile == nil ? "Select File" : "Change File") {
                    isFileImporterPresented = true
                }
                if fileUploadFormData.selectedFile != nil {
                    LargeButton(labelText: "Upload") {
                        Task {
                            try await uploadFile()
                        }
                    }
                    .disabled(fileUploadFormData.filename.isEmpty)
                } // hello!
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, shouldPaddingBeApplied ? 12 : 0)
        .fileImporter(isPresented: $isFileImporterPresented, allowedContentTypes: [.image, .movie]) { result in
            Task {
                await loadFile(result)
            }
        }
    }
}

#Preview {
    FileUploadViewBottomButtons(shouldPaddingBeApplied: .constant(false))
        .environmentObject(FileUploadFormData(filename: "", location: .splatoon))
        .environmentObject(TopBarStateController.previewObject(position: 0))
}
