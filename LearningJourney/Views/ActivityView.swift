import SwiftUI

struct ActivityView: View {
    
    // بيانات الايام حق التقويم الي فوق
    // الحروف وأرقام الأيام، وأي يوم هو اليوم، وأي أيام تعلّم فيه اليوزر
    
    //هنا سويت ربط للفيو مودل
    @StateObject private var viewModel = ActivityViewModel()
    @State private var showGoal = false
    @State private var showCalendar = false
    @ObservedObject var goalViewModel: GoalViewModel
    private let weekLetters = ["S", "M", "T", "W", "T", "F", "S"]
    private var weekDays: [Int] { viewModel.weekDays }
    private var today: Int { viewModel.todayNumber }
    private let learnedDays: [Int] = []

    
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
                    // viewModelهنا ربط تغيير التاريخ بشاشة ال
                    Text(viewModel.todayTitle)                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
                
//هنا زر الكالندر
                Button {
                    showCalendar = true
                } label: {                    Image(systemName: "calendar")
                }
                .glassIconButton()
//هنا استدعاء ايقونه القلم
                Button {
                    showGoal = true
                } label: {                    Image(systemName: "pencil.and.outline")
                }
                .glassIconButton()
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

            if viewModel.isGoalCompleted {
                GoalCompletedView {
                    showGoal = true
                }
            } else if viewModel.isGoalFailed {
                GoalNotMetView {
                    showGoal = true
                }
            } else {
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
            }
            
            Spacer()
        }
        .padding()
        
        
        .onAppear {
            viewModel.maxFreezes = goalViewModel.maxFreezes
            viewModel.goalDays = goalViewModel.goalDays
            viewModel.checkStreak()
            //هنا عدلت تحديثات الفريز يعني لكل شهر كم يكون فيه تجميد
        }
        .navigationDestination(isPresented: $showGoal) {
            LearningGoalView(viewModel: goalViewModel, activityViewModel: viewModel)
        }
        .navigationDestination(isPresented: $showCalendar) {
  
            //نمرر القوائم للتقويم
            ActivitiesView(viewModel: CalendarViewModel(
                learnedDays: viewModel.learnedDates,
                frozenDays: viewModel.frozenDates
            ))       }
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
    ActivityView(goalViewModel: GoalViewModel())
}


// شاشة "اكتمل الهدف" (تظهر بدل الدايرة وزر Freeze)
struct GoalCompletedView: View {
    // الزر يخبر الشاشة الأم إن المستخدم يبي هدف جديد
    var onSetGoal: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // الأيقونة (SF Symbol) بدل الإيموجي
            Image(systemName: "hands.sparkles.fill")
                .font(.system(size: 44))
                .foregroundStyle(Color("AppOrange"))
                .padding(.bottom, 12)

            Text("Well done!")
                .font(.title2)
                .bold()

            Text("Ready for your next goal?")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                onSetGoal()
                // هنا ابغى تغيير الحجم للخط حقSet a goal
            } label: {
                Label("Set a goal", systemImage: "pencil.and.outline")
                    .font(.body)
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
            }
            .glassButton(selected: true, tint: Color("AppOrange"))
            .padding(.top, 48)
        }
        .frame(maxWidth: .infinity)
    }
}


// شاشة "اكتمل الهدف" (تظهر بدل الدايرة وزر Freeze)
struct GoalNotMetView: View {
    // الزر يخبر الشاشة الأم إن المستخدم يبي هدف جديد
    var onSetGoal: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // الأيقونة (SF Symbol) بدل الإيموجي
            Image(systemName: "xmark.seal")
                .font(.system(size: 44))
                .foregroundStyle(Color("AppOrange"))
                .padding(.bottom, 12)

            Text("You didn't reach your goal this time.")
                .font(.title2)
                .bold()

            Text("Want to set another goal?")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                onSetGoal()
                // هنا ابغى تغيير الحجم للخط حقSet a goal
            } label: {
                Label("Set a goal", systemImage: "pencil.and.outline")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
            }
            .glassButton(selected: true, tint: Color("AppOrange"))
            .padding(.top, 48)
        }
        .frame(maxWidth: .infinity)
    }
}
