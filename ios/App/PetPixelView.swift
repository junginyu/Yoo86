import SwiftUI

// MARK: - Game Boy Colors

extension Color {
    static let gbLight  = Color(red: 0.608, green: 0.737, blue: 0.059) // #9bbc0f
    static let gbDark   = Color(red: 0.059, green: 0.220, blue: 0.059) // #0f380f
    static let gbMid    = Color(red: 0.188, green: 0.384, blue: 0.188) // #306230
    static let gbYellow = Color(red: 0.784, green: 0.753, blue: 0.063) // #c8c010 (danger)
}

// MARK: - PetPixelView

struct PetPixelView: View {

    let pet: PetState
    var pixelSize: CGFloat = 4

    private var spriteRows: Int { 12 }
    private var spriteCols: Int { 12 }
    private var spriteW: CGFloat { CGFloat(spriteCols) * pixelSize }
    private var spriteH: CGFloat { CGFloat(spriteRows) * pixelSize }
    private var canvasW: CGFloat { spriteW + 32 }  // extra room for Z's / heart
    private var canvasH: CGFloat { spriteH + 16 }  // room for ground + effects above

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            Canvas { ctx, size in
                drawScene(ctx: ctx, size: size, t: t)
            }
            .frame(width: canvasW, height: canvasH)
        }
    }

    // MARK: - Drawing

    private func drawScene(ctx: GraphicsContext, size: CGSize, t: TimeInterval) {
        let W = size.width
        let H = size.height

        // Background
        let bgColor: Color = pet.health < 30 && !pet.isDead
            ? (sin(t * 4) > 0 ? .gbLight : .gbYellow)
            : .gbLight
        ctx.fill(Path(CGRect(origin: .zero, size: size)), with: .color(bgColor))

        // Ground dots
        let groundY = H - 6
        var gx: CGFloat = 0
        while gx < W {
            ctx.fill(Path(CGRect(x: gx, y: groundY, width: 2, height: 2)), with: .color(.gbDark))
            gx += 8
        }

        // Pet position (centred horizontally, with bob)
        let bobY: CGFloat = pet.isDead || pet.isSleeping
            ? 0
            : CGFloat(sin(t * 3.0) * 3.0)
        let sx = floor((W - spriteW) / 2)
        let sy = floor((H - spriteH - 6) / 2 + bobY)

        // Main sprite
        let sprite = getSprite(stage: pet.stage, mood: pet.mood)
        drawSprite(ctx: ctx, sprite: sprite, x: sx, y: sy, scale: pixelSize, color: .gbDark)

        // Sleeping Z's
        if pet.isSleeping {
            let alpha1 = (sin(t * 1.5) + 1) / 2
            let alpha2 = (sin(t * 1.5 + .pi) + 1) / 2
            drawSprite(ctx: ctx, sprite: Z_BIG, x: sx + spriteW + 4, y: sy + 2,
                       scale: 2, color: .gbDark.opacity(alpha1))
            drawSprite(ctx: ctx, sprite: Z_SML, x: sx + spriteW + 12, y: sy - 6,
                       scale: 2, color: .gbDark.opacity(alpha2))
        }

        // Happy heart (pulses every ~1.3s)
        if pet.mood == .happy {
            let heartAlpha = max(0, sin(t * 2.4))
            let hx = sx - 14
            let hy = sy - 4
            drawSprite(ctx: ctx, sprite: HEART, x: hx, y: hy, scale: 2,
                       color: .gbDark.opacity(heartAlpha))
        }

        // Sick wavy dots
        if pet.mood == .sick {
            for i in 0..<4 {
                let wx = sx - 10 + CGFloat(i) * 3
                let wy = sy + 8 + CGFloat(sin(t * 4 + Double(i))) * 3
                ctx.fill(Path(CGRect(x: wx, y: wy, width: 2, height: 2)), with: .color(.gbDark.opacity(0.7)))
            }
        }
    }

    // MARK: - Sprite Renderer

    private func drawSprite(
        ctx: GraphicsContext,
        sprite: PixelSprite,
        x: CGFloat, y: CGFloat,
        scale: CGFloat,
        color: Color
    ) {
        var path = Path()
        for (row, rowData) in sprite.enumerated() {
            for (col, on) in rowData.enumerated() where on {
                let rect = CGRect(
                    x: x + CGFloat(col) * scale,
                    y: y + CGFloat(row) * scale,
                    width: scale,
                    height: scale
                )
                path.addRect(rect)
            }
        }
        ctx.fill(path, with: .color(color))
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black
        PetPixelView(pet: PetState(), pixelSize: 6)
    }
    .frame(width: 200, height: 200)
}
