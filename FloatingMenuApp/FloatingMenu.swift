import SwiftUI

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
            // Header với nút đóng
            HStack {
                Image(systemName: "scope")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.blue)
                
                Text("ESP & AIMBOT")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Nút đóng
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
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            Divider().background(Color.white.opacity(0.1))
            
            // Nội dung scroll
            ScrollView {
                VStack(spacing: 2) {
                    // ESP Section
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
                    
                    Divider().background(Color.white.opacity(0.1))
                        .padding(.vertical, 4)
                    
                    // Aimbot Section
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
                    
                    // FOV Slider
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
                    
                    // Target Selection
                    HStack {
                        Text("Target:")
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                        Spacer()
                        
                        targetButton(title: "Head", targetValue: 0, boneValue: 0)
                        targetButton(title: "Body", targetValue: 1, boneValue: 2)
                        targetButton(title: "Chest", targetValue: 2, boneValue: 1)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                    .padding(.bottom, 8)
                }
            }
            .frame(height: 400)
        }
        .frame(width: 300)
        .onAppear {
            print("📋 FloatingMenu appeared!")
        }
    }
    
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
    
    private func handleToggle(_ title: String, isOn: Bool) {
        print("🔄 Toggle: \(title) = \(isOn)")
        switch title {
        case "ESP": EspManager.setEspEnabled(isOn)
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
            if isOn {
                EspManager.setEspEnabled(true)
            }
        case "Silent Aim": EspManager.setSilentAimEnabled(isOn)
        case "Visible Check": EspManager.setAimbotVisibleCheck(isOn)
        default: break
        }
    }
}

struct ToggleItem: Identifiable {
    let id = UUID()
    let title: String
    var isOn: Bool
}

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
