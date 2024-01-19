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
    @State var fileName = ""
    @State private var selectedLocation = UploadLocation.oneshot
    @Binding var backgroundImage: Image?
    @Binding var isImageOverlayed: Bool
    @State private var selectedImage: PhotosPickerItem?
    @FocusState private var isNameInputFocused: Bool // Used to add padding to the view when the keyboard is visible
    
    var body: some View {
        VStack(spacing: 12) {
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
                } label: {
                    Text("File Name")
                        .font(Font.custom("UrbanistRoman-SemiBold", size: 17, relativeTo: .body))
                }
                .padding(.bottom, 8)
                .padding(.horizontal, 24)
                
                Divider()
                    .padding(.leading, 24)
                
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
            .padding(.vertical, 18)
            .background(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : .white)
            .clipShape(RoundedRectangle(cornerRadius: 26))
            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 5)
            
            HStack {
                PhotosPicker(selection: $selectedImage, matching: .any(of: [.images, .videos]), photoLibrary: .shared()) {
                    ActionlessLargeButton(text: backgroundImage != nil ? "Change Photo" : "Select Photo")
                }
                .onChange(of: selectedImage) {
                    Task {
                        selectedImage!.loadTransferable(type: BackgroundImage.self) { result in
                            if let resultImage = try? result.get() {
                                withAnimation {
                                    backgroundImage = resultImage.image
                                }
                                isImageOverlayed = true
                            }
                        }
                    }
                }
                if backgroundImage != nil {
                    LargeButton(labelText: "Upload") {}
                }
            }
            .padding(.horizontal, isImageOverlayed ? 6 : 0)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, isNameInputFocused ? 12 : 0)
    }
}

#Preview {
    PhotoPickerBottomForm(backgroundImage: .constant(nil), isImageOverlayed: .constant(false))
}
