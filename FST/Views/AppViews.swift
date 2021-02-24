import SwiftUI

@main
struct FSTApp: App {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some Scene {
        WindowGroup {
            MovieCatalogView()
                .environmentObject(colorScheme == .dark ? FSTTheme.Dark : FSTTheme.Light)
        }
    }
}