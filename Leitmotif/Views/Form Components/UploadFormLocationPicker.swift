import SwiftUI

struct UploadFormLocationPicker: View {
    @EnvironmentObject private var uploadFormData: UploadFormData
    
    var body: some View {
        LabeledContent {
            Menu {
                Picker(selection: $uploadFormData.location) {
                    // TaggedLocations is displayed in reverse order by default for some reason
                    ForEach(taggedLocations.reversed()) { location in
                        Text(location.name).tag(location.tag)
                    }
                } label: {}
            } label: {
                HStack(alignment: .center, spacing: 6) {
                    Text(taggedLocations.first(where: { $0.tag == uploadFormData.location })!.name)
                        .font(Font.custom("UrbanistRoman-Medium", size: 17, relativeTo: .body))
                        .foregroundStyle(Color(UIColor.label).opacity(0.4))
                    Image(systemName: "chevron.up.chevron.down")
                        .font(Font.system(size: 12, weight: .medium))
                        .foregroundStyle(Color(UIColor.label).opacity(0.4))
                }
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
        .environmentObject(UploadFormData(filename: "", location: .splatoon))
}
