import Foundation
import SwiftUI

struct RecallItem: Identifiable, Codable, Hashable {
    let id: UUID
    let iconName: String
    let postponeTime: Date
    var isRecalled: Bool
    var description: String
    var deadline: Date
    var recallSuccess: Bool // True if guessed correctly, False if forgotten / wrong
    
    init(iconName: String, postponeTime: Date = Date()) {
        self.id = UUID()
        self.iconName = iconName
        self.postponeTime = postponeTime
        self.isRecalled = false
        self.description = ""
        self.deadline = Date().addingTimeInterval(3600) // Default 1 hour later
        self.recallSuccess = false
    }
}

struct IconCategory: Identifiable, Hashable {
    let id = UUID()
    let iconName: String
    let label: String
    let color: Color
}

class StorageManager: ObservableObject {
    static let shared = StorageManager()
    
    @Published var pendingItems: [RecallItem] = [] {
        didSet { saveItems() }
    }
    
    @Published var completedItems: [RecallItem] = [] {
        didSet { saveCompleted() }
    }
    
    // Cognitive scores stats
    @Published var totalRecalledCount: Int = 0
    @Published var correctRecalledCount: Int = 0
    
    let categories: [IconCategory] = [
        IconCategory(iconName: "pills.fill", label: "약 복용", color: .pink),
        IconCategory(iconName: "cart.fill", label: "장보기", color: .orange),
        IconCategory(iconName: "phone.fill", label: "전화 연락", color: .green),
        IconCategory(iconName: "car.fill", label: "운전/차량", color: .blue),
        IconCategory(iconName: "cup.and.saucer.fill", label: "커피/약속", color: .purple),
        IconCategory(iconName: "briefcase.fill", label: "회사/업무", color: .indigo),
        IconCategory(iconName: "book.fill", label: "독서/공부", color: .teal),
        IconCategory(iconName: "drop.fill", label: "식물 물주기", color: .cyan),
        IconCategory(iconName: "house.fill", label: "집안 청소", color: .yellow),
        IconCategory(iconName: "dollarsign.circle.fill", label: "은행/이체", color: .green),
        IconCategory(iconName: "wrench.and.screwdriver.fill", label: "수리/정비", color: .gray),
        IconCategory(iconName: "heart.fill", label: "운동/건강", color: .red),
        IconCategory(iconName: "gamecontroller.fill", label: "휴식/게임", color: .mint),
        IconCategory(iconName: "envelope.fill", label: "우편/메일", color: .blue),
        IconCategory(iconName: "gift.fill", label: "선물/기념일", color: .pink),
        IconCategory(iconName: "pawprint.fill", label: "반려동물", color: .orange),
        IconCategory(iconName: "scissors", label: "미용/헤어", color: .purple),
        IconCategory(iconName: "trash.fill", label: "분리수거", color: .gray),
        IconCategory(iconName: "lightbulb.fill", label: "아이디어", color: .yellow),
        IconCategory(iconName: "calendar", label: "중요 행사", color: .indigo)
    ]
    
    private init() {
        loadItems()
        loadCompleted()
        loadStats()
    }
    
    func postponeIcon(iconName: String) {
        let newItem = RecallItem(iconName: iconName)
        pendingItems.append(newItem)
        
        // Schedule local push notification (in 1 hour = 3600 seconds)
        // For debugging/testing, we can toggle this easily.
        NotificationService.shared.scheduleNotification(for: newItem, delay: 3600)
    }
    
    func recallSuccess(item: RecallItem, description: String, deadline: Date, guessedCorrectly: Bool) {
        if let idx = pendingItems.firstIndex(where: { $0.id == item.id }) {
            var completedItem = pendingItems[idx]
            completedItem.isRecalled = true
            completedItem.description = description
            completedItem.deadline = deadline
            completedItem.recallSuccess = guessedCorrectly
            
            pendingItems.remove(at: idx)
            completedItems.append(completedItem)
            
            // Add to system calendar
            ReminderService.shared.addEventToCalendar(
                title: "\(completedItem.iconName.categoryLabel): \(description)",
                dueDate: deadline
            )
            
            // Update stats
            totalRecalledCount += 1
            if guessedCorrectly {
                correctRecalledCount += 1
            }
            saveStats()
        }
    }
    
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(pendingItems) {
            UserDefaults.standard.set(encoded, forKey: "AuraRecall_Pending")
        }
    }
    
    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: "AuraRecall_Pending"),
           let decoded = try? JSONDecoder().decode([RecallItem].self, from: data) {
            pendingItems = decoded
        }
    }
    
    private func saveCompleted() {
        if let encoded = try? JSONEncoder().encode(completedItems) {
            UserDefaults.standard.set(encoded, forKey: "AuraRecall_Completed")
        }
    }
    
    private func loadCompleted() {
        if let data = UserDefaults.standard.data(forKey: "AuraRecall_Completed"),
           let decoded = try? JSONDecoder().decode([RecallItem].self, from: data) {
            completedItems = decoded
        }
    }
    
    private func saveStats() {
        UserDefaults.standard.set(totalRecalledCount, forKey: "AuraRecall_TotalStats")
        UserDefaults.standard.set(correctRecalledCount, forKey: "AuraRecall_CorrectStats")
    }
    
    private func loadStats() {
        totalRecalledCount = UserDefaults.standard.integer(forKey: "AuraRecall_TotalStats")
        correctRecalledCount = UserDefaults.standard.integer(forKey: "AuraRecall_CorrectStats")
    }
}

// Convert SF Symbol names to Korean label easily
extension String {
    var categoryLabel: String {
        switch self {
        case "pills.fill": return "약 복용"
        case "cart.fill": return "장보기"
        case "phone.fill": return "전화 연락"
        case "car.fill": return "운전/차량"
        case "cup.and.saucer.fill": return "커피/약속"
        case "briefcase.fill": return "회사/업무"
        case "book.fill": return "독서/공부"
        case "drop.fill": return "식물 물주기"
        case "house.fill": return "집안 청소"
        case "dollarsign.circle.fill": return "은행/이체"
        case "wrench.and.screwdriver.fill": return "수리/정비"
        case "heart.fill": return "운동/건강"
        case "gamecontroller.fill": return "휴식/게임"
        case "envelope.fill": return "우편/메일"
        case "gift.fill": return "선물/기념일"
        case "pawprint.fill": return "반려동물"
        case "scissors": return "미용/헤어"
        case "trash.fill": return "분리수거"
        case "lightbulb.fill": return "아이디어"
        case "calendar": return "중요 행사"
        default: return "미룬 일"
        }
    }
    
    var categoryColor: Color {
        switch self {
        case "pills.fill", "gift.fill": return .pink
        case "cart.fill", "pawprint.fill": return .orange
        case "phone.fill", "dollarsign.circle.fill": return .green
        case "car.fill", "envelope.fill": return .blue
        case "cup.and.saucer.fill", "scissors": return .purple
        case "briefcase.fill", "calendar": return .indigo
        case "book.fill": return .teal
        case "drop.fill": return .cyan
        case "house.fill", "lightbulb.fill": return .yellow
        case "wrench.and.screwdriver.fill", "trash.fill": return .gray
        case "heart.fill": return .red
        case "gamecontroller.fill": return .mint
        default: return .white
        }
    }
}
