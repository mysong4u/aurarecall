import SwiftUI

struct ContentView: View {
    @StateObject private var storage = StorageManager.shared
    
    @State private var selectedItemForRecall: RecallItem? = nil
    @State private var recallDescription: String = ""
    @State private var recallDeadline: Date = Date().addingTimeInterval(3600)
    @State private var guessedCorrectly: Bool = true
    
    @State private var isDemoMode: Bool = true // Enabled by default for easy App Review testing!
    @State private var animationPulse: Bool = false
    @State private var showCompletedHistory: Bool = false
    
    // Timer to check countdowns and trigger auto recall pops
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    let columns = [
        GridItem(.adaptive(minimum: 75, maximum: 90), spacing: 15)
    ]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background Glow
                Color(red: 0.05, green: 0.05, blue: 0.08)
                    .ignoresSafeArea()
                
                // Pulsing Ambient Aura Orbs
                Circle()
                    .fill(Color.indigo.opacity(0.12))
                    .frame(width: geo.size.width * 1.3, height: geo.size.width * 1.3)
                    .blur(radius: 70)
                    .position(x: geo.size.width / 2, y: -geo.size.height * 0.1)
                
                Circle()
                    .fill(Color.mint.opacity(0.08))
                    .frame(width: geo.size.width * 1.0, height: geo.size.width * 1.0)
                    .blur(radius: 60)
                    .position(x: geo.size.width * 0.8, y: geo.size.height * 0.9)
                
                VStack(spacing: 0) {
                    // Header with Score
                    headerView
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Demo Mode Toggle Banner
                            demoModeBanner
                                .padding(.horizontal)
                            
                            // Postponed Pending Queue Section
                            pendingQueueSection
                            
                            // Grid of Postpone Icons
                            postponeGridSection
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 30)
                    }
                }
                
                // RECALL QUIZ MODAL OVERLAY (Dementia Prevention Quiz)
                if let item = selectedItemForRecall {
                    recallQuizOverlay(for: item)
                }
            }
            .onReceive(timer) { _ in
                checkPendingItemsForRecall()
            }
            .sheet(isPresented: $showCompletedHistory) {
                HistoryView()
            }
        }
    }
    
    // MARK: - Header & Cognitive Score View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("AuraRecall")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("원클릭 미루기 & 치매 예방 회상")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Score Pill Badge
            Button(action: { showCompletedHistory = true }) {
                VStack(alignment: .trailing, spacing: 2) {
                    HStack(spacing: 6) {
                        Image(systemName: "brain.head.profile")
                            .foregroundColor(.mint)
                        Text("\(Int(cognitiveScore))%")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    Text("기억 성취율 (\(storage.correctRecalledCount)/\(storage.totalRecalledCount))")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.04))
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.mint.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(.vertical, 10)
    }
    
    // MARK: - Prototyping Demo Mode Banner
    private var demoModeBanner: some View {
        HStack {
            Image(systemName: "clock.arrow.2.circlepath")
                .font(.system(size: 22))
                .foregroundColor(.yellow)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("데모 테스트 모드 (Quick Demo Mode)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                Text(isDemoMode ? "아이콘 클릭 시 5초 후에 회상 알림 퀴즈가 울립니다." : "아이콘 클릭 시 1시간 후에 회상 알림 퀴즈가 울립니다.")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Toggle("", isOn: $isDemoMode)
                .toggleStyle(SwitchToggleStyle(tint: .yellow))
                .labelsHidden()
        }
        .padding()
        .background(Color.white.opacity(0.03))
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(isDemoMode ? Color.yellow.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
    
    // MARK: - Pending Queue Section
    private var pendingQueueSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("지연된 기억 대기열")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("\(storage.pendingItems.count)개 대기 중")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundColor(.indigo)
            }
            .padding(.horizontal)
            
            if storage.pendingItems.isEmpty {
                // Empty State
                VStack(spacing: 8) {
                    Image(systemName: "tray.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white.opacity(0.15))
                    Text("대기 중인 기억이 없습니다. 아래 아이콘을 눌러 미뤄보세요!")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.white.opacity(0.02))
                .cornerRadius(20)
                .padding(.horizontal)
            } else {
                // Horizontal Pending scroll view
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(storage.pendingItems) { item in
                            Button(action: {
                                withAnimation {
                                    openRecallQuiz(for: item)
                                }
                            }) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(item.iconName.categoryColor.opacity(0.15))
                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: item.iconName)
                                            .font(.system(size: 22))
                                            .foregroundColor(item.iconName.categoryColor)
                                    }
                                    
                                    // Countdown Timer text
                                    Text(timeRemainingString(from: item))
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 85, height: 100)
                                .background(Color.white.opacity(0.03))
                                .cornerRadius(18)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(item.iconName.categoryColor.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    // MARK: - Postpone Icon Grid Section
    private var postponeGridSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("지금 바쁘니까, 이 분류로 일단 미루기 (1초 원탭)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.gray)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(storage.categories) { cat in
                    Button(action: {
                        triggerHapticFeedback()
                        // Register item
                        let delay: TimeInterval = isDemoMode ? 5.0 : 3600.0
                        let newItem = RecallItem(iconName: cat.iconName)
                        storage.pendingItems.append(newItem)
                        
                        NotificationService.shared.scheduleNotification(for: newItem, delay: delay)
                    }) {
                        VStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(cat.color.opacity(0.12))
                                    .frame(width: 54, height: 54)
                                    .shadow(color: cat.color.opacity(0.2), radius: 6)
                                
                                Image(systemName: cat.iconName)
                                    .font(.system(size: 24))
                                    .foregroundColor(cat.color)
                            }
                            
                            Text(cat.label)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 80, height: 105)
                        .background(Color.white.opacity(0.02))
                        .cornerRadius(18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white.opacity(0.03), lineWidth: 1)
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Recall Quiz Overlay View
    private func recallQuizOverlay(for item: RecallItem) -> some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header Ring
                    VStack(spacing: 8) {
                        Text("두뇌 인지 회상 퀴즈! 🔮")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.mint)
                        
                        Text("1시간 전(데모 5초 전)에 미뤄두었던 이 아이콘은 과연 어떤 기억이었나요? 기억해 내어 맞춰보세요!")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal)
                    }
                    
                    // Huge Glowing Icon
                    ZStack {
                        Circle()
                            .fill(item.iconName.categoryColor.opacity(0.2))
                            .frame(width: 110, height: 110)
                            .blur(radius: animationPulse ? 15 : 5)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    animationPulse = true
                                }
                            }
                        
                        Image(systemName: item.iconName)
                            .font(.system(size: 50))
                            .foregroundColor(item.iconName.categoryColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Task Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("할 일 상세 정보 입력")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.gray)
                            
                            TextField("예: 고혈압 약 복용하기, 철수 전화 회신", text: $recallDescription)
                                .padding()
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(14)
                                .foregroundColor(.white)
                        }
                        
                        // Deadline Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("캘린더 예약 일시 지정")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.gray)
                            
                            DatePicker("", selection: $recallDeadline, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(14)
                        }
                        
                        // Cognitive Correctness Checkbox
                        Toggle(isOn: $guessedCorrectly) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.mint)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("스스로 올바르게 기억해 내셨나요?")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("정확히 기억하고 맞췄다면 체크해 주세요!")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .mint))
                        .padding()
                        .background(Color.white.opacity(0.04))
                        .cornerRadius(14)
                    }
                    .padding(.horizontal)
                    
                    // Submit and close buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            triggerHapticSuccess()
                            storage.recallSuccess(
                                item: item,
                                description: recallDescription,
                                deadline: recallDeadline,
                                guessedCorrectly: guessedCorrectly
                            )
                            selectedItemForRecall = nil
                        }) {
                            Text("기억 일치 및 캘린더 등록")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(Color.mint)
                                .cornerRadius(16)
                        }
                        .disabled(recallDescription.isEmpty)
                        .opacity(recallDescription.isEmpty ? 0.5 : 1.0)
                        
                        Button(action: {
                            selectedItemForRecall = nil
                        }) {
                            Text("기억 안 남 (나중에 하기)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 4)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 30)
            }
            .background(Color(red: 0.08, green: 0.08, blue: 0.12))
            .cornerRadius(28)
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(item.iconName.categoryColor.opacity(0.4), lineWidth: 1.5)
            )
            .padding()
        }
    }
    
    // MARK: - Helper Methods
    private var cognitiveScore: Double {
        guard storage.totalRecalledCount > 0 else { return 100.0 }
        return (Double(storage.correctRecalledCount) / Double(storage.totalRecalledCount)) * 100.0
    }
    
    private func checkPendingItemsForRecall() {
        guard selectedItemForRecall == nil else { return }
        
        let now = Date()
        for item in storage.pendingItems {
            let elapsed = now.timeIntervalSince(item.postponeTime)
            let limit: TimeInterval = isDemoMode ? 5.0 : 3600.0
            
            if elapsed >= limit {
                openRecallQuiz(for: item)
                break
            }
        }
    }
    
    private func openRecallQuiz(for item: RecallItem) {
        selectedItemForRecall = item
        recallDescription = ""
        recallDeadline = Date().addingTimeInterval(3600) // Default 1 hour later
        guessedCorrectly = true
    }
    
    private func timeRemainingString(from item: RecallItem) -> String {
        let now = Date()
        let elapsed = now.timeIntervalSince(item.postponeTime)
        let limit: TimeInterval = isDemoMode ? 5.0 : 3600.0
        let remaining = limit - elapsed
        
        if remaining <= 0 {
            return "RECALL!"
        }
        
        let mins = Int(remaining) / 60
        let secs = Int(remaining) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    private func triggerHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func triggerHapticSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

// MARK: - Cognitive History List Sheet View
struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var storage = StorageManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.05, green: 0.05, blue: 0.08)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("완료된 회상 훈련 기록")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    if storage.completedItems.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.1))
                            Text("완료된 기억 훈련 기록이 아직 없습니다.")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(storage.completedItems.reversed()) { item in
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(item.iconName.categoryColor.opacity(0.12))
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: item.iconName)
                                            .font(.system(size: 20))
                                            .foregroundColor(item.iconName.categoryColor)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.description)
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                        Text("미룬시점: \(formattedDate(item.postponeTime)) ➔ 예약: \(formattedDate(item.deadline))")
                                            .font(.system(size: 10, weight: .semibold))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    // Guesed correctly status icon
                                    Image(systemName: item.recallSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(item.recallSuccess ? .mint : .red)
                                }
                                .padding(.vertical, 4)
                                .listRowBackground(Color.white.opacity(0.01))
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.mint))
        }
        .preferredColorScheme(.dark)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
