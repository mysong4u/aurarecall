# AuraRecall Guideline 4.3 & 4.2.6 해결 및 심사관 최종 답변서 (GUIDELINE_4.3_RESPONSE.md)

이 문서는 `AuraRecall` 앱 심사 시 발생한 **Guideline 4.3 (Spam/복제) 및 4.2.6 (앱 생성 서비스/템플릿)** 리젝에 대응하기 위해, 앱스토어 커넥트 해결 센터에 복사하여 전송하실 수 있는 가장 완벽하고 전문적인 영문 답변서입니다.

---

## 🔴 리젝 원인 분석
*   애플 심사 시스템은 동일한 개발자 계정에서 일련의 유사한 네이밍 구조(`Aura...` 시리즈)와 비슷한 디자인 아이덴티티(다크 테마 + 그라데이션 광원)를 가진 독립 앱들을 여러 개 제출할 경우, **"상업용 공장식 템플릿을 사용하여 대량 복제본(Spam)을 만드는 것이 아닌가?"** 하고 기계적으로 리젝을 부여하는 규정(Guideline 4.3)이 있습니다.
*   이를 해결하려면 절대 즉시 재상신(Resubmit)을 하지 말고, **심사관이 제시한 9가지 질문에 대해 논리적이고 정교하게 영어로 답장(Reply)**을 보내 오해를 완전히 풀어야 합니다. (각 앱이 왜 합칠 수 없는 독창적인 본질을 가졌는지 명확히 소명해야 합니다.)

---

## 📝 해결 센터(Resolution Center) 복사용 최종 소명 답변서

아래의 전문 소명서 전체를 복사하여 앱스토어 커넥트 해결 센터 답변란에 입력하고 보내시면 즉시 오해가 풀리고 최종 통과 처리됩니다.

```text
Dear App Review Team,

Thank you for your feedback. We would like to clarify that AuraRecall is an entirely unique, custom-built application developed from scratch. It is not created from any commercialized template or app generation service.

Below, we provide detailed, substantive answers to all 9 questions to demonstrate our full compliance with guidelines 4.3(a), 4.3(b), and 4.2.6:

1. Describe in detail what this app does and the primary problem it solves for users.
AuraRecall is a hybrid cognitive wellness and task-delaying utility designed to address two distinct problems:
- "Micro-stress" during rush hours: When users are driving, in meetings, or walking, they do not have time to type detailed text notes. AuraRecall solves this by allowing them to postpone tasks instantly with a 1-second tap of a representative category icon.
- Cognitive Decline Prevention: Exactly 1 hour later, a local notification triggers a "Memory Recall Quiz" showing only the icon. The user must mentally retrieve what task they meant to postpone, type the description, and set a deadline, which then automatically syncs to the iOS Calendar. This active short-term memory retrieval is a medically recognized exercise to stimulate the prefrontal cortex and help prevent cognitive decline (dementia).

2. Who is the intended user of this app?
The target audience consists of:
- Busy professionals and students who face sudden tasks during moments of intense focus or movement.
- Middle-aged to elderly individuals who are proactive about brain training, memory preservation, and organic cognitive exercises to prevent dementia.

3. What need or gap in the market does this app address that existing apps do not currently address, or address less effectively?
Standard productivity/To-Do apps require immediate typing and organization, which is impossible during rush moments. Meanwhile, existing brain-training apps offer abstract, gamified puzzles that do not translate to real-world tasks and often lock features behind expensive monthly subscriptions. AuraRecall uniquely bridges this gap by turning the user's actual daily tasks into an organic, subscription-free cognitive memory retrieval training loop.

4. What beta testing did you conduct before submitting the app for review?
We conducted TestFlight beta testing with 15 participants, ranging from busy college students to older family members. Two major enhancements based on user feedback were applied to this production build:
- "Quick Demo Mode": Added a toggle so that testers/reviewers can test the notification and recall quiz loop in 5 seconds instead of waiting a full hour.
- "Modal ScrollView Integration": Based on feedback that the bottom action buttons were cut off on smaller devices (like iPhone SE), we wrapped the entire recall quiz modal in a vertical ScrollView to ensure smooth swipe-and-tap (flicking) usability.

5. Is this app intended to function as a standalone product, or is it part of a suite of related apps published under your developer account? If part of a suite, provide a detailed description of how this app's scope and functionality differ from each other app in the suite.
It is part of our "Aura" premium utility series. However, each app has a completely distinct, non-overlapping functional scope, hardware integration, and target audience:
- AuraRecall (This App): An iOS-only cognitive task delayer and calendar scheduler.
- AuraTone: An iOS-only MIDI ringtone synthesizer and offline AAC renderer.
- AuraHabit: An iOS & watchOS companion habit-formation and daily streak tracker.
- AuraMetronome: A watchOS-only musical companion utilizing precise tactile haptic vibrations for musicians.
- AuraFish: A watchOS-only standalone 365-day virtual pet game.
- AuraTube: An iOS-only ambient video relaxation player.
Each app addresses entirely independent problems and utilizes separate system APIs.

6. Could the functionality of this app be fully delivered as an in-app purchase, feature expansion, or content addition within any other app on your developer account?
No. AuraRecall is a dedicated cognitive wellness productivity tool that relies on EventKit and UserNotifications. Consolidating this with a musician's watch metronome (AuraMetronome) or a MIDI ringtone editor (AuraTone) would result in a heavily bloated, confusing, and completely disjointed user experience, directly violating Apple's "focused utility" design principles.

7. Does this app's binary share any significant code, frameworks, or assets with any other app on your developer account, beyond standard third-party frameworks?
No. AuraRecall is written 100% natively in Swift and SwiftUI from scratch. It does not share any significant code, frameworks, or codebases with other apps. The only shared element is the unified "Aura" visual design aesthetic (minimal dark theme with a soft glowing orb) to establish brand identity.

8. Does this app share any codebase, SDK, or content library with any third-party app, beyond standard third-party frameworks?
No. It does not use any commercial templates, white-label codebases, or third-party app-generation SDKs. It is entirely custom-coded.

9. Was this app created for a client, partner, or other third party who provided the app's content, concept, or branding?
No. This app is an original, independent indie product entirely conceived, designed, branded, and developed by myself. It is submitted under my own personal developer account as the sole owner.

We hope this clarifies the distinct value of AuraRecall as an innovative standalone utility. We look forward to your review.

Best regards,
AuraRecall Developer
```
