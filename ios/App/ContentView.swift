import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @StateObject private var game = GameManager.shared

    var body: some View {
        ZStack {
            // Starfield background
            Color(red: 0.047, green: 0.047, blue: 0.118).ignoresSafeArea()
            StarfieldView()

            DeviceView(game: game)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            game.pauseTimer()
            game.save()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            game.load()
            game.startTimer()
        }
    }
}

// MARK: - DeviceView

struct DeviceView: View {
    @ObservedObject var game: GameManager

    var body: some View {
        ZStack(alignment: .top) {
            // ── Device body ──────────────────────────────────────
            EggShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.878, green: 0.769, blue: 1.0),
                            Color(red: 0.753, green: 0.565, blue: 0.910),
                            Color(red: 0.533, green: 0.314, blue: 0.753),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.6), radius: 20, x: 0, y: 12)
                .overlay(
                    EggShape()
                        .stroke(Color(red: 0.376, green: 0.188, blue: 0.627), lineWidth: 2.5)
                )

            VStack(spacing: 0) {
                Spacer().frame(height: 28)

                // ── Chain hole ───────────────────────────────────
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(red: 0.502, green: 0.314, blue: 0.784),
                                     Color(red: 0.251, green: 0.125, blue: 0.502)],
                            center: .topLeading,
                            startRadius: 0, endRadius: 12
                        )
                    )
                    .frame(width: 20, height: 20)
                    .overlay(Circle().stroke(Color(red: 0.165, green: 0.063, blue: 0.439), lineWidth: 2.5))
                    .shadow(color: .black.opacity(0.4), radius: 4)

                Spacer().frame(height: 10)

                // ── Screen bezel ─────────────────────────────────
                ScreenView(game: game)
                    .padding(.horizontal, 20)

                Spacer().frame(height: 14)

                // ── Controls ─────────────────────────────────────
                ControlsView(game: game)
                    .padding(.horizontal, 18)

                Spacer().frame(height: 26)
            }
        }
        .frame(width: 270, height: 480)
        // Toast overlay
        .overlay(alignment: .bottom) {
            ToastView(message: game.message)
                .padding(.bottom, -60)
        }
    }
}

// MARK: - ScreenView

struct ScreenView: View {
    @ObservedObject var game: GameManager
    @State private var timeStr = ""

    var body: some View {
        ZStack {
            // Bezel
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(white: 0.07))
                .shadow(color: .black.opacity(0.9), radius: 8, x: 0, y: 4)

            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gbLight)
                .padding(7)
                .overlay(
                    // LCD pixel grid
                    Canvas { ctx, size in
                        let gridColor = Color(white: 0, opacity: 0.06)
                        var x: CGFloat = 0
                        while x < size.width {
                            ctx.fill(Path(CGRect(x: x, y: 0, width: 0.5, height: size.height)), with: .color(gridColor))
                            x += 2
                        }
                        var y: CGFloat = 0
                        while y < size.height {
                            ctx.fill(Path(CGRect(x: 0, y: y, width: size.width, height: 0.5)), with: .color(gridColor))
                            y += 2
                        }
                    }
                    .padding(7)
                    .allowsHitTesting(false)
                )

            // Screen content
            VStack(spacing: 4) {
                // HUD
                HStack {
                    Text(game.pet.stage.label)
                    Spacer()
                    Text(timeStr)
                }
                .font(.custom("Press Start 2P", size: 6))
                .foregroundColor(.gbDark)
                .padding(.horizontal, 4)

                // Pet canvas
                PetPixelView(pet: game.pet, pixelSize: 5)
                    .frame(maxWidth: .infinity)

                // Stat bars
                VStack(spacing: 3) {
                    StatBarView(label: "FOOD",  value: game.pet.hunger)
                    StatBarView(label: "HAPPY", value: game.pet.happiness)
                    StatBarView(label: "HLTH",  value: game.pet.health)
                    StatBarView(label: "ENRG",  value: game.pet.energy)
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 4)
            }
            .padding(.top, 12)
        }
        .frame(height: 220)
        .onAppear { updateTime() }
        .onReceive(Timer.publish(every: 30, on: .main, in: .common).autoconnect()) { _ in
            updateTime()
        }
    }

    private func updateTime() {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        timeStr = f.string(from: Date())
    }
}

// MARK: - ControlsView

struct ControlsView: View {
    @ObservedObject var game: GameManager

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // A Button — FEED
            VStack(spacing: 5) {
                Text("A")
                    .font(.custom("Press Start 2P", size: 7))
                    .foregroundColor(.white.opacity(0.45))
                BigButton(icon: "🍎", color1: Color(red: 0.976, green: 0.659, blue: 0.831),
                          color2: Color(red: 0.745, green: 0.094, blue: 0.365),
                          shadow: Color(red: 0.514, green: 0.047, blue: 0.196)) {
                    game.feed()
                }
                Text("FEED")
                    .font(.custom("Press Start 2P", size: 5))
                    .foregroundColor(.white.opacity(0.35))
            }

            Spacer()

            // Center — brand + speaker + small buttons
            VStack(spacing: 8) {
                Text("TAMA")
                    .font(.custom("Press Start 2P", size: 7))
                    .foregroundColor(.white.opacity(0.25))
                    .kerning(2)

                // Speaker dots
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(5), spacing: 3), count: 2), spacing: 3) {
                    ForEach(0..<6, id: \.self) { _ in
                        Circle()
                            .fill(Color.black.opacity(0.4))
                            .frame(width: 5, height: 5)
                    }
                }

                // Small buttons
                VStack(spacing: 6) {
                    SmallButton(label: "ZZZ") { game.toggleSleep() }
                    SmallButton(label: "MED") { game.heal() }
                }
            }

            Spacer()

            // B Button — PLAY
            VStack(spacing: 5) {
                Text("B")
                    .font(.custom("Press Start 2P", size: 7))
                    .foregroundColor(.white.opacity(0.45))
                BigButton(icon: "🎮", color1: Color(red: 0.576, green: 0.773, blue: 0.992),
                          color2: Color(red: 0.114, green: 0.306, blue: 0.847),
                          shadow: Color(red: 0.118, green: 0.227, blue: 0.541)) {
                    game.play()
                }
                Text("PLAY")
                    .font(.custom("Press Start 2P", size: 5))
                    .foregroundColor(.white.opacity(0.35))
            }
        }
    }
}

// MARK: - BigButton

struct BigButton: View {
    let icon:    String
    let color1:  Color
    let color2:  Color
    let shadow:  Color
    let action:  () -> Void

    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            Text(icon)
                .font(.system(size: 24))
                .frame(width: 54, height: 54)
                .background(
                    Circle()
                        .fill(RadialGradient(colors: [color1, color2],
                                             center: UnitPoint(x: 0.38, y: 0.32),
                                             startRadius: 0, endRadius: 30))
                )
                .overlay(Circle().stroke(shadow, lineWidth: 1))
                .shadow(color: shadow, radius: 0, x: 0, y: pressed ? 1 : 6)
                .offset(y: pressed ? 5 : 0)
        }
        .buttonStyle(PressButtonStyle(pressed: $pressed))
    }
}

// MARK: - SmallButton

struct SmallButton: View {
    let label:  String
    let action: () -> Void

    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.custom("Press Start 2P", size: 5))
                .foregroundColor(.white.opacity(0.75))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(LinearGradient(colors: [Color(white: 0.36), Color(white: 0.17)],
                                             startPoint: .top, endPoint: .bottom))
                )
                .shadow(color: Color(white: 0.1), radius: 0, x: 0, y: pressed ? 1 : 4)
                .offset(y: pressed ? 3 : 0)
        }
        .buttonStyle(PressButtonStyle(pressed: $pressed))
    }
}

// MARK: - PressButtonStyle

struct PressButtonStyle: ButtonStyle {
    @Binding var pressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, val in pressed = val }
    }
}

// MARK: - ToastView

struct ToastView: View {
    let message: String?

    var body: some View {
        if let msg = message {
            Text(msg)
                .font(.custom("Press Start 2P", size: 7))
                .foregroundColor(.gbLight)
                .lineSpacing(6)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 22)
                .padding(.vertical, 12)
                .background(Color.black.opacity(0.92))
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.gbMid, lineWidth: 2)
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.22), value: message)
        }
    }
}

// MARK: - EggShape

struct EggShape: Shape {
    func path(in rect: CGRect) -> Path {
        // Wider at the top, narrower at the bottom — classic Tamagotchi egg
        var path = Path()
        let w = rect.width, h = rect.height
        path.move(to: CGPoint(x: w * 0.5, y: 0))
        path.addCurve(
            to: CGPoint(x: w, y: h * 0.42),
            control1: CGPoint(x: w * 0.98, y: 0),
            control2: CGPoint(x: w, y: h * 0.18)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: h),
            control1: CGPoint(x: w, y: h * 0.72),
            control2: CGPoint(x: w * 0.78, y: h)
        )
        path.addCurve(
            to: CGPoint(x: 0, y: h * 0.42),
            control1: CGPoint(x: w * 0.22, y: h),
            control2: CGPoint(x: 0, y: h * 0.72)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: 0),
            control1: CGPoint(x: 0, y: h * 0.18),
            control2: CGPoint(x: w * 0.02, y: 0)
        )
        path.closeSubpath()
        return path
    }
}

// MARK: - StarfieldView

struct StarfieldView: View {
    private let stars: [(CGFloat, CGFloat, CGFloat)] = (0..<18).map { _ in
        (CGFloat.random(in: 0...1), CGFloat.random(in: 0...1), CGFloat.random(in: 0.5...1.5))
    }

    var body: some View {
        GeometryReader { geo in
            ForEach(stars.indices, id: \.self) { i in
                let (rx, ry, size) = stars[i]
                Circle()
                    .fill(Color.white.opacity(Double.random(in: 0.3...0.7)))
                    .frame(width: size, height: size)
                    .position(x: geo.size.width * rx, y: geo.size.height * ry)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
