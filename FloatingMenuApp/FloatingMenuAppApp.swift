// FloatingMenuAppApp.swift - GIỮ LẠI FILE NÀY
import SwiftUI

@main
struct FloatingMenuAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        OverlayWindow.shared.show()
                    }
                }
        }
    }
}

// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Hiển thị overlay window sau khi app khởi động
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            OverlayWindow.shared.show()
            print("✅ OverlayWindow shown from AppDelegate")
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Giữ overlay khi app background
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            OverlayWindow.shared.show()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Hiển thị lại overlay khi app active
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            OverlayWindow.shared.show()
            print("✅ OverlayWindow shown - App became active")
        }
    }
}
