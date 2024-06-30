import SwiftUI

struct TwitterUploadBottomForm: View {
    @EnvironmentObject var twitterUploadFormData: TwitterUploadFormData
    @Binding var shouldPaddingBeApplied: Bool
    var body: some View {
        VStack(spacing: 12) {
            TwitterUploadForm(shouldPaddingBeApplied: $shouldPaddingBeApplied)
                .environmentObject(twitterUploadFormData as UploadFormData)
        }
    }
}

#Preview {
    TwitterUploadBottomForm(shouldPaddingBeApplied: .constant(false))
        .environmentObject(TwitterUploadFormData(filename: "", location: .splatoon, url: ""))
}
