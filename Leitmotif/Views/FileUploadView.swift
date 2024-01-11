import SwiftUI
import Foundation

struct FileUploadView: View {
    @Environment (\.colorScheme) var colorScheme
    @State private var fileName = ""
    @State private var selectedFileName = "Select File"
    @State private var selectedLocation = UploadLocation.oneshot
    @State private var isFileImporterPresented = false
    @State private var selectedFile: URL? = nil
    @State private var isErrorAlertVisible = false
    @State private var progressString = ""
    @State private var progressValue = 0.0
    @State private var areUploadsPaused = false
    @State private var isUploadButtonDisabled = false
    @State private var isUploadInProgress = false
    @State private var alertMessage = ""
    var body: some View {
        VStack {
            Form {
                HStack {
                    LabeledContent {
                        TextField("File Name", text: $fileName)
                            .multilineTextAlignment(.trailing)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.asciiCapable)
                            .disabled(areUploadsPaused)
                        Button {
                            fileName = UUID().uuidString.lowercased().components(separatedBy: "-").first!
                            if selectedFile != nil {
                                fileName += ".\(selectedFile!.pathExtension.lowercased())"
                            }
                        } label: {
                            Image(systemName: "die.face.5")
                        }
                        .disabled(areUploadsPaused)
                    } label: {
                        Text("File Name")
                    }
                }
                LabeledContent {
                    Button {
                        isFileImporterPresented = true
                    } label: {
                        Text(selectedFileName)
                    }
                    .disabled(areUploadsPaused)
                    .fileImporter(isPresented: $isFileImporterPresented, allowedContentTypes: [.image, .movie], allowsMultipleSelection: false) { result in
                        switch result {
                        case .success(let resultUrl):
                            selectedFile = resultUrl[0]
                            selectedFileName = "\(selectedFile!.lastPathComponent.components(separatedBy: ".").first!).\(selectedFile!.pathExtension.lowercased())"
                            fileName = selectedFileName
                        case .failure(let error):
                            NSLog("\(error)")
                        }
                    }
                } label: {
                    Text("File")
                }
                Picker("Location", selection: $selectedLocation) {
                    ForEach(taggedLocations) { location in
                        Text(location.name).tag(location.tag)
                    }
                }
                .disabled(areUploadsPaused)
            }
            
            VStack {
                HStack(spacing: 5) {
                    Text(progressString)
                    if isUploadInProgress {
                        Text("(\(Int(round(progressValue * 100)))%)")
                            .contentTransition(.numericText(countsDown: true))
                    }
                }
                ProgressView(value: progressValue)
                    .opacity(isUploadInProgress ? 1 : 0)
            }
            .padding(.horizontal, 30)
            
            LargeButton(labelText: "Upload") {
                if areUploadsPaused { return }
                areUploadsPaused = true
                
                Task {
                    try! await Task.sleep(for: .seconds(1))
                    isUploadButtonDisabled = true
                    do {
                        try await uploadFile(fileName: fileName, file: selectedFile!, location: selectedLocation, progressCallback: updateProgress)
                        progressString = "Upload complete!"
                        isUploadInProgress = false
                        
                        try! await Task.sleep(for: .seconds(3))
                    
                        fileName = ""
                        selectedFile = nil
                        progressValue = 0.0
                        selectedFileName = "Select File"
                        progressString = ""
                        isUploadButtonDisabled = false
                        areUploadsPaused = false
                    }
                    catch UploadError.fileExistsError {
                        alertMessage = "The file you're trying to upload already exists."
                        isErrorAlertVisible = true
                        resetViewPreservingInput()
                    }
                    catch UploadError.fileAccessError {
                        NSLog("Unable to access file")
                        alertMessage = "Something went wrong when trying to upload the file. Give it another shot, or try again in a bit."
                        isErrorAlertVisible = true
                        resetViewPreservingInput()
                    }
                    catch UploadError.fileReadError {
                        NSLog("Unable to read file")
                        alertMessage = "Something went wrong when trying to upload the file. Give it another shot, or try again in a bit."
                        isErrorAlertVisible = true
                        resetViewPreservingInput()
                    }
                    catch UploadError.wanQueryFailure {
                        NSLog("Unable to query WAN address")
                        alertMessage = "Something went wrong when trying to upload the file. Give it another shot, or try again in a bit."
                        isErrorAlertVisible = true
                        resetViewPreservingInput()
                    }
                    catch UploadError.uploadFailure {
                        NSLog("Failed to upload file")
                        alertMessage = "Something went wrong when trying to upload the file. Give it another shot, or try again in a bit."
                        isErrorAlertVisible = true
                        resetViewPreservingInput()
                    }
                }
            }
            .disabled(fileName.isEmpty || selectedFile == nil || isUploadButtonDisabled)
        }
        .alert(isPresented: $isErrorAlertVisible) {
            Alert(title: Text("Upload Failed"), message: Text(alertMessage))
        }
        .background(Color(colorScheme == .light ? UIColor.secondarySystemBackground : UIColor.systemBackground))
    }
    
    func updateProgress(text: String, progress: Double, isUploading: Bool) {
        isUploadInProgress = isUploading
        withAnimation {
            progressString = text
            progressValue = progress
        }
    }
    
    func resetViewPreservingInput() {
        progressString = ""
        progressValue = 0.0
        isUploadInProgress = false
        isUploadButtonDisabled = false
        areUploadsPaused = false
    }
}

#Preview {
    FileUploadView()
}
