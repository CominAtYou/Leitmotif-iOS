import SwiftUI
import Foundation

struct FileUploadView: View {
    @EnvironmentObject private var topBarStateController: TopBarStateController
    @StateObject private var fileUploadFormData = FileUploadFormData(filename: "", location: .splatoon)
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                FileUploadViewBottomForm()
                    .environmentObject(fileUploadFormData)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                fileUploadFormData.backgroundImage?
                .resizable()
                .scaledToFill()
                .blur(radius: 5)
                .scaleEffect(1.05) // remove white glow from top and bottom of image
                .frame(minWidth: geometry.size.width, maxWidth: geometry.size.width)
                .clipped()
                .ignoresSafeArea(.all),
                alignment: .center)
            .onChange(of: topBarStateController.selectedButton) {
                if topBarStateController.selectedButton == 0 {
                    withAnimation(.linear(duration: 0.25)) {
                        topBarStateController.isImageOverlayed = fileUploadFormData.backgroundImage != nil
                    }
                }
            }
        }
    }
}

#Preview {
    FileUploadView()
        .environmentObject(TopBarStateController.previewObject(position: 0))
}
