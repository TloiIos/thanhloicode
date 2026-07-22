import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var overlayWindow: OverlayWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("🚀 App did finish launching")
        
        // 1. Tạo cửa sổ chính
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIHostingController(rootView: ContentView())
        window?.makeKeyAndVisible()
        print("✅ Main window created")
        
        // 2. Tạo và hiển thị overlay window sau 0.5s
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            print("⏰ Creating overlay window...")
            self?.overlayWindow = OverlayWindow.shared
            self?.overlayWindow?.show()
            
            // Debug: In ra tất cả windows
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                print("📱 All windows after overlay:")
                for (index, win) in UIApplication.shared.windows.enumerated() {
                    print("  Window \(index): \(type(of: win)) - hidden: \(win.isHidden)")
                }
            }
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("▶️ App became active")
        overlayWindow?.show()
    }
}
