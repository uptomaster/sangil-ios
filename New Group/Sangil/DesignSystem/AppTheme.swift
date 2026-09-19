import SwiftUI

enum AppColors {
    static let background = Color(red: 0.035, green: 0.047, blue: 0.043)
    static let surface = Color(red: 0.08, green: 0.10, blue: 0.09)
    static let surfaceSecondary = Color(red: 0.13, green: 0.16, blue: 0.14)
    static let accentLime = Color(red: 0.77, green: 0.97, blue: 0.28)
    static let primary = accentLime
    static let accentYellow = Color(red: 0.97, green: 0.85, blue: 0.32)
    static let accentCyan = Color(red: 0.35, green: 0.85, blue: 0.89)
    static let textPrimary = Color(red: 0.95, green: 0.96, blue: 0.93)
    static let textSecondary = Color(red: 0.61, green: 0.66, blue: 0.63)
}

enum AppTypography {
    static let display = Font.system(.largeTitle, design: .rounded, weight: .heavy)
    static let title = Font.system(.title2, weight: .bold)
    static let number = Font.system(.largeTitle, design: .rounded, weight: .bold)
    static let eyebrow = Font.system(.caption2, design: .monospaced, weight: .bold)
}

extension View {
    func sangilScreen() -> some View {
        self.background(AppColors.background).foregroundStyle(AppColors.textPrimary)
            .sangilNavigationBackground()
    }

    @ViewBuilder
    private func sangilNavigationBackground() -> some View {
        #if os(iOS) || os(visionOS)
        self.toolbarBackground(AppColors.background, for: .navigationBar)
        #else
        self
        #endif
    }

    @ViewBuilder
    func sangilInlineTitle() -> some View {
        #if os(iOS) || os(visionOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }

    @ViewBuilder
    func sangilHiddenNavigationBar() -> some View {
        #if os(iOS) || os(visionOS)
        self.toolbar(.hidden, for: .navigationBar)
        #else
        self
        #endif
    }

    @ViewBuilder
    func sangilDecimalKeyboard() -> some View {
        #if os(iOS) || os(visionOS)
        self.keyboardType(.decimalPad)
        #else
        self
        #endif
    }
}
