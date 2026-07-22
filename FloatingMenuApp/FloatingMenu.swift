import SwiftUI

struct ToggleItem: Identifiable {
    let id = UUID()
    let title: String
    var isOn: Bool
}

struct FloatingMenu: View {
    @Binding var isOpen: Bool
    @Binding var isGameConnected: Bool
    @State private var fovValue: Float = 90.0
    @State private var selectedTarget: Int = 0
    @State private var toggles: [ToggleItem] = [
        ToggleItem(title: "ESP", isOn: false),
        ToggleItem(title: "ESP Box", isOn: false),
        ToggleItem(title: "ESP Lines", isOn: false),
        ToggleItem(title: "ESP Skeleton", isOn: false),
        ToggleItem(title: "ESP Circle", isOn: false),
        ToggleItem(title: "ESP OOF", isOn: false),
        ToggleItem(title: "Show Info", isOn: false),
        ToggleItem(title: "Enemy Count", isOn: false),
        ToggleItem(title: "Enemy Warning", isOn: false),
        ToggleItem(title: "Aimbot", isOn: false),
        ToggleItem(title: "Silent Aim", isOn: false),
        ToggleItem(title: "Visible Check", isOn: true),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            Divider().background(Color.white.opacity(0.1))
            scrollContentView
        }
        .frame(width: 280)
        .background(menuBackground)
        .shadow(color: .black.opacity(0.6), radius: 25, y: 10)
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Image(systemName: "scope")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.blue)
            
            Text("ESP & AIMBOT")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            connectionStatusView
            closeButton
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
    
    // MARK: - Connection Status
    private var connectionStatusView: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(isGameConnected ? Color.green : Color.red)
                .frame(width: 6, height: 6)
            Text(isGameConnected ? "Online" : "Offline")
                .font(.system(size: 10))
                .foregroundColor(isGameConnected ? .green : .red)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 2)
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
    
    // MARK: - Close Button
    private var closeButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isOpen = false
            }
        }) {
            Image(systemName: "xmark.circle.fill")
                .font(.title2)
                .foregroundColor(.white.opacity(0.5))
        }
    }
    
    // MARK: - Scroll Content
    private var scrollContentView: some View {
        ScrollView {
            VStack(spacing: 2) {
                espSectionView
                Divider().background(Color.white.opacity(0.1)).padding(.vertical, 4)
                aimbotSectionView
                targetSelectionView
                fovSliderView
            }
        }
        .frame(height: 420)
    }
    
    // MARK: - ESP Section
    private var espSectionView: some View {
        Group {
            Text("🎯 ESP FEATURES")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Color.blue.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 2)
            
            ForEach(0..<8, id: \.self) { index in
                ToggleRow(
                    title: toggles[index].title,
                    isOn: $toggles[index].isOn,
                    onToggle: handleToggle
                )
            }
        }
    }
    
    // MARK: - Aimbot Section
    private var aimbotSectionView: some View {
        Group {
            Text("🎯 AIMBOT FEATURES")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Color.green.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 2)
            
            ForEach(8..<11, id: \.self) { index in
                ToggleRow(
                    title: toggles[index].title,
                    isOn: $toggles[index].isOn,
                    onToggle: handleToggle
                )
            }
        }
    }
    
    // MARK: - FOV Slider
    private var fovSliderView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("FOV: \(Int(fovValue))°")
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                Spacer()
                Text(fovValue < 30 ? "🎯 Perfect" :
                     fovValue < 60 ? "⚡ Good" : "📡 Wide")
                    .font(.system(size: 10))
                    .foregroundColor(fovValue < 30 ? .green :
                                    fovValue < 60 ? .orange : .red)
            }
            
            Slider(value: $fovValue, in: 10...180, step: 1)
                .tint(Color.blue)
                .onChange(of: fovValue) { newValue in
                    EspManager.setAimbotFov(newValue)
                }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
    
    // MARK: - Target Selection
    private var targetSelectionView: some View {
        HStack {
            Text("Target:")
                .font(.system(size: 13))
                .foregroundColor(.white)
            Spacer()
            
            targetButton(title: "Head", targetValue: 0, boneValue: 0)
            targetButton(title: "Body", targetValue: 1, boneValue: 2)
            targetButton(title: "Chest", targetValue: 2, boneValue: 1)
            targetButton(title: "Legs", targetValue: 3, boneValue: 3)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .padding(.bottom, 8)
    }
    
    // MARK: - Target Button Helper
    private func targetButton(title: String, targetValue: Int, boneValue: Int32) -> some View {
        Button(title) {
            selectedTarget = targetValue
            EspManager.setAimbotTarget(boneValue)
        }
        .font(.system(size: 11))
        .padding(.horizontal, 14)
        .padding(.vertical, 3)
        .background(selectedTarget == targetValue ? Color.blue : Color.white.opacity(0.08))
        .foregroundColor(selectedTarget == targetValue ? .white : .white.opacity(0.6))
        .cornerRadius(6)
    }
    
    // MARK: - Menu Background
    private var menuBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(red: 0.06, green: 0.06, blue: 0.10).opacity(0.96))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
    }
    
    // MARK: - Toggle Handler
    private func handleToggle(_ title: String, isOn: Bool) {
        switch title {
        case "ESP":
            EspManager.setEspEnabled(isOn)
        case "ESP Box":
            EspManager.setEspBoxEnabled(isOn)
        case "ESP Lines":
            EspManager.setEspLinesEnabled(isOn)
        case "ESP Skeleton":
            EspManager.setEspSkeletonEnabled(isOn)
        case "ESP Circle":
            EspManager.setEspCircleEnabled(isOn)
        case "ESP OOF":
            EspManager.setEspOOFEnabled(isOn)
        case "Show Info":
            EspManager.setEspShowInfoEnabled(isOn)
        case "Enemy Count":
            EspManager.setEspEnemyCountEnabled(isOn)
        case "Enemy Warning":
            EspManager.setEspEnemyWarningEnabled(isOn)
        case "Aimbot":
            EspManager.setAimbotEnabled(isOn)
            if isOn {
                EspManager.setEspEnabled(true)
                if let espIndex = toggles.firstIndex(where: { $0.title == "ESP" }) {
                    toggles[espIndex].isOn = true
                }
            }
        case "Silent Aim":
            EspManager.setSilentAimEnabled(isOn)
        case "Visible Check":
            EspManager.setAimbotVisibleCheck(isOn)
        default:
            break
        }
        
        // Auto-enable ESP if any ESP feature is on
        let espTitles = ["ESP Box", "ESP Lines", "ESP Skeleton", "ESP Circle",
                         "ESP OOF", "Show Info", "Enemy Count", "Enemy Warning"]
        let anyEspOn = toggles.filter { espTitles.contains($0.title) && $0.isOn }.count > 0
        
        if anyEspOn {
            EspManager.setEspEnabled(true)
            if let espIndex = toggles.firstIndex(where: { $0.title == "ESP" }) {
                toggles[espIndex].isOn = true
            }
        }
    }
}

// MARK: - Toggle Row Component
struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    let onToggle: (String, Bool) -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.85))
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.green)
                .scaleEffect(0.7)
                .onChange(of: isOn) { newValue in
                    onToggle(title, newValue)
                }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 3)
    }
}
