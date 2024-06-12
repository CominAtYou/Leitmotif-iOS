import SwiftUI

struct UploadFormLocationPicker: View {
    @EnvironmentObject private var uploadFormData: UploadFormData
    
    var body: some View {
        LabeledContent {
            Menu {
                Picker(selection: $uploadFormData.selectedLocation) {
                    // TaggedLocations is displayed in reverse order by default for some reason
                    ForEach(taggedLocations.reversed()) { location in
                        Text(location.name).tag(location.tag)
                    }
                } label: {}
            } label: {
                Text(taggedLocations.first(where: { $0.tag == uploadFormData.selectedLocation })!.name)
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
}

#Preview {
    UploadFormLocationPicker()
        .environmentObject(UploadFormData(fileName: "", selectedLocation: .splatoon))
}
