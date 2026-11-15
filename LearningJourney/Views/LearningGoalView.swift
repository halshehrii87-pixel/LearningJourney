// هذا الكود معاه التنبيه الصغير
//تفاعلي
// استجابه


import SwiftUI

struct LearningGoalView: View {
    // نستخدم نفس الـ ViewModel (مو نسخة جديدة)
    @ObservedObject var viewModel: GoalViewModel
    //الشاشة تستقبل الـ ViewModel من برا، ما تنشئه هي. وبكذا Onboarding وهذي الشاشة يشاركون نفس البيانات
    
    @State private var showAlert = false
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //يرسمون الشريط الفوقي، وفيه العنوان وزر ✓
                        showAlert = true
                        
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .glassButton()
                }
            }
            .alert("Update goal", isPresented: $showAlert) {
                //تنبيه Update goal الجاهز من آبل، مع زرّي Dismiss وUpdate
                
                
                Button("Dismiss", role: .cancel) { }
                Button("Update") {
                    // نكتب فعل التحديث لاحقاً (تصفير الـ Streak)
                }
            } message: {
                Text("If you update now, your streak will start over.")
            }
        }
    }
}

#Preview {
    LearningGoalView(viewModel: GoalViewModel())
}
