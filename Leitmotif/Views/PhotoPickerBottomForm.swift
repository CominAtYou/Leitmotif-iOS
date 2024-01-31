//
//  BottomForm.swift
//  Leitmotif
//
//  Created by William Martin on 1/11/24.
//

import SwiftUI
import PhotosUI

struct PhotoPickerBottomForm: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var topBarStateController: TopBarStateController
    @State var fileName = ""
    @State private var selectedLocation = UploadLocation.oneshot
    @Binding var backgroundImageData: PhotosPickerContentTransferrable?
    @Binding var isImageOverlayed: Bool
    @State private var selectedImage: PhotosPickerItem?
    @FocusState private var isNameInputFocused: Bool // Used to add padding to the view when the keyboard is visible
    @State private var shouldPaddingBeApplied = false
    
    var body: some View {
        VStack(spacing: 12) {
            // MARK: - File Name
            VStack {
                LabeledContent {
                    TextField("", text: $fileName)
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
                                shouldPaddingBeApplied = isNameInputFocused
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
                
                // MARK: - Picker
                LabeledContent {
                    Menu {
                        Picker(selection: $selectedLocation) {
                            // TaggedLocations is displayed in reverse order by default for some reason
                            ForEach(taggedLocations.reversed()) { location in
                                Text(location.name).tag(location.tag)
                            }
                        } label: {}
                    } label: {
                        Text(taggedLocations.first(where: { $0.tag == selectedLocation })!.name)
                            .font(Font.custom("UrbanistRoman-Medium", size: 17, relativeTo: .body))
                            .foregroundStyle(Color(UIColor.label).opacity(0.4))
                    }
                } label: {
                    Text("Location")
                        .font(Font.custom("UrbanistRoman-SemiBold", size: 17, relativeTo: .body))
                }
                
                .padding(.horizontal, 24)
                .padding(.top, 8)
            }
            // MARK: - Form Body End
            .padding(.vertical, 18)
            .background(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : .white)
            .clipShape(RoundedRectangle(cornerRadius: 26))
            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 5)
            // MARK: - Bottom Buttons
            HStack {
                PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
                    ActionlessLargeButton(text: backgroundImageData != nil ? "Change Photo" : "Select Photo")
                }
                .onChange(of: selectedImage, handleSelectionChange)
                if let backgroundImageData {
                    LargeButton(labelText: "Upload") {
                        Task { await startUpload(backgroundImageData) }
                    }
                }
            }
            .padding(.horizontal, isImageOverlayed ? 6 : 0)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, shouldPaddingBeApplied ? 12 : 0)
    }
    
    func handleSelectionChange() {
        selectedImage!.loadTransferable(type: PhotosPickerContentTransferrable.self) { result in
            if var resultData = try? result.get() {
                let fileExt = selectedImage!.supportedContentTypes.first!.preferredFilenameExtension!
                
                if (fileName.isEmpty) {
                    let nameComponent = UUID().uuidString.split(separator: "-").first!.lowercased()
                    fileName = "\(nameComponent).\(fileExt)"
                }
                else if (fileName.contains(".")) {
                    let nameComponent = fileName.split(separator: ".").first!
                    fileName = "\(nameComponent).\(fileExt)"
                }
                else {
                    fileName += ".\(fileExt)"
                }
                
                resultData.mimeType = selectedImage!.supportedContentTypes.first!.preferredMIMEType
                withAnimation {
                    backgroundImageData = resultData
                    
                }
                isImageOverlayed = true
            }
        }
    }
    
    func startUpload(_ backgroundImageData: PhotosPickerContentTransferrable) async {
        do {
            try await uploadData(fileName: fileName, file: backgroundImageData.imageData!, location: selectedLocation, mime: backgroundImageData.mimeType!, topBarStateController: topBarStateController)
            
            topBarStateController.state = .inactive
            withAnimation {
                topBarStateController.statusText = "Upload Complete!"
            }
        }
        catch UploadError.fileExistsError {
            // TODO: Something
        }
        catch (UploadError.uploadFailure) {
            // TODO: Something
        }
        catch (UploadError.wanQueryFailure) {
            // TODO: something
        }
        catch {
            // TODO: something
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let name = UserDefaults.standard.string(forKey: "lastSeenServerName")!
            withAnimation {
                topBarStateController.statusText = "\(name) | Online"
            }
        }
    }
}

#Preview {
    PhotoPickerBottomForm(backgroundImageData: .constant(nil), isImageOverlayed: .constant(false))
}
