import SwiftUI

private struct Movimiento: Identifiable {
    let id = UUID()
    let nombre: String
    let categoria: String
    let monto: Double
    let fecha: Date
    let simbolo: String
    let color: Color
}

struct SwiftUIScreen: View {
    @State private var presupuesto: Double = 900
    @State private var movimientos: [Movimiento] = [
        Movimiento(nombre: "Super Selectos", categoria: "Alimentación", monto: 48.75, fecha: .now, simbolo: "basket.fill", color: .orange),
        Movimiento(nombre: "Gasolina", categoria: "Transporte", monto: 35, fecha: .now.addingTimeInterval(-86400), simbolo: "car.fill", color: .blue),
        Movimiento(nombre: "Internet", categoria: "Servicios", monto: 28.99, fecha: .now.addingTimeInterval(-172800), simbolo: "wifi", color: .purple),
        Movimiento(nombre: "Café y almuerzo", categoria: "Alimentación", monto: 12.50, fecha: .now.addingTimeInterval(-259200), simbolo: "cup.and.saucer.fill", color: .orange),
        Movimiento(nombre: "Cine", categoria: "Entretenimiento", monto: 16, fecha: .now.addingTimeInterval(-345600), simbolo: "ticket.fill", color: .pink)
    ]
    @State private var nombre = ""
    @State private var monto = ""
    @State private var categoria = "Alimentación"
    @State private var filtro = "Todos"
    @State private var mostrarFormulario = false

    private let categorias = ["Alimentación", "Transporte", "Servicios", "Entretenimiento", "Otros"]
    private let azul = Color(red: 0.12, green: 0.27, blue: 0.55)
    private var totalGastado: Double { movimientos.reduce(0) { $0 + $1.monto } }
    private var disponible: Double { presupuesto - totalGastado }
    private var porcentaje: Double { presupuesto > 0 ? min(totalGastado / presupuesto, 1) : 0 }
    private var movimientosFiltrados: [Movimiento] {
        filtro == "Todos" ? movimientos : movimientos.filter { $0.categoria == filtro }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    encabezado
                    resumen
                    presupuestoCard
                    formulario
                    historial
                    pie
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Mi Finanzas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { mostrarFormulario.toggle() } label: {
                        Image(systemName: "plus.circle.fill").font(.title2)
                    }
                    .accessibilityLabel("Agregar movimiento")
                }
            }
            .sheet(isPresented: $mostrarFormulario) { formularioSheet }
        }
    }

    private var encabezado: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("¡Hola, Eduardo!").font(.title2.bold())
                Text("Este es el resumen de tus finanzas").font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 42)).foregroundStyle(azul)
        }
    }

    private var resumen: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("DINERO DISPONIBLE").font(.caption.bold()).foregroundStyle(.white.opacity(0.8))
            Text(disponible, format: .currency(code: "USD"))
                .font(.system(size: 34, weight: .bold, design: .rounded)).foregroundStyle(.white)
            HStack {
                Label("Presupuesto \(presupuesto, format: .currency(code: "USD"))", systemImage: "wallet.bifold")
                Spacer()
                Label("\(movimientos.count) movimientos", systemImage: "list.bullet")
            }
            .font(.caption).foregroundStyle(.white.opacity(0.85))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [azul, Color(red: 0.20, green: 0.48, blue: 0.76)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 22))
    }

    private var presupuestoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Presupuesto mensual", systemImage: "chart.pie.fill").font(.headline)
                Spacer()
                Text("\(Int(porcentaje * 100))%").font(.headline).foregroundStyle(porcentaje >= 1 ? .red : azul)
            }
            ProgressView(value: porcentaje).tint(porcentaje >= 1 ? .red : .green)
            HStack {
                dato(titulo: "Gastado", valor: totalGastado, color: .orange)
                Spacer()
                dato(titulo: "Restante", valor: disponible, color: disponible >= 0 ? .green : .red)
            }
            Text("Ajusta tu presupuesto mensual:")
                .font(.caption).foregroundStyle(.secondary)
            Slider(value: $presupuesto, in: 100...2500, step: 25)
                .tint(azul)
            Text(presupuesto, format: .currency(code: "USD"))
                .font(.subheadline.bold()).frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))
    }

    private func dato(titulo: String, valor: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(titulo).font(.caption).foregroundStyle(.secondary)
            Text(valor, format: .currency(code: "USD")).font(.headline).foregroundStyle(color)
        }
    }

    private var formulario: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Registrar gasto", systemImage: "plus.rectangle.fill").font(.headline)
            HStack {
                TextField("Descripción", text: $nombre)
                    .textFieldStyle(.roundedBorder)
                TextField("Monto $", text: $monto)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 105)
            }
            Picker("Categoría", selection: $categoria) {
                ForEach(categorias, id: \.self) { Text($0) }
            }
            .pickerStyle(.menu)
            Button(action: agregarMovimiento) {
                Label("Guardar movimiento", systemImage: "checkmark.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(azul)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))
    }

    private var historial: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Movimientos recientes", systemImage: "clock.arrow.circlepath").font(.headline)
                Spacer()
                Text("\(movimientosFiltrados.count) registros").font(.caption).foregroundStyle(.secondary)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    filtroChip("Todos")
                    ForEach(categorias, id: \.self) { filtroChip($0) }
                }
            }
            if movimientosFiltrados.isEmpty {
                ContentUnavailableView("Sin movimientos", systemImage: "tray", description: Text("Agrega un gasto o cambia el filtro."))
            } else {
                ForEach(movimientosFiltrados) { item in
                    HStack(spacing: 12) {
                        Image(systemName: item.simbolo)
                            .font(.title3).foregroundStyle(item.color)
                            .frame(width: 42, height: 42)
                            .background(item.color.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(item.nombre).font(.subheadline.bold())
                            Text("\(item.categoria) · \(item.fecha.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("-\(item.monto, format: .currency(code: "USD"))")
                            .font(.subheadline.bold()).foregroundStyle(.red)
                        Button(role: .destructive) {
                            movimientos.removeAll { $0.id == item.id }
                        } label: {
                            Image(systemName: "trash").font(.caption)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Eliminar \(item.nombre)")
                    }
                    .padding(12)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))
                }
            }
        }
    }

    private func filtroChip(_ texto: String) -> some View {
        Button { filtro = texto } label: {
            Text(texto).font(.caption.bold())
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(filtro == texto ? azul : Color(.tertiarySystemGroupedBackground), in: Capsule())
                .foregroundStyle(filtro == texto ? .white : .primary)
        }
        .buttonStyle(.plain)
    }

    private var pie: some View {
        Text("Datos de demostración · No se conecta a una cuenta bancaria")
            .font(.caption2).foregroundStyle(.secondary)
            .frame(maxWidth: .infinity).padding(.top, 4)
    }

    private var formularioSheet: some View {
        NavigationStack {
            Form {
                Section("Nuevo movimiento") {
                    TextField("Descripción", text: $nombre)
                    TextField("Monto en dólares", text: $monto).keyboardType(.decimalPad)
                    Picker("Categoría", selection: $categoria) {
                        ForEach(categorias, id: \.self) { Text($0) }
                    }
                }
                Section {
                    Button("Guardar gasto", action: {
                        agregarMovimiento()
                        mostrarFormulario = false
                    })
                    .disabled(!formularioValido)
                }
            }
            .navigationTitle("Agregar gasto")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Cerrar") { mostrarFormulario = false } } }
        }
        .presentationDetents([.medium, .large])
    }

    private var formularioValido: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty && (Double(monto.replacingOccurrences(of: ",", with: ".")) ?? 0) > 0
    }

    private func agregarMovimiento() {
        guard formularioValido,
              let cantidad = Double(monto.replacingOccurrences(of: ",", with: ".")) else { return }
        let icono: String
        let color: Color
        switch categoria {
        case "Alimentación": icono = "basket.fill"; color = .orange
        case "Transporte": icono = "car.fill"; color = .blue
        case "Servicios": icono = "bolt.fill"; color = .purple
        case "Entretenimiento": icono = "ticket.fill"; color = .pink
        default: icono = "tag.fill"; color = .gray
        }
        movimientos.insert(Movimiento(nombre: nombre.trimmingCharacters(in: .whitespaces), categoria: categoria, monto: cantidad, fecha: .now, simbolo: icono, color: color), at: 0)
        nombre = ""
        monto = ""
    }
}

#Preview {
    SwiftUIScreen()
}
