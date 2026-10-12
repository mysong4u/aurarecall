import SwiftUI
import UserNotifications
import EventKit

@main
struct AuraRecallApp: App {
    init() {
        requestNotificationPermission()
        requestCalendarPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification authorization granted.")
            } else if let error = error {
                print("Notification authorization failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func requestCalendarPermission() {
        let eventStore = EKEventStore()
        if #available(iOS 17.0, *) {
            eventStore.requestWriteOnlyAccessToEvents { granted, error in
                if granted {
                    print("Calendar write-only access granted.")
                } else if let error = error {
                    print("Calendar authorization failed: \(error.localizedDescription)")
                }
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, error in
                if granted {
                    print("Calendar access granted.")
                } else if let error = error {
                    print("Calendar authorization failed: \(error.localizedDescription)")
                }
            }
        }
    }
}
