import SwiftUI
import Foundation

struct FileUploadView: View {
    // TODO: move this higher up in the view hiearchy (probably to ContentView) so it doesn't get nuked whenever the selected view changes
    @StateObject private var fileUploadFormData = FileUploadFormData(filename: "", location: .splatoon)
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                FileUploadViewBottomForm()
                    .environmentObject(fileUploadFormData)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Background(geometry), alignment: .center)
        }
    }
    
    @ViewBuilder
    func Background(_ geometry: GeometryProxy) -> some View {
        fileUploadFormData.backgroundImage?
            .resizable()
            .scaledToFill()
            .blur(radius: 5)
            .scaleEffect(1.05) // remove white glow from top and bottom of image
            .frame(minWidth: geometry.size.width, maxWidth: geometry.size.width)
            .ignoresSafeArea(.all)
    }
}

class FileUploadFormData: UploadFormData {
    @Published var selectedFile: URL? = nil
    // This will only be non-nil if the file is an image – the background image data will be stored here so we don't have to read the file twice
    @Published var fileData: Data? = nil
    @Published var backgroundImage: Image? = nil
}

#Preview {
    FileUploadView()
}
