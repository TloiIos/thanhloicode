import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.05, blue: 0.12), Color(red: 0.12, green: 0.08, blue: 0.20)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "circle.grid.2x2.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(.white.opacity(0.85))
                Text("Floating Menu Demo")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Text("Chạm vào nút tròn để mở/đóng menu nổi.\nCó thể kéo nút đi khắp màn hình.")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(.horizontal, 40)
            }

            FloatingBubbleOverlay()
        }
    }
}

#Preview {
    ContentView()
}
