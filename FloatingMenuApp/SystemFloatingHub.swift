import SwiftUI

struct SystemFloatingHub: View {
    @State private var isMenuOpen = false
    @State private var isGameConnected = false
    
    var body: some View {
        VStack {
            // Nút tròn - Đặt ở góc phải màn hình
            Button(action: {
                print("🟢 Button tapped!")
                isMenuOpen.toggle()
            }) {
                ZStack {
                    // Vòng tròn nổi
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.blue, Color.purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 65, height: 65)
                        .shadow(color: .blue.opacity(0.5), radius: 15)
                    
                    // Icon
                    Image(systemName: "scope")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Badge trạng thái
                    Circle()
                        .fill(isGameConnected ? Color.green : Color.red)
                        .frame(width: 14, height: 14)
                        .offset(x: 24, y: -24)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 14, height: 14)
                                .offset(x: 24, y: -24)
                        )
                }
            }
            .padding(.top, 60) // Đặt cách top 60px
            .padding(.trailing, 20) // Đặt cách phải 20px
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            
            Spacer()
        }
        .background(Color.clear)
        .onAppear {
            print("🟢✅ SystemFloatingHub appeared!")
            
            // Update trạng thái game
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                isGameConnected = EspManager.isGameConnected()
            }
        }
    }
}
