import SwiftUI

extension View {
    // الأمر الثابت لكل أزرار الزجاج في التطبيق
    // selected: هل الزر مختار؟ (برتقالي) أو عادي (رمادي غامق)
    // tint: لون الزجاج، الافتراضي برتقالي AppOrange
    @ViewBuilder
    func glassButton(selected: Bool = true, tint: Color = Color("AppOrange")) -> some View {
        if selected {
            // زجاج معبّى باللون (مثل زر Start Learning)
            self
                .buttonStyle(.glassProminent)
                .tint(tint)
        } else {
            // زجاج عادي غامق (للخيارات غير المختارة)
            self
                .buttonStyle(.glass)
                .environment(\.colorScheme, .dark)
        }
    }
}
