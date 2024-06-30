import SwiftUI

struct TwitterUploadView: View {
    @StateObject private var twitterUploadFormData = TwitterUploadFormData(filename: "", location: .splatoon, url: "")
    @State private var shouldPaddingBeApplied = false
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            TwitterUploadForm(shouldPaddingBeApplied: $shouldPaddingBeApplied)
                .environmentObject(twitterUploadFormData)
            
            LargeButton(labelText: "Upload") {
                Task {
                    
                }
            }
                .padding(.horizontal, 24)
                .disabled(twitterUploadFormData.url.isEmpty || twitterUploadFormData.filename.isEmpty || twitterUploadFormData.url.wholeMatch(of: /https?:\/\/(?:www\.)?(?:twitter|x)\.com\/[A-Za-z0-9_]{1,}\/status\/\d+(?:\?.*)?/) == nil)
        }
    }
}

#Preview {
    TwitterUploadView()
}
