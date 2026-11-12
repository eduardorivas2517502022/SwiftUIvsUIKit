
import SwiftUI

struct ContentView: View {

    var body: some View {

        TabView {

            SwiftUIScreen()
                .tabItem {
                    Image(systemName: "swift")
                    Text("Finanzas SwiftUI")
                }

            UIKitScreen()
                .ignoresSafeArea(edges: .top)
                .tabItem {
                    Image(systemName: "checklist")
                    Text("Tareas UIKit")
                }

            ComparisonView()
                .tabItem {
                    Image(systemName: "book.closed.fill")
                    Text("Explicación")
                }
        }
        .tint(.indigo)
    }
}

#Preview {
    ContentView()
}

