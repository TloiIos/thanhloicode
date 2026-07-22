import SwiftUI

struct FloatingMenuContent: View {
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
    let onToggle: (String, Bool) -> Void
    
    var body: some View {
        VStack(spacing: 2) {
            // Game Connection Status
            HStack {
                Circle()
                    .fill(isGameConnected ? Color.green : Color.red)
                    .frame(width: 8, height: 8)
                Text(isGameConnected ? "● INJECTED - ACTIVE" : "● WAITING FOR GAME")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(isGameConnected ? .green : .red)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            
            // ESP Section
            Text("🎯 ESP FEATURES")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Color.blue.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 2)
            
            ForEach(0..<8, id: \.self) { index in
                ToggleRow(
                    title: toggles[index].title,
                    isOn: $toggles[index].isOn,
                    onToggle: onToggle
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
                    onToggle: onToggle
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
}
