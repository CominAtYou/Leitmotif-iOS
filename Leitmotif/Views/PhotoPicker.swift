import SwiftUI
import PhotosUI
import UIKit
import UniformTypeIdentifiers
import AVFoundation

//struct PhotoPicker: UIViewControllerRepresentable {
//    @Binding var isPresented: Bool
//    @Binding var selectedItem: URL?
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = .photoLibrary
//        picker.mediaTypes = [UTType.image.identifier, UTType.movie.identifier]
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        var parent: PhotoPicker
//
//        init(_ parent: PhotoPicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            if let imageURL = info[.imageURL] as? URL {
//                parent.selectedItem = imageURL
//            } else if let videoURL = info[.mediaURL] as? URL {
//                parent.selectedItem = videoURL
//            }
//            parent.isPresented = false
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            parent.isPresented = false
//        }
//    }
//}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selectedItem: URL?     
    let completionHandler: () -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.videoQuality = .typeHigh
        picker.allowsEditing = false
        picker.videoExportPreset = AVAssetExportPresetPassthrough
        picker.mediaTypes = [UTType.image.identifier, UTType.movie.identifier]
        picker.delegate = context.coordinator

        // Configure for iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            picker.modalPresentationStyle = .popover
            picker.popoverPresentationController?.sourceView = context.coordinator.rootView
            picker.popoverPresentationController?.sourceRect = CGRectNull
        }

        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: PhotoPicker
        var rootView: UIView?

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let imageURL = info[.imageURL] as? URL {
                parent.selectedItem = imageURL
            } else if let videoURL = info[.mediaURL] as? URL {
                parent.selectedItem = videoURL
            }
            parent.isPresented = false
            parent.completionHandler()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }

        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.isPresented = false
        }
    }
    
}

#Preview {
    PhotoPicker(isPresented: .constant(true), selectedItem: .constant(nil)) {}
        .ignoresSafeArea(.all)
}
