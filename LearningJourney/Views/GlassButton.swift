import SwiftUI

// ═══════════════════════════════════════════════
// أزرار الزجاج (Liquid Glass) بدون تكبير
// الستايلات الجاهزة (.glass و .glassProminent) تكبّر الزر لما ينضغط،
// فسوينا ستايلات خاصة تخفت بس لما ينضغط الزر
// ═══════════════════════════════════════════════

// ───────────── 1) زر كبسولة (Start Learning، Freeze، Week/Month/Year) ─────────────
struct NoScaleGlassButtonStyle: ButtonStyle {

    // هل الزر مختار؟ (ملون) أو عادي (رمادي)
    var selected: Bool
    var tint: Color

    // هل الزر شغال؟ (يتغير لما نستخدم .disabled)
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {

        // نوع الزجاج: ملون إذا مختار، وعادي إذا لا
        let glass: Glass = selected ? Glass.regular.tint(tint) : Glass.regular

        configuration.label
            .foregroundStyle(.white)             // لون الكلام
            .padding(.horizontal, 12)            // مسافة داخل الزر (يمين ويسار)
            .padding(.vertical, 8)               // مسافة داخل الزر (فوق وتحت)
            .glassEffect(glass, in: Capsule())   // شكل الزجاج (كبسولة)
            // الشفافية: مقفل 0.4 ، منضغط 0.6 ، عادي 1
            .opacity(!isEnabled ? 0.4 : (configuration.isPressed ? 0.6 : 1))
            // في الآخر عشان يشمل الزجاج نفسه (زجاج غامق مثل Sketch)
            .environment(\.colorScheme, .dark)
    }
}

extension View {
    // الأمر الثابت لكل أزرار الزجاج: .glassButton()
    // selected: هل الزر مختار؟ (برتقالي) أو عادي (رمادي غامق)
    // tint: لون الزجاج، الافتراضي برتقالي AppOrange
    func glassButton(selected: Bool = true, tint: Color = Color("AppOrange")) -> some View {
        self.buttonStyle(NoScaleGlassButtonStyle(selected: selected, tint: tint))
    }
}

// ───────────── 2) زر أيقونة دائري (التقويم، القلم، ✓، الرجوع) ─────────────
struct NoScaleGlassIconButtonStyle: ButtonStyle {

    // لون الزجاج (اختياري): إذا ما حطيناه يكون زجاج عادي
    var tint: Color? = nil

    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {

        // ملون إذا فيه tint، وإلا عادي
        let glass: Glass = tint.map { Glass.regular.tint($0) } ?? Glass.regular

        configuration.label
            .foregroundStyle(.white)
            .frame(width: 44, height: 44)         // حجم الدائرة
            .glassEffect(glass, in: Circle())     // زجاج على شكل دائرة
            .opacity(!isEnabled ? 0.4 : (configuration.isPressed ? 0.6 : 1))
            .environment(\.colorScheme, .dark)    // زجاج غامق مثل Sketch
    }
}

extension View {
    // .glassIconButton() ← دائرة عادية
    // .glassIconButton(tint: Color("AppOrange")) ← دائرة ملونة
    func glassIconButton(tint: Color? = nil) -> some View {
        self.buttonStyle(NoScaleGlassIconButtonStyle(tint: tint))
    }
}
