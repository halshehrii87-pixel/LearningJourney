// هذا الكود معاه التنبيه الصغير
//تفاعلي
// استجابه


import SwiftUI

struct LearningGoalView: View {
    // نستخدم نفس الـ ViewModel (مو نسخة جديدة)
    @ObservedObject var viewModel: GoalViewModel
    @ObservedObject var activityViewModel: ActivityViewModel
    //الشاشة تستقبل الـ ViewModel من برا، ما تنشئه هي. وبكذا Onboarding وهذي الشاشة يشاركون نفس البيانات
    
    @State private var showAlert = false
    @Environment(\.dismiss) private var dismiss
    //صندوق يحفظ "هل التنبيه ظاهر الحين؟". يبدأ false.
    

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("I want to learn")
                    .padding(.top, 24)

                TextField("Swift", text: $viewModel.subject)
                Divider()

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
            }
            .padding()
            .navigationTitle("Learning Goal")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    // دائرة زجاج عادية بدون تكبير عند الضغط
                    .glassIconButton()
                }
                // يخفي الخلفية الافتراضية من النظام
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAlert = true
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    // دائرة زجاج برتقالية بدون تكبير عند الضغط
                    .glassIconButton(tint: Color("AppOrange"))
                    // يتعطل الزر إذا ما كتبتي هدف
                    .disabled(!viewModel.isGoalValid)
                }
                // يخفي الخلفية الزجاجية الافتراضية من النظام عشان ما تصير زجاجين فوق بعض
                .sharedBackgroundVisibility(.hidden)
            }
            .alert("Update goal", isPresented: $showAlert) {
                //تنبيه Update goal الجاهز من آبل، مع زرّي Dismiss وUpdate
                
                
                Button("Dismiss", role: .cancel) { }
                Button("Update") {
                    activityViewModel.resetStreak()
                    
                    // هنا عشان ترجع صفحه تحديث القول لصفحت الاساسيه بدون ما اضغط زر السهم 
                    dismiss()
                }
            } message: {
                Text("If you update now, your streak will start over.")
            }
        }
    }
}

#Preview {
    LearningGoalView(viewModel: GoalViewModel(), activityViewModel: ActivityViewModel())
}
