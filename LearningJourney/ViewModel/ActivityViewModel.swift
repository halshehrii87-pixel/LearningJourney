import SwiftUI
import Combine

// ViewModel شاشة Activity: يحفظ الأرقام ويقرر وش يصير لما المستخدم يضغط
//
final class ActivityViewModel: ObservableObject {

    // الأرقام اللي تظهر في البطاقتين (نبدأ بقيم التصميم)
    //  يحفظ رقم أيام التعلّم إذا تغيّر، أي شاشة تراقبه تتحدّث لحالها
    @Published var learnedDays = 0
    @Published var freezedDays = 0

    // حالة اليوم الحالي
    @Published var isLoggedToday = false
    @Published var isFreezedToday = false
    
    @Published var learnedDates: [DateComponents] = []
    @Published var frozenDates: [DateComponents] = []
    
    // آخر مرة سجّل فيها اليوزر (Learned أو Freeze)
    private var lastActivityDate: Date?
    
    // تاريخ اليوم (سنة، شهر، يوم) عشان نحفظه
    private var todayComponents: DateComponents {
        Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: Date())
    }

    // الحد الأقصى للـ Freezes (2 للأسبوع، نربطه بالهدف لاحقاً)
    @Published var maxFreezes = 2
    
    // عدد الأيام اللي لازم نتعلمها عشان يكتمل الهدف
    @Published var goalDays = 7
    
    // هل فشل المستخدم في تحقيق الهدف؟ (انكسرت السلسلة قبل ما يكتمل)
    @Published var isGoalFailed = false

    // هل اكتمل الهدف؟ (أيام التعلم وصلت لطول الهدف)
    var isGoalCompleted: Bool {
        learnedDays >= goalDays
    }

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

    // تاريخ اليوم الحقيقي بصيغة: Monday, 16 November
    var todayTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: Date())
    }

    // أرقام أيام الأسبوع الحالي (من الأحد إلى السبت)
    var weekDays: [Int] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1   // الأسبوع يبدأ من الأحد
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else { return [] }
        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: weekStart)
                .map { calendar.component(.day, from: $0) }
        }
    }

    // رقم يوم اليوم (مثلاً 16)
    var todayNumber: Int {
        Calendar(identifier: .gregorian).component(.day, from: Date())
    }

    // لما المستخدم يضغط الدايرة الكبيرة
    // أمر يسوّي شغلتين: يعلّم اليوم، ويزيد عدّاد الأيام
    //* إذا الشرط غلط، "وقّف وما تسوي شي" وهذا يمنع تسجيل الهدف نفس اليوم مرتين*
    //
    //حفظ اليوم لما تضغطين Log as Learned
    // حفظ اليوم لما تفعلين Log as Learned
    func logAsLearned() {
        guard !isLoggedToday else { return }
        isLoggedToday = true
        learnedDays += 1
        learnedDates.append(todayComponents)
        lastActivityDate = Date()
    }

    // لما المستخدم يضغط Freeze
    func freezeToday() {
        guard canFreeze else { return }
        isFreezedToday = true
        freezedDays += 1
        frozenDates.append(todayComponents)
        lastActivityDate = Date()
    }

    // لما اليوزر يحدّث هدفه، السلسلة تبدأ من جديد
    func resetStreak() {
        learnedDays = 0
        freezedDays = 0
        isLoggedToday = false
        isFreezedToday = false
        learnedDates = []
        frozenDates = []
        lastActivityDate = nil
        isGoalFailed = false
    }

    // نفحص كل ما تنفتح الشاشة: هل يوم جديد؟ هل عدّت 32 ساعة؟
    func checkStreak() {
        guard let last = lastActivityDate else { return }

        // يوم جديد (بعد 12 صباحاً): الأزرار ترجع تشتغل
        if !Calendar.current.isDateInToday(last) {
            isLoggedToday = false
            isFreezedToday = false
        }

        // أكثر من 32 ساعة بدون نشاط: السلسلة تنكسر
        // عشان التست بخليها ١٠ ثواني 0.003
        let hours = Date().timeIntervalSince(last) / 3600
        if hours > 32 && !isGoalCompleted {
            resetStreak()
            isGoalFailed = true
        }
    }
}
