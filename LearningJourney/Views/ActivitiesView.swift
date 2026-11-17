import SwiftUI

// ═══════════════════════════════════════════════
// شاشة Activities: التقويم (عرض فقط، بدون ضغط على الأيام)
// تعرض 12 شهر من الشهر الحالي، بسكرول عمودي
// ═══════════════════════════════════════════════
struct ActivitiesView: View {

    // زر الرجوع: dismiss() يسكر الشاشة ويرجع للي قبلها
    @Environment(\.dismiss) private var dismiss

    // الدماغ: يعطينا الأشهر والأيام ويقرر مين برتقالي ومين أزرق
    // (الـView ما يحسب شي بنفسه، بس يعرض اللي يقوله الـViewModel)
    let viewModel: CalendarViewModel

    // الأعمدة: 7 أعمدة = 7 أيام في الأسبوع
    // .flexible() يعني كل عمود ياخذ عرض متساوي
    // spacing: 0 ← مسافة بين الأعمدة
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    // ───────────── الشاشة كاملة ─────────────
    var body: some View {
        VStack(spacing: 0) {

            // الجزء الأعلى (الرجوع + العنوان) معرّف تحت باسم header
            header

            // ScrollView: يخلي المحتوى ينزل بسكرول
            ScrollView {

                // LazyVStack: أشهر تحت بعض، "Lazy" يعني ما يرسم الشهر إلا لما يقرب يظهر
                // spacing: 28 ← المسافة بين الشهر والشهر اللي بعده
                LazyVStack(alignment: .leading, spacing: 28) {

                    // نكرر الرسم لكل شهر من الـ12 شهر
                    ForEach(viewModel.months, id: \.self) { month in
                        monthSection(month)   // يرسم شهر واحد (معرّف تحت)
                        Divider()             // خط رفيع يفصل بين الأشهرش          // خط رفيع يفصل بين الأشهر
                    }
                }
                .padding(.horizontal)   // مسافة يمين ويسار الشاشة
                .padding(.top, 16)      // مسافة فوق أول شهر
            }
        }
        // نخفي زر الرجوع الجاهز عشان نرسم زرنا (زي Sketch)
        .navigationBarBackButtonHidden(true)
    }

    // ───────────── الجزء الأعلى: زر الرجوع + عنوان "Activities" ─────────────
    private var header: some View {

        // ZStack: يحط العناصر فوق بعض (العنوان في النص، والزر على الجنب)
        ZStack {

            // العنوان في النص
            Text("Activities")
                .font(.headline)

            // الصف اللي فيه الزر + Spacer يدفعه لأقصى اليسار
            HStack {
                Button {
                    dismiss()   // لما تضغطين: يرجع للشاشة اللي قبل
                } label: {
                    Image(systemName: "chevron.left")   // السهم (اسم SF Symbol)
                        .font(.headline)
                        .foregroundStyle(.primary)       // لونه يتغير حسب الوضع (فاتح/داكن)
                        .frame(width: 44, height: 44)    // حجم الدائرة
                        .glassEffect(.regular, in: Circle())   // تأثير الزجاج (Liquid Glass)
                }
                .buttonStyle(.plain)   // يشيل الشكل الافتراضي للزر

                Spacer()   // مسافة فاضية تدفع الزر لليسار
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    // ───────────── شهر واحد: العنوان + أسماء الأيام + الأيام ─────────────
    private func monthSection(_ month: Date) -> some View {

        // VStack: العنوان فوق، والجدول تحته
        VStack(alignment: .leading, spacing: 12) {

            // عنوان الشهر مثل "November 2026" (من ViewModel)
            Text(viewModel.title(for: month))
                .font(.headline)

            // LazyVGrid: جدول بـ7 أعمدة، والعناصر تنزل صف بعد صف
            // spacing: 8 ← المسافة العمودية بين صفوف الأيام
            LazyVGrid(columns: columns, spacing: 8) {

                // الصف الأول: أسماء الأيام SUN MON TUE ...
                ForEach(viewModel.weekdays, id: \.self) { name in
                    Text(name)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                // بعده: الأيام (قبل أول يوم تجي خانات فاضية nil)
                ForEach(Array(viewModel.days(in: month).enumerated()), id: \.offset) { _, date in

                    // إذا فيه تاريخ ← ارسمي اليوم
                    if let date {
                        dayCell(date)
                    } else {
                        // إذا فاضي ← مربع شفاف بنفس الارتفاع عشان الترتيب يمشي
                        Color.clear.frame(height: 40)
                    }
                }
            }
        }
    }

    // ───────────── يوم واحد: رقم داخل دائرة ملونة ─────────────
    private func dayCell(_ date: Date) -> some View {

        // نسأل ViewModel عن حالة هذا اليوم (هو اللي يقرر)
        let learned = viewModel.isLearned(date)   // برتقالي
        let frozen = viewModel.isFrozen(date)     // أزرق
        let today = viewModel.isToday(date)       // اليوم الحالي

        // لون الرقم: أزرق إذا Freeze، برتقالي إذا Learned، أبيض إذا اليوم، وإلا عادي
        let textColor: Color = frozen ? .cyan : (learned ? Color("AppOrange") : (today ? .white : .primary))

        // لون الدائرة من ورا الرقم (opacity = الشفافية، 0 مختفي و1 ممتلئ)
        let fillColor: Color = frozen ? Color.cyan.opacity(0.2) : (learned ? Color("AppOrange").opacity(0.25) : (today ? Color("AppOrange") : .clear))

        return Text(viewModel.dayNumber(date))   // رقم اليوم
            .font(.body)
            .foregroundStyle(textColor)
            .frame(width: 40, height: 40)         // حجم الدائرة (غيريه مع height: 40 فوق)
            .background(fillColor, in: Circle())
    }
}

// ───────────── المعاينة: بيانات تجريبية بس عشان نشوف الشكل ─────────────
#Preview {
    NavigationStack {
        ActivitiesView(viewModel: CalendarViewModel(
            learnedDays: [
                DateComponents(year: 2026, month: 11, day: 15),
                DateComponents(year: 2026, month: 11, day: 16)
            ],
            frozenDays: [
                DateComponents(year: 2026, month: 11, day: 14)
            ]
        ))
    }
}
