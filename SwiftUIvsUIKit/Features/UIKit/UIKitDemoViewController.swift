
import UIKit

struct TareaAcademica {
    let id = UUID()
    var titulo: String
    var descripcion: String
    var materia: String
    var prioridad: String
    var fecha: Date
    var completada: Bool
}

final class UIKitDemoViewController: UIViewController {

    private var tareas: [TareaAcademica] = [
        TareaAcademica(
            titulo: "Investigación de SwiftUI",
            descripcion: "Investigar las características principales",
            materia: "Programación Móvil",
            prioridad: "Alta",
            fecha: Date().addingTimeInterval(86400),
            completada: false
        ),
        TareaAcademica(
            titulo: "Diseñar interfaz",
            descripcion: "Crear prototipo de aplicación",
            materia: "Diseño de Software",
            prioridad: "Media",
            fecha: Date().addingTimeInterval(172800),
            completada: false
        ),
        TareaAcademica(
            titulo: "Entregar cuestionario",
            descripcion: "Resolver las preguntas de la guía",
            materia: "Ingeniería de Software",
            prioridad: "Baja",
            fecha: Date(),
            completada: true
        )
    ]

    private var filtroActual = "Todas"

    private let scroll = UIScrollView()
    private let contenido = UIStackView()

    private let totalLabel = UILabel()
    private let pendientesLabel = UILabel()
    private let completadasLabel = UILabel()

    private let tituloField = UITextField()
    private let descripcionField = UITextField()
    private let materiaField = UITextField()

    private let prioridadControl = UISegmentedControl(
        items: ["Baja", "Media", "Alta"]
    )

    private let fechaPicker = UIDatePicker()

    private let filtroControl = UISegmentedControl(
        items: ["Todas", "Pendientes", "Hechas"]
    )

    private let listaTareas = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Mis tareas"
        view.backgroundColor = .systemGroupedBackground

        configurarInterfaz()
        actualizarInterfaz()
    }

    // MARK: - Interfaz principal

    private func configurarInterfaz() {

        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contenido.axis = .vertical
        contenido.spacing = 16
        contenido.translatesAutoresizingMaskIntoConstraints = false

        scroll.addSubview(contenido)

        NSLayoutConstraint.activate([
            contenido.topAnchor.constraint(
                equalTo: scroll.contentLayoutGuide.topAnchor,
                constant: 18
            ),
            contenido.leadingAnchor.constraint(
                equalTo: scroll.frameLayoutGuide.leadingAnchor,
                constant: 16
            ),
            contenido.trailingAnchor.constraint(
                equalTo: scroll.frameLayoutGuide.trailingAnchor,
                constant: -16
            ),
            contenido.bottomAnchor.constraint(
                equalTo: scroll.contentLayoutGuide.bottomAnchor,
                constant: -20
            )
        ])

        configurarResumen()
        configurarFormulario()
        configurarLista()
    }

    // MARK: - Resumen

    private func configurarResumen() {

        let tarjeta = crearTarjeta(
            titulo: "Resumen académico",
            icono: "graduationcap.fill"
        )

        totalLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )

        pendientesLabel.font = .systemFont(
            ofSize: 14,
            weight: .medium
        )

        completadasLabel.font = .systemFont(
            ofSize: 14,
            weight: .medium
        )

        tarjeta.addArrangedSubview(totalLabel)
        tarjeta.addArrangedSubview(pendientesLabel)
        tarjeta.addArrangedSubview(completadasLabel)

        contenido.addArrangedSubview(tarjeta)
    }

    // MARK: - Formulario

    private func configurarFormulario() {

        let tarjeta = crearTarjeta(
            titulo: "Nueva tarea",
            icono: "plus.circle.fill"
        )

        configurarCampo(
            tituloField,
            placeholder: "Nombre de la tarea"
        )

        configurarCampo(
            descripcionField,
            placeholder: "Descripción"
        )

        configurarCampo(
            materiaField,
            placeholder: "Materia"
        )

        prioridadControl.selectedSegmentIndex = 1

        fechaPicker.datePickerMode = .date
        fechaPicker.minimumDate = Calendar.current.startOfDay(
            for: Date()
        )

        let prioridadLabel = crearEtiqueta("Prioridad")
        let fechaLabel = crearEtiqueta("Fecha de entrega")

        let guardarButton = crearBoton(
            titulo: "Agregar tarea",
            icono: "plus.circle.fill",
            accion: #selector(agregarTarea)
        )

        tarjeta.addArrangedSubview(tituloField)
        tarjeta.addArrangedSubview(descripcionField)
        tarjeta.addArrangedSubview(materiaField)
        tarjeta.addArrangedSubview(prioridadLabel)
        tarjeta.addArrangedSubview(prioridadControl)
        tarjeta.addArrangedSubview(fechaLabel)
        tarjeta.addArrangedSubview(fechaPicker)
        tarjeta.addArrangedSubview(guardarButton)

        contenido.addArrangedSubview(tarjeta)
    }

    // MARK: - Lista

    private func configurarLista() {

        let tarjeta = crearTarjeta(
            titulo: "Lista de tareas",
            icono: "checklist"
        )

        filtroControl.selectedSegmentIndex = 0

        filtroControl.addTarget(
            self,
            action: #selector(cambiarFiltro),
            for: .valueChanged
        )

        listaTareas.axis = .vertical
        listaTareas.spacing = 10

        tarjeta.addArrangedSubview(filtroControl)
        tarjeta.addArrangedSubview(listaTareas)

        contenido.addArrangedSubview(tarjeta)
    }

    // MARK: - Componentes reutilizables

    private func crearTarjeta(
        titulo: String,
        icono: String
    ) -> UIStackView {

        let tarjeta = UIStackView()
        tarjeta.axis = .vertical
        tarjeta.spacing = 12
        tarjeta.backgroundColor = .secondarySystemGroupedBackground
        tarjeta.layer.cornerRadius = 16
        tarjeta.isLayoutMarginsRelativeArrangement = true

        tarjeta.layoutMargins = UIEdgeInsets(
            top: 16,
            left: 14,
            bottom: 16,
            right: 14
        )

        let imagen = UIImageView(
            image: UIImage(systemName: icono)
        )

        imagen.tintColor = .systemIndigo
        imagen.widthAnchor.constraint(equalToConstant: 22).isActive = true

        let etiqueta = UILabel()
        etiqueta.text = titulo
        etiqueta.font = .systemFont(
            ofSize: 18,
            weight: .bold
        )

        let encabezado = UIStackView(
            arrangedSubviews: [imagen, etiqueta]
        )

        encabezado.axis = .horizontal
        encabezado.spacing = 9

        tarjeta.addArrangedSubview(encabezado)

        return tarjeta
    }

    private func configurarCampo(
        _ campo: UITextField,
        placeholder: String
    ) {

        campo.placeholder = placeholder
        campo.borderStyle = .roundedRect
        campo.backgroundColor = .tertiarySystemBackground
        campo.heightAnchor.constraint(
            equalToConstant: 44
        ).isActive = true
    }

    private func crearEtiqueta(_ texto: String) -> UILabel {

        let etiqueta = UILabel()
        etiqueta.text = texto
        etiqueta.font = .systemFont(
            ofSize: 14,
            weight: .semibold
        )

        return etiqueta
    }

    private func crearBoton(
        titulo: String,
        icono: String,
        accion: Selector
    ) -> UIButton {

        let boton = UIButton(type: .system)

        var configuracion = UIButton.Configuration.filled()
        configuracion.title = titulo
        configuracion.image = UIImage(systemName: icono)
        configuracion.imagePadding = 8
        configuracion.cornerStyle = .medium

        boton.configuration = configuracion

        boton.addTarget(
            self,
            action: accion,
            for: .touchUpInside
        )

        return boton
    }

    // MARK: - Agregar tarea

    @objc private func agregarTarea() {

        let titulo = tituloField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let descripcion = descripcionField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let materia = materiaField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !titulo.isEmpty,
              !descripcion.isEmpty,
              !materia.isEmpty else {

            mostrarAlerta(
                titulo: "Campos incompletos",
                mensaje: "Completa el nombre, descripción y materia."
            )

            return
        }

        let prioridades = ["Baja", "Media", "Alta"]

        let nuevaTarea = TareaAcademica(
            titulo: titulo,
            descripcion: descripcion,
            materia: materia,
            prioridad: prioridades[prioridadControl.selectedSegmentIndex],
            fecha: fechaPicker.date,
            completada: false
        )

        tareas.insert(nuevaTarea, at: 0)

        tituloField.text = ""
        descripcionField.text = ""
        materiaField.text = ""

        view.endEditing(true)

        filtroControl.selectedSegmentIndex = 0

        actualizarInterfaz()
    }

    // MARK: - Actualizar tareas

    private func actualizarInterfaz() {

        let pendientes = tareas.filter {
            !$0.completada
        }.count

        let completadas = tareas.filter {
            $0.completada
        }.count

        totalLabel.text = "Total de tareas: \(tareas.count)"
        pendientesLabel.text = "Pendientes: \(pendientes)"
        completadasLabel.text = "Completadas: \(completadas)"

        listaTareas.arrangedSubviews.forEach {
            listaTareas.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let tareasVisibles: [TareaAcademica]

        switch filtroControl.selectedSegmentIndex {

        case 1:
            tareasVisibles = tareas.filter {
                !$0.completada
            }

        case 2:
            tareasVisibles = tareas.filter {
                $0.completada
            }

        default:
            tareasVisibles = tareas
        }

        if tareasVisibles.isEmpty {

            let vacio = UILabel()
            vacio.text = "No hay tareas en esta categoría."
            vacio.textColor = .secondaryLabel
            vacio.textAlignment = .center

            listaTareas.addArrangedSubview(vacio)
        }

        for tarea in tareasVisibles {
            crearFila(tarea)
        }
    }

    // MARK: - Fila de tarea

    private func crearFila(_ tarea: TareaAcademica) {

        let tarjeta = UIStackView()
        tarjeta.axis = .vertical
        tarjeta.spacing = 8
        tarjeta.backgroundColor = .tertiarySystemGroupedBackground
        tarjeta.layer.cornerRadius = 12
        tarjeta.isLayoutMarginsRelativeArrangement = true

        tarjeta.layoutMargins = UIEdgeInsets(
            top: 12,
            left: 12,
            bottom: 12,
            right: 12
        )

        let titulo = UILabel()
        titulo.text = tarea.titulo
        titulo.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )

        if tarea.completada {
            titulo.textColor = .secondaryLabel
            titulo.attributedText = NSAttributedString(
                string: tarea.titulo,
                attributes: [
                    .strikethroughStyle:
                        NSUnderlineStyle.single.rawValue
                ]
            )
        }

        let descripcion = UILabel()
        descripcion.text = tarea.descripcion
        descripcion.font = .systemFont(ofSize: 13)
        descripcion.textColor = .secondaryLabel
        descripcion.numberOfLines = 0

        let materia = UILabel()
        materia.text = "Materia: \(tarea.materia)"
        materia.font = .systemFont(ofSize: 12)

        let fecha = UILabel()
        fecha.text = "Entrega: \(tarea.fecha.formatted(date: .abbreviated, time: .omitted))"
        fecha.font = .systemFont(ofSize: 12)

        let prioridad = UILabel()
        prioridad.text = "Prioridad: \(tarea.prioridad)"
        prioridad.font = .systemFont(
            ofSize: 12,
            weight: .semibold
        )

        switch tarea.prioridad {
        case "Alta":
            prioridad.textColor = .systemRed
        case "Media":
            prioridad.textColor = .systemOrange
        default:
            prioridad.textColor = .systemGreen
        }

        let botones = UIStackView()
        botones.axis = .horizontal
        botones.spacing = 10
        botones.distribution = .fillEqually

        let completar = UIButton(type: .system)

        completar.setTitle(
            tarea.completada ? "Reabrir" : "Completar",
            for: .normal
        )

        completar.setImage(
            UIImage(
                systemName: tarea.completada
                ? "arrow.uturn.backward"
                : "checkmark.circle"
            ),
            for: .normal
        )

        completar.addAction(
            UIAction { [weak self] _ in
                self?.cambiarEstado(tarea.id)
            },
            for: .touchUpInside
        )

        let eliminar = UIButton(type: .system)

        eliminar.setTitle("Eliminar", for: .normal)
        eliminar.setImage(
            UIImage(systemName: "trash"),
            for: .normal
        )
        eliminar.tintColor = .systemRed

        eliminar.addAction(
            UIAction { [weak self] _ in
                self?.eliminarTarea(tarea.id)
            },
            for: .touchUpInside
        )

        botones.addArrangedSubview(completar)
        botones.addArrangedSubview(eliminar)

        tarjeta.addArrangedSubview(titulo)
        tarjeta.addArrangedSubview(descripcion)
        tarjeta.addArrangedSubview(materia)
        tarjeta.addArrangedSubview(fecha)
        tarjeta.addArrangedSubview(prioridad)
        tarjeta.addArrangedSubview(botones)

        listaTareas.addArrangedSubview(tarjeta)
    }

    // MARK: - Acciones

    private func cambiarEstado(_ id: UUID) {

        guard let indice = tareas.firstIndex(
            where: { $0.id == id }
        ) else {
            return
        }

        tareas[indice].completada.toggle()

        actualizarInterfaz()
    }

    private func eliminarTarea(_ id: UUID) {

        tareas.removeAll {
            $0.id == id
        }

        actualizarInterfaz()
    }

    @objc private func cambiarFiltro() {
        actualizarInterfaz()
    }

    private func mostrarAlerta(
        titulo: String,
        mensaje: String
    ) {

        let alerta = UIAlertController(
            title: titulo,
            message: mensaje,
            preferredStyle: .alert
        )

        alerta.addAction(
            UIAlertAction(
                title: "Aceptar",
                style: .default
            )
        )

        present(alerta, animated: true)
    }
}

