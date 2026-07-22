import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 0.1, green: 0.05, blue: 0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("🎮 ESP & Aimbot")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Nút tròn sẽ xuất hiện ở góc phải")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("👉 Nếu không thấy, kiểm tra console log")
                    .font(.caption)
                    .foregroundColor(.yellow)
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            print("📱 ContentView appeared")
        }
    }
}
