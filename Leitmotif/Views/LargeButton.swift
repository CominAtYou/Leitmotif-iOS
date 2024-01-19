import SwiftUI

struct LargeButton: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled
    var labelText: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Text(labelText)
                .font(Font.custom("UrbanistRoman-Medium", size: 17, relativeTo: .body))
                .foregroundColor(Color(UIColor.label).opacity(isEnabled ? 1 : 0.2))
                .font(.headline)
                .fontWeight(.semibold)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : .white)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 5)
        })
    }
}

#Preview {
    LargeButton(labelText: "Upload") {}
}
