import SwiftUI
import Combine

// ViewModel شاشة Activity: يحفظ الأرقام ويقرر وش يصير لما المستخدم يضغط
//
final class ActivityViewModel: ObservableObject {

    // الأرقام اللي تظهر في البطاقتين (نبدأ بقيم التصميم)
    //  يحفظ رقم أيام التعلّم إذا تغيّر، أي شاشة تراقبه تتحدّث لحالها
    @Published var learnedDays = 4
    @Published var freezedDays = 0

    // حالة اليوم الحالي
    @Published var isLoggedToday = false
    @Published var isFreezedToday = false

    // الحد الأقصى للـ Freezes (2 للأسبوع، نربطه بالهدف لاحقاً)
    let maxFreezes = 2

    // هل زر Freeze شغّال؟ لو ما استخدمنا Freeze اليوم، وباقي Freezes
    var canFreeze: Bool {
        !isFreezedToday && freezedDays < maxFreezes
    }

    // النصوص اللي تظهر على الأزرار (تتغير حسب الحالة)
   // يحفظ المستخدم هل سجل هدف اليوم او لا (true\false)
    var logTitle: String {
        isLoggedToday ? "Logged as Learned" : "Log as Learned"
    }

    
    //  Freezes او انتها رصيده فيها Freeze هنا قاعدة التصميم :الزر يتعطل اذا استخدم اليوزر
    // هنا بعد يرجعون لنفس الكلمة الاساسيه او المناسبه في الرد على اليوزر
     var freezeTitle: String {
        canFreeze ? "Freeze for a day" : "Freezed for a day"
    }

    var freezeStatus: String {
        "\(freezedDays) out of \(maxFreezes) Freezes used"
    }

    // لما المستخدم يضغط الدايرة الكبيرة
    // أمر يسوّي شغلتين: يعلّم اليوم، ويزيد عدّاد الأيام
    //* إذا الشرط غلط، "وقّف وما تسوي شي" وهذا يمنع تسجيل الهدف نفس اليوم مرتين*
    func logAsLearned() {
        guard !isLoggedToday else { return }
        isLoggedToday = true
        learnedDays += 1
    }

    // لما المستخدم يضغط Freeze
    func freezeToday() {
        guard canFreeze else { return }
        isFreezedToday = true
        freezedDays += 1
    }
}
