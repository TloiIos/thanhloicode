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
        // QUAN TRỌNG: Set window level cao nhất
        self.windowLevel = UIWindow.Level.statusBar + 2
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
        
        // QUAN TRỌNG: Make key và visible
        self.makeKeyAndVisible()
        
        // Hiển thị lên top
        self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        
        print("✅ OverlayWindow setup complete")
        print("📐 Frame: \(self.frame)")
        print("🎚️ WindowLevel: \(self.windowLevel.rawValue)")
        print("👁️ isHidden: \(self.isHidden)")
        print("🔑 isKeyWindow: \(self.isKeyWindow)")
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(bringToFront),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc private func bringToFront() {
        self.windowLevel = UIWindow.Level.statusBar + 2
        self.isHidden = false
        self.makeKeyAndVisible()
        self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        print("🔄 Bring to front called")
    }
    
    func show() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isHidden = false
            self.windowLevel = UIWindow.Level.statusBar + 2
            self.makeKeyAndVisible()
            self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
            
            // Force layout
            self.layoutIfNeeded()
            
            print("✅ OverlayWindow shown")
            print("👁️ isHidden: \(self.isHidden)")
            print("🔑 isKeyWindow: \(self.isKeyWindow)")
        }
    }
    
    func hide() {
        self.isHidden = true
        print("🔴 OverlayWindow hidden")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
