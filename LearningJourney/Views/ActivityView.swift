import SwiftUI

struct ActivityView: View {
    
    // بيانات الايام حق التقويم الي فوق
    // الحروف وأرقام الأيام، وأي يوم هو اليوم، وأي أيام تعلّم فيه اليوزر
    
    //هنا سويت ربط للفيو مودل
    @StateObject private var viewModel = ActivityViewModel()
    @State private var showGoal = false
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
                Button {
                    showGoal = true
                } label: {                    Image(systemName: "pencil.and.outline")
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
            // هنا سويت ربط بين فيو و فيو موديل
            HStack(spacing: 12) {
                StatCard(icon: "flame.fill", iconColor: Color("AppOrange"), value: viewModel.learnedDays, label: "Learned")
                StatCard(icon: "snowflake", iconColor: .cyan, value: viewModel.freezedDays, label: "Freezed")
            }
            Spacer()

            // الدايرة الكبيرة: Log as Learned
            //استدعاءglassEffect
            Button {
                viewModel.logAsLearned()
            } label: {
                Text(viewModel.logTitle)
                    .font(.headline)
                    .foregroundStyle(viewModel.isLoggedToday ? .gray : .white)
                    .frame(width: 273, height: 273)
                    .background(viewModel.isLoggedToday ? Color.gray.opacity(0.25) : Color("AppOrange"), in: Circle())
                    .glassEffect(.regular, in: Circle())
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoggedToday)
            .frame(maxWidth: .infinity)
            //هنا سويت ربط وحذفت الكود الي قبل
            
            // زر Freeze
            //هنا حجم الزر تعدل واضفت العرض حقه
            Button {
                viewModel.freezeToday()
            } label: {
                Text(viewModel.freezeTitle)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .glassButton(selected: viewModel.canFreeze, tint: .cyan)
            .disabled(!viewModel.canFreeze)
            .frame(maxWidth: .infinity)

            Text(viewModel.freezeStatus)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding()
        .navigationDestination(isPresented: $showGoal) {
            LearningGoalView(viewModel: GoalViewModel())
        }
    }
}
struct StatCard: View {
    let icon: String
    let iconColor: Color
    let value: Int
    let label: String

    // لو الرقم 1 نكتب day، وغير كذا days
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
