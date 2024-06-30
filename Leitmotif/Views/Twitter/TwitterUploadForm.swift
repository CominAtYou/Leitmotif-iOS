import SwiftUI

struct TwitterUploadForm: View {
    @Binding var shouldPaddingBeApplied: Bool
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var twitterUploadFormData: TwitterUploadFormData

    var body: some View {
        VStack {
            VStack {
                UploadFormTextField(label: "File Name", value: $twitterUploadFormData.filename, shouldPaddingBeApplied: $shouldPaddingBeApplied)
                VStack {
                    UploadFormTextField(label: "Tweet URL", value: $twitterUploadFormData.url, shouldPaddingBeApplied: $shouldPaddingBeApplied)
                        .textContentType(.URL)
                        .keyboardType(.URL)
                }
                .padding(.top, 8)
                UploadFormLocationPicker()
            }
            .environmentObject(twitterUploadFormData as UploadFormData)
            .padding(.vertical, 18)
            .background(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : .white)
            .clipShape(RoundedRectangle(cornerRadius: 26))
            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 5)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    TwitterUploadForm(shouldPaddingBeApplied: .constant(false))
        .environmentObject(TwitterUploadFormData(filename: "", location: .splatoon, url: ""))
}
