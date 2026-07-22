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
        self.windowLevel = .alert + 2
        self.backgroundColor = .clear
        self.isHidden = false
        self.alpha = 1.0
        self.isUserInteractionEnabled = true
        
        let hubView = SystemFloatingHub()
        let controller = UIHostingController(rootView: hubView)
        controller.view.backgroundColor = .clear
        controller.view.isUserInteractionEnabled = true
        controller.view.frame = self.bounds
        
        self.rootViewController = controller
        self.hostingController = controller
        
        self.makeKeyAndVisible()
        self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }
    
    func show() {
        DispatchQueue.main.async {
            self.isHidden = false
            self.windowLevel = .alert + 2
            self.makeKeyAndVisible()
            self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        }
    }
}
