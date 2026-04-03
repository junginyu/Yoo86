import WidgetKit
import SwiftUI

// MARK: - Timeline Entry

struct TamagotchiEntry: TimelineEntry {
    let date: Date
    let pet:  PetState
}

// MARK: - Timeline Provider

struct TamagotchiProvider: TimelineProvider {

    func placeholder(in context: Context) -> TamagotchiEntry {
        TamagotchiEntry(date: Date(), pet: PetState())
    }

    func getSnapshot(in context: Context, completion: @escaping (TamagotchiEntry) -> Void) {
        completion(TamagotchiEntry(date: Date(), pet: loadPet()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TamagotchiEntry>) -> Void) {
        var pet = loadPet()

        // Apply offline decay for widget display
        let elapsed = Date().timeIntervalSince(pet.lastSaved)
        let ticks   = min(Int(elapsed / kTickInterval), kMaxOfflineTicks)
        if !pet.isDead && ticks > 0 {
            pet.applyDecay(ticks: ticks)
            pet.calcMood()
        }

        let entry    = TamagotchiEntry(date: Date(), pet: pet)
        // Refresh every 5 minutes
        let nextDate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextDate))
        completion(timeline)
    }

    private func loadPet() -> PetState {
        let defaults = UserDefaults(suiteName: kAppGroup) ?? .standard
        guard
            let data = defaults.data(forKey: kSaveKey),
            let pet  = try? JSONDecoder().decode(PetState.self, from: data)
        else { return PetState() }
        return pet
    }
}

// MARK: - Small Widget View (systemSmall)

struct SmallWidgetView: View {
    let entry: TamagotchiEntry

    var body: some View {
        ZStack {
            Color.gbLight.ignoresSafeArea()

            // LCD grid overlay
            Canvas { ctx, size in
                let c = Color(white: 0, opacity: 0.06)
                var x: CGFloat = 0
                while x < size.width {
                    ctx.fill(Path(CGRect(x: x, y: 0, width: 0.5, height: size.height)), with: .color(c))
                    x += 2
                }
            }
            .allowsHitTesting(false)

            VStack(spacing: 4) {
                Text(entry.pet.stage.label)
                    .font(.custom("Press Start 2P", size: 6))
                    .foregroundColor(.gbDark)

                PetPixelView(pet: entry.pet, pixelSize: 4)

                Text(moodLabel)
                    .font(.custom("Press Start 2P", size: 6))
                    .foregroundColor(.gbDark)

                // Mini health dots
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { i in
                        Circle()
                            .fill(Double(i) * 20 < entry.pet.health ? Color.gbDark : Color.gbDark.opacity(0.2))
                            .frame(width: 5, height: 5)
                    }
                }
            }
            .padding(8)
        }
    }

    private var moodLabel: String {
        switch entry.pet.mood {
        case .happy:    return ":)"
        case .sad:      return ":("
        case .hungry:   return ":P"
        case .sick:     return "X("
        case .sleeping: return "zzz"
        case .dead:     return "RIP"
        }
    }
}

// MARK: - Medium Widget View (systemMedium)

struct MediumWidgetView: View {
    let entry: TamagotchiEntry

    var body: some View {
        ZStack {
            Color.gbLight.ignoresSafeArea()

            HStack(spacing: 12) {
                // Pet display
                VStack(spacing: 4) {
                    Text(entry.pet.stage.label)
                        .font(.custom("Press Start 2P", size: 6))
                        .foregroundColor(.gbDark)

                    PetPixelView(pet: entry.pet, pixelSize: 4)

                    Text(timeString)
                        .font(.custom("Press Start 2P", size: 6))
                        .foregroundColor(.gbDark)
                }

                // Stats
                VStack(alignment: .leading, spacing: 4) {
                    MiniStatBar(label: "FOOD",  value: entry.pet.hunger)
                    MiniStatBar(label: "HAPPY", value: entry.pet.happiness)
                    MiniStatBar(label: "HLTH",  value: entry.pet.health)
                    MiniStatBar(label: "ENRG",  value: entry.pet.energy)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(10)
        }
    }

    private var timeString: String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: entry.date)
    }
}

// MARK: - MiniStatBar (for widget)

struct MiniStatBar: View {
    let label: String
    let value: Double

    private var filled: Int { Int((value / 10).rounded()) }

    var body: some View {
        HStack(spacing: 2) {
            Text(label)
                .font(.custom("Press Start 2P", size: 4))
                .foregroundColor(.gbDark)
                .frame(width: 32, alignment: .leading)

            HStack(spacing: 1) {
                ForEach(0..<10, id: \.self) { i in
                    Rectangle()
                        .fill(i < filled ? Color.gbDark : Color.gbDark.opacity(0.15))
                        .frame(height: 5)
                }
            }
        }
    }
}

// MARK: - Widget Configuration

struct TamagotchiWidget: Widget {
    let kind = "TamagotchiWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamagotchiProvider()) { entry in
            TamagotchiWidgetEntryView(entry: entry)
                .widgetURL(URL(string: "tamagotchi://open"))
        }
        .configurationDisplayName("다마고치")
        .description("내 다마고치 상태를 확인하세요")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct TamagotchiWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: TamagotchiEntry

    var body: some View {
        switch family {
        case .systemSmall:  SmallWidgetView(entry: entry)
        case .systemMedium: MediumWidgetView(entry: entry)
        default:            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    TamagotchiWidget()
} timeline: {
    TamagotchiEntry(date: .now, pet: PetState())
}
