import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = GoalViewModel()
    @State private var goToActivity = false
 var body: some View {
     ZStack(alignment: .top) {
         Image(systemName: "flame.fill")
         // هنا أيقونةالنار ومعلوماتها كاملة مع المقاسات "SF"
         //تاخذ كامل العرض، وبكذا تتوسّط "frame"
         
             .font(.system(size: 44))
             .foregroundStyle(Color("AppOrange"))
             .padding(.top, 60)
         
         VStack(alignment: .leading, spacing: 16) {
             // هنا صندوق "عمودي" يرتبلي كل اللي داخله من فوق لتحت
             //يعني محاذاة الكلام او اي شيء لجهة البداية"leading"
             //يعني مسافة 16 بين كل عنصر "spacing"
             
             
             Text("Hello \(Text("Learner").fontWeight(.heavy))")
                 .font(.system(size: 34))
                 .padding(.top, 80)
                 
             
             Text("This app will help you learn everyday!")
                 .font(.subheadline)
                 .foregroundStyle(.secondary)
             //".secondary" هنا خليته لون رمادي عشان  يختاره النظام، ويتغير تلقائي بين الفاتح والغامق (عشان لايت و دارك)
             
             Text("I want to learn")
                 .font(.system(size: 16))
                 .padding(.top, 24)
             
             TextField("Swift", text: $viewModel.subject)            
             
             //"Swift" الكلام الباهت اللي يختفي لما يكتب اليوزر.
             //علامة $ تربط الخانة بالصندوق: كل حرف يكتبه اليوزر ينحفظ في
             //"subject" علطووول
             
             Text("I want to learn it in a")
                 .padding(.top, 16)
             
             HStack(spacing: 12) {
                 ForEach(viewModel.durations, id: \.self) { duration in
                     Button {
                         viewModel.selectedDuration = duration
                     } label: {
                         Text(duration)
                             .padding(.horizontal, 12)
                             .padding(.vertical, 4)
                             .foregroundStyle(viewModel.selectedDuration == duration ? .white : .secondary)
                     }
                     .glassButton(selected: viewModel.selectedDuration == duration)
                 }
             }
             
             Spacer()
             
             Button {
                 goToActivity = true             } label: {
                 Text("Start Learning")
                     .padding(.horizontal, 24)
                     .padding(.vertical, 6)
             }
             .glassButton()
             .frame(maxWidth: .infinity)
             
             Text("You can edit your desire later")
                 .font(.system(size: 12))
                 .foregroundStyle(.secondary)
                 .frame(maxWidth: .infinity)
         }
         .padding()
         .padding(.top, 100)
         
         .navigationDestination(isPresented: $goToActivity) {
             ActivityView(goalViewModel: viewModel)
                 .navigationBarBackButtonHidden(true)
         }
         //180 هذا حق الايقونه مسافه بين الخط و الشكل
         //.padding() يعطي الشاشة كلها مسافة من الأطراف
     }
    }
}

#Preview {
    OnboardingView()
}
