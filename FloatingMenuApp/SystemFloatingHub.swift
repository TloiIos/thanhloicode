import SwiftUI

struct SystemFloatingHub: View {
    @State private var isMenuOpen = false
    @State private var isGameConnected = false
    @State private var menuPosition: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Nút tròn
                Button(action: {
                    print("🟢 Button tapped! isMenuOpen: \(isMenuOpen)")
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isMenuOpen.toggle()
                    }
                    print("🟢 After toggle: isMenuOpen: \(isMenuOpen)")
                }) {
                    ZStack {
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
                        
                        Image(systemName: "scope")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
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
                .padding(.top, 60)
                .padding(.trailing, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                
                // Menu - Hiển thị khi isMenuOpen = true
                if isMenuOpen {
                    // Tạo một view overlay để bắt tap bên ngoài đóng menu
                    Color.black.opacity(0.01)
                        .onTapGesture {
                            withAnimation {
                                isMenuOpen = false
                            }
                        }
                        .edgesIgnoringSafeArea(.all)
                    
                    // Menu content
                    FloatingMenu(isOpen: $isMenuOpen, isGameConnected: $isGameConnected)
                        .frame(width: 280)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.06, green: 0.06, blue: 0.10).opacity(0.96))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                                )
                        )
                        .shadow(color: .black.opacity(0.6), radius: 25, y: 10)
                        .position(x: UIScreen.main.bounds.width - 160, y: 160) // Đặt menu ở vị trí cố định
                        .transition(.scale(scale: 0.8).combined(with: .opacity))
                        .zIndex(999)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            print("🟢✅ SystemFloatingHub appeared!")
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                isGameConnected = EspManager.isGameConnected()
            }
        }
    }
}
