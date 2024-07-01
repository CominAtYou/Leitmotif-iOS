import SwiftUI
import Foundation
import PhotosUI

struct PhotoUploadView: View {
    @EnvironmentObject private var topBarStateController: TopBarStateController
    @StateObject private var photoUploadFormData = PhotoUploadFormData(filename: "", location: .splatoon)
    
    @State private var backgroundImageData: PhotosPickerContentTransferrable?
    @State private var isPhotoPickerVisible = false
    @State private var selectedItem: URL?
    @State private var fileExtension: String?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                PhotoUploadViewBottomForm(backgroundImageData: $backgroundImageData)
                    .environmentObject(photoUploadFormData)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                backgroundImageData?.backgroundImage?
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 5)
                    .scaleEffect(1.05) // remove white glow from top and bottom of image
                    .frame(minWidth: geometry.size.width, maxWidth: geometry.size.width)
                    .clipped()
                    .ignoresSafeArea(.all), 
                alignment: .center)
        }
        .onChange(of: topBarStateController.selectedButton) {
            if topBarStateController.selectedButton == 1 {
                withAnimation(.linear(duration: 0.25)) {
                    topBarStateController.isImageOverlayed = backgroundImageData?.backgroundImage != nil
                }
            }
        }
    }
}
                
#Preview {
    PhotoUploadView()
        .environmentObject(UploadFormData(filename: "", location: .splatoon))
        .environmentObject(TopBarStateController(state: .inactive, statusText: "", selectedButton: 1))
}
