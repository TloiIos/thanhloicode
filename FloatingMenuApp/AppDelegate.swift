import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var overlayWindow: OverlayWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("🚀 App started")
        
        // KHÔNG tạo window chính, chỉ tạo overlay window
        // Overlay sẽ hiển thị trên game
        
        // Tạo overlay window ngay lập tức
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.overlayWindow = OverlayWindow.shared
            self.overlayWindow?.show()
            
            print("✅ Overlay window created and shown")
            
            // In ra tất cả windows để debug
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                print("📱 All windows:")
                for (index, win) in UIApplication.shared.windows.enumerated() {
                    print("  [\(index)] \(type(of: win)) - hidden: \(win.isHidden), level: \(win.windowLevel.rawValue)")
                }
            }
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("App became active")
        overlayWindow?.show()
    }
}
