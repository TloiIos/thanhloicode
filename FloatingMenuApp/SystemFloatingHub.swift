import SwiftUI

struct SystemFloatingHub: View {
    @State private var isMenuOpen = false
    @State private var isGameConnected = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Nút tròn ở góc phải
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            print("🟢 Button tapped!")
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                isMenuOpen.toggle()
                            }
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
                        .padding(.trailing, 20)
                        .padding(.top, 60)
                    }
                    Spacer()
                }
                
                // Menu khi mở
                if isMenuOpen {
                    // Overlay background để đóng menu
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isMenuOpen = false
                            }
                        }
                    
                    // Menu
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            FloatingMenu(isOpen: $isMenuOpen, isGameConnected: $isGameConnected)
                                .frame(width: 300)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(red: 0.06, green: 0.06, blue: 0.10).opacity(0.98))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                )
                                .shadow(color: .black.opacity(0.6), radius: 30, y: 15)
                                .padding(.trailing, 20)
                                .padding(.top, 120)
                            Spacer()
                        }
                        Spacer()
                    }
                    .transition(.scale(scale: 0.8).combined(with: .opacity))
                    .zIndex(999)
                }
            }
        }
        .ignoresSafeArea()
        .background(Color.clear)
        .onAppear {
            print("🟢 SystemFloatingHub appeared on game!")
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                isGameConnected = EspManager.isGameConnected()
            }
        }
    }
}
