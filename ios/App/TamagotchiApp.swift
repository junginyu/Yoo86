import SwiftUI

@main
struct TamagotchiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .onOpenURL { url in
                    // Handle widget deep link: tamagotchi://open
                    _ = url
                }
        }
    }
}
