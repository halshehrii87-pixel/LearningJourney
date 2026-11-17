import SwiftUI
import Combine

// ViewModel: يحفظ هدف التعلّم ويقرر منطقه
final class GoalViewModel: ObservableObject {
    // @Published = لو تغيرت القيمة، الشاشات اللي تراقبها تتحدث لحالها بدون ما اتدخل
    @Published var subject = ""
    @Published var selectedDuration = "Week"

    // القائمة الثابتة للخيارات الاساسيه
    let durations = ["Week", "Month", "Year"]

    // عدد الـ Freezes الفرص المسموحة حسب المدة (من ملاحظات التصميم)
    var maxFreezes: Int {
        switch selectedDuration {
        case "Week": return 2
        case "Month": return 8
        default: return 96
        }
    }
    // كم يوم لازم نتعلم عشان يكتمل الهدف
    var goalDays: Int {
        switch selectedDuration {
        case "Week": return 7
        case "Month": return 30
        default: return 365
        }
    }
}
