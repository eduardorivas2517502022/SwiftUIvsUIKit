
import SwiftUI
import UIKit

struct UIKitScreen: UIViewControllerRepresentable {

    func makeUIViewController(
        context: Context
    ) -> UINavigationController {

        let controlador = UIKitDemoViewController()

        return UINavigationController(
            rootViewController: controlador
        )
    }

    func updateUIViewController(
        _ uiViewController: UINavigationController,
        context: Context
    ) {
        // No requiere actualización externa.
    }
}
