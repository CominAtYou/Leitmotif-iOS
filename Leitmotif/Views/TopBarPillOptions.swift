import SwiftUI

struct TopBarPillOptions: View {
    @Environment(\.isEnabled) private var isEnabled
    @EnvironmentObject private var configurationStateController: ConfigurationStateController
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Options")
                .font(Font.custom("UrbanistRoman-SemiBold", size: 12, relativeTo: .caption))
                .opacity(0.3)
            VStack(spacing: 10) {
                LabeledContent {
                    Menu {
                        Picker(selection: $configurationStateController.networkMode) {
                            Text("Automatic").tag(NetworkMode.automatic)
                            Text("Local").tag(NetworkMode.local)
                            Text("External").tag(NetworkMode.wan)
                        } label: {}
                    } label: {
                        HStack(alignment: .center, spacing: 6) {
                            Text(configurationStateController.networkMode.rawValue)
                                .font(Font.custom("UrbanistRoman-Medium", size: 16, relativeTo: .body))
                                .foregroundStyle(Color(UIColor.label).opacity(0.4))
                            Image(systemName: "chevron.up.chevron.down")
                                .font(Font.system(size: 12, weight: .medium))
                                .foregroundStyle(Color(UIColor.label).opacity(0.4))
                        }
                    }
                } label: {
                    Text("Location")
                        .font(Font.custom("UrbanistRoman-SemiBold", size: 17, relativeTo: .body))
                        .foregroundStyle(Color(UIColor.label))
                }
                HStack {
                    Text("Upload Locations")
                        .font(Font.custom("UrbanistRoman-Semibold", size: 16, relativeTo: .body))
                        .opacity(isEnabled ? 1 : 0.4)
                    Spacer()
                    Text("Tap to refresh")
                        .font(Font.custom("UrbanistRoman-Medium", size: 16, relativeTo: .body))
                        .opacity(isEnabled ? 0.4 : 0.2)
                }
            }
        }
        .padding(.bottom, 8)
    }
}

enum NetworkMode: String {
    case automatic = "Automatic"
    case local = "Local"
    case wan = "External"
}

#Preview {
    TopBarPillOptions()
        .environmentObject(ConfigurationStateController(networkMode: .automatic))
}
