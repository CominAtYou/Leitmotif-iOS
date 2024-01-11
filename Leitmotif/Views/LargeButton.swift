import SwiftUI

struct LargeButton: View {
    @Environment(\.isEnabled) var isEnabled
    var labelText: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Text(labelText)
                .foregroundColor(isEnabled ? .white : .gray)
                .font(.headline)
                .fontWeight(.semibold)
                .frame(width: 350, height: 50)
                .background(isEnabled ? .accentColor : Color(UIColor.tertiarySystemFill))
                .cornerRadius(15)
                .padding()
        })
    }
}

#Preview {
    LargeButton(labelText: "Upload") {}
}
