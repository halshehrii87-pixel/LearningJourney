import SwiftUI

struct ActivityView: View {
    
    // بيانات الايام حق التقويم الي فوق
    // الحروف وأرقام الأيام، وأي يوم هو اليوم، وأي أيام تعلّم فيه اليوزر
    
    private let weekLetters = ["S", "M", "T", "W", "T", "F", "S"]
    private let weekDays = [20, 21, 22, 23, 24, 25, 26]
    private let today = 24
    private let learnedDays = [20, 21, 22, 23]

    
    // لون الدائرة ححقت التاريخ حسب نوع اليوم
    private func circleColor(for day: Int) -> Color {
        if day == today {
            return Color("AppOrange")
        } else if learnedDays.contains(day) {
            // هنا حددت الشفافية للون البرتقالي
            
            return Color("AppOrange").opacity(0.25)
        } else {
            return .clear
        }
    }

    // لون الرقم حسب نوع اليوم Freeze/Learned
    private func numberColor(for day: Int) -> Color {
        if day == today {
            return .white
        } else if learnedDays.contains(day) {
            return Color("AppOrange")
        } else {
            return .primary
        }
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // الهيدر: العنوان والتاريخ على اليسار، والزرين على اليمين
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Activity")
                        .font(.largeTitle)
                        .bold()
                    Text("Thursday, 24 October")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button { } label: {
                    Image(systemName: "calendar")
                }
                .glassButton(selected: false)
                .buttonBorderShape(.circle)
                
//هنا استدعاء ايقونه القلم
                Button { } label: {
                    Image(systemName: "pencil.and.outline")
                }
                .glassButton(selected: false)
                .buttonBorderShape(.circle)
            }
            // صف أيام الأسبوع
            HStack {
                ForEach(weekDays.indices, id: \.self) { index in
                    // هنا اعطي الامر اذ اليوزر سوا شيء غيرة واذا لا لا تغير*
                    
                    
                    let day = weekDays[index]
                    VStack(spacing: 8) {
                        Text(weekLetters[index])
                            .font(.caption2)
                            .foregroundStyle(.secondary)

                        ZStack {
                            Circle()
                                .fill(circleColor(for: day))
                            //دالة، يعني أمر كتبته مرة وحدة واصير انادي عليه
                            
                            Text("\(day)")
                            // عشان يحول الرقم الي نص عشان ينعرض
                                .font(.subheadline)
                                .foregroundStyle(numberColor(for: day))
                        }
                        .frame(width: 40, height: 40)
                    }
                    .frame(maxWidth: .infinity)
                    //على كل عمود: عشان يوزّع لي الـ 7 أعمدة بالتساوي على عرض الشاشة 
                }
            }
            
            //   بطاقتين الإحصائيات حقت ال days
            HStack(spacing: 12) {
                StatCard(icon: "flame.fill", iconColor: Color("AppOrange"), value: 4, label: "Learned")
                StatCard(icon: "snowflake", iconColor: .cyan, value: 0, label: "Freezed")
            }
            Spacer()

            // الدايرة الكبيرة: Log as Learned
            Button { } label: {
                Text("Log as Learned")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 260, height: 260)
                    .background(Color("AppOrange"), in: Circle())
            }
            .frame(maxWidth: .infinity)

            Spacer()

            // زر Freeze
            //هنا حجم الزر تعدل واضفت العرض حقه
            Button { } label: {
                Text("Freeze for a day")
                    .frame(width: 272, height: 46)
            }
            .glassButton(tint: .cyan)
            .frame(maxWidth: .infinity)

            Text("0 out of 2 Freezes used")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding()
    }
}
struct StatCard: View {
    let icon: String
    let iconColor: Color
    let value: Int
    let label: String

    // لو الرقم 1 نكتب day، وغير كذا days (حسب ملاحظة التصميم)
    private var unit: String {
        value == 1 ? "day" : "days"
    }

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
            Text("\(Text("\(value)").fontWeight(.bold)) \(unit)")
                .font(.subheadline)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .glassEffect(in: .rect(cornerRadius: 24))
    }
}
#Preview {
    ActivityView()
}
