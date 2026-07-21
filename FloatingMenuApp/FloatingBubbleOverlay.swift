import SwiftUI

struct ToggleItem: Identifiable {
    let id = UUID()
    let title: String
    var isOn: Bool
}

struct FloatingBubbleOverlay: View {
    @State private var bubblePosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width - 50, y: 180)
    @State private var dragOffset: CGSize = .zero
    @State private var panelVisible: Bool = false
    @State private var fovValue: Float = 90.0
    
    @State private var toggles: [ToggleItem] = [
        ToggleItem(title: "ESP", isOn: false),
        ToggleItem(title: "ESP Box", isOn: false),
        ToggleItem(title: "ESP Lines", isOn: false),
        ToggleItem(title: "ESP Skeleton", isOn: false),
        ToggleItem(title: "ESP Circle", isOn: false),
        ToggleItem(title: "ESP OOF", isOn: false),
        ToggleItem(title: "ESP Show Info", isOn: false),
        ToggleItem(title: "ESP Enemy Count", isOn: false),
        ToggleItem(title: "ESP Warning", isOn: false),
        ToggleItem(title: "Aimbot", isOn: false),
        ToggleItem(title: "Silent Aim", isOn: false),
        ToggleItem(title: "Visible Check", isOn: true),
    ]
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                if panelVisible {
                    panelView
                        .position(panelPosition(in: geo.size))
                        .transition(.scale(scale: 0.85).combined(with: .opacity))
                }
                
                bubbleButton
                    .position(x: bubblePosition.x + dragOffset.width,
                              y: bubblePosition.y + dragOffset.height)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation
                            }
                            .onEnded { value in
                                var newX = bubblePosition.x + value.translation.width
                                var newY = bubblePosition.y + value.translation.height
                                let w = geo.size.width
                                let h = geo.size.height
                                newX = min(max(newX, 30), w - 30)
                                newY = min(max(newY, 80), h - 80)
                                newX = newX < w / 2 ? 30 : w - 30
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    bubblePosition = CGPoint(x: newX, y: newY)
                                    dragOffset = .zero
                                }
                            }
                    )
            }
        }
        .onAppear {
            EspManager.setupESP()
        }
    }
    
    private var bubbleButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                panelVisible.toggle()
            }
        } label: {
            Image(systemName: "scope")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(
                    Circle().fill(Color(red: 0.10, green: 0.55, blue: 0.95))
                )
                .shadow(color: .black.opacity(0.35), radius: 8, y: 4)
        }
    }
    
    private var panelView: some View {
        VStack(spacing: 0) {
            Text("ESP & AIMBOT")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.top, 14)
                .padding(.bottom, 8)
            
            Divider().background(Color.white.opacity(0.15))
            
            ScrollView {
                VStack(spacing: 2) {
                    // ESP Section
                    Text("ESP FEATURES")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.blue.opacity(0.8))
                        .padding(.top, 6)
                        .padding(.bottom, 2)
                    
                    ForEach(0..<8, id: \.self) { index in
                        ToggleRow(
                            title: toggles[index].title,
                            isOn: $toggles[index].isOn,
                            onToggle: handleToggle
                        )
                    }
                    
                    Divider().background(Color.white.opacity(0.1))
                    
                    // Aimbot Section
                    Text("AIMBOT FEATURES")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.green.opacity(0.8))
                        .padding(.top, 6)
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
                                .foregroundStyle(.white)
                            Spacer()
                            Text(fovValue < 30 ? "🎯 Perfect" : fovValue < 60 ? "⚡ Good" : "📡 Wide")
                                .font(.system(size: 11))
                                .foregroundStyle(fovValue < 30 ? .green : fovValue < 60 ? .orange : .red)
                        }
                        
                        Slider(value: $fovValue, in: 10...180, step: 1)
                            .tint(.blue)
                            .onChange(of: fovValue) { newValue in
                                EspManager.setAimbotFov(newValue)
                            }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    
                    // Target Selection
                    HStack {
                        Text("Target:")
                            .font(.system(size: 13))
                            .foregroundStyle(.white)
                        Spacer()
                        Button("Head") {
                            EspManager.setAimbotTarget(0)
                        }
                        .font(.system(size: 12))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(6)
                        
                        Button("Body") {
                            EspManager.setAimbotTarget(2)
                        }
                        .font(.system(size: 12))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(6)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 4)
                }
                .padding(.bottom, 10)
            }
            .frame(height: 460)
        }
        .frame(width: 270)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.08, green: 0.08, blue: 0.10).opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.4), radius: 12, y: 6)
    }
    
    private func panelPosition(in size: CGSize) -> CGPoint {
        let bubbleX = bubblePosition.x + dragOffset.width
        let bubbleY = bubblePosition.y + dragOffset.height
        let opensLeft = bubbleX > size.width / 2
        let panelX = opensLeft ? bubbleX - 175 : bubbleX + 175
        let panelY = min(max(bubbleY + 40, 140), size.height - 140)
        return CGPoint(x: panelX, y: panelY)
    }
    
    private func handleToggle(_ title: String, isOn: Bool) {
        switch title {
        case "ESP": EspManager.setEspEnabled(isOn)
        case "ESP Box": EspManager.setEspBoxEnabled(isOn)
        case "ESP Lines": EspManager.setEspLinesEnabled(isOn)
        case "ESP Skeleton": EspManager.setEspSkeletonEnabled(isOn)
        case "ESP Circle": EspManager.setEspCircleEnabled(isOn)
        case "ESP OOF": EspManager.setEspOOFEnabled(isOn)
        case "ESP Show Info": EspManager.setEspShowInfoEnabled(isOn)
        case "ESP Enemy Count": EspManager.setEspEnemyCountEnabled(isOn)
        case "ESP Warning": EspManager.setEspEnemyWarningEnabled(isOn)
        case "Aimbot":
            EspManager.setAimbotEnabled(isOn)
            if isOn { EspManager.setEspEnabled(true) }
        case "Silent Aim": EspManager.setSilentAimEnabled(isOn)
        case "Visible Check": EspManager.setAimbotVisibleCheck(isOn)
        default: break
        }
        
        let espTitles = ["ESP Box", "ESP Lines", "ESP Skeleton", "ESP Circle",
                         "ESP OOF", "ESP Show Info", "ESP Enemy Count", "ESP Warning"]
        let anyEspOn = toggles.filter { espTitles.contains($0.title) && $0.isOn }.count > 0
        
        if anyEspOn {
            EspManager.setEspEnabled(true)
        }
    }
}

struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    let onToggle: (String, Bool) -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
                .foregroundStyle(.white)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.green)
                .onChange(of: isOn) { newValue in
                    onToggle(title, newValue)
                }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
    }
}

#Preview {
    FloatingBubbleOverlay()
}
