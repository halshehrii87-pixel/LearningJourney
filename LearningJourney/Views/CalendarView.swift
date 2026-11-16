// ═══════════════════════════════════════
// 1) الاستيراد: نجيب المكتبات اللي نحتاجها
// ═══════════════════════════════════════
import SwiftUI   // مكتبة الشاشات اللي نستخدمها دايماً
import UIKit     // مكتبة UIKit، لأن UICalendarView منها


// ═══════════════════════════════════════
// 2) الجسر: struct يخلي تقويم UIKit يشتغل داخل SwiftUI
// ═══════════════════════════════════════
// UIViewRepresentable = "أنا ألبس شي من UIKit وأعرضه في SwiftUI"
struct CalendarView: UIViewRepresentable {

    // ───────────────────────────────────
    // 3) البيانات اللي تجيه من برا (من الـ ViewModel لاحقاً)
    // ───────────────────────────────────
    // DateComponents = تاريخ مفصّل (سنة، شهر، يوم) بدون ساعة
    var learnedDays: [DateComponents]   // أيام التعلم → نقطة برتقالية
    var frozenDays: [DateComponents]    // أيام التجميد → نقطة سماوية


    // ───────────────────────────────────
    // 4) إنشاء المساعد (Coordinator)
    // ───────────────────────────────────
    // SwiftUI يناديها مرة وحدة، والمساعد يجاوب على أسئلة التقويم
    func makeCoordinator() -> Coordinator {
        Coordinator(self)   // نعطيه نسخة منّا عشان يشوف البيانات
    }


    // ───────────────────────────────────
    // 5) إنشاء التقويم أول مرة بس
    // ───────────────────────────────────
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()                          // نسوي التقويم
        calendarView.calendar = Calendar(identifier: .gregorian)     // نختار التقويم الميلادي
        calendarView.delegate = context.coordinator                  // نقوله: "اسأل المساعد عن النقاط"
        return calendarView                                          // نرجّعه عشان ينعرض
    }


    // ───────────────────────────────────
    // 6) التحديث كل ما تتغير البيانات
    // ───────────────────────────────────
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        context.coordinator.parent = self    // نعطي المساعد البيانات الجديدة
        // نقول للتقويم: "أعد رسم النقاط لهذي الأيام"
        uiView.reloadDecorations(forDateComponents: learnedDays + frozenDays, animated: true)
    }


    // ───────────────────────────────────
    // 7) المساعد: يقرر وش النقطة تحت كل يوم
    // ───────────────────────────────────
    // UICalendarViewDelegate = "أنا أجاوب على أسئلة التقويم"
    class Coordinator: NSObject, UICalendarViewDelegate {

        var parent: CalendarView   // يحتفظ بنسخة من CalendarView عشان يقرأ الأيام

        init(_ parent: CalendarView) {
            self.parent = parent
        }

        // دالة مساعدة: هل هذا اليوم موجود في القائمة؟
        // نقارن السنة والشهر واليوم بس (نتجاهل أي تفاصيل ثانية)
        private func contains(_ list: [DateComponents], _ day: DateComponents) -> Bool {
            list.contains { $0.year == day.year && $0.month == day.month && $0.day == day.day }
        }

        // ─── السؤال اللي يسأله التقويم لكل يوم ───
        // "وش أحط تحت هذا اليوم؟"
        func calendarView(_ calendarView: UICalendarView,
                          decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {

            if contains(parent.learnedDays, dateComponents) {
                // يوم تعلم → نقطة برتقالية
                return .default(color: UIColor(named: "AppOrange") ?? .orange, size: .large)
            }
            if contains(parent.frozenDays, dateComponents) {
                // يوم تجميد → نقطة سماوية
                return .default(color: .systemCyan, size: .large)
            }
            return nil   // ولا شي، يوم عادي بدون نقطة
        }
    }
}


// ═══════════════════════════════════════
// 8) المعاينة: بيانات تجريبية بس عشان نشوف الشكل
// ═══════════════════════════════════════
#Preview {
    CalendarView(
        learnedDays: [
            DateComponents(year: 2026, month: 11, day: 9),
            DateComponents(year: 2026, month: 11, day: 10),
            DateComponents(year: 2026, month: 11, day: 11)
        ],
        frozenDays: [
            DateComponents(year: 2026, month: 11, day: 12)
        ]
    )
}
