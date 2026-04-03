# 다마고치 iOS 앱 — Xcode 설정 가이드

## 파일 구조

```
ios/
├── Shared/
│   ├── PetModel.swift         ← 게임 데이터 모델 + 픽셀 스프라이트
│   └── GameManager.swift      ← 게임 로직 + 타이머
├── App/
│   ├── TamagotchiApp.swift    ← @main 진입점
│   ├── ContentView.swift      ← 메인 UI
│   ├── PetPixelView.swift     ← Canvas 픽셀 아트 렌더러
│   └── StatBarView.swift      ← 블록 세그먼트 스탯 바
└── Widget/
    ├── TamagotchiWidget.swift ← 홈 화면 위젯
    └── TamagotchiWidgetBundle.swift
```

---

## Xcode 프로젝트 설정

### 1. 메인 앱 프로젝트 생성

1. Xcode → **File > New > Project**
2. **iOS > App** 선택
3. 설정:
   - **Product Name**: `Tamagotchi`
   - **Bundle Identifier**: `com.junginyu.tamagotchi`
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Minimum Deployments**: iOS 17.0

### 2. 소스 파일 추가

Project Navigator에서:
- `App/` 폴더 그룹 생성 후 `TamagotchiApp.swift`, `ContentView.swift`, `PetPixelView.swift`, `StatBarView.swift` 추가
- `Shared/` 폴더 그룹 생성 후 `PetModel.swift`, `GameManager.swift` 추가
- Xcode가 자동 생성한 기본 파일들 삭제 (ContentView, App 등)

### 3. Press Start 2P 폰트 추가

1. [Google Fonts](https://fonts.google.com/specimen/Press+Start+2P)에서 `PressStart2P-Regular.ttf` 다운로드
2. Project Navigator에 드래그 앤 드롭 (Target Membership: Tamagotchi 체크)
3. `Info.plist` → **Fonts provided by application** 키 추가 → 값: `PressStart2P-Regular.ttf`

### 4. Widget Extension 추가

1. Xcode → **File > New > Target**
2. **Widget Extension** 선택
3. 설정:
   - **Product Name**: `TamagotchiWidget`
   - **Bundle Identifier**: `com.junginyu.tamagotchi.widget`
   - Include Configuration Intent: **체크 해제**
4. Xcode가 자동 생성한 Widget 파일 삭제
5. `Widget/TamagotchiWidget.swift`, `Widget/TamagotchiWidgetBundle.swift` 추가
   - Target Membership: **TamagotchiWidget** 체크
6. `Shared/PetModel.swift`, `Shared/GameManager.swift`도 Widget target에 추가
   - File Inspector → Target Membership에서 TamagotchiWidget 체크

### 5. App Group 설정

앱과 위젯이 데이터를 공유하려면 App Group이 필요합니다.

**메인 앱:**
1. Project → Tamagotchi target → **Signing & Capabilities**
2. **+ Capability** → **App Groups**
3. `+` 클릭 → `group.com.junginyu.tamagotchi` 입력

**위젯 Extension:**
1. TamagotchiWidget target → **Signing & Capabilities**
2. **+ Capability** → **App Groups**
3. 동일하게 `group.com.junginyu.tamagotchi` 추가

### 6. Info.plist 설정 (위젯)

`TamagotchiWidget/Info.plist`에 폰트 추가:
```xml
<key>UIAppFonts</key>
<array>
    <string>PressStart2P-Regular.ttf</string>
</array>
```

---

## 빌드 및 실행

```bash
# 시뮬레이터 실행
xcodebuild -scheme Tamagotchi -destination 'platform=iOS Simulator,name=iPhone 15' build

# 또는 Xcode에서 Cmd+R
```

---

## 위젯 테스트

1. 시뮬레이터에서 앱 실행 후 홈 화면으로 이동
2. 홈 화면 길게 탭 → 위젯 추가 (+)
3. "다마고치" 검색 → 소형(Small) 또는 중형(Medium) 선택

---

## 주요 상수 (PetModel.swift)

| 상수 | 값 | 설명 |
|------|-----|------|
| kTickInterval | 5.0s | 게임 틱 주기 |
| kHungerDecay | 3/틱 | 배고픔 감소량 |
| kHappyDecay | 2/틱 | 행복 감소량 |
| kHealthDmg | 2/틱 | 위험 시 체력 감소 |
| kSleepEnergy | 6/틱 | 수면 시 에너지 회복 |
| kMaxOfflineTicks | 120틱 | 오프라인 최대 패널티 (~10분) |

---

## Bundle ID 참고

| Target | Bundle ID |
|--------|-----------|
| 메인 앱 | `com.junginyu.tamagotchi` |
| 위젯 | `com.junginyu.tamagotchi.widget` |
| App Group | `group.com.junginyu.tamagotchi` |

> Bundle ID의 `junginyu` 부분을 본인의 Team ID 또는 식별자로 변경하세요.
