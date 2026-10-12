import Foundation
import EventKit

class ReminderService {
    static let shared = ReminderService()
    
    private let eventStore = EKEventStore()
    
    private init() {}
    
    func addEventToCalendar(title: String, dueDate: Date) {
        // Request appropriate access based on iOS version
        if #available(iOS 17.0, *) {
            eventStore.requestWriteOnlyAccessToEvents { [weak self] granted, error in
                guard let self = self, granted, error == nil else {
                    print("Calendar permission denied or error: \(String(describing: error))")
                    return
                }
                self.createEvent(title: title, dueDate: dueDate)
            }
        } else {
            eventStore.requestAccess(to: .event) { [weak self] granted, error in
                guard let self = self, granted, error == nil else {
                    print("Calendar permission denied or error: \(String(describing: error))")
                    return
                }
                self.createEvent(title: title, dueDate: dueDate)
            }
        }
    }
    
    private func createEvent(title: String, dueDate: Date) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = dueDate
        // Set event duration to 30 minutes
        event.endDate = dueDate.addingTimeInterval(1800)
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        // Add alarm 15 minutes before due date
        let alarm = EKAlarm(relativeOffset: -900)
        event.addAlarm(alarm)
        
        do {
            try eventStore.save(event, span: .thisEvent)
            print("Successfully added event to system calendar: \(title)")
        } catch {
            print("Failed to save event to calendar: \(error.localizedDescription)")
        }
    }
}
