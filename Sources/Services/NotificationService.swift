import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    private init() {}
    
    func scheduleNotification(for item: RecallItem, delay: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "1시간 전의 기억이 도착했습니다! 🔮"
        content.body = "미뤄두었던 기억을 되살려 퀴즈를 맞추고 일정을 캘린더에 예약해 보세요!"
        content.sound = .default
        content.badge = 1
        
        // Add item ID to userInfo to handle relaunching
        content.userInfo = ["itemId": item.id.uuidString]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: item.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Scheduled notification for \(item.id.uuidString) in \(delay) seconds.")
            }
        }
    }
    
    func cancelNotification(for item: RecallItem) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id.uuidString])
    }
}
