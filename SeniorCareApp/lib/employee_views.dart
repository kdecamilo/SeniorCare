part of 'main.dart';

// ============================================================
// VISTA PROFESIONAL / EMPLEADO / TRABAJADOR
// El trabajador gestiona la atención real de las solicitudes:
// aceptar, iniciar, finalizar, cancelar o reasignar según corresponda.
// ============================================================

// Panel principal del profesional con resumen de tareas, pendientes y turnos.
class ProfessionalDashboardPage extends StatefulWidget {
  const ProfessionalDashboardPage({super.key});

  @override
  State<ProfessionalDashboardPage> createState() =>
      _ProfessionalDashboardPageState();
}

class _ProfessionalDashboardPageState extends State<ProfessionalDashboardPage> {
  @override
  Widget build(BuildContext context) {
    final misSolicitudes = solicitudes
        .where(
          (s) =>
      s.asignadoA == profesionalActual &&
          s.estado != 'Completada' &&
          s.estado != 'Cancelada',
    )
        .toList();
    misSolicitudes.sort((a, b) {
      int orden(String e) =>
          e == 'Pendiente' ? 0 : (e == 'Asignada' || e == 'Reasignada' ? 1 : 2);
      return orden(a.estado).compareTo(orden(b.estado));
    });
    final pendientes = misSolicitudes
        .where(
          (s) =>
      s.estado == 'Asignada' ||
          s.estado == 'Reasignada' ||
          s.estado == 'Pendiente',
    )
        .length;
    final aceptadas = misSolicitudes
        .where((s) => s.estado == 'Aceptada' || s.estado == 'En Proceso')
        .length;
    final misTurnos = turnos
        .where((t) => t.empleado == profesionalActual)
        .toList();

    return ProfessionalLayout(
      title: 'Panel Profesional',
      subtitle: 'Bienvenido/a, $profesionalActual',
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: responsiveColumns(
              context,
              mobile: 1,
              tablet: 2,
              desktop: 4,
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
                'Asignaciones Totales',
                misSolicitudes.length.toString(),
                Icons.assignment,
                Colors.blue,
              ),
              summaryCard(
                'Pendientes',
                pendientes.toString(),
                Icons.assignment_late,
                Colors.deepOrange,
              ),
              summaryCard(
                'Aceptadas / En proceso',
                aceptadas.toString(),
                Icons.check_circle_outline,
                Colors.green,
              ),
              summaryCard(
                'Turnos Esta Semana',
                misTurnos.length.toString(),
                Icons.calendar_month,
                Colors.cyan,
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (misSolicitudes.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Solicitudes Asignadas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...misSolicitudes.map(
                        (s) => professionalMiniCard(context, s),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mis Turnos de la Semana',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: responsiveColumns(
                    context,
                    mobile: 1,
                    tablet: 2,
                    desktop: 3,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: responsiveAspectRatio(
                    context,
                    mobile: 2.0,
                    tablet: 2.45,
                    desktop: 2.75,
                    largeDesktop: 2.9,
                  ),
                  children: misTurnos
                      .map(
                        (t) => Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD7DEE8)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            t.fecha,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month, size: 16),
                              const SizedBox(width: 6),
                              Text('${t.horaInicio} - ${t.horaTermino}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Historial de Solicitudes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'Solicitudes finalizadas, canceladas o reasignadas por $profesionalActual.',
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfessionalHistoryPage(),
                      ),
                    ),
                    icon: const Icon(Icons.history),
                    label: const Text('Ver historial'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget professionalMiniCard(BuildContext context, Solicitud s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD7DEE8)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  s.tipo,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              statusChip(s.estado),
            ],
          ),
          const SizedBox(height: 8),
          Text(s.descripcion),
          const SizedBox(height: 8),
          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              infoRow('Paciente', s.paciente),
              infoRow('Fecha', s.fecha),
              infoRow('Prioridad', s.prioridad),
              if (s.horaAsignacion != null)
                infoRow('Asignada el', s.horaAsignacion!),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfessionalTasksPage(initialSolicitud: s),
                ),
              ),
              child: const Text('Gestionar'),
            ),
          ),
        ],
      ),
    );
  }
}

// Vista de tareas del profesional para aceptar, iniciar, finalizar, cancelar o reasignar solicitudes.
class ProfessionalTasksPage extends StatefulWidget {
  final Solicitud? initialSolicitud;

  const ProfessionalTasksPage({super.key, this.initialSolicitud});

  @override
  State<ProfessionalTasksPage> createState() => _ProfessionalTasksPageState();
}

class _ProfessionalTasksPageState extends State<ProfessionalTasksPage> {
  @override
  Widget build(BuildContext context) {
    final misSolicitudes = solicitudes
        .where(
          (s) =>
      s.asignadoA == profesionalActual &&
          s.estado != 'Completada' &&
          s.estado != 'Cancelada',
    )
        .toList();
    misSolicitudes.sort((a, b) {
      int orden(String e) =>
          e == 'Pendiente' ? 0 : (e == 'Asignada' || e == 'Reasignada' ? 1 : 2);
      return orden(a.estado).compareTo(orden(b.estado));
    });

    return ProfessionalLayout(
      title: 'Mis Tareas',
      subtitle: 'Solicitudes asignadas para atención del paciente',
      child: Column(
        children: [
          if (misSolicitudes.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: cardDecoration(),
              child: const Center(child: Text('No tienes tareas asignadas.')),
            ),
          ...misSolicitudes.map((s) => professionalTaskCard(s)),
        ],
      ),
    );
  }

  Widget professionalTaskCard(Solicitud solicitud) {
    final paciente = pacientes.firstWhere(
          (p) => p.nombre == solicitud.paciente,
      orElse: () => pacienteActual,
    );
    final puedeAceptar =
        solicitud.estado == 'Asignada' ||
            solicitud.estado == 'Reasignada' ||
            solicitud.estado == 'Pendiente';
    final puedeIniciar = solicitud.estado == 'Aceptada';
    final puedeFinalizar = solicitud.estado == 'En Proceso';
    final bloqueada =
        solicitud.estado == 'Cancelada' || solicitud.estado == 'Completada';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: const Border(left: BorderSide(color: Colors.green, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mobile = constraints.maxWidth < 700;
          final left = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      solicitud.tipo,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  statusChip('Solicitud de Paciente'),
                ],
              ),
              const SizedBox(height: 10),
              statusChip('Prioridad: ${solicitud.prioridad}'),
              const SizedBox(height: 18),
              infoRow('Paciente', paciente.nombre),
              infoRow('Información de contacto', paciente.telefono),
              infoRow('Dirección', paciente.direccion),
              infoRow(
                'Especialidad requerida',
                especialidadPorTipo(solicitud.tipo),
              ),
            ],
          );
          final right = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: puedeAceptar
                    ? () => aceptarSolicitud(solicitud)
                    : null,
                icon: const Icon(Icons.check_circle_outline),
                label: Text(
                  solicitud.estado == 'Aceptada' ||
                      solicitud.estado == 'En Proceso' ||
                      solicitud.estado == 'Completada'
                      ? 'Aceptado'
                      : 'Aceptar',
                ),
                style: FilledButton.styleFrom(backgroundColor: Colors.green),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: bloqueada || solicitud.estado == 'En Proceso'
                    ? null
                    : () => marcarPendienteProfesional(solicitud),
                icon: const Icon(Icons.pause_circle_outline),
                label: const Text('Marcar pendiente'),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: puedeIniciar
                    ? () => iniciarSolicitudProfesional(solicitud)
                    : null,
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('Iniciar'),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: puedeFinalizar
                    ? () => finalizarSolicitudProfesional(solicitud)
                    : null,
                icon: const Icon(Icons.stop_circle_outlined),
                label: const Text('Finalizar'),
                style: FilledButton.styleFrom(backgroundColor: Colors.orange),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: bloqueada
                          ? null
                          : () => cancelarSolicitudProfesional(solicitud),
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: solicitud.estado == 'Completada'
                          ? null
                          : () => reasignarSolicitudProfesional(solicitud),
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text('Reasignar'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    timeLineRow('Creado', solicitud.horaCreacion),
                    timeLineRow(
                      'Aceptado',
                      solicitud.estado == 'Aceptada' ||
                          solicitud.estado == 'En Proceso' ||
                          solicitud.estado == 'Completada'
                          ? (solicitud.horaAsignacion ??
                          solicitud.horaReasignacion ??
                          '—')
                          : '—',
                    ),
                    timeLineRow('Inicio', solicitud.horaInicioAtencion ?? '—'),
                    timeLineRow(
                      'Finalizado',
                      solicitud.horaFinalizacion ?? '—',
                    ),
                    if (solicitud.horaCancelacion != null)
                      timeLineRow('Cancelado', solicitud.horaCancelacion!),
                    if (solicitud.horaReasignacion != null)
                      timeLineRow('Reasignado', solicitud.horaReasignacion!),
                    if (solicitud.motivoCancelacion != null)
                      timeLineRow(
                        'Motivo cancelación',
                        solicitud.motivoCancelacion!,
                      ),
                    if (solicitud.motivoReasignacion != null)
                      timeLineRow(
                        'Motivo reasignación',
                        solicitud.motivoReasignacion!,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2937),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProfessionalRequestDetailPage(solicitud: solicitud),
                  ),
                ),
                child: const Text('Ver detalle'),
              ),
            ],
          );

          if (mobile)
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [left, const SizedBox(height: 18), right],
            );
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: left),
              const SizedBox(width: 24),
              Expanded(child: right),
            ],
          );
        },
      ),
    );
  }

  Future<void> guardarEstadoSolicitudEnSupabase(
      Solicitud solicitud,
      String estado,
      String detalle,
      ) async {
    await SeniorCareDb.registrarHistorialSolicitud(
      solicitud: solicitud,
      estado: estado,
      detalle: detalle,
    );
  }

  Future<void> marcarPendienteProfesional(Solicitud solicitud) async {
    final estadoAnterior = solicitud.estado;
    final hora = formatDateTime(DateTime.now());
    setState(() {
      solicitud.estado = 'Pendiente';
    });

    try {
      await guardarEstadoSolicitudEnSupabase(
        solicitud,
        'Pendiente',
        '${solicitud.titulo} fue marcada como pendiente por $profesionalActual a las $hora.',
      );
      registrarHistorial(
        'Solicitud marcada pendiente',
        '${solicitud.titulo} fue marcada como pendiente por $profesionalActual a las $hora.',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud marcada como pendiente')),
      );
    } catch (e) {
      setState(() => solicitud.estado = estadoAnterior);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar en Supabase: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> aceptarSolicitud(Solicitud solicitud) async {
    final estadoAnterior = solicitud.estado;
    final horaAnterior = solicitud.horaAsignacion;
    final hora = formatDateTime(DateTime.now());
    setState(() {
      solicitud.estado = 'Aceptada';
      solicitud.horaAsignacion ??= hora;
    });

    try {
      await guardarEstadoSolicitudEnSupabase(
        solicitud,
        'Aceptada',
        '${solicitud.titulo} fue aceptada por $profesionalActual a las $hora.',
      );
      registrarHistorial(
        'Solicitud aceptada por profesional',
        '${solicitud.titulo} fue aceptada por $profesionalActual a las $hora.',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud aceptada correctamente')),
      );
    } catch (e) {
      setState(() {
        solicitud.estado = estadoAnterior;
        solicitud.horaAsignacion = horaAnterior;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar en Supabase: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> iniciarSolicitudProfesional(Solicitud solicitud) async {
    final estadoAnterior = solicitud.estado;
    final horaInicioAnterior = solicitud.horaInicioAtencion;
    final hora = formatDateTime(DateTime.now());
    setState(() {
      solicitud.estado = 'En Proceso';
      solicitud.horaInicioAtencion = hora;
    });

    try {
      await guardarEstadoSolicitudEnSupabase(
        solicitud,
        'En Proceso',
        '${solicitud.titulo} fue iniciada por $profesionalActual a las $hora.',
      );
      registrarHistorial(
        'Inicio de atención',
        '${solicitud.titulo} fue iniciada por $profesionalActual a las $hora.',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Atención iniciada correctamente')),
      );
    } catch (e) {
      setState(() {
        solicitud.estado = estadoAnterior;
        solicitud.horaInicioAtencion = horaInicioAnterior;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar en Supabase: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> finalizarSolicitudProfesional(Solicitud solicitud) async {
    final estadoAnterior = solicitud.estado;
    final horaFinalizacionAnterior = solicitud.horaFinalizacion;
    final hora = formatDateTime(DateTime.now());
    setState(() {
      solicitud.estado = 'Completada';
      solicitud.horaFinalizacion = hora;
    });

    try {
      await guardarEstadoSolicitudEnSupabase(
        solicitud,
        'Completada',
        '${solicitud.titulo} fue finalizada por $profesionalActual a las $hora.',
      );
      registrarHistorial(
        'Finalización de atención',
        '${solicitud.titulo} fue finalizada por $profesionalActual a las $hora.',
      );
      registrarHistorialProfesional(
        profesional: profesionalActual,
        solicitud: solicitud,
        estadoFinal: 'Completada',
        detalle: 'Solicitud finalizada correctamente a las $hora.',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud finalizada correctamente')),
      );
    } catch (e) {
      setState(() {
        solicitud.estado = estadoAnterior;
        solicitud.horaFinalizacion = horaFinalizacionAnterior;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar en Supabase: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void cancelarSolicitudProfesional(Solicitud solicitud) {
    final motivoController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancelar solicitud'),
        content: TextField(
          controller: motivoController,
          maxLines: 3,
          decoration: inputDecoration().copyWith(
            labelText: 'Motivo de cancelación',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Volver'),
          ),
          FilledButton(
            onPressed: () async {
              final estadoAnterior = solicitud.estado;
              final horaCancelacionAnterior = solicitud.horaCancelacion;
              final motivoCancelacionAnterior = solicitud.motivoCancelacion;
              final asignadoAnterior = solicitud.asignadoA;
              final hora = formatDateTime(DateTime.now());
              final motivo = motivoController.text.trim().isEmpty
                  ? 'Sin motivo registrado'
                  : motivoController.text.trim();
              setState(() {
                solicitud.estado = 'Cancelada';
                solicitud.horaCancelacion = hora;
                solicitud.motivoCancelacion = motivo;
                solicitud.asignadoA = 'Sin asignar';
              });

              try {
                await guardarEstadoSolicitudEnSupabase(
                  solicitud,
                  'Cancelada',
                  '${solicitud.titulo} fue cancelada por $profesionalActual a las $hora. Motivo: $motivo.',
                );
                registrarHistorial(
                  'Solicitud cancelada por profesional',
                  '${solicitud.titulo} fue cancelada por $profesionalActual a las $hora. Motivo: $motivo.',
                );
                registrarHistorialProfesional(
                  profesional: profesionalActual,
                  solicitud: solicitud,
                  estadoFinal: 'Cancelada',
                  detalle: 'Cancelada a las $hora. Motivo: $motivo.',
                );
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Solicitud cancelada. El administrador podrá reasignarla si corresponde.',
                    ),
                  ),
                );
              } catch (e) {
                setState(() {
                  solicitud.estado = estadoAnterior;
                  solicitud.horaCancelacion = horaCancelacionAnterior;
                  solicitud.motivoCancelacion = motivoCancelacionAnterior;
                  solicitud.asignadoA = asignadoAnterior;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al guardar en Supabase: $e'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Cancelar solicitud'),
          ),
        ],
      ),
    );
  }

  void reasignarSolicitudProfesional(Solicitud solicitud) {
    String nuevoEmpleado = empleados
        .firstWhere(
          (e) => e.nombre != profesionalActual,
      orElse: () => empleados.first,
    )
        .nombre;
    final motivoController = TextEditingController(
      text:
      'Mi turno terminó y no pude completar esta solicitud. Se reasigna para continuidad de atención.',
    );
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Reasignar solicitud'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selecciona el profesional que continuará con la solicitud.',
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: nuevoEmpleado,
                decoration: inputDecoration().copyWith(
                  labelText: 'Nuevo profesional',
                ),
                items: empleados
                    .where((e) => e.nombre != profesionalActual)
                    .map(
                      (e) => DropdownMenuItem(
                    value: e.nombre,
                    child: Text('${e.nombre} - ${e.cargo}'),
                  ),
                )
                    .toList(),
                onChanged: (value) =>
                    setDialogState(() => nuevoEmpleado = value!),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: motivoController,
                maxLines: 4,
                decoration: inputDecoration().copyWith(
                  labelText: 'Descripción del motivo de reasignación',
                ),
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
                final empleadoAnterior = solicitud.asignadoA;
                final estadoAnterior = solicitud.estado;
                final horaReasignacionAnterior = solicitud.horaReasignacion;
                final motivoReasignacionAnterior = solicitud.motivoReasignacion;
                final horaInicioAnterior = solicitud.horaInicioAtencion;
                final horaFinalizacionAnterior = solicitud.horaFinalizacion;
                final horaCancelacionAnterior = solicitud.horaCancelacion;
                final idEmpleadoAnterior = solicitud.idEmpleadoAsignado;
                final hora = formatDateTime(DateTime.now());
                final motivo = motivoController.text.trim().isEmpty
                    ? 'Sin descripción registrada'
                    : motivoController.text.trim();

                try {
                  final idNuevoEmpleado = await SeniorCareDb.asignarSolicitud(
                    solicitud: solicitud,
                    empleadoNombre: nuevoEmpleado,
                    reasignar: true,
                    descripcion: motivo,
                  );
                  if (idNuevoEmpleado == null) {
                    throw Exception('No se pudo encontrar el nuevo empleado en Supabase.');
                  }
                  await guardarEstadoSolicitudEnSupabase(
                    solicitud,
                    'Reasignada',
                    '${solicitud.titulo} fue reasignada por $profesionalActual a $nuevoEmpleado a las $hora. Motivo: $motivo.',
                  );

                  setState(() {
                    solicitud.idEmpleadoAsignado = idNuevoEmpleado;
                    solicitud.asignadoA = nuevoEmpleado;
                    solicitud.estado = 'Reasignada';
                    solicitud.horaReasignacion = hora;
                    solicitud.motivoReasignacion = motivo;
                    solicitud.horaInicioAtencion = null;
                    solicitud.horaFinalizacion = null;
                    solicitud.horaCancelacion = null;
                  });
                  registrarHistorial(
                    'Solicitud reasignada por profesional',
                    '${solicitud.titulo} fue reasignada por $profesionalActual a $nuevoEmpleado a las $hora. Motivo: $motivo.',
                  );
                  registrarHistorialProfesional(
                    profesional: profesionalActual,
                    solicitud: solicitud,
                    estadoFinal: 'Reasignada',
                    detalle:
                    'Reasignada a $nuevoEmpleado a las $hora. Motivo: $motivo.',
                  );
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Solicitud reasignada correctamente'),
                    ),
                  );
                } catch (e) {
                  setState(() {
                    solicitud.idEmpleadoAsignado = idEmpleadoAnterior;
                    solicitud.asignadoA = empleadoAnterior;
                    solicitud.estado = estadoAnterior;
                    solicitud.horaReasignacion = horaReasignacionAnterior;
                    solicitud.motivoReasignacion = motivoReasignacionAnterior;
                    solicitud.horaInicioAtencion = horaInicioAnterior;
                    solicitud.horaFinalizacion = horaFinalizacionAnterior;
                    solicitud.horaCancelacion = horaCancelacionAnterior;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al reasignar en Supabase: $e'), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('Reasignar'),
            ),
          ],
        ),
      ),
    );
  }
}

// Vista detallada de una solicitud con datos del paciente, red de apoyo y registro de tiempos.
class ProfessionalRequestDetailPage extends StatelessWidget {
  final Solicitud solicitud;

  const ProfessionalRequestDetailPage({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    final paciente = pacientes.firstWhere(
          (p) => p.nombre == solicitud.paciente,
      orElse: () => pacienteActual,
    );
    final contacto =
    contactosEmergencia
        .where((c) => c.paciente == paciente.nombre)
        .isNotEmpty
        ? contactosEmergencia.where((c) => c.paciente == paciente.nombre).first
        : null;
    final profesional = empleados.firstWhere(
          (e) => e.nombre == solicitud.asignadoA,
      orElse: () => empleados.first,
    );

    return ProfessionalLayout(
      title: 'Detalle de ${solicitud.titulo}',
      subtitle: 'Información completa de la solicitud y registro de tiempos',
      child: Column(
        children: [
          detailSection(
            title: 'Datos del Paciente',
            icon: Icons.person_outline,
            color: Colors.blue,
            children: [
              infoRow('Nombre', paciente.nombre),
              infoRow('RUT', paciente.rut),
              infoRow('Teléfono', paciente.telefono),
              infoRow('Comuna', 'Santiago'),
              infoRow('Dirección', paciente.direccion),
              infoRow('Habitación', paciente.habitacion),
            ],
          ),
          detailSection(
            title: 'Red de Apoyo',
            icon: Icons.groups_outlined,
            color: Colors.pink,
            children: [
              infoRow('Nombre', contacto?.nombre ?? 'Sin contacto registrado'),
              infoRow(
                'Prioridad',
                contacto == null ? '—' : contacto.prioridad.toString(),
              ),
              infoRow('Teléfono', contacto?.telefono ?? '—'),
              infoRow('Email', contacto?.email ?? '—'),
            ],
          ),
          detailSection(
            title: 'Solicitud',
            icon: Icons.assignment_outlined,
            color: Colors.purple,
            children: [
              statusChip('Solicitud de Paciente'),
              infoRow('Tipo', solicitud.tipo),
              infoRow('Estado', solicitud.estado),
              infoRow('Prioridad', solicitud.prioridad),
              infoRow('Fecha', solicitud.fecha),
              infoRow('Descripción', solicitud.descripcion),
            ],
          ),
          detailSection(
            title: 'Profesional Asignado',
            icon: Icons.badge_outlined,
            color: Colors.green,
            children: [
              infoRow('Nombre', solicitud.asignadoA),
              infoRow('Especialidad', profesional.cargo),
              infoRow('Teléfono', profesional.telefono),
            ],
          ),
          detailSection(
            title: 'Registro de Tiempos',
            icon: Icons.schedule,
            color: Colors.deepOrange,
            children: [
              infoRow('Creado', solicitud.horaCreacion),
              infoRow('Asignado', solicitud.horaAsignacion ?? '—'),
              infoRow(
                'Aceptado',
                solicitud.estado == 'Aceptada' ||
                    solicitud.estado == 'En Proceso' ||
                    solicitud.estado == 'Completada'
                    ? (solicitud.horaAsignacion ??
                    solicitud.horaReasignacion ??
                    '—')
                    : '—',
              ),
              infoRow('Iniciado', solicitud.horaInicioAtencion ?? '—'),
              infoRow('Finalizado', solicitud.horaFinalizacion ?? '—'),
              infoRow('Cancelado', solicitud.horaCancelacion ?? '—'),
              infoRow('Reasignado', solicitud.horaReasignacion ?? '—'),
              infoRow('Duración total', calcularDuracionSolicitud(solicitud)),
            ],
          ),
        ],
      ),
    );
  }
}

String normalizarEstadoSolicitud(String estado) {
  final e = estado.toLowerCase().trim();

  if (e.contains('complet') || e.contains('finaliz')) return 'completada';
  if (e.contains('cancel')) return 'cancelada';
  if (e.contains('reasign')) return 'reasignada';
  if (e.contains('proceso')) return 'en proceso';
  if (e.contains('acept')) return 'aceptada';
  if (e.contains('pend')) return 'pendiente';
  if (e.contains('asign')) return 'asignada';

  return e;
}

// Historial del profesional con solicitudes finalizadas, canceladas o reasignadas.
class ProfessionalHistoryPage extends StatelessWidget {
  const ProfessionalHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final registrosMap = <String, HistorialProfesional>{};

    for (final h in historialProfesional.where((h) => h.profesional == profesionalActual)) {
      registrosMap['${h.solicitud}|${h.estadoFinal}|${h.fecha}|${h.detalle}'] = h;
    }

    for (final s in solicitudes.where((s) =>
    s.asignadoA == profesionalActual &&
        (normalizarEstadoSolicitud(s.estado) == 'completada' ||
            normalizarEstadoSolicitud(s.estado) == 'finalizada' ||
            normalizarEstadoSolicitud(s.estado) == 'cancelada' ||
            normalizarEstadoSolicitud(s.estado) == 'reasignada'))) {
      registrosMap['${s.titulo}|${s.estado}|${s.horaFinalizacion ?? s.horaCancelacion ?? s.horaReasignacion ?? s.horaAsignacion ?? s.horaCreacion}'] = HistorialProfesional(
        profesional: profesionalActual,
        solicitud: s.titulo,
        paciente: s.paciente,
        tipo: s.tipo,
        estadoFinal: s.estado,
        detalle: s.motivoCancelacion ?? s.motivoReasignacion ?? s.descripcion,
        fecha: s.horaFinalizacion ?? s.horaCancelacion ?? s.horaReasignacion ?? s.horaAsignacion ?? s.horaCreacion,
      );
    }

    final registros = registrosMap.values.toList();

    return ProfessionalLayout(
      title: 'Historial de Solicitudes',
      subtitle: 'Solicitudes gestionadas por $profesionalActual',
      child: Column(
        children: [
          if (registros.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: cardDecoration(),
              child: const Center(
                child: Text('Aún no tienes solicitudes en el historial.'),
              ),
            ),
          ...registros.map(
                (h) => listCard(
              title: h.solicitud,
              subtitle: h.detalle,
              children: [
                statusChip(h.estadoFinal),
                infoRow('Paciente', h.paciente),
                infoRow('Tipo', h.tipo),
                infoRow('Fecha y hora', h.fecha),
                infoRow('Profesional', h.profesional),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


Widget paginaProfesionalActualPorTitulo(String title) {
  switch (title) {
    case 'Panel Profesional':
      return const ProfessionalDashboardPage();
    case 'Mis Tareas':
      return const ProfessionalTasksPage();
    case 'Historial de Solicitudes':
      return const ProfessionalHistoryPage();
    case 'Gestión temporal de solicitudes':
      return const ProfessionalTasksPage();
    default:
      return const ProfessionalDashboardPage();
  }
}

Future<void> refrescarVistaProfesional(BuildContext context, String title) async {
  try {
    await cargarSesionActualDesdeSupabase();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos actualizados correctamente')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => paginaProfesionalActualPorTitulo(title)),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al actualizar datos: $e'), backgroundColor: Colors.red),
    );
  }
}

// Layout base para pantallas del profesional.
class ProfessionalLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const ProfessionalLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 650;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            CircleAvatar(
              backgroundColor: Color(0xFFDDEBFF),
              child: Icon(Icons.favorite_border, color: Colors.blue),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SeniorCare',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('Profesional', style: TextStyle(fontSize: 11)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Inicio',
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfessionalDashboardPage(),
              ),
            ),
            icon: const Icon(Icons.home),
          ),
          IconButton(
            tooltip: 'Actualizar',
            onPressed: () => refrescarVistaProfesional(context, title),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            ),
            icon: const Icon(Icons.logout, color: Colors.red),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: responsivePadding(context),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: responsiveMaxWidth(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(subtitle),
                const SizedBox(height: 24),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Fila reutilizable para mostrar una etiqueta y una hora dentro del registro de tiempos.
Widget timeLineRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

// Tarjeta reutilizable para mostrar secciones de detalle con color e icono.
Widget detailSection({
  required String title,
  required IconData icon,
  required Color color,
  required List<Widget> children,
}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: color.withOpacity(0.10),
      border: Border.all(color: color.withOpacity(0.65)),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(spacing: 40, runSpacing: 12, children: children),
      ],
    ),
  );
}

String especialidadPorTipo(String tipo) {
  final t = tipo.toLowerCase();
  if (t.contains('médica') || t.contains('medica') || t.contains('dolor'))
    return 'Medicina';
  if (t.contains('medicación') || t.contains('medicamento'))
    return 'Enfermería';
  if (t.contains('traslado') || t.contains('caminar') || t.contains('postura'))
    return 'Cuidador/a';
  return 'Asistencia general';
}

DateTime? tryParseDateTime(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  try {
    final parts = value.split(' ');
    final date = parts[0].split('-');
    final time = parts.length > 1 ? parts[1].split(':') : ['0', '0'];
    return DateTime(
      int.parse(date[2]),
      int.parse(date[1]),
      int.parse(date[0]),
      int.parse(time[0]),
      int.parse(time[1]),
    );
  } catch (_) {
    return null;
  }
}

String calcularDuracionSolicitud(Solicitud solicitud) {
  final inicio = tryParseDateTime(solicitud.horaInicioAtencion);
  final fin = tryParseDateTime(solicitud.horaFinalizacion);
  if (inicio == null || fin == null) return '—';
  final duracion = fin.difference(inicio);
  if (duracion.inMinutes < 60) return '${duracion.inMinutes} minutos';
  return '${duracion.inHours} h ${duracion.inMinutes.remainder(60)} min';
}
