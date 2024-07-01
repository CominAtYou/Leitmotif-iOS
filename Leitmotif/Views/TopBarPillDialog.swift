import SwiftUI

struct TopBarPillDialog: View {
    @EnvironmentObject private var topBarStateController: TopBarStateController
    @Binding var pillState: TopBarPillState
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(topBarStateController.dialogTitle)
                    .font(Font.custom("UrbanistRoman-SemiBold", size: 17, relativeTo: .title2))
                Text(topBarStateController.dialogMessage)
                    .font(Font.custom("UrbanistRoman-Medium", size: 14, relativeTo: .title2))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                withAnimation(.bouncy(duration: 0.5)) {
                    pillState = .standard
                }
            } label: {
                Text("OK")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }

            .font(Font.custom("UrbanistRoman-SemiBold", size: 16))
            .foregroundStyle(Color(uiColor: UIColor.label))
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
        }
    }
}

struct TopBarPillDialog_Previews: PreviewProvider {
    struct TopBarPillDialogPreviewView: View {
        @StateObject private var topBarStateController = TopBarStateController.previewObject(position: 0)
        @State private var pillState = TopBarPillState.expandedShowingDialog
        
        var body: some View {
            TopBarPillDialog(pillState: $pillState)
                .environmentObject(topBarStateController)
                .onAppear {
                    topBarStateController.dialogTitle = "Unable to Retrieve Tweet"
                    topBarStateController.dialogMessage = "The tweet provided is from a protected account."
                }
        }
    }
    
    static var previews: some View {
        TopBarPillDialogPreviewView()
            .padding()
    }
}
