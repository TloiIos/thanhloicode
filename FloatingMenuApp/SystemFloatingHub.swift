import SwiftUI
import UIKit

struct SystemFloatingHub: View {
    @State private var position: CGPoint = CGPoint(x: UIScreen.main.bounds.width - 70, y: 120)
    @State private var isDragging = false
    @State private var isMenuOpen = false
    @State private var dragOffset: CGSize = .zero
    @State private var isGameConnected = false
    @State private var isEspEnabled = false
    @State private var isAimbotEnabled = false
    @State private var currentApp: AppInfo?
    @State private var isAutoInjecting = false
    @State private var autoInjectEnabled = true
    @State private var availableApps: [AppInfo] = []
    @State private var injectionStatus: String = "🔍 Scanning..."
    @State private var lastScanTime: Date = Date()
    @State private var scanTimer: Timer?
    @State private var scanCount: Int = 0
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // Danh sách game cần tự động detect
    let gameList: [String: String] = [
        "com.tencent.ig": "PUBG Mobile",
        "com.activision.callofduty": "Call of Duty",
        "com.mobile.legends": "Mobile Legends",
        "com.garena": "Garena",
        "com.vng.pubg": "PUBG VNG",
        "com.tencent.tmgp": "Tencent Games",
        "com.dts.freefireth": "Free Fire",
        "com.miHoYo": "Genshin Impact",
        "com.ea.games": "EA Games",
        "com.supercell": "Supercell",
        "com.netease": "NetEase Games",
    ]
    
    let gameIcons: [String: String] = [
        "com.tencent.ig": "gamecontroller.fill",
        "com.garena.game.ff": "flame.fill",
        "com.activision.callofduty": "target",
        "com.mobile.legends": "shield.fill",
        "com.garena": "star.fill",
        "com.miHoYo": "wand.and.rays",
        "com.ea.games": "gamecontroller.fill",
        "com.supercell": "crown.fill",
        "com.netease": "cloud.fill",
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Nút Hub tròn
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isMenuOpen.toggle()
                    }
                }) {
                    ZStack {
                        // Background với hiệu ứng glow
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        isGameConnected ? Color.green : Color.blue,
                                        isGameConnected ? Color.green.opacity(0.7) : Color.purple
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                            .shadow(color: (isGameConnected ? Color.green : Color.blue).opacity(0.5), radius: 15)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                        
                        // Icon - Hiển thị trạng thái
                        if isAutoInjecting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: isGameConnected ? "checkmark.circle.fill" : "scope")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        // Trạng thái kết nối game
                        Circle()
                            .fill(isGameConnected ? Color.green : Color.red)
                            .frame(width: 12, height: 12)
                            .offset(x: 22, y: -22)
                            .shadow(color: isGameConnected ? .green.opacity(0.6) : .red.opacity(0.6), radius: 4)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 12, height: 12)
                                    .offset(x: 22, y: -22)
                            )
                        
                        // Tên app đang inject
                        if let app = currentApp {
                            Text(app.name.prefix(2))
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(.white)
                                .padding(2)
                                .background(Color.black.opacity(0.6))
                                .cornerRadius(4)
                                .offset(x: 0, y: 30)
                        }
                    }
                }
                .position(x: position.x + dragOffset.width,
                         y: position.y + dragOffset.height)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            isDragging = false
                            let newX = position.x + value.translation.width
                            let newY = position.y + value.translation.height
                            
                            position = CGPoint(
                                x: min(max(newX, 35), screenWidth - 35),
                                y: min(max(newY, 90), screenHeight - 90)
                            )
                            dragOffset = .zero
                            
                            UserDefaults.standard.set(position.x, forKey: "hubPositionX")
                            UserDefaults.standard.set(position.y, forKey: "hubPositionY")
                        }
                )
                .onAppear {
                    if let x = UserDefaults.standard.object(forKey: "hubPositionX") as? CGFloat,
                       let y = UserDefaults.standard.object(forKey: "hubPositionY") as? CGFloat {
                        position = CGPoint(x: x, y: y)
                    }
                    
                    // Bắt đầu tự động scan
                    startAutoScan()
                }
                .onDisappear {
                    stopAutoScan()
                }
                
                // Menu
                if isMenuOpen {
                    Color.black.opacity(0.01)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isMenuOpen = false
                            }
                        }
                    
                    menuContentView
                        .position(x: position.x + dragOffset.width + 160,
                                 y: position.y + dragOffset.height)
                        .transition(.scale(scale: 0.8).combined(with: .opacity))
                        .zIndex(1)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Menu Content
    private var menuContentView: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "scope")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.blue)
                
                Text("AUTO INJECTOR")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Auto inject toggle
                HStack(spacing: 4) {
                    Text("Auto")
                        .font(.system(size: 9))
                        .foregroundColor(autoInjectEnabled ? .green : .gray)
                    Toggle("", isOn: $autoInjectEnabled)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                        .scaleEffect(0.6)
                        .onChange(of: autoInjectEnabled) { newValue in
                            if newValue {
                                startAutoScan()
                            } else {
                                stopAutoScan()
                            }
                        }
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.white.opacity(0.05))
                .cornerRadius(8)
                
                Button(action: {
                    withAnimation {
                        isMenuOpen = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            Divider().background(Color.white.opacity(0.1))
            
            ScrollView {
                VStack(spacing: 8) {
                    // Status Section
                    statusSection
                    
                    Divider().background(Color.white.opacity(0.1))
                        .padding(.vertical, 4)
                    
                    // ESP & Aimbot Menu
                    FloatingMenuContent(
                        isGameConnected: $isGameConnected,
                        onToggle: handleToggle
                    )
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
            }
            .frame(height: 440)
        }
        .frame(width: 300)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.06, green: 0.06, blue: 0.10).opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.6), radius: 25, y: 10)
    }
    
    // MARK: - Status Section
    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "waveform.circle.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 14))
                Text("INJECTION STATUS")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.blue.opacity(0.7))
                Spacer()
                if isAutoInjecting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .scaleEffect(0.5)
                }
            }
            .padding(.horizontal, 12)
            
            // Current app
            HStack {
                Circle()
                    .fill(currentApp != nil ? Color.green : Color.gray)
                    .frame(width: 8, height: 8)
                
                Text(currentApp?.name ?? "No game detected")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(currentApp != nil ? .white : .gray)
                
                Spacer()
                
                if isGameConnected {
                    Text("✅ INJECTED")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(4)
                } else if currentApp != nil {
                    Text("⏳ WAITING...")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.yellow)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)
            
            // Status text
            HStack {
                Text(injectionStatus)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                Spacer()
                Text(lastScanTime, style: .time)
                    .font(.system(size: 9))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 4)
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Auto Scan Functions
    private func startAutoScan() {
        guard autoInjectEnabled else { return }
        
        injectionStatus = "🔍 Scanning for games..."
        isAutoInjecting = true
        
        // Scan ngay lập tức
        performScan()
        
        // Tạo timer scan mỗi 3 giây
        scanTimer?.invalidate()
        scanTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            if !autoInjectEnabled {
                self.stopAutoScan()
                return
            }
            self.performScan()
        }
    }
    
    private func stopAutoScan() {
        scanTimer?.invalidate()
        scanTimer = nil
        isAutoInjecting = false
        injectionStatus = "⏸️ Auto inject paused"
    }
    
    private func performScan() {
        DispatchQueue.global(qos: .background).async {
            let detectedApp = self.detectRunningGame()
            
            DispatchQueue.main.async {
                self.lastScanTime = Date()
                self.scanCount += 1
                
                if let app = detectedApp {
                    if self.currentApp?.bundleId != app.bundleId {
                        // Phát hiện game mới
                        self.currentApp = app
                        self.injectionStatus = "🎯 Found: \(app.name)"
                        self.isAutoInjecting = true
                        
                        // Tự động inject
                        self.autoInject(app)
                    } else {
                        // Game vẫn đang chạy
                        self.injectionStatus = "🔄 Monitoring: \(app.name)"
                    }
                } else {
                    if self.currentApp != nil {
                        // Game đã đóng
                        self.currentApp = nil
                        self.isGameConnected = false
                        self.injectionStatus = "❌ Game closed - Waiting..."
                    } else {
                        self.injectionStatus = "🔍 Scanning for games... (\(self.scanCount))"
                    }
                }
            }
        }
    }
    
    private func detectRunningGame() -> AppInfo? {
        var detectedApp: AppInfo?
        
        // Cách 1: Kiểm tra thông qua UIApplication (chỉ detect app của mình)
        // Cách 2: Dùng private API (cần entitlements)
        // Cách 3: Mô phỏng cho demo
        
        #if targetEnvironment(simulator)
        // Trên simulator, mô phỏng scan
        let gameBundleIds = Array(gameList.keys)
        if let randomBundleId = gameBundleIds.randomElement() {
            let gameName = gameList[randomBundleId] ?? randomBundleId
            let icon = gameIcons[randomBundleId] ?? "app.fill"
            detectedApp = AppInfo(
                name: gameName,
                bundleId: randomBundleId,
                icon: icon
            )
        }
        #else
        // Trên device thật
        // Lưu ý: iOS sandbox không cho phép get running apps
        // Bạn cần jailbreak hoặc dùng entitlements đặc biệt
        
        // Demo: Luân phiên các game để test
        let gameBundleIds = Array(gameList.keys)
        let index = Int(Date().timeIntervalSince1970) % gameBundleIds.count
        let bundleId = gameBundleIds[index]
        let gameName = gameList[bundleId] ?? bundleId
        let icon = gameIcons[bundleId] ?? "app.fill"
        
        detectedApp = AppInfo(
            name: gameName,
            bundleId: bundleId,
            icon: icon
        )
        #endif
        
        return detectedApp
    }
    
    private func getGameName(from bundleId: String) -> String {
        return gameList[bundleId] ?? bundleId
    }
    
    private func getGameIcon(from bundleId: String) -> String {
        return gameIcons[bundleId] ?? "app.fill"
    }
    
    private func autoInject(_ app: AppInfo) {
        injectionStatus = "💉 Injecting into \(app.name)..."
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Giả lập inject thành công
            self.isGameConnected = true
            self.isAutoInjecting = false
            self.injectionStatus = "✅ Injected: \(app.name)"
            
            print("✅ Auto-injected into \(app.name)")
            
            // Bật ESP tự động khi inject thành công
            EspManager.setEspEnabled(true)
            EspManager.setAimbotEnabled(true)
            
            // Haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Cập nhật UI
            self.isEspEnabled = true
            self.isAimbotEnabled = true
        }
    }
    
    private func handleToggle(_ title: String, isOn: Bool) {
        print("🔄 Toggle: \(title) = \(isOn)")
        switch title {
        case "ESP": 
            EspManager.setEspEnabled(isOn)
            isEspEnabled = isOn
        case "ESP Box": EspManager.setEspBoxEnabled(isOn)
        case "ESP Lines": EspManager.setEspLinesEnabled(isOn)
        case "ESP Skeleton": EspManager.setEspSkeletonEnabled(isOn)
        case "ESP Circle": EspManager.setEspCircleEnabled(isOn)
        case "ESP OOF": EspManager.setEspOOFEnabled(isOn)
        case "Show Info": EspManager.setEspShowInfoEnabled(isOn)
        case "Enemy Count": EspManager.setEspEnemyCountEnabled(isOn)
        case "Enemy Warning": EspManager.setEspEnemyWarningEnabled(isOn)
        case "Aimbot":
            EspManager.setAimbotEnabled(isOn)
            isAimbotEnabled = isOn
            if isOn {
                EspManager.setEspEnabled(true)
                isEspEnabled = true
            }
        case "Silent Aim": EspManager.setSilentAimEnabled(isOn)
        case "Visible Check": EspManager.setAimbotVisibleCheck(isOn)
        default: break
        }
    }
}

// MARK: - Preview
struct SystemFloatingHub_Previews: PreviewProvider {
    static var previews: some View {
        SystemFloatingHub()
            .background(Color.black)
    }
}
