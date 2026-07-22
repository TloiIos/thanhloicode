import UIKit
import SwiftUI

class OverlayWindow: UIWindow {
    static let shared = OverlayWindow(frame: UIScreen.main.bounds)
    
    private var hostingController: UIHostingController<SystemFloatingHub>?
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupWindow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWindow() {
        // QUAN TRỌNG: Set windowLevel cao hơn tất cả
        // UIWindowLevelStatusBar = 1000
        // UIWindowLevelAlert = 2000
        // Dùng level cao nhất để hiển thị trên game
        self.windowLevel = .alert + 2
        self.backgroundColor = .clear
        self.isHidden = false
        self.alpha = 1.0
        self.isUserInteractionEnabled = true
        
        // Tạo SwiftUI view
        let hubView = SystemFloatingHub()
        let controller = UIHostingController(rootView: hubView)
        controller.view.backgroundColor = .clear
        controller.view.isUserInteractionEnabled = true
        controller.view.frame = self.bounds
        
        self.rootViewController = controller
        self.hostingController = controller
        
        // QUAN TRỌNG: Đảm bảo window hiển thị
        self.makeKeyAndVisible()
        
        // Đưa lên trên cùng
        self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        
        print("✅ OverlayWindow setup complete")
        print("📐 Frame: \(self.frame)")
        print("🎚️ WindowLevel: \(self.windowLevel.rawValue)")
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(bringToFront),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc private func bringToFront() {
        self.windowLevel = .alert + 2
        self.isHidden = false
        self.makeKeyAndVisible()
        self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }
    
    func show() {
        DispatchQueue.main.async {
            self.isHidden = false
            self.windowLevel = .alert + 2
            self.makeKeyAndVisible()
            self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
            self.layoutIfNeeded()
            
            print("✅ OverlayWindow shown - level: \(self.windowLevel.rawValue)")
        }
    }
    
    func hide() {
        self.isHidden = true
    }
}
