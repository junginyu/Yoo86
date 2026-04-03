import SwiftUI

struct StatBarView: View {
    let label: String
    let value: Double   // 0-100

    private var filledBlocks: Int { Int((value / 10).rounded()) }

    var body: some View {
        HStack(spacing: 3) {
            Text(label)
                .font(.custom("Press Start 2P", size: 5))
                .foregroundColor(.gbDark)
                .frame(width: 38, alignment: .leading)

            HStack(spacing: 1) {
                ForEach(0..<10, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(i < filledBlocks ? Color.gbDark : Color.gbDark.opacity(0.18))
                        .overlay(
                            RoundedRectangle(cornerRadius: 1)
                                .stroke(Color.gbMid, lineWidth: i < filledBlocks ? 0 : 0.5)
                        )
                        .frame(height: 6)
                }
            }
        }
    }
}
