import SwiftUI
import UIKit

struct SystemFloatingHub: View {
    @State private var position: CGPoint = CGPoint(x: UIScreen.main.bounds.width - 70, y: 120)
    @State private var isDragging = false
    @State private var isMenuOpen = false
    @State private var dragOffset: CGSize = .zero
    @State private var isGameConnected = false
    @State private var isEspEnabled = false
    @State private var isAimbotEnabled = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Nút Hub
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isMenuOpen.toggle()
                    }
                }) {
                    ZStack {
                        // Background với hiệu ứng glow
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.1, green: 0.5, blue: 0.9),
                                        Color(red: 0.3, green: 0.6, blue: 1.0)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                            .shadow(color: .blue.opacity(0.5), radius: 15)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                        
                        // Icon
                        Image(systemName: "scope")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        // Trạng thái kết nối game
                        Circle()
                            .fill(isGameConnected ? Color.green : Color.red)
                            .frame(width: 12, height: 12)
                            .offset(x: 22, y: -22)
                            .shadow(color: isGameConnected ? .green.opacity(0.6) : .red.opacity(0.6), radius: 4)
                    }
                }
                .position(x: position.x + dragOffset.width,
                         y: position.y + dragOffset.height)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            isDragging = false
                            let newX = position.x + value.translation.width
                            let newY = position.y + value.translation.height
                            
                            position = CGPoint(
                                x: min(max(newX, 35), screenWidth - 35),
                                y: min(max(newY, 90), screenHeight - 90)
                            )
                            dragOffset = .zero
                            
                            // Lưu vị trí
                            UserDefaults.standard.set(position.x, forKey: "hubPositionX")
                            UserDefaults.standard.set(position.y, forKey: "hubPositionY")
                        }
                )
                .onAppear {
                    // Khôi phục vị trí
                    if let x = UserDefaults.standard.object(forKey: "hubPositionX") as? CGFloat,
                       let y = UserDefaults.standard.object(forKey: "hubPositionY") as? CGFloat {
                        position = CGPoint(x: x, y: y)
                    }
                    
                    // Cập nhật trạng thái mỗi giây
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        isGameConnected = EspManager.isGameConnected()
                        isEspEnabled = EspManager.isEspEnabled()
                        isAimbotEnabled = EspManager.isAimbotEnabled()
                    }
                }
                
                // Menu
                if isMenuOpen {
                    FloatingMenu(isOpen: $isMenuOpen, isGameConnected: $isGameConnected)
                        .position(x: position.x + dragOffset.width + 145,
                                 y: position.y + dragOffset.height)
                        .transition(.scale(scale: 0.8).combined(with: .opacity))
                }
            }
        }
        .ignoresSafeArea()
    }
}
