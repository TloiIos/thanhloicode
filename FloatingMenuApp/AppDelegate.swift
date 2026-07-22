import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var overlayWindow: OverlayWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Tạo cửa sổ chính
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIHostingController(rootView: ContentView())
        window?.makeKeyAndVisible()
        
        // Tạo overlay window để hiển thị trên tất cả app
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.overlayWindow = OverlayWindow.shared
            self.overlayWindow?.show()
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        overlayWindow?.show()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        overlayWindow?.show()
    }
}
