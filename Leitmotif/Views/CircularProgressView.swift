import SwiftUI

struct CircularProgressView: View {
    @Binding var progress: Double
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color(UIColor.secondarySystemFill),
                    lineWidth: 3
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.blue,
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round
                    )
                )
                .rotationEffect(.radians(Double.pi / -2))
        }
        .frame(width: 20, height: 20)
    }
}

#Preview {
    CircularProgressView(progress: .constant(0.2))
}
