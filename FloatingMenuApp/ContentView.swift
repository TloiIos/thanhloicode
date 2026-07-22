import SwiftUI

struct ContentView: View {
    @State private var isOverlayShowing = true
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.12),
                    Color(red: 0.12, green: 0.08, blue: 0.20)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Logo
                Image(systemName: "scope")
                    .font(.system(size: 70))
                    .foregroundColor(.white.opacity(0.15))
                    .padding(.bottom, 4)
                
                Text("ESP & Aimbot")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Text("System-wide Floating Hub")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.5))
                
                // Status
                VStack(spacing: 8) {
                    StatusRow(label: "ESP", isOn: EspManager.isEspEnabled())
                    StatusRow(label: "Aimbot", isOn: EspManager.isAimbotEnabled())
                    StatusRow(label: "Game", isOn: EspManager.isGameConnected())
                }
                .padding(.top, 12)
                
                // Info
                Text("💡 Nút tròn sẽ hiển thị trên tất cả app\nKéo thả để di chuyển")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.top, 20)
            }
            .padding(.top, -40)
        }
        .onAppear {
            EspManager.setupESP()
            // Hiển thị overlay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                OverlayWindow.shared.show()
            }
        }
    }
}

struct StatusRow: View {
    let label: String
    let isOn: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(isOn ? Color.green : Color.red)
                .frame(width: 8, height: 8)
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
            Text(isOn ? "✅ Active" : "⏳ Inactive")
                .font(.system(size: 12))
                .foregroundColor(isOn ? .green.opacity(0.7) : .red.opacity(0.7))
        }
    }
}
