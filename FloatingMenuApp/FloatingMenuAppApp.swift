import SwiftUI

@main
struct FloatingMenuAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Hiển thị overlay window
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            OverlayWindow.shared.show()
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Giữ overlay khi app background
        OverlayWindow.shared.show()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        OverlayWindow.shared.show()
    }
}
