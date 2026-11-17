import Foundation

// ViewModel شاشة Activities: يجهز الأشهر والأيام ويقرر لون كل يوم
struct CalendarViewModel {
    // الأيام اللي تعلمها / جمدها المستخدم (تجي من ActivityViewModel)
    let learnedDays: [DateComponents]
    let frozenDays: [DateComponents]

    // أسماء الأيام فوق كل شهر
    let weekdays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

    private var calendar: Calendar { Calendar(identifier: .gregorian) }

    // 12 شهر: يبدأ من الشهر الحالي
    var months: [Date] {
        let start = calendar.date(from: calendar.dateComponents([.year, .month], from: Date())) ?? Date()
        return (0..<12).compactMap { calendar.date(byAdding: .month, value: $0, to: start) }
    }

    // عنوان الشهر مثل: November 2026
    func title(for month: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: month)
    }

    // أيام الشهر، وقبلها خانات فاضية (nil) عشان اليوم الأول ينزل تحت اسم يومه
    func days(in month: Date) -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: month) else { return [] }
        let firstWeekday = calendar.component(.weekday, from: month) // 1 = الأحد
        let blanks: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        let days: [Date?] = range.map { calendar.date(byAdding: .day, value: $0 - 1, to: month) }
        return blanks + days
    }

    // رقم اليوم كنص
    func dayNumber(_ date: Date) -> String {
        String(calendar.component(.day, from: date))
    }

    // حالة اليوم: وش لونه؟
    func isLearned(_ date: Date) -> Bool { contains(learnedDays, date) }
    func isFrozen(_ date: Date) -> Bool { contains(frozenDays, date) }
    func isToday(_ date: Date) -> Bool { calendar.isDateInToday(date) }

    // هل اليوم موجود في القائمة؟
    private func contains(_ list: [DateComponents], _ date: Date) -> Bool {
        let c = calendar.dateComponents([.year, .month, .day], from: date)
        return list.contains { $0.year == c.year && $0.month == c.month && $0.day == c.day }
    }
}
