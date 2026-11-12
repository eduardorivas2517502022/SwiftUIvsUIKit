import SwiftUI

struct ComparisonView: View {
    private let azul = Color.indigo

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Una aplicación, dos formas de construirla")
                        .font(.title2.bold())
                    Text("Este proyecto implementa el mismo administrador de gastos en dos tecnologías nativas de Apple. La finalidad es observar cómo cambia la construcción de la interfaz, no comparar aplicaciones con funciones distintas.")
                        .foregroundStyle(.secondary)

                    bloque(numero: "01", titulo: "Swift no es SwiftUI", texto: "Swift es el lenguaje de programación. SwiftUI es un framework de interfaz que utiliza Swift y un enfoque declarativo: se describe cómo debe verse la pantalla según el estado de los datos.")
                    bloque(numero: "02", titulo: "¿Qué es UIKit?", texto: "UIKit es un framework de interfaz para iOS. Permite construir pantallas mediante objetos como UIView, UILabel, UIButton y UIViewController. El desarrollador configura vistas, restricciones y acciones.")
                    bloque(numero: "03", titulo: "Ejemplo SwiftUI", texto: "La pantalla se organiza con NavigationStack, ScrollView, VStack, HStack, TextField, Picker, Slider y ForEach. Las variables marcadas con @State guardan el estado local. Cuando cambia una variable, SwiftUI actualiza las vistas que dependen de ella.")
                    bloque(numero: "04", titulo: "Ejemplo UIKit", texto: "La pantalla se construye desde UIKitDemoViewController. Se crean controles, se agregan a UIStackView y UIScrollView, y se definen restricciones con NSLayoutConstraint. Los botones usan addTarget y las modificaciones se reflejan al llamar actualizarVista().")
                    bloque(numero: "05", titulo: "Funciones equivalentes", texto: "Ambas versiones muestran presupuesto, total gastado y dinero disponible; permiten registrar gastos, elegir categorías, filtrar movimientos y eliminar registros. Utilizan datos de demostración en memoria, por lo que al cerrar la aplicación los cambios no se conservan.")
                    bloque(numero: "06", titulo: "Diferencia principal", texto: "SwiftUI expresa la interfaz declarativamente y reduce el código de actualización manual. UIKit ofrece control explícito sobre cada vista y su ciclo de vida, pero normalmente requiere más configuración y mantenimiento de las relaciones entre datos e interfaz.")

                    Text("Comparación técnica")
                        .font(.headline)
                    VStack(spacing: 0) {
                        fila("Aspecto", "SwiftUI", "UIKit", encabezado: true)
                        fila("Enfoque", "Declarativo", "Imperativo")
                        fila("Estado", "@State y bindings", "Propiedades y actualización manual")
                        fila("Contenedores", "VStack, HStack", "UIStackView")
                        fila("Desplazamiento", "ScrollView", "UIScrollView")
                        fila("Acciones", "closures y modifiers", "addTarget / UIAction")
                        fila("Diseño", "composición de vistas", "Auto Layout y constraints")
                    }
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    bloque(numero: "07", titulo: "¿Cuál conviene utilizar?", texto: "SwiftUI es una opción práctica para interfaces nuevas, declarativas y fáciles de componer. UIKit sigue siendo importante en proyectos existentes, controles especializados y escenarios que requieren integración directa con APIs tradicionales. También pueden convivir en una misma aplicación.")
                    bloque(numero: "08", titulo: "Alcance de la demostración", texto: "Los importes y movimientos son ficticios. No existe conexión bancaria, autenticación real ni almacenamiento persistente. El presupuesto y los gastos sirven para demostrar el flujo de datos y la actualización de la interfaz en cada framework.")

                    VStack(alignment: .leading, spacing: 8) {
                        Label("Conclusión", systemImage: "checkmark.seal.fill")
                            .font(.headline).foregroundStyle(azul)
                        Text("Las dos tecnologías pueden resolver el mismo problema. SwiftUI simplifica la declaración y reacción de la interfaz; UIKit permite gestionar de forma más directa sus componentes. La elección depende del proyecto, los requisitos y el contexto técnico.")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(azul.opacity(0.09), in: RoundedRectangle(cornerRadius: 16))

                    Text("Documentación oficial")
                        .font(.headline)
                    Link(destination: URL(string: "https://developer.apple.com/documentation/swiftui")!) {
                        Label("Apple Developer — SwiftUI", systemImage: "link")
                    }
                    Link(destination: URL(string: "https://developer.apple.com/documentation/uikit")!) {
                        Label("Apple Developer — UIKit", systemImage: "link")
                    }
                    Link(destination: URL(string: "https://www.swift.org/about/")!) {
                        Label("Swift.org — About Swift", systemImage: "link")
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Aprender")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func bloque(numero: String, titulo: String, texto: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(numero)
                .font(.headline.monospacedDigit())
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(azul, in: RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 5) {
                Text(titulo).font(.headline)
                Text(texto).font(.subheadline).foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }

    private func fila(_ a: String, _ b: String, _ c: String, encabezado: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(a).frame(maxWidth: .infinity, alignment: .leading)
            Text(b).frame(maxWidth: .infinity, alignment: .leading)
            Text(c).frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(encabezado ? .caption.bold() : .caption)
        .padding(10)
        .background(encabezado ? azul.opacity(0.12) : Color.clear)
    }
}

#Preview {
    ComparisonView()
}
