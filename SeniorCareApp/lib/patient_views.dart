part of 'main.dart';

// ============================================================
// VISTA PACIENTE
// ============================================================

// Panel principal del paciente: resumen, accesos rápidos y botones grandes de solicitud.
class PatientDashboardPage extends StatefulWidget {
  const PatientDashboardPage({super.key});

  @override
  State<PatientDashboardPage> createState() => _PatientDashboardPageState();
}

class _PatientDashboardPageState extends State<PatientDashboardPage> {
  @override
  Widget build(BuildContext context) {
    final misSolicitudes = solicitudes
        .where((s) => s.paciente == pacienteActual.nombre)
        .toList();
    final pendientes = misSolicitudes
        .where((s) => s.estado != 'Completada' && s.estado != 'Cancelada')
        .length;
    final completadas = misSolicitudes
        .where((s) => s.estado == 'Completada')
        .length;

    return PatientLayout(
      title: 'Bienvenido/a, ${pacienteActual.nombre.split(' ').first}',
      subtitle: 'Panel de paciente - SeniorCare',
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: responsiveColumns(
              context,
              mobile: 1,
              tablet: 2,
              desktop: 3,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: responsiveAspectRatio(
              context,
              mobile: 2.0,
              tablet: 2.45,
              desktop: 2.75,
              largeDesktop: 2.9,
            ),
            children: [
              summaryCard(
                'Solicitudes Totales',
                misSolicitudes.length.toString(),
                Icons.assignment,
                Colors.blue,
              ),
              summaryCard(
                'Solicitudes Pendientes',
                pendientes.toString(),
                Icons.assignment_late,
                Colors.deepOrange,
              ),
              summaryCard(
                'Solicitudes Completadas',
                completadas.toString(),
                Icons.assignment_turned_in,
                Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Accesos Rápidos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),
                GridView.count(
                  crossAxisCount: responsiveColumns(
                    context,
                    mobile: 1,
                    tablet: 2,
                    desktop: 3,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: responsiveAspectRatio(
                    context,
                    mobile: 1.45,
                    tablet: 2.0,
                    desktop: 2.45,
                    largeDesktop: 2.7,
                  ),
                  children: [
                    patientQuickAccess(
                      context,
                      'Ver Mis Solicitudes',
                      'Revisa el estado de tus solicitudes',
                      Icons.assignment,
                      Colors.green,
                      const PatientRequestsPage(),
                    ),
                    patientQuickAccess(
                      context,
                      'Mi Información',
                      'Ver y editar datos personales',
                      Icons.person,
                      Colors.purple,
                      PatientInfoPage(paciente: pacienteActual),
                    ),
                    patientQuickAccess(
                      context,
                      'Contactos de Emergencia',
                      'Ver y editar contactos registrados',
                      Icons.phone,
                      Colors.deepOrange,
                      const EmergencyContactsPage(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: cardDecoration(),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        pacienteActual.nombre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Habitación ${pacienteActual.habitacion}',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: responsiveColumns(
                    context,
                    mobile: 2,
                    tablet: 3,
                    desktop: 4,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: responsiveAspectRatio(
                    context,
                    mobile: 0.95,
                    tablet: 1.2,
                    desktop: 1.45,
                    largeDesktop: 1.6,
                  ),
                  children: [
                    requestButton(
                      'Cambiar postura',
                      Icons.refresh,
                      Colors.blue,
                    ),
                    requestButton(
                      'Paseo / Caminar',
                      Icons.accessibility_new,
                      Colors.green,
                    ),
                    requestButton('Medicamentos', Icons.medication, Colors.red),
                    requestButton(
                      'Cambio de pañal',
                      Icons.baby_changing_station,
                      Colors.amber,
                    ),
                    requestButton(
                      'Tiene hambre',
                      Icons.restaurant,
                      Colors.deepOrange,
                    ),
                    requestButton(
                      'Dolor / Se siente mal',
                      Icons.favorite_border,
                      Colors.pink,
                    ),
                    requestButton(
                      'Ayuda para ir al baño',
                      Icons.bathtub,
                      Colors.cyan,
                    ),
                    requestButton(
                      'Asistencia médica',
                      Icons.medical_services,
                      Colors.purple,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void confirmarSolicitudPaciente(String tipoSolicitud, Color color) {
    String prioridadSeleccionada =
        tipoSolicitud.contains('Dolor') || tipoSolicitud.contains('Asistencia')
        ? 'Urgente'
        : 'Media';
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Confirmar solicitud'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Solicitud: $tipoSolicitud'),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: prioridadSeleccionada,
                decoration: inputDecoration().copyWith(labelText: 'Prioridad'),
                items: const [
                  DropdownMenuItem(value: 'Urgente', child: Text('Urgente')),
                  DropdownMenuItem(value: 'Alta', child: Text('Alta')),
                  DropdownMenuItem(value: 'Media', child: Text('Media')),
                  DropdownMenuItem(value: 'Baja', child: Text('Baja')),
                ],
                onChanged: (value) =>
                    setDialogState(() => prioridadSeleccionada = value!),
              ),
              const SizedBox(height: 8),
              const Text(
                'El estado de la solicitud será asignado por el administrador.',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                try {
                  final nueva = Solicitud(
                    titulo: 'Solicitud #${solicitudes.length + 1}',
                    descripcion: tipoSolicitud,
                    paciente: pacienteActual.nombre,
                    tipo: tipoSolicitud,
                    fecha: formatDate(DateTime.now()),
                    estado: 'Creada',
                    prioridad: prioridadSeleccionada,
                    asignadoA: 'Sin asignar',
                    horaCreacion: formatDateTime(DateTime.now()),
                  );
                  nueva.idSolicitud = await SeniorCareDb.crearSolicitudPaciente(
                    paciente: pacienteActual,
                    tipo: tipoSolicitud,
                    descripcion: tipoSolicitud,
                    prioridad: prioridadSeleccionada,
                  );
                  if (nueva.idSolicitud == null) {
                    throw Exception(
                      'No fue posible guardar la solicitud en Supabase.',
                    );
                  }
                  setState(() => solicitudes.add(nueva));
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Solicitud creada con prioridad $prioridadSeleccionada',
                      ),
                      backgroundColor: color,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al guardar solicitud: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Enviar solicitud'),
            ),
          ],
        ),
      ),
    );
  }

  Widget requestButton(String text, IconData icon, Color color) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => confirmarSolicitudPaciente(text, color),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 42),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Vista donde el paciente revisa el estado y prioridad de sus solicitudes.
class PatientRequestsPage extends StatefulWidget {
  const PatientRequestsPage({super.key});

  @override
  State<PatientRequestsPage> createState() => _PatientRequestsPageState();
}

class _PatientRequestsPageState extends State<PatientRequestsPage> {
  @override
  Widget build(BuildContext context) {
    final misSolicitudes = solicitudes
        .where((s) => s.paciente == pacienteActual.nombre)
        .toList();
    return PatientLayout(
      title: 'Mis Solicitudes',
      subtitle: 'Estado de tus solicitudes realizadas',
      child: Column(
        children: [
          if (misSolicitudes.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: cardDecoration(),
              child: const Center(
                child: Text('Aún no tienes solicitudes registradas.'),
              ),
            ),
          ...misSolicitudes.map(
            (s) => listCard(
              title: s.titulo,
              subtitle: s.descripcion,
              children: [
                infoRow('Paciente', s.paciente),
                infoRow('Habitación', pacienteActual.habitacion),
                infoRow('Estado', s.estado),
                infoRow('Prioridad', s.prioridad),
                infoRow('Creada el', s.horaCreacion),
                if (s.horaAsignacion != null)
                  infoRow('Asignada el', s.horaAsignacion!),
                if (s.horaReasignacion != null)
                  infoRow('Reasignada el', s.horaReasignacion!),
                if (s.horaCancelacion != null)
                  infoRow('Cancelada el', s.horaCancelacion!),
                if (s.horaInicioAtencion != null)
                  infoRow('Inicio atención', s.horaInicioAtencion!),
                if (s.horaFinalizacion != null)
                  infoRow('Finalizada el', s.horaFinalizacion!),
                infoRow('Asignado a', s.asignadoA),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Vista de información personal del paciente; permite editar datos permitidos.
class PatientInfoPage extends StatefulWidget {
  final Paciente paciente;
  const PatientInfoPage({super.key, required this.paciente});

  @override
  State<PatientInfoPage> createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage> {
  late final TextEditingController nombreController;
  late final TextEditingController rutController;
  late final TextEditingController telefonoController;
  late final TextEditingController correoController;
  late final TextEditingController direccionController;
  late final TextEditingController fechaNacimientoController;
  late final TextEditingController diagnosticoController;
  late final TextEditingController alergiasController;
  late final TextEditingController medicamentosController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.paciente.nombre);
    rutController = TextEditingController(text: widget.paciente.rut);
    telefonoController = TextEditingController(text: widget.paciente.telefono);
    correoController = TextEditingController(text: widget.paciente.correo);
    direccionController = TextEditingController(
      text: widget.paciente.direccion,
    );
    fechaNacimientoController = TextEditingController(
      text: formatDate(widget.paciente.fechaNacimiento),
    );
    diagnosticoController = TextEditingController(
      text: widget.paciente.diagnostico,
    );
    alergiasController = TextEditingController(text: widget.paciente.alergias);
    medicamentosController = TextEditingController(
      text: widget.paciente.medicamentos,
    );
  }

  Future<void> seleccionarFechaNacimiento() async {
    final seleccion = await showDatePicker(
      context: context,
      initialDate: widget.paciente.fechaNacimiento,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (seleccion != null) {
      setState(() {
        widget.paciente.fechaNacimiento = seleccion;
        fechaNacimientoController.text = formatDate(seleccion);
      });
    }
  }

  void guardarInformacion() {
    setState(() {
      widget.paciente.nombre = nombreController.text;
      widget.paciente.rut = rutController.text;
      widget.paciente.telefono = telefonoController.text;
      widget.paciente.correo = correoController.text;
      widget.paciente.direccion = direccionController.text;
      widget.paciente.diagnostico = diagnosticoController.text;
      widget.paciente.alergias = alergiasController.text;
      widget.paciente.medicamentos = medicamentosController.text;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Información actualizada correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PatientLayout(
      title: 'Mi Información',
      subtitle: 'Datos personales y médicos del paciente',
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información Personal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            patientInput('Nombre completo', nombreController),
            patientInput('RUT', rutController),
            patientInput('Teléfono', telefonoController),
            patientInput('Correo electrónico', correoController),
            patientInput('Dirección', direccionController),
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: TextField(
                controller: fechaNacimientoController,
                readOnly: true,
                onTap: seleccionarFechaNacimiento,
                decoration: inputDecoration().copyWith(
                  labelText: 'Fecha de nacimiento',
                  suffixIcon: const Icon(Icons.calendar_month),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: TextField(
                controller: TextEditingController(
                  text: widget.paciente.habitacion,
                ),
                readOnly: true,
                decoration: inputDecoration().copyWith(
                  labelText: 'Habitación asignada',
                  helperText:
                      'La habitación solo puede modificarla el administrador.',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Información Médica',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            patientInput('Diagnóstico principal', diagnosticoController),
            patientInput('Alergias', alergiasController),
            patientInput('Medicamentos actuales', medicamentosController),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: guardarInformacion,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget patientInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        decoration: inputDecoration().copyWith(labelText: label),
      ),
    );
  }
}

// Vista del paciente para ver, editar o eliminar contactos de emergencia.
class EmergencyContactsPage extends StatefulWidget {
  const EmergencyContactsPage({super.key});

  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  @override
  Widget build(BuildContext context) {
    final contactosPaciente = contactosEmergencia
        .where((c) => c.paciente == pacienteActual.nombre)
        .toList();
    return PatientLayout(
      title: 'Contactos de Emergencia',
      subtitle:
          'Personas registradas para ser contactadas en caso de emergencia',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () => editarContacto(context, null),
              icon: const Icon(Icons.add),
              label: const Text('Nuevo contacto'),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: responsiveColumns(
              context,
              mobile: 1,
              tablet: 2,
              desktop: 2,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 22,
            mainAxisSpacing: 22,
            childAspectRatio: responsiveAspectRatio(
              context,
              mobile: 0.95,
              tablet: 1.15,
              desktop: 1.35,
              largeDesktop: 1.5,
            ),
            children: contactosPaciente
                .map((c) => contactoCard(c, puedeEditar: true))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget contactoCard(ContactoEmergencia c, {required bool puedeEditar}) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            c.nombre,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Chip(
            label: Text('Prioridad ${c.prioridad}'),
            backgroundColor: const Color(0xFFDDEBFF),
            labelStyle: const TextStyle(color: Colors.blue),
          ),
          const SizedBox(height: 14),
          infoRow('Teléfono', c.telefono),
          infoRow('Email', c.email),
          infoRow('Dirección', c.direccion),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => editarContacto(context, c),
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => eliminarContacto(context, c),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void eliminarContacto(BuildContext context, ContactoEmergencia contacto) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar contacto'),
        content: Text(
          '¿Deseas eliminar a ${contacto.nombre} de tus contactos de emergencia?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await SeniorCareDb.eliminarContacto(contacto);
                setState(() {
                  contactosEmergencia.remove(contacto);
                });
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contacto eliminado correctamente'),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al eliminar contacto: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void editarContacto(BuildContext context, ContactoEmergencia? contacto) {
    final nombre = TextEditingController(text: contacto?.nombre ?? '');
    final telefono = TextEditingController(
      text: contacto?.telefono.replaceAll(RegExp(r'[^0-9]'), '') ?? '',
    );
    final email = TextEditingController(text: contacto?.email ?? '');
    final direccion = TextEditingController(text: contacto?.direccion ?? '');

    // Se obtienen las prioridades ya usadas por este paciente.
    // Si se está editando un contacto, se permite conservar su misma prioridad.
    final prioridadesUsadas = contactosEmergencia
        .where((c) => c.paciente == pacienteActual.nombre && c != contacto)
        .map((c) => c.prioridad)
        .toSet();
    final prioridadesDisponibles = [
      1,
      2,
      3,
      4,
      5,
    ].where((p) => !prioridadesUsadas.contains(p)).toList();

    if (prioridadesDisponibles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ya tienes ocupadas todas las prioridades disponibles.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int prioridad = contacto?.prioridad ?? prioridadesDisponibles.first;
    if (!prioridadesDisponibles.contains(prioridad)) {
      prioridad = prioridadesDisponibles.first;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            contacto == null
                ? 'Nuevo contacto de emergencia'
                : 'Editar contacto de emergencia',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombre,
                  decoration: inputDecoration().copyWith(labelText: 'Nombre'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: telefono,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                  ],
                  decoration: inputDecoration().copyWith(
                    labelText: 'Teléfono',
                    helperText: 'Ingresa 9 números, sin +56.',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: email,
                  decoration: inputDecoration().copyWith(labelText: 'Email'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: direccion,
                  decoration: inputDecoration().copyWith(
                    labelText: 'Dirección',
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  value: prioridad,
                  decoration: inputDecoration().copyWith(
                    labelText: 'Prioridad',
                    helperText:
                        'No se puede repetir la prioridad para el mismo paciente.',
                  ),
                  items: prioridadesDisponibles
                      .map(
                        (p) => DropdownMenuItem(
                          value: p,
                          child: Text('Prioridad $p'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => prioridad = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final telefonoLimpio = telefono.text.trim();
                final existePrioridadDuplicada = contactosEmergencia.any(
                  (c) =>
                      c.paciente == pacienteActual.nombre &&
                      c != contacto &&
                      c.prioridad == prioridad,
                );

                if (nombre.text.trim().isEmpty ||
                    telefonoLimpio.isEmpty ||
                    email.text.trim().isEmpty ||
                    direccion.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Completa todos los datos del contacto.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (telefonoLimpio.length != 9) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'El teléfono debe tener exactamente 9 números, sin +56.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (existePrioridadDuplicada) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Esa prioridad ya está asignada a otro contacto de emergencia.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  final contactoPersistente =
                      contacto ??
                      ContactoEmergencia(
                        idPaciente: pacienteActual.idPaciente,
                        paciente: pacienteActual.nombre,
                        nombre: nombre.text.trim(),
                        telefono: telefonoLimpio,
                        email: email.text.trim(),
                        direccion: direccion.text.trim(),
                        prioridad: prioridad,
                      );
                  await SeniorCareDb.crearOActualizarContacto(
                    contacto: contactoPersistente,
                    nombre: nombre.text.trim(),
                    telefono: telefonoLimpio,
                    email: email.text.trim(),
                    direccion: direccion.text.trim(),
                    prioridad: prioridad,
                  );
                  setState(() {
                    if (contacto == null) {
                      contactosEmergencia.add(contactoPersistente);
                    } else {
                      contacto.nombre = nombre.text.trim();
                      contacto.telefono = telefonoLimpio;
                      contacto.email = email.text.trim();
                      contacto.direccion = direccion.text.trim();
                      contacto.prioridad = prioridad;
                    }
                  });
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contacto guardado correctamente'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al guardar contacto: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
