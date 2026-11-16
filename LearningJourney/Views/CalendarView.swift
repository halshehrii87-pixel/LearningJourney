import SwiftUI
import UIKit

struct CalendarView: UIViewRepresentable {

    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.calendar = Calendar(identifier: .gregorian)
        return calendarView
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {
    }
}

#Preview {
    CalendarView()
}
