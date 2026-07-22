import UIKit
import SwiftUI

class OverlayWindow: UIWindow {
    static let shared = OverlayWindow()
    
    private var hostingController: UIHostingController<SystemFloatingHub>?
    
    private override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setupWindow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWindow() {
        self.windowLevel = .statusBar + 1
        self.backgroundColor = .clear
        self.isHidden = false
        self.makeKeyAndVisible()
        
        // Tạo SwiftUI view
        let hubView = SystemFloatingHub()
        let controller = UIHostingController(rootView: hubView)
        controller.view.backgroundColor = .clear
        controller.view.isUserInteractionEnabled = true
        
        self.rootViewController = controller
        self.hostingController = controller
        
        // Đảm bảo cửa sổ luôn ở trên cùng
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(bringToFront),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc private func bringToFront() {
        self.windowLevel = .statusBar + 1
        self.isHidden = false
        self.makeKeyAndVisible()
    }
    
    func show() {
        self.isHidden = false
        self.windowLevel = .statusBar + 1
        self.makeKeyAndVisible()
    }
    
    func hide() {
        self.isHidden = true
    }
}
