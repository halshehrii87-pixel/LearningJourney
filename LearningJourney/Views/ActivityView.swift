import SwiftUI

struct ActivityView: View {
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

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ActivityView()
}
