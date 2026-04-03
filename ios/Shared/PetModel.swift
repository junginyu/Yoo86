import Foundation

// MARK: - Game Constants

let kTickInterval: TimeInterval = 5.0
let kHungerDecay:  Double = 3
let kHappyDecay:   Double = 2
let kHealthDmg:    Double = 2
let kHealthRegen:  Double = 1
let kSleepEnergy:  Double = 6
let kSleepHunger:  Double = 1
let kMaxOfflineTicks: Int = 120
let kAppGroup = "group.com.junginyu.tamagotchi"
let kSaveKey  = "tama_pet_ios"

// MARK: - Enums

enum PetStage: String, Codable, CaseIterable {
    case baby, child, teen, adult

    var label: String {
        switch self {
        case .baby:  return "EGG"
        case .child: return "CHILD"
        case .teen:  return "TEEN"
        case .adult: return "ADULT"
        }
    }
}

enum PetMood: String, Codable {
    case happy, sad, hungry, sick, sleeping, dead
}

// MARK: - PetState

struct PetState: Codable {
    var stage:      PetStage = .baby
    var mood:       PetMood  = .happy
    var hunger:     Double   = 100   // 0-100
    var happiness:  Double   = 100
    var health:     Double   = 100
    var energy:     Double   = 100
    var age:        Double   = 0     // game-minutes
    var isSleeping: Bool     = false
    var isDead:     Bool     = false
    var lastSaved:  Date     = Date()

    mutating func calcMood() {
        if isDead     { mood = .dead;     return }
        if isSleeping { mood = .sleeping; return }
        if health    < 30 { mood = .sick;   return }
        if hunger    < 25 { mood = .hungry; return }
        if happiness < 25 { mood = .sad;    return }
        mood = .happy
    }

    @discardableResult
    mutating func updateStage() -> Bool {
        let prev = stage
        if      age <  2 { stage = .baby  }
        else if age < 10 { stage = .child }
        else if age < 30 { stage = .teen  }
        else             { stage = .adult }
        return stage != prev
    }

    mutating func applyDecay(ticks: Int) {
        let n = min(ticks, 200)
        for _ in 0..<n {
            if isDead { break }
            hunger    = max(0, hunger    - kHungerDecay)
            happiness = max(0, happiness - kHappyDecay)
            if hunger < 20 || happiness < 20 {
                health = max(0, health - kHealthDmg)
            } else if hunger > 60 && happiness > 60 {
                health = min(100, health + kHealthRegen)
            }
        }
    }
}

// MARK: - Pixel Sprites

typealias PixelSprite = [[Bool]]

/// Parse sprite from string rows. '.' = off (light), any other char = on (dark).
private func px(_ rows: [String]) -> PixelSprite {
    rows.map { $0.map { $0 != "." } }
}

// ── Baby (12×12) ──────────────────────────────────────────────────────────────

let BABY_H: PixelSprite = px([   // happy
    "....XXXX....",
    "..XX....XX..",
    ".X.XX..XX.X.",
    ".X........X.",
    ".X..XXXX..X.",
    "..XX....XX..",
    "....XXXX....",
    "............",
    "............",
    "............",
    "............",
    "............",
])

let BABY_S: PixelSprite = px([   // sad
    "....XXXX....",
    "..XX....XX..",
    ".X.XX..XX.X.",
    ".X........X.",
    ".XX.XXXX.XX.",
    "..XX....XX..",
    "....XXXX....",
    "............",
    "............",
    "............",
    "............",
    "............",
])

let BABY_K: PixelSprite = px([   // sick
    "....XXXX....",
    "..XX....XX..",
    ".X.X.XX.X.X.",
    ".X........X.",
    ".XX.X..X.XX.",
    "..XX.XX.XX..",
    "....XXXX....",
    "............",
    "............",
    "............",
    "............",
    "............",
])

let BABY_Z: PixelSprite = px([   // sleeping
    "....XXXX....",
    "..XX....XX..",
    ".XXXXXXXXXX.",
    ".X..XX....X.",
    ".X..XX....X.",
    "..XX....XX..",
    "....XXXX....",
    "............",
    "............",
    "............",
    "............",
    "............",
])

let BABY_D: PixelSprite = px([   // dead
    "....XXXX....",
    "..XX....XX..",
    ".X.X.XX.X.X.",
    ".X........X.",
    ".X........X.",
    "..XX....XX..",
    "....XXXX....",
    "............",
    "............",
    "............",
    "............",
    "............",
])

// ── Child (12×12) ─────────────────────────────────────────────────────────────

let CHILD_H: PixelSprite = px([  // happy
    "....XXXX....",
    "..XXXXXXXX..",
    ".X.XX..XX.X.",
    ".XXXXXXXXXX.",
    ".X..XXXX..X.",
    ".XXXXXXXXXX.",
    "..XXXXXXXX..",
    "...XX..XX...",
    "...XX..XX...",
    "............",
    "............",
    "............",
])

let CHILD_S: PixelSprite = px([  // sad
    "....XXXX....",
    "..XXXXXXXX..",
    ".X.XX..XX.X.",
    ".XXXXXXXXXX.",
    ".XX.XXXX.XX.",
    ".XXXXXXXXXX.",
    "..XXXXXXXX..",
    "...XX..XX...",
    "...XX..XX...",
    "............",
    "............",
    "............",
])

let CHILD_K: PixelSprite = px([  // sick
    "....XXXX....",
    "..XXXXXXXX..",
    ".X.X.XX.X.X.",
    ".XXXXXXXXXX.",
    ".XX.X..X.XX.",
    ".XXXXXXXXXX.",
    "..XXXXXXXX..",
    "...XX..XX...",
    "...XX..XX...",
    "............",
    "............",
    "............",
])

let CHILD_Z: PixelSprite = px([  // sleeping
    "....XXXX....",
    "..XXXXXXXX..",
    ".XXXXXXXXXX.",
    ".XXXXXXXXXX.",
    ".X..XXXX..X.",
    ".XXXXXXXXXX.",
    "..XXXXXXXX..",
    "...XX..XX...",
    "............",
    "............",
    "............",
    "............",
])

let CHILD_D: PixelSprite = px([  // dead
    "....XXXX....",
    "..XXXXXXXX..",
    ".X.X.XX.X.X.",
    ".XXXXXXXXXX.",
    ".X........X.",
    ".XXXXXXXXXX.",
    "..XXXXXXXX..",
    "...XX..XX...",
    "...XX..XX...",
    "............",
    "............",
    "............",
])

// ── Teen (12×12) ──────────────────────────────────────────────────────────────

let TEEN_H: PixelSprite = px([   // happy
    "..XXXXXXXX..",
    ".XXXXXXXXXX.",
    "XX.XX..XX.XX",
    "XXXXXXXXXXXX",
    "XX.XXXXXX.XX",
    ".XXXXXXXXXX.",
    "..XXXXXXXX..",
    "...XX..XX...",
    "..XXX..XXX..",
    "............",
    "............",
    "............",
])

let TEEN_S: PixelSprite = px([   // sad
    "..XXXXXXXX..",
    ".XXXXXXXXXX.",
    "XX.XX..XX.XX",
    "XXXXXXXXXXXX",
    "XXX.XXXX.XXX",
    ".XXXXXXXXXX.",
    "..XXXXXXXX..",
    "...XX..XX...",
    "..XXX..XXX..",
    "............",
    "............",
    "............",
])

let TEEN_K: PixelSprite = px([   // sick
    "..XXXXXXXX..",
    ".XXXXXXXXXX.",
    "XX.X.XX.X.XX",
    "XXXXXXXXXXXX",
    "XX.X..X..XX.",
    ".XXXXXXXXXX.",
    "..XXXXXXXX..",
    "...XX..XX...",
    "..XXX..XXX..",
    "............",
    "............",
    "............",
])

let TEEN_Z: PixelSprite = px([   // sleeping
    "..XXXXXXXX..",
    ".XXXXXXXXXX.",
    "XXXXXXXXXXXX",
    "XXXXXXXXXXXX",
    "XX.XXXXXX.XX",
    ".XXXXXXXXXX.",
    "..XXXXXXXX..",
    "...XX..XX...",
    "............",
    "............",
    "............",
    "............",
])

let TEEN_D: PixelSprite = px([   // dead
    "..XXXXXXXX..",
    ".XXXXXXXXXX.",
    "XX.X.XX.X.XX",
    "XXXXXXXXXXXX",
    "XX........XX",
    ".XXXXXXXXXX.",
    "..XXXXXXXX..",
    "...XX..XX...",
    "..XXX..XXX..",
    "............",
    "............",
    "............",
])

// ── Adult (12×12) ─────────────────────────────────────────────────────────────

let ADULT_H: PixelSprite = px([  // happy
    ".XXXXXXXXXX.",
    "X.XXXXXXXX.X",
    "X.XX....XX.X",
    "XXXXXXXXXXXX",
    "X..XXXXXX..X",
    "XXXXXXXXXXXX",
    "X.XXXXXXXX.X",
    ".XXXXXXXXXX.",
    "...XX..XX...",
    "..XXX..XXX..",
    "............",
    "............",
])

let ADULT_S: PixelSprite = px([  // sad
    ".XXXXXXXXXX.",
    "X.XXXXXXXX.X",
    "X.XX....XX.X",
    "XXXXXXXXXXXX",
    "X.XXXXXXXX.X",
    "XXXXXXXXXXXX",
    "X.XXXXXXXX.X",
    ".XXXXXXXXXX.",
    "...XX..XX...",
    "..XXX..XXX..",
    "............",
    "............",
])

let ADULT_K: PixelSprite = px([  // sick
    ".XXXXXXXXXX.",
    "X.XXXXXXXX.X",
    "X.X.XXXX.X.X",
    "XXXXXXXXXXXX",
    "X.XX....XX.X",
    "XXXXXXXXXXXX",
    "X.XXXXXXXX.X",
    ".XXXXXXXXXX.",
    "...XX..XX...",
    "..XXX..XXX..",
    "............",
    "............",
])

let ADULT_Z: PixelSprite = px([  // sleeping
    ".XXXXXXXXXX.",
    "X.XXXXXXXX.X",
    "XXXXXXXXXXXX",
    "XXXXXXXXXXXX",
    "X..XXXXXX..X",
    "XXXXXXXXXXXX",
    "X.XXXXXXXX.X",
    ".XXXXXXXXXX.",
    "...XX..XX...",
    "............",
    "............",
    "............",
])

let ADULT_D: PixelSprite = px([  // dead
    ".XXXXXXXXXX.",
    "X.XXXXXXXX.X",
    "X.X.XXXX.X.X",
    "XXXXXXXXXXXX",
    "X..........X",
    "XXXXXXXXXXXX",
    "X.XXXXXXXX.X",
    ".XXXXXXXXXX.",
    "...XX..XX...",
    "..XXX..XXX..",
    "............",
    "............",
])

// ── Effect Sprites ────────────────────────────────────────────────────────────

let Z_BIG: PixelSprite = px([    // 5×5
    "XXXXX",
    "....X",
    "..X..",
    "X....",
    "XXXXX",
])

let Z_SML: PixelSprite = px([    // 3×5
    "XXX",
    "..X",
    ".X.",
    "X..",
    "XXX",
])

let HEART: PixelSprite = px([    // 5×5
    ".X.X.",
    "XXXXX",
    "XXXXX",
    ".XXX.",
    "..X..",
])

// ── Sprite Lookup ─────────────────────────────────────────────────────────────

let PIXEL_SPRITES: [PetStage: [PetMood: PixelSprite]] = [
    .baby:  [.happy: BABY_H,  .sad: BABY_S,  .hungry: BABY_H,  .sick: BABY_K,  .sleeping: BABY_Z,  .dead: BABY_D],
    .child: [.happy: CHILD_H, .sad: CHILD_S, .hungry: CHILD_S, .sick: CHILD_K, .sleeping: CHILD_Z, .dead: CHILD_D],
    .teen:  [.happy: TEEN_H,  .sad: TEEN_S,  .hungry: TEEN_S,  .sick: TEEN_K,  .sleeping: TEEN_Z,  .dead: TEEN_D],
    .adult: [.happy: ADULT_H, .sad: ADULT_S, .hungry: ADULT_S, .sick: ADULT_K, .sleeping: ADULT_Z, .dead: ADULT_D],
]

func getSprite(stage: PetStage, mood: PetMood) -> PixelSprite {
    PIXEL_SPRITES[stage]?[mood] ?? BABY_H
}
