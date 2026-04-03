import Foundation
import Combine
import WidgetKit

// MARK: - GameManager

final class GameManager: ObservableObject {

    static let shared = GameManager()

    @Published var pet:     PetState = PetState()
    @Published var message: String?  = nil  // toast text (set → auto-clears)

    private var timer:       AnyCancellable?
    private var msgTimer:    DispatchWorkItem?
    private let defaults:    UserDefaults

    private init() {
        defaults = UserDefaults(suiteName: kAppGroup) ?? .standard
        load()
        startTimer()
    }

    // MARK: - Persistence

    func save() {
        pet.lastSaved = Date()
        if let data = try? JSONEncoder().encode(pet) {
            defaults.set(data, forKey: kSaveKey)
        }
        WidgetCenter.shared.reloadAllTimelines()
    }

    func load() {
        guard
            let data  = defaults.data(forKey: kSaveKey),
            let saved = try? JSONDecoder().decode(PetState.self, from: data)
        else { return }

        pet = saved

        // Apply offline decay
        let elapsed = Date().timeIntervalSince(pet.lastSaved)
        let ticks   = min(Int(elapsed / kTickInterval), kMaxOfflineTicks)
        if !pet.isDead && ticks > 0 {
            pet.applyDecay(ticks: ticks)
            pet.calcMood()
            if ticks > 6 {
                showMsg("자리를 비웠네요!\n펫 상태를 확인해주세요")
            }
        }
    }

    // MARK: - Game Loop

    func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: kTickInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.tick() }
    }

    func pauseTimer() {
        timer?.cancel()
        timer = nil
    }

    private func tick() {
        guard !pet.isDead else { return }

        pet.age += kTickInterval / 60.0
        let didLevelUp = pet.updateStage()

        if pet.isSleeping {
            pet.energy = min(100, pet.energy + kSleepEnergy)
            pet.hunger = max(0,   pet.hunger - kSleepHunger)
            if pet.energy >= 100 {
                pet.isSleeping = false
                showMsg("잘 잤어요! 이제 놀아요! ☀️")
            }
        } else {
            pet.applyDecay(ticks: 1)
        }

        if pet.health <= 0 {
            pet.isDead = true
            showMsg("펫이 무지개 다리를 건넜어요... 😢\n탭해서 새 펫을 키워요!")
        }

        if didLevelUp {
            showMsg("성장했어요!\n\(pet.stage.label) 🎉")
        }

        pet.calcMood()
        save()
    }

    // MARK: - Actions

    func feed() {
        guard !pet.isDead else { showMsg("펫이 없어요..."); return }
        guard !pet.isSleeping else { showMsg("자고 있어요! 💤"); return }
        guard pet.hunger < 100 else { showMsg("배가 너무 불러요! 🤭"); return }

        pet.hunger    = min(100, pet.hunger    + 25)
        pet.happiness = min(100, pet.happiness + 5)
        showMsg("냠냠! 맛있다! 🍎")
        finish()
    }

    func play() {
        guard !pet.isDead else { showMsg("펫이 없어요..."); return }
        guard !pet.isSleeping else { showMsg("자고 있어요! 💤"); return }
        guard pet.energy >= 15 else { showMsg("너무 피곤해요! 재워주세요 😴"); return }
        guard pet.happiness < 100 else { showMsg("이미 너무 행복해요! 🥳"); return }

        pet.happiness = min(100, pet.happiness + 20)
        pet.energy    = max(0,   pet.energy    - 15)
        pet.hunger    = max(0,   pet.hunger    - 5)
        let msgs = ["신난다! 같이 놀아요! 🎮", "야호! 재밌어요! ⭐", "더 놀고 싶어요! 🎉"]
        showMsg(msgs.randomElement()!)
        finish()
    }

    func toggleSleep() {
        guard !pet.isDead else { showMsg("펫이 없어요..."); return }

        if pet.isSleeping {
            pet.isSleeping = false
            showMsg("일어났어요! 좋은 아침이에요! ☀️")
        } else {
            guard pet.energy < 95 else { showMsg("아직 안 피곤해요! 🙅"); return }
            pet.isSleeping = true
            showMsg("쿨쿨... 자는 중이에요 💤")
        }
        finish()
    }

    func heal() {
        guard !pet.isDead else { showMsg("펫이 없어요..."); return }
        guard !pet.isSleeping else { showMsg("자고 있어요! 💤"); return }
        guard pet.health < 100 else { showMsg("이미 건강해요! 💪"); return }

        pet.health = min(100, pet.health + 30)
        showMsg("약을 먹었어요! 건강해져요! 💊")
        finish()
    }

    func reset() {
        pet = PetState()
        pet.calcMood()
        save()
        showMsg("새로운 펫이 태어났어요! 🎉\n잘 부탁드려요!")
    }

    // MARK: - Helpers

    private func finish() {
        pet.calcMood()
        save()
    }

    func showMsg(_ text: String) {
        msgTimer?.cancel()
        message = text
        let work = DispatchWorkItem { [weak self] in self?.message = nil }
        msgTimer = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8, execute: work)
    }
}
