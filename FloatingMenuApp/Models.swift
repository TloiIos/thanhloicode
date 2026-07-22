import Foundation
import SwiftUI

// MARK: - App Info Model
struct AppInfo: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let bundleId: String
    let icon: String
    
    static func == (lhs: AppInfo, rhs: AppInfo) -> Bool {
        return lhs.bundleId == rhs.bundleId
    }
}

// MARK: - Toggle Item Model
struct ToggleItem: Identifiable {
    let id = UUID()
    let title: String
    var isOn: Bool
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
