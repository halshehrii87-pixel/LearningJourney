import SwiftUI

extension View {
    // أمر جاهز نناديه على أي زر: .glassButton()
    @ViewBuilder
    func glassButton(selected: Bool = true) -> some View {
        if selected {
            // زجاج معبّى برتقالي (للزر الرئيسي أو الخيار المختار)
            self
                .buttonStyle(.glassProminent)
                .tint(Color("AppOrange"))
        } else {
            // زجاج عادي غامق (للخيارات غير المختارة)
            self
                .buttonStyle(.glass)
                .environment(\.colorScheme, .dark)
        }
    }
}
