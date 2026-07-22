import UIKit
import SwiftUI

class OverlayWindow: UIWindow {
    static let shared = OverlayWindow(frame: UIScreen.main.bounds)
    
    private var hostingController: UIHostingController<SystemFloatingHub>?
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        print("🔵 1. Init called")
        setupWindow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWindow() {
        print("🔵 2. Setup window")
        
        // Cấu hình window
        self.backgroundColor = .clear
        self.windowLevel = .alert + 1  // Dùng level cao nhất
        self.isUserInteractionEnabled = true
        self.isHidden = false
        self.alpha = 1.0
        
        // Tạo SwiftUI view
        let hubView = SystemFloatingHub()
        let controller = UIHostingController(rootView: hubView)
        controller.view.backgroundColor = .clear
        controller.view.frame = self.bounds
        controller.view.isUserInteractionEnabled = true
        
        self.rootViewController = controller
        self.hostingController = controller
        
        // Force hiển thị
        self.makeKeyAndVisible()
        
        print("🔵 3. Window setup complete")
        print("   - isHidden: \(self.isHidden)")
        print("   - isKeyWindow: \(self.isKeyWindow)")
        print("   - windowLevel: \(self.windowLevel.rawValue)")
    }
    
    func show() {
        DispatchQueue.main.async {
            print("🔵 4. show() called")
            
            self.isHidden = false
            self.alpha = 1.0
            self.windowLevel = .alert + 1
            self.makeKeyAndVisible()
            
            // Force update
            self.layoutIfNeeded()
            self.setNeedsDisplay()
            
            print("   - After show - isHidden: \(self.isHidden)")
            print("   - After show - isKeyWindow: \(self.isKeyWindow)")
        }
    }
    
    func hide() {
        print("🔴 hide() called")
        self.isHidden = true
    }
}
