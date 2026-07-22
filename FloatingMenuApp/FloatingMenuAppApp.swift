import SwiftUI

@main
struct FloatingMenuAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    print("📱 ContentView appeared")
                    
                    // Hiển thị overlay sau 0.5 giây
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        OverlayWindow.shared.show()
                        
                        // Debug thêm: Kiểm tra cửa sổ
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            let windows = UIApplication.shared.windows
                            print("📱 Total windows: \(windows.count)")
                            for (index, window) in windows.enumerated() {
                                print("  Window \(index): \(type(of: window)) - hidden: \(window.isHidden)")
                                if let overlay = window as? OverlayWindow {
                                    print("  ✅ Found OverlayWindow at index \(index)")
                                }
                            }
                        }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        OverlayWindow.shared.show()
                    }
                }
        }
    }
}
