// ============================================================
// SENIORCARE - APLICACIÓN FLUTTER
// ------------------------------------------------------------
// Este archivo contiene una versión funcional de la aplicación
// SeniorCare con datos temporales en memoria. Más adelante,
// estos datos pueden conectarse a la base de datos relacional
// definitiva mediante servicios, API o conexión local.
//
// Módulos incluidos:
// - Inicio de sesión y creación de cuenta.
// - Panel de paciente con solicitudes rápidas.
// - Información personal y contactos de emergencia editables por paciente.
// - Panel administrador con pacientes, habitaciones, solicitudes, turnos,
//   permisos temporales e historial.
// - Panel profesional con tareas asignadas, pendientes, gestión de atención
//   e historial de acciones.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


part 'patient_views.dart';
part 'employee_views.dart';

// Punto de entrada de la aplicación: inicia SeniorCare en Flutter.
// Inicializa Supabase para que la app pueda leer y guardar registros reales.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rkcqrauwzjwmompqfqum.supabase.co',
    anonKey: 'sb_publishable_MnixKcikNKp_UwMBGjjPlg_steewCxh',
  );

  runApp(const SeniorCareApp());
}

// Configura la aplicación principal, tema visual, idioma español y pantalla inicial.
class SeniorCareApp extends StatelessWidget {
  const SeniorCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SeniorCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        useMaterial3: true,
      ),
      // Configuración en español para calendarios, selectores de hora y textos del sistema.
      locale: const Locale('es', 'CL'),
      supportedLocales: const [Locale('es', 'CL'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const LoginPage(),
    );
  }
}

// ============================================================
// MODELOS TEMPORALES
// Luego estos modelos se reemplazan por datos desde la base de datos.
// ============================================================

// Modelo temporal que representa a un paciente del hogar de adultos mayores.
class Paciente {
  int? idPaciente;
  int? idUsuario;
  int? idHabitacion;
  String nombre;
  String rut;
  String telefono;
  String correo;
  String direccion;
  DateTime fechaNacimiento;
  String habitacion;
  String fechaIngreso;
  String estado;
  String diagnostico;
  String alergias;
  String medicamentos;
  String motivoInactividad;
  String descripcionInactividad;
  String fechaInactividad;

  Paciente({
    this.idPaciente,
    this.idUsuario,
    this.idHabitacion,
    required this.nombre,
    required this.rut,
    required this.telefono,
    required this.correo,
    required this.direccion,
    required this.fechaNacimiento,
    required this.habitacion,
    required this.fechaIngreso,
    required this.estado,
    required this.diagnostico,
    required this.alergias,
    required this.medicamentos,
    this.motivoInactividad = '',
    this.descripcionInactividad = '',
    this.fechaInactividad = '',
  });
}

// Modelo temporal que representa a un trabajador/profesional del sistema.
class Empleado {
  int? idEmpleado;
  int? idUsuario;
  int? idCargo;
  String nombre;
  String rut;
  String cargo;
  String telefono;
  String estado;
  bool permisoAdminTemporal;

  Empleado({
    this.idEmpleado,
    this.idUsuario,
    this.idCargo,
    required this.nombre,
    required this.rut,
    required this.cargo,
    required this.telefono,
    required this.estado,
    this.permisoAdminTemporal = false,
  });
}

// Modelo temporal de una solicitud creada por el paciente y gestionada por profesionales.
class Solicitud {
  int? idSolicitud;
  int? idAsignacion;
  int? idEmpleadoAsignado;
  String titulo;
  String descripcion;
  String paciente;
  String tipo;
  String fecha;
  String estado;
  String prioridad;
  String asignadoA;

  // Fechas y horas de trazabilidad para que cada acción quede registrada.
  String horaCreacion;
  String? horaAsignacion;
  String? horaReasignacion;
  String? horaCancelacion;
  String? horaInicioAtencion;
  String? horaFinalizacion;
  String? motivoCancelacion;
  String? motivoReasignacion;

  Solicitud({
    this.idSolicitud,
    this.idAsignacion,
    this.idEmpleadoAsignado,
    required this.titulo,
    required this.descripcion,
    required this.paciente,
    required this.tipo,
    required this.fecha,
    required this.estado,
    required this.prioridad,
    required this.asignadoA,
    String? horaCreacion,
    this.horaAsignacion,
    this.horaReasignacion,
    this.horaCancelacion,
    this.horaInicioAtencion,
    this.horaFinalizacion,
    this.motivoCancelacion,
    this.motivoReasignacion,
  }) : horaCreacion = horaCreacion ?? formatDateTime(DateTime.now());
}

// Modelo temporal para representar habitaciones, capacidad, ocupación y paciente asignado.
class Habitacion {
  int? idHabitacion;
  String numero;
  String piso;
  int capacidad;
  int ocupantes;
  String estado;
  String paciente;

  Habitacion({
    this.idHabitacion,
    required this.numero,
    required this.piso,
    required this.capacidad,
    required this.ocupantes,
    required this.estado,
    required this.paciente,
  });
}

// Modelo temporal para registrar los turnos semanales de cada profesional.
class Turno {
  int? idTurno;
  int? idEmpleado;
  String empleado;
  String cargo;
  String fecha;
  String horaInicio;
  String horaTermino;
  String estado;

  Turno({
    this.idTurno,
    this.idEmpleado,
    required this.empleado,
    required this.cargo,
    required this.fecha,
    required this.horaInicio,
    required this.horaTermino,
    required this.estado,
  });
}

// Modelo temporal para los contactos de emergencia asociados a un paciente.
class ContactoEmergencia {
  int? idContEmer;
  int? idPacienteCont;
  int? idPaciente;
  String paciente;
  String nombre;
  String telefono;
  String email;
  String direccion;
  int prioridad;

  ContactoEmergencia({
    this.idContEmer,
    this.idPacienteCont,
    this.idPaciente,
    required this.paciente,
    required this.nombre,
    required this.telefono,
    required this.email,
    required this.direccion,
    required this.prioridad,
  });
}

// Modelo temporal para permisos especiales entregados a profesionales durante su jornada.
class PermisoTemporal {
  int? idPermiso;
  int? idEmpleado;
  String empleado;
  String permiso;
  DateTime inicio;
  DateTime termino;
  String estado;

  // Hora real en que se registró o revocó el permiso en el sistema.
  String horaOtorgado;
  String? horaRevocado;

  PermisoTemporal({
    this.idPermiso,
    this.idEmpleado,
    required this.empleado,
    required this.permiso,
    required this.inicio,
    required this.termino,
    required this.estado,
    String? horaOtorgado,
    this.horaRevocado,
  }) : horaOtorgado = horaOtorgado ?? formatDateTime(DateTime.now());

  bool get activoAhora {
    final ahora = DateTime.now();
    return estado == 'Activo' &&
        (ahora.isAtSameMomentAs(inicio) || ahora.isAfter(inicio)) &&
        ahora.isBefore(termino);
  }
}

// Modelo temporal para registrar acciones importantes realizadas en el sistema por administración.
class HistorialAdmin {
  String accion;
  String detalle;
  String fecha;
  String responsable;

  HistorialAdmin({
    required this.accion,
    required this.detalle,
    required this.fecha,
    required this.responsable,
  });
}

// Modelo temporal para guardar el historial de pacientes retirados, trasladados o fallecidos.
class HistorialPacienteInactivo {
  String paciente;
  String motivo;
  String descripcion;
  String fecha;
  String responsable;

  HistorialPacienteInactivo({
    required this.paciente,
    required this.motivo,
    required this.descripcion,
    required this.fecha,
    required this.responsable,
  });
}

// Modelo temporal para guardar las acciones realizadas por el profesional sobre sus solicitudes.
class HistorialProfesional {
  String profesional;
  String solicitud;
  String paciente;
  String tipo;
  String estadoFinal;
  String detalle;
  String fecha;

  HistorialProfesional({
    required this.profesional,
    required this.solicitud,
    required this.paciente,
    required this.tipo,
    required this.estadoFinal,
    required this.detalle,
    required this.fecha,
  });
}

// ============================================================
// DATOS EN MEMORIA CARGADOS DESDE SUPABASE
// ------------------------------------------------------------
// Estas listas parten vacías. Se llenan al iniciar sesión o cuando
// se agregan registros reales en Supabase. Así la app ya no muestra
// pacientes, empleados, solicitudes ni habitaciones de prueba.
// ============================================================

final pacientes = <Paciente>[];
final empleados = <Empleado>[];
final solicitudes = <Solicitud>[];
final habitaciones = <Habitacion>[];
final turnos = <Turno>[];
final contactosEmergencia = <ContactoEmergencia>[];

final permisosTemporales = <PermisoTemporal>[];
final historialAdmin = <HistorialAdmin>[];
final historialPacientesInactivos = <HistorialPacienteInactivo>[];
final historialProfesional = <HistorialProfesional>[];

// Datos de sesión del usuario autenticado con la tabla usuario de Supabase.
Map<String, dynamic>? usuarioSesion;
String rolSesion = '';
Paciente? pacienteSesion;
Empleado? empleadoSesion;

// Clave interna de registro para crear cuentas de administrador.
// En una aplicación real esta clave NO debe quedar escrita en Flutter.
// Debe validarse desde backend, una función RPC o una tabla segura con RLS.
const String numeroSerieAdministrador = 'SC-ADMIN-2026';

// Esta versión usa Supabase como base de datos, pero NO usa Supabase Auth
// para crear cuentas. Así se evita el error "email rate limit exceeded".
const bool usarSupabaseAuthParaRegistro = false;
const bool enviarCorreoRecuperacionReal = false;

// ============================================================
// SERVICIO SUPABASE DE LA APP
// ------------------------------------------------------------
// Estos métodos guardan en Supabase las acciones principales de la app.
// Se evitan consultas con relaciones embebidas como habitacion(*) para no
// generar errores PGRST201 por relaciones múltiples.
// ============================================================
class SeniorCareDb {
  static SupabaseClient get db => Supabase.instance.client;

  static Future<int?> idTipoSolicitudPorNombre(String nombre) async {
    final existente = await db
        .from('tipo_solicitud')
        .select('id_tipo')
        .eq('nombre_tipo', nombre)
        .maybeSingle();
    if (existente != null) return existente['id_tipo'] as int?;
    final insertado = await db
        .from('tipo_solicitud')
        .insert({
      'nombre_tipo': nombre,
      'descripcion': 'Solicitud creada desde la aplicación SeniorCare',
    })
        .select('id_tipo')
        .single();
    return insertado['id_tipo'] as int?;
  }

  static Future<int?> idPrioridadPorNombre(String nombre) async {
    final p = await db
        .from('prioridad')
        .select('id_prioridad')
        .eq('tipo_prioridad', nombre)
        .maybeSingle();
    return p?['id_prioridad'] as int?;
  }

  static Future<int?> idEstadoSolPorNombre(String nombre) async {
    final e = await db
        .from('estado_sol')
        .select('id_est')
        .ilike('nombre_estado', nombre)
        .maybeSingle();
    return e?['id_est'] as int?;
  }

  static Future<int?> idEstadoAsigPorNombre(String nombre) async {
    final e = await db
        .from('estado_asig')
        .select('id_est_asig')
        .ilike('nombre', nombre)
        .maybeSingle();
    return e?['id_est_asig'] as int?;
  }

  static Future<int?> idEmpleadoPorNombreCompleto(String nombreCompleto) async {
    final registros = await db
        .from('empleado')
        .select('id_empleado, p_nombre, s_nombre, ap_paterno, ap_materno');
    for (final e in List<Map<String, dynamic>>.from(registros)) {
      final nombre =
      '${e['p_nombre'] ?? ''} ${e['s_nombre'] ?? ''} ${e['ap_paterno'] ?? ''} ${e['ap_materno'] ?? ''}'
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      if (nombre == nombreCompleto) return e['id_empleado'] as int?;
    }
    return null;
  }

  static Future<int?> crearSolicitudPaciente({
    required Paciente paciente,
    required String tipo,
    required String descripcion,
    required String prioridad,
  }) async {
    if (paciente.idPaciente == null) return null;
    final idTipo = await idTipoSolicitudPorNombre(tipo);
    if (idTipo == null) return null;
    final solicitud = await db
        .from('solicitud')
        .insert({
      'descripcion': descripcion,
      'id_tipo': idTipo,
      'id_paciente': paciente.idPaciente,
    })
        .select('id_solicitud, fecha_creacion')
        .single();
    final idSolicitud = solicitud['id_solicitud'] as int;
    final idPri = await idPrioridadPorNombre(prioridad);
    if (idPri != null) {
      await db.from('sol_prioridad').insert({
        'id_prioridad': idPri,
        'id_solicitud': idSolicitud,
        'descripcion': 'Prioridad definida por paciente al crear la solicitud',
      });
    }
    return idSolicitud;
  }

  static Future<void> crearOActualizarContacto({
    required ContactoEmergencia contacto,
    required String nombre,
    required String telefono,
    required String email,
    required String direccion,
    required int prioridad,
    int? idComuna,
  }) async {
    idComuna ??= await _idComunaFallback(contacto.idPaciente);
    final partes = nombre.trim().split(RegExp(r'\s+'));
    final pNombre = partes.isNotEmpty ? partes.first : nombre.trim();
    final apPaterno = partes.length >= 2 ? partes[1] : 'SinApellido';
    final apMaterno = partes.length >= 3
        ? partes.sublist(2).join(' ')
        : 'SinApellido';
    if (contacto.idContEmer == null) {
      final ce = await db
          .from('cont_emer')
          .insert({
        'p_nombre': pNombre,
        'ap_paterno': apPaterno,
        'ap_materno': apMaterno,
        'telefono': telefono,
        'correo': email,
        'direccion': direccion,
        'id_comuna': idComuna,
      })
          .select('id_cont_emer')
          .single();
      contacto.idContEmer = ce['id_cont_emer'] as int?;
      if (contacto.idPaciente != null && contacto.idContEmer != null) {
        final pc = await db
            .from('paciente_cont')
            .insert({
          'prioridad': prioridad,
          'id_cont_emer': contacto.idContEmer,
          'id_paciente': contacto.idPaciente,
        })
            .select('id_paciente_cont')
            .single();
        contacto.idPacienteCont = pc['id_paciente_cont'] as int?;
      }
    } else {
      await db
          .from('cont_emer')
          .update({
        'p_nombre': pNombre,
        'ap_paterno': apPaterno,
        'ap_materno': apMaterno,
        'telefono': telefono,
        'correo': email,
        'direccion': direccion,
        'id_comuna': idComuna,
      })
          .eq('id_cont_emer', contacto.idContEmer!);
      if (contacto.idPacienteCont != null) {
        await db
            .from('paciente_cont')
            .update({'prioridad': prioridad})
            .eq('id_paciente_cont', contacto.idPacienteCont!);
      }
    }
  }

  static Future<int?> _idComunaFallback(int? idPaciente) async {
    if (idPaciente != null) {
      final p = await db
          .from('paciente')
          .select('id_comuna')
          .eq('id_paciente', idPaciente)
          .maybeSingle();
      if (p != null && p['id_comuna'] != null) return p['id_comuna'] as int;
    }
    final c = await db
        .from('comuna')
        .select('id_comuna')
        .or('nombre_comuna.eq.Concepción,nombre_comuna.eq.Concepcion')
        .limit(1)
        .maybeSingle();
    return c?['id_comuna'] as int?;
  }

  static Future<void> eliminarContacto(ContactoEmergencia contacto) async {
    if (contacto.idPacienteCont != null) {
      await db
          .from('paciente_cont')
          .delete()
          .eq('id_paciente_cont', contacto.idPacienteCont!);
    }
    if (contacto.idContEmer != null) {
      await db
          .from('cont_emer')
          .delete()
          .eq('id_cont_emer', contacto.idContEmer!);
    }
  }

  static Future<int?> asignarSolicitud({
    required Solicitud solicitud,
    required String empleadoNombre,
    required bool reasignar,
    String? descripcion,
  }) async {
    if (solicitud.idSolicitud == null) return null;
    final idEmpleado = await idEmpleadoPorNombreCompleto(empleadoNombre);
    if (idEmpleado == null) return null;

    final textoDescripcion = (descripcion == null || descripcion.trim().isEmpty)
        ? (reasignar
        ? 'Reasignación desde administrador'
        : 'Asignación desde administrador')
        : descripcion.trim();

    if (solicitud.idAsignacion == null) {
      final asig = await db
          .from('asignacion')
          .insert({
        'descripcion': textoDescripcion.length > 100
            ? textoDescripcion.substring(0, 100)
            : textoDescripcion,
        'id_solicitud': solicitud.idSolicitud,
        'id_empleado': idEmpleado,
      })
          .select('id_asig')
          .single();
      solicitud.idAsignacion = asig['id_asig'] as int?;
    } else {
      await db
          .from('asignacion')
          .update({
        'descripcion': textoDescripcion.length > 100
            ? textoDescripcion.substring(0, 100)
            : textoDescripcion,
        'id_empleado': idEmpleado,
      })
          .eq('id_asig', solicitud.idAsignacion!);
    }
    final idEstado = await idEstadoAsigPorNombre(
      reasignar ? 'Reasignada' : 'Asignada',
    );
    if (idEstado != null && solicitud.idAsignacion != null) {
      await db.from('asig_estado').insert({
        'id_est_asig': idEstado,
        'id_asig': solicitud.idAsignacion,
      });
    }
    return idEmpleado;
  }

  static Future<void> registrarHistorialSolicitud({
    required Solicitud solicitud,
    required String estado,
    required String detalle,
    int? idEmpleado,
  }) async {
    if (solicitud.idSolicitud == null) {
      throw Exception('La solicitud no tiene id_solicitud. No se puede guardar historial.');
    }

    final idEstado = await idEstadoSolPorNombre(estado);
    if (idEstado == null) {
      throw Exception('No existe el estado "$estado" en la tabla estado_sol.');
    }

    // Se intenta obtener el empleado por varias vías para evitar que el guardado falle
    // si el nombre completo tiene espacios, segundo nombre o diferencias de formato.
    final empleado = idEmpleado ??
        solicitud.idEmpleadoAsignado ??
        empleadoSesion?.idEmpleado ??
        await idEmpleadoPorNombreCompleto(profesionalActual);

    final datosHistorial = <String, dynamic>{
      'descripcion_hist': detalle,
      'id_solicitud': solicitud.idSolicitud,
      'id_est': idEstado,
    };

    // Para acciones del administrador puede no existir un empleado asociado.
    // Si la solicitud tiene empleado asignado se guarda; si no, se registra sin id_empleado.
    if (empleado != null) {
      datosHistorial['id_empleado'] = empleado;
    }

    await db.from('historial_sol').insert(datosHistorial);

    // También se guarda el estado en la asignación cuando existe id_asig.
    // Esto ayuda a que administrador y empleado vean el mismo estado actualizado.
    final idEstadoAsignacion = await idEstadoAsigPorNombre(estado);
    if (idEstadoAsignacion != null && solicitud.idAsignacion != null) {
      await db.from('asig_estado').insert({
        'id_est_asig': idEstadoAsignacion,
        'id_asig': solicitud.idAsignacion,
      });
    }
  }

  static Future<void> actualizarHabitacionPaciente(
      Paciente paciente,
      Habitacion destino,
      ) async {
    if (paciente.idPaciente == null || destino.idHabitacion == null) return;
    await db
        .from('paciente')
        .update({'id_habitacion': destino.idHabitacion})
        .eq('id_paciente', paciente.idPaciente!);
  }

  static Future<void> actualizarEstadoPaciente(
      Paciente paciente,
      String estado,
      ) async {
    if (paciente.idPaciente == null) return;
    await db
        .from('paciente')
        .update({'estado': estado})
        .eq('id_paciente', paciente.idPaciente!);
  }


  static Future<void> registrarPacienteInactivo({
    required Paciente paciente,
    required String motivo,
    required String descripcion,
    required String responsable,
  }) async {
    if (paciente.idPaciente == null) {
      throw Exception('El paciente no tiene id_paciente. No se puede guardar historial.');
    }

    await db.from('historial_paciente_inactivo').insert({
      'id_paciente': paciente.idPaciente,
      'motivo': motivo,
      'descripcion': descripcion,
      'responsable': responsable,
      'estado_accion': 'Inactivo',
    });
  }

  static Future<void> registrarPacienteReactivado({
    required Paciente paciente,
    required String responsable,
  }) async {
    if (paciente.idPaciente == null) return;

    await db.from('historial_paciente_inactivo').insert({
      'id_paciente': paciente.idPaciente,
      'motivo': 'Reactivación',
      'descripcion': 'Paciente reactivado y habilitado nuevamente para usar la aplicación.',
      'responsable': responsable,
      'estado_accion': 'Reactivado',
    });
  }

  static Future<void> cargarHistorialPacientesInactivosDesdeSupabase() async {
    historialPacientesInactivos.clear();

    final data = await db
        .from('historial_paciente_inactivo')
        .select('id_historial, id_paciente, motivo, descripcion, fecha, responsable, estado_accion')
        .order('fecha', ascending: false);

    final ultimoInactivoPorPaciente = <int, Map<String, dynamic>>{};

    for (final h in List<Map<String, dynamic>>.from(data)) {
      final accion = (h['estado_accion'] ?? 'Inactivo').toString();
      final idPaciente = h['id_paciente'] as int?;
      if (idPaciente == null) continue;

      final pacienteRelacionado = pacientes.where((p) => p.idPaciente == idPaciente).toList();
      if (pacienteRelacionado.isEmpty) continue;

      final fechaDb = DateTime.tryParse((h['fecha'] ?? '').toString());
      final fechaTexto = fechaDb == null ? '' : formatDateTime(fechaDb.toLocal());

      if (accion == 'Inactivo') {
        final registro = HistorialPacienteInactivo(
          paciente: pacienteRelacionado.first.nombre,
          motivo: (h['motivo'] ?? '').toString(),
          descripcion: (h['descripcion'] ?? '').toString(),
          fecha: fechaTexto,
          responsable: (h['responsable'] ?? 'Administrador').toString(),
        );

        historialPacientesInactivos.add(registro);
        ultimoInactivoPorPaciente.putIfAbsent(idPaciente, () => h);
      }
    }

    for (final paciente in pacientes) {
      if (paciente.estado != 'Inactivo' || paciente.idPaciente == null) {
        paciente.motivoInactividad = '';
        paciente.descripcionInactividad = '';
        paciente.fechaInactividad = '';
        continue;
      }

      final ultimo = ultimoInactivoPorPaciente[paciente.idPaciente!];
      if (ultimo == null) continue;

      final fechaDb = DateTime.tryParse((ultimo['fecha'] ?? '').toString());
      paciente.motivoInactividad = (ultimo['motivo'] ?? '').toString();
      paciente.descripcionInactividad = (ultimo['descripcion'] ?? '').toString();
      paciente.fechaInactividad = fechaDb == null ? '' : formatDateTime(fechaDb.toLocal());
    }
  }

  static Future<int?> crearTurno(Turno turno) async {
    final idEmpleado = await idEmpleadoPorNombreCompleto(turno.empleado);
    if (idEmpleado == null) return null;
    final esLibre = turno.estado == 'Libre';
    final t = await db
        .from('turno')
        .insert({
      'dia_semana': esLibre ? 'Libre: ${turno.fecha}' : turno.fecha,
      'hora_inicio': esLibre ? '00:00' : turno.horaInicio,
      'hora_fin': esLibre ? '00:00' : turno.horaTermino,
      'id_empleado': idEmpleado,
    })
        .select('id_turno')
        .single();
    return t['id_turno'] as int?;
  }

  static Future<void> eliminarTurno(Turno turno) async {
    if (turno.idTurno != null)
      await db.from('turno').delete().eq('id_turno', turno.idTurno!);
  }

  static Future<List<Map<String, dynamic>>> obtenerCargos() async {
    final data = await db
        .from('cargo')
        .select('id_cargo, nombre_cargo')
        .order('nombre_cargo');
    return List<Map<String, dynamic>>.from(data);
  }

  static Future<int?> idRolPorNombre(String nombre) async {
    final r = await db
        .from('rol')
        .select('id_rol')
        .eq('nombre_rol', nombre)
        .maybeSingle();
    return r?['id_rol'] as int?;
  }

  static Future<int?> idEstadoUsuarioPorNombre(String nombre) async {
    final e = await db
        .from('est_usuario')
        .select('id_est_usuario')
        .eq('nombre_est', nombre)
        .maybeSingle();
    return e?['id_est_usuario'] as int?;
  }

  static Future<int?> idHogarUnico() async {
    final hogar = await db
        .from('hogar')
        .select('id_hogar')
        .eq('nombre_hogar', 'Cuidado de Adulto Mayor')
        .maybeSingle();
    return hogar?['id_hogar'] as int?;
  }

  static Future<int?> idComunaHogarUnico() async {
    final hogar = await db
        .from('hogar')
        .select('id_comuna')
        .eq('nombre_hogar', 'Cuidado de Adulto Mayor')
        .maybeSingle();
    return hogar?['id_comuna'] as int?;
  }

  static Future<Map<String, dynamic>> crearEmpleadoDesdeAdmin({
    required String nombreUsuario,
    required String correo,
    required String contrasena,
    required String rut,
    required String primerNombre,
    required String segundoNombre,
    required String apellidoPaterno,
    required String apellidoMaterno,
    required String direccion,
    required String telefono,
    required int idCargo,
  }) async {
    final existe = await db
        .from('usuario')
        .select('id_usuario')
        .eq('correo', correo)
        .maybeSingle();
    if (existe != null)
      throw Exception('Ya existe una cuenta registrada con ese correo.');

    final idRol = await idRolPorNombre('Empleado');
    final idEstado = await idEstadoUsuarioPorNombre('Activo');
    final idHogar = await idHogarUnico();
    final idComuna = await idComunaHogarUnico();

    if (idRol == null ||
        idEstado == null ||
        idHogar == null ||
        idComuna == null) {
      throw Exception(
        'Faltan datos base: rol, estado de usuario, hogar o comuna del hogar.',
      );
    }

    final usuario = await db
        .from('usuario')
        .insert({
      'nombre': nombreUsuario,
      'correo': correo,
      'contrasena': contrasena,
      'id_est_usuario': idEstado,
      'id_rol': idRol,
    })
        .select('id_usuario')
        .single();

    final idUsuario = usuario['id_usuario'] as int;
    final emp = await db
        .from('empleado')
        .insert({
      'rut_empleado': rut,
      'p_nombre': primerNombre,
      's_nombre': segundoNombre.isEmpty ? null : segundoNombre,
      'ap_paterno': apellidoPaterno,
      'ap_materno': apellidoMaterno,
      'direccion': direccion,
      'telefono': telefono,
      'id_hogar': idHogar,
      'id_cargo': idCargo,
      'id_comuna': idComuna,
      'id_usuario': idUsuario,
    })
        .select('id_empleado')
        .single();

    return {'id_usuario': idUsuario, 'id_empleado': emp['id_empleado']};
  }

  static Future<void> desactivarEmpleado(Empleado empleado) async {
    if (empleado.idUsuario == null) return;
    final idEstado = await idEstadoUsuarioPorNombre('Inactivo');
    if (idEstado != null) {
      await db
          .from('usuario')
          .update({'id_est_usuario': idEstado})
          .eq('id_usuario', empleado.idUsuario!);
    }
    // Se eliminan turnos futuros asociados para que no sigan apareciendo como activos.
    if (empleado.idEmpleado != null) {
      await db.from('turno').delete().eq('id_empleado', empleado.idEmpleado!);
    }
  }

  static Future<int?> guardarPermisoTemporal(PermisoTemporal permiso) async {
    final empleado = empleados
        .where((e) => e.nombre == permiso.empleado)
        .toList();

    if (empleado.isEmpty || empleado.first.idEmpleado == null) {
      throw Exception('No se encontró el empleado en Supabase.');
    }

    permiso.idEmpleado = empleado.first.idEmpleado;

    final insertado = await db
        .from('permiso_temporal')
        .insert({
      'permiso': permiso.permiso,
      'fecha_inicio': permiso.inicio.toIso8601String(),
      'fecha_termino': permiso.termino.toIso8601String(),
      'estado': permiso.estado,
      'descripcion': 'Permiso temporal otorgado desde administración',
      'id_empleado': permiso.idEmpleado,
    })
        .select('id_permiso')
        .single();

    return insertado['id_permiso'] as int?;
  }

  static Future<void> cargarPermisosTemporalesDesdeSupabase() async {
    permisosTemporales.clear();

    for (final empleado in empleados) {
      empleado.permisoAdminTemporal = false;
    }

    final data = await db
        .from('permiso_temporal')
        .select('id_permiso, permiso, fecha_inicio, fecha_termino, estado, fecha_registro, id_empleado')
        .order('fecha_registro', ascending: false);

    for (final p in List<Map<String, dynamic>>.from(data)) {
      final empleadoRelacionado = empleados
          .where((e) => e.idEmpleado == p['id_empleado'])
          .toList();

      if (empleadoRelacionado.isEmpty) continue;

      final inicio = DateTime.tryParse((p['fecha_inicio'] ?? '').toString());
      final termino = DateTime.tryParse((p['fecha_termino'] ?? '').toString());
      final registro = DateTime.tryParse((p['fecha_registro'] ?? '').toString());

      if (inicio == null || termino == null) continue;

      final permiso = PermisoTemporal(
        idPermiso: p['id_permiso'] as int?,
        idEmpleado: p['id_empleado'] as int?,
        empleado: empleadoRelacionado.first.nombre,
        permiso: (p['permiso'] ?? '').toString(),
        inicio: inicio.toLocal(),
        termino: termino.toLocal(),
        estado: (p['estado'] ?? 'Activo').toString(),
        horaOtorgado: registro == null ? formatDateTime(DateTime.now()) : formatDateTime(registro.toLocal()),
      );

      permisosTemporales.add(permiso);

      if (permiso.activoAhora) {
        empleadoRelacionado.first.permisoAdminTemporal = true;
      }
    }
  }

  static Future<void> revocarPermisoTemporal(PermisoTemporal permiso) async {
    if (permiso.idPermiso == null) return;

    await db
        .from('permiso_temporal')
        .update({'estado': 'Revocado'})
        .eq('id_permiso', permiso.idPermiso!);
  }


  static Future<void> cancelarSolicitudAdmin({
    required Solicitud solicitud,
    required String motivo,
  }) async {
    await registrarHistorialSolicitud(
      solicitud: solicitud,
      estado: 'Cancelada',
      detalle: motivo,
    );
  }

  static Future<void> eliminarSolicitudCompleta(Solicitud solicitud) async {
    if (solicitud.idSolicitud == null) {
      throw Exception('La solicitud no tiene id_solicitud.');
    }

    final idSolicitud = solicitud.idSolicitud!;

    final asignaciones = await db
        .from('asignacion')
        .select('id_asig')
        .eq('id_solicitud', idSolicitud);

    for (final a in List<Map<String, dynamic>>.from(asignaciones)) {
      final idAsig = a['id_asig'];
      if (idAsig != null) {
        await db.from('asig_estado').delete().eq('id_asig', idAsig);
      }
    }

    await db.from('historial_sol').delete().eq('id_solicitud', idSolicitud);
    await db.from('sol_prioridad').delete().eq('id_solicitud', idSolicitud);
    await db.from('asignacion').delete().eq('id_solicitud', idSolicitud);
    await db.from('solicitud').delete().eq('id_solicitud', idSolicitud);
  }

}

// Paciente visible para pantallas de paciente. Si aún no se cargó desde Supabase,
// se muestra un registro vacío para que la interfaz no se rompa.
Paciente get pacienteActual =>
    pacienteSesion ??
        Paciente(
          nombre: 'Paciente no cargado',
          rut: '',
          telefono: '',
          correo: '',
          direccion: '',
          fechaNacimiento: DateTime(1950, 1, 1),
          habitacion: 'Sin habitación asignada',
          fechaIngreso: '',
          estado: 'Sin datos',
          diagnostico: '',
          alergias: '',
          medicamentos: '',
        );

// Profesional visible para pantallas del trabajador.
String get profesionalActual =>
    empleadoSesion?.nombre ?? 'Profesional no cargado';

// ============================================================
// FUNCIONES DE FORMATO Y REGISTRO
// ============================================================

String twoDigits(int number) => number.toString().padLeft(2, '0');

String formatDate(DateTime date) {
  return '${twoDigits(date.day)}-${twoDigits(date.month)}-${date.year}';
}

String formatDateTime(DateTime date) {
  return '${formatDate(date)} ${twoDigits(date.hour)}:${twoDigits(date.minute)}';
}

String formatTime(DateTime date) {
  return '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
}

DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

// Registra una acción administrativa con fecha y hora para mantener trazabilidad.
void registrarHistorial(String accion, String detalle) {
  historialAdmin.insert(
    0,
    HistorialAdmin(
      accion: accion,
      detalle: detalle,
      fecha: formatDateTime(DateTime.now()),
      responsable: 'Administrador',
    ),
  );
}

// Registra una acción administrativa con fecha y hora para mantener trazabilidad.
void registrarHistorialProfesional({
  required String profesional,
  required Solicitud solicitud,
  required String estadoFinal,
  required String detalle,
}) {
  historialProfesional.insert(
    0,
    HistorialProfesional(
      profesional: profesional,
      solicitud: solicitud.titulo,
      paciente: solicitud.paciente,
      tipo: solicitud.tipo,
      estadoFinal: estadoFinal,
      detalle: detalle,
      fecha: formatDateTime(DateTime.now()),
    ),
  );
}

bool rangoSeTraslapa(
    DateTime inicioA,
    DateTime terminoA,
    DateTime inicioB,
    DateTime terminoB,
    ) {
  return inicioA.isBefore(terminoB) && terminoA.isAfter(inicioB);
}

// Mantiene sincronizados los datos de habitaciones con la habitación asignada a cada paciente.
// Esto evita que en la pantalla aparezcan ocupantes duplicados o datos sobrepuestos.
// Sincroniza el estado de las habitaciones de acuerdo con el paciente asignado.
void sincronizarHabitacionesConPacientes() {
  for (final h in habitaciones) {
    final pacientesEnHabitacion = pacientes
        .where((p) => p.habitacion == h.numero)
        .map((p) => p.nombre)
        .toList();
    h.ocupantes = pacientesEnHabitacion.length.clamp(0, h.capacidad).toInt();
    h.paciente = pacientesEnHabitacion.isEmpty
        ? 'Sin paciente'
        : pacientesEnHabitacion.join(', ');
    if (h.estado != 'Mantenimiento') {
      h.estado = pacientesEnHabitacion.isEmpty ? 'Disponible' : 'Ocupada';
    }
  }
}


// Elimina registros duplicados en memoria después de refrescar desde Supabase.
// Esto evita que al presionar el botón actualizar se repitan turnos, solicitudes,
// pacientes, empleados, habitaciones o permisos temporales en las vistas.
void eliminarDuplicadosSesionEnMemoria() {
  final pacientesUnicos = <int, Paciente>{};
  final pacientesSinId = <Paciente>[];
  for (final p in pacientes) {
    if (p.idPaciente != null) {
      pacientesUnicos[p.idPaciente!] = p;
    } else if (!pacientesSinId.any((x) => x.nombre == p.nombre && x.rut == p.rut)) {
      pacientesSinId.add(p);
    }
  }
  pacientes
    ..clear()
    ..addAll(pacientesUnicos.values)
    ..addAll(pacientesSinId);

  final empleadosUnicos = <int, Empleado>{};
  final empleadosSinId = <Empleado>[];
  for (final e in empleados) {
    if (e.idEmpleado != null) {
      empleadosUnicos[e.idEmpleado!] = e;
    } else if (!empleadosSinId.any((x) => x.nombre == e.nombre && x.rut == e.rut)) {
      empleadosSinId.add(e);
    }
  }
  empleados
    ..clear()
    ..addAll(empleadosUnicos.values)
    ..addAll(empleadosSinId);

  final solicitudesUnicas = <int, Solicitud>{};
  final solicitudesSinId = <Solicitud>[];
  for (final s in solicitudes) {
    if (s.idSolicitud != null) {
      solicitudesUnicas[s.idSolicitud!] = s;
    } else if (!solicitudesSinId.any((x) => x.titulo == s.titulo && x.paciente == s.paciente && x.horaCreacion == s.horaCreacion)) {
      solicitudesSinId.add(s);
    }
  }
  solicitudes
    ..clear()
    ..addAll(solicitudesUnicas.values)
    ..addAll(solicitudesSinId);

  final habitacionesUnicas = <int, Habitacion>{};
  final habitacionesSinId = <Habitacion>[];
  for (final h in habitaciones) {
    if (h.idHabitacion != null) {
      habitacionesUnicas[h.idHabitacion!] = h;
    } else if (!habitacionesSinId.any((x) => x.numero == h.numero)) {
      habitacionesSinId.add(h);
    }
  }
  habitaciones
    ..clear()
    ..addAll(habitacionesUnicas.values)
    ..addAll(habitacionesSinId);

  final turnosUnicos = <int, Turno>{};
  final turnosSinId = <Turno>[];
  for (final t in turnos) {
    if (t.idTurno != null) {
      turnosUnicos[t.idTurno!] = t;
    } else if (!turnosSinId.any((x) => x.empleado == t.empleado && x.fecha == t.fecha && x.horaInicio == t.horaInicio && x.horaTermino == t.horaTermino)) {
      turnosSinId.add(t);
    }
  }
  turnos
    ..clear()
    ..addAll(turnosUnicos.values)
    ..addAll(turnosSinId);

  final permisosUnicos = <int, PermisoTemporal>{};
  final permisosSinId = <PermisoTemporal>[];
  for (final p in permisosTemporales) {
    if (p.idPermiso != null) {
      permisosUnicos[p.idPermiso!] = p;
    } else if (!permisosSinId.any((x) => x.empleado == p.empleado && x.permiso == p.permiso && x.inicio == p.inicio && x.termino == p.termino)) {
      permisosSinId.add(p);
    }
  }
  permisosTemporales
    ..clear()
    ..addAll(permisosUnicos.values)
    ..addAll(permisosSinId);
}

// Selector de hora con ruedas, similar al ejemplo enviado, usando textos en español.
// Abre un selector de hora tipo rueda para evitar escribir horas manualmente.
Future<TimeOfDay?> seleccionarHoraRueda(
    BuildContext context,
    TimeOfDay horaInicial,
    String titulo,
    ) async {
  var horaSeleccionada = DateTime(
    2024,
    1,
    1,
    horaInicial.hour,
    horaInicial.minute,
  );

  return showModalBottomSheet<TimeOfDay>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (context) {
      return SafeArea(
        child: SizedBox(
          height: 330,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(
                        context,
                        TimeOfDay(
                          hour: horaSeleccionada.hour,
                          minute: horaSeleccionada.minute,
                        ),
                      ),
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  minuteInterval: 1,
                  initialDateTime: horaSeleccionada,
                  onDateTimeChanged: (value) {
                    horaSeleccionada = value;
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// ============================================================
// VALIDACIONES CHILE: RUT, TELÉFONO, REGIÓN, COMUNA Y HOGAR
// ============================================================

// Formatea automáticamente el RUT chileno mientras se escribe.
// Permite números y la letra K como dígito verificador.
// Ejemplo: 12345678k -> 12.345.678-K.
class RutInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    var limpio = newValue.text
        .replaceAll('.', '')
        .replaceAll('-', '')
        .replaceAll(RegExp(r'[^0-9kK]'), '')
        .toUpperCase();

    // El RUT chileno se guarda como máximo con 8 números + dígito verificador.
    if (limpio.length > 9) limpio = limpio.substring(0, 9);

    // La K solo puede ir al final. Si aparece antes, se elimina.
    if (limpio.length > 1) {
      final cuerpo = limpio.substring(0, limpio.length - 1).replaceAll('K', '');
      final dv = limpio.substring(limpio.length - 1);
      limpio = cuerpo + dv;
    }

    final formateado = formatearRut(limpio);
    return TextEditingValue(
      text: formateado,
      selection: TextSelection.collapsed(offset: formateado.length),
    );
  }
}

String limpiarRut(String rut) {
  return rut
      .replaceAll('.', '')
      .replaceAll('-', '')
      .replaceAll(RegExp(r'[^0-9kK]'), '')
      .toUpperCase();
}

String formatearRut(String rutLimpio) {
  if (rutLimpio.isEmpty) return '';
  if (rutLimpio.length == 1) return rutLimpio;

  final cuerpo = rutLimpio.substring(0, rutLimpio.length - 1);
  final dv = rutLimpio.substring(rutLimpio.length - 1);

  final buffer = StringBuffer();
  int contador = 0;
  for (int i = cuerpo.length - 1; i >= 0; i--) {
    buffer.write(cuerpo[i]);
    contador++;
    if (contador == 3 && i != 0) {
      buffer.write('.');
      contador = 0;
    }
  }

  final cuerpoFormateado = buffer.toString().split('').reversed.join();
  return '$cuerpoFormateado-$dv';
}

bool validarRutChileno(String rut) {
  final limpio = limpiarRut(rut);
  // Para el prototipo se valida que el RUT tenga un formato viable en Chile:
  // 7 u 8 números en el cuerpo + dígito verificador 0-9 o K.
  // Esto permite ingresar RUT terminados en 0,1,2,3,4,5,6,7,8,9,K o k.
  if (limpio.length < 8 || limpio.length > 9) return false;

  final cuerpo = limpio.substring(0, limpio.length - 1);
  final dv = limpio.substring(limpio.length - 1).toUpperCase();

  if (!RegExp(r'^\d{7,8}$').hasMatch(cuerpo)) return false;
  if (!RegExp(r'^[0-9K]$').hasMatch(dv)) return false;

  return true;
}

bool validarTelefonoChile(String telefono) {
  final limpio = telefono.replaceAll(RegExp(r'[^0-9]'), '');
  return limpio.length == 9;
}


// Recarga los datos reales desde Supabase sin cerrar sesión.
// Se usa desde los botones de actualizar de administrador, paciente y profesional.
Future<void> cargarSesionActualDesdeSupabase() async {
  final usuario = usuarioSesion;
  final rol = rolSesion;
  if (usuario == null || rol.isEmpty) return;

  final supabase = Supabase.instance.client;
  usuarioSesion = usuario;
  rolSesion = rol;
  pacienteSesion = null;
  empleadoSesion = null;

  pacientes.clear();
  empleados.clear();
  solicitudes.clear();
  habitaciones.clear();
  turnos.clear();
  contactosEmergencia.clear();
  historialPacientesInactivos.clear();

  final habitacionesDb = await supabase
      .from('habitacion')
      .select('id_habitacion, nro_hab, piso, capacidad, estado');
  for (final h in List<Map<String, dynamic>>.from(habitacionesDb)) {
    habitaciones.add(
      Habitacion(
        idHabitacion: h['id_habitacion'] as int?,
        numero: (h['nro_hab'] ?? '').toString(),
        piso: 'Piso ${h['piso'] ?? ''}',
        capacidad: h['capacidad'] ?? 1,
        ocupantes: 0,
        estado: (h['estado'] ?? 'Disponible').toString(),
        paciente: 'Sin paciente',
      ),
    );
  }

  // IMPORTANTE: no se usa select('*, habitacion(...)') porque en la BD hay varias
  // relaciones entre paciente, habitacion e hist_hab. Si se usa embed, Supabase
  // lanza error PGRST201. Por eso se consulta paciente y habitación por separado.
  final pacientesDb = await supabase.from('paciente').select();
  for (final p in List<Map<String, dynamic>>.from(pacientesDb)) {
    final nombreCompleto =
    '${p['p_nombre'] ?? ''} ${p['s_nombre'] ?? ''} ${p['ap_paterno'] ?? ''} ${p['ap_materno'] ?? ''}'
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    String textoHabitacion = 'Sin habitación';
    final idHabitacion = p['id_habitacion'];
    if (idHabitacion != null) {
      final habitacionDb = await supabase
          .from('habitacion')
          .select('nro_hab')
          .eq('id_habitacion', idHabitacion)
          .maybeSingle();
      if (habitacionDb != null) {
        textoHabitacion = (habitacionDb['nro_hab'] ?? 'Sin habitación')
            .toString();
      }
    }

    final paciente = Paciente(
      idPaciente: p['id_paciente'] as int?,
      idUsuario: p['id_usuario'] as int?,
      idHabitacion: p['id_habitacion'] as int?,
      nombre: nombreCompleto,
      rut: (p['rut_paciente'] ?? '').toString(),
      telefono: (p['telefono'] ?? '').toString(),
      correo: (usuario['correo'] ?? '').toString(),
      direccion: (p['direccion'] ?? '').toString(),
      fechaNacimiento:
      DateTime.tryParse((p['fecha_nacimiento'] ?? '').toString()) ??
          DateTime(1950, 1, 1),
      habitacion: textoHabitacion,
      fechaIngreso: (p['fecha_ingreso'] ?? '').toString(),
      estado: (p['estado'] ?? 'Activo').toString(),
      diagnostico: '',
      alergias: '',
      medicamentos: '',
    );
    pacientes.add(paciente);
    if (p['id_usuario'] == usuario['id_usuario']) pacienteSesion = paciente;
  }

  await SeniorCareDb.cargarHistorialPacientesInactivosDesdeSupabase();

  // Se consulta cargo aparte para evitar problemas similares de relaciones automáticas.
  final empleadosDb = await supabase.from('empleado').select();
  for (final e in List<Map<String, dynamic>>.from(empleadosDb)) {
    final nombreCompleto =
    '${e['p_nombre'] ?? ''} ${e['s_nombre'] ?? ''} ${e['ap_paterno'] ?? ''} ${e['ap_materno'] ?? ''}'
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    String nombreCargo = 'Empleado';
    final idCargo = e['id_cargo'];
    if (idCargo != null) {
      final cargoDb = await supabase
          .from('cargo')
          .select('nombre_cargo')
          .eq('id_cargo', idCargo)
          .maybeSingle();
      if (cargoDb != null)
        nombreCargo = (cargoDb['nombre_cargo'] ?? 'Empleado').toString();
    }

    final empleado = Empleado(
      idEmpleado: e['id_empleado'] as int?,
      idUsuario: e['id_usuario'] as int?,
      idCargo: e['id_cargo'] as int?,
      nombre: nombreCompleto,
      rut: (e['rut_empleado'] ?? '').toString(),
      cargo: nombreCargo,
      telefono: (e['telefono'] ?? '').toString(),
      estado: 'Activo',
    );
    empleados.add(empleado);
    if (e['id_usuario'] == usuario['id_usuario']) empleadoSesion = empleado;
  }

  // Carga todos los contactos de emergencia desde Supabase.
  // El paciente verá solo sus propios contactos por el filtro de la pantalla,
  // mientras que el administrador podrá ver todos los contactos registrados.
  final contactosDb = await supabase
      .from('paciente_cont')
      .select('id_paciente_cont, prioridad, id_cont_emer, id_paciente');
  for (final c in List<Map<String, dynamic>>.from(contactosDb)) {
    final idContacto = c['id_cont_emer'];
    final idPacienteContacto = c['id_paciente'];
    if (idContacto == null || idPacienteContacto == null) continue;

    final pacienteRelacionado = pacientes
        .where((p) => p.idPaciente == idPacienteContacto)
        .toList();
    final nombrePacienteContacto = pacienteRelacionado.isNotEmpty
        ? pacienteRelacionado.first.nombre
        : 'Paciente no cargado';

    final ce = await supabase
        .from('cont_emer')
        .select(
      'p_nombre, ap_paterno, ap_materno, telefono, correo, direccion',
    )
        .eq('id_cont_emer', idContacto)
        .maybeSingle();
    if (ce == null) continue;

    contactosEmergencia.add(
      ContactoEmergencia(
        idContEmer: idContacto as int?,
        idPacienteCont: c['id_paciente_cont'] as int?,
        idPaciente: idPacienteContacto as int?,
        paciente: nombrePacienteContacto,
        nombre:
        '${ce['p_nombre'] ?? ''} ${ce['ap_paterno'] ?? ''} ${ce['ap_materno'] ?? ''}'
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim(),
        telefono: (ce['telefono'] ?? '').toString(),
        email: (ce['correo'] ?? '').toString(),
        direccion: (ce['direccion'] ?? '').toString(),
        prioridad: c['prioridad'] ?? 1,
      ),
    );
  }

  // Carga solicitudes reales desde Supabase sin relaciones embebidas.
  final solicitudesDb = await supabase
      .from('solicitud')
      .select(
    'id_solicitud, fecha_creacion, descripcion, id_tipo, id_paciente',
  );
  for (final sol in List<Map<String, dynamic>>.from(solicitudesDb)) {
    final idPaciente = sol['id_paciente'];
    final pacienteRelacionado = pacientes
        .where((p) => p.idPaciente == idPaciente)
        .toList();
    final nombrePaciente = pacienteRelacionado.isNotEmpty
        ? pacienteRelacionado.first.nombre
        : 'Paciente no cargado';

    String tipoNombre = 'Otro';
    if (sol['id_tipo'] != null) {
      final tipoDb = await supabase
          .from('tipo_solicitud')
          .select('nombre_tipo')
          .eq('id_tipo', sol['id_tipo'])
          .maybeSingle();
      if (tipoDb != null)
        tipoNombre = (tipoDb['nombre_tipo'] ?? 'Otro').toString();
    }

    String prioridadNombre = 'Media';
    final priDb = await supabase
        .from('sol_prioridad')
        .select('id_prioridad')
        .eq('id_solicitud', sol['id_solicitud'])
        .order('fecha_cambio', ascending: false)
        .limit(1)
        .maybeSingle();
    if (priDb != null && priDb['id_prioridad'] != null) {
      final pDb = await supabase
          .from('prioridad')
          .select('tipo_prioridad')
          .eq('id_prioridad', priDb['id_prioridad'])
          .maybeSingle();
      if (pDb != null)
        prioridadNombre = (pDb['tipo_prioridad'] ?? 'Media').toString();
    }

    String estadoNombre = 'Creada';
    String asignadoNombre = 'Sin asignar';
    int? idAsignacion;
    int? idEmpleadoAsignado;
    String? horaAsignacion;
    final asigDb = await supabase
        .from('asignacion')
        .select('id_asig, fecha_asignacion, id_empleado')
        .eq('id_solicitud', sol['id_solicitud'])
        .order('fecha_asignacion', ascending: false)
        .limit(1)
        .maybeSingle();
    if (asigDb != null) {
      idAsignacion = asigDb['id_asig'] as int?;
      idEmpleadoAsignado = asigDb['id_empleado'] as int?;
      final empleadoRelacionado = empleados
          .where((e) => e.idEmpleado == idEmpleadoAsignado)
          .toList();
      if (empleadoRelacionado.isNotEmpty)
        asignadoNombre = empleadoRelacionado.first.nombre;
      final fechaAsig = DateTime.tryParse(
        (asigDb['fecha_asignacion'] ?? '').toString(),
      );
      if (fechaAsig != null) horaAsignacion = formatDateTime(fechaAsig);
      final estadoAsigDb = await supabase
          .from('asig_estado')
          .select('id_est_asig')
          .eq('id_asig', idAsignacion ?? -1)
          .order('fecha', ascending: false)
          .limit(1)
          .maybeSingle();
      if (estadoAsigDb != null && estadoAsigDb['id_est_asig'] != null) {
        final eDb = await supabase
            .from('estado_asig')
            .select('nombre')
            .eq('id_est_asig', estadoAsigDb['id_est_asig'])
            .maybeSingle();
        if (eDb != null)
          estadoNombre = (eDb['nombre'] ?? 'Asignada').toString();
      } else {
        estadoNombre = 'Asignada';
      }
    }

    // Revisa el último estado real guardado por el profesional en historial_sol.
    // La tabla solicitud no tiene columna estado, por eso el estado actual se recupera
    // desde el último registro de historial_sol.
    final histDb = await supabase
        .from('historial_sol')
        .select('id_est, fecha')
        .eq('id_solicitud', sol['id_solicitud'])
        .order('fecha', ascending: false)
        .limit(1)
        .maybeSingle();

    if (histDb != null && histDb['id_est'] != null) {
      final estadoDb = await supabase
          .from('estado_sol')
          .select('nombre_estado')
          .eq('id_est', histDb['id_est'])
          .maybeSingle();
      if (estadoDb != null) {
        estadoNombre = (estadoDb['nombre_estado'] ?? estadoNombre).toString();
      }
    }

    final fechaCreacion = DateTime.tryParse(
      (sol['fecha_creacion'] ?? '').toString(),
    );
    solicitudes.add(
      Solicitud(
        idSolicitud: sol['id_solicitud'] as int?,
        idAsignacion: idAsignacion,
        idEmpleadoAsignado: idEmpleadoAsignado,
        titulo: 'Solicitud #${sol['id_solicitud']}',
        descripcion: (sol['descripcion'] ?? '').toString(),
        paciente: nombrePaciente,
        tipo: tipoNombre,
        fecha: fechaCreacion == null ? '' : formatDate(fechaCreacion),
        estado: estadoNombre,
        prioridad: prioridadNombre,
        asignadoA: asignadoNombre,
        horaCreacion: fechaCreacion == null
            ? ''
            : formatDateTime(fechaCreacion),
        horaAsignacion: horaAsignacion,
      ),
    );
  }

  // Carga turnos reales desde Supabase.
  final turnosDb = await supabase
      .from('turno')
      .select('id_turno, dia_semana, hora_inicio, hora_fin, id_empleado');
  for (final t in List<Map<String, dynamic>>.from(turnosDb)) {
    final idEmpleado = t['id_empleado'] as int?;
    final empleadoRelacionado = empleados
        .where((e) => e.idEmpleado == idEmpleado)
        .toList();
    final empleado = empleadoRelacionado.isNotEmpty
        ? empleadoRelacionado.first
        : null;
    final diaTurno = (t['dia_semana'] ?? '').toString();
    final esLibre = diaTurno.startsWith('Libre:');
    turnos.add(
      Turno(
        idTurno: t['id_turno'] as int?,
        idEmpleado: idEmpleado,
        empleado: empleado?.nombre ?? 'Empleado no cargado',
        cargo: empleado?.cargo ?? 'Sin cargo',
        fecha: esLibre
            ? diaTurno.replaceFirst('Libre:', '').trim()
            : diaTurno,
        horaInicio: esLibre
            ? 'Libre'
            : (t['hora_inicio'] ?? '').toString().substring(0, 5),
        horaTermino: esLibre
            ? 'Libre'
            : (t['hora_fin'] ?? '').toString().substring(0, 5),
        estado: esLibre ? 'Libre' : 'Asignado',
      ),
    );
  }

  await SeniorCareDb.cargarPermisosTemporalesDesdeSupabase();
  eliminarDuplicadosSesionEnMemoria();

  sincronizarHabitacionesConPacientes();

}

Future<void> refrescarSesionActual(BuildContext context, Widget homePage) async {
  try {
    await cargarSesionActualDesdeSupabase();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos actualizados correctamente')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => homePage),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al actualizar datos: $e'), backgroundColor: Colors.red),
    );
  }
}

// ============================================================
// LOGIN Y CREACIÓN DE CUENTA
// ============================================================

// Pantalla de inicio de sesión y creación de cuenta según el rol del usuario.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum AuthTab { login, register }

class _LoginPageState extends State<LoginPage> {
  AuthTab selectedTab = AuthTab.login;
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final nombreController = TextEditingController();
  final nuevoCorreoController = TextEditingController();
  final nuevaPasswordController = TextEditingController();
  final confirmarPasswordController = TextEditingController();

  // Datos personales reales solicitados al crear la cuenta.
  // Estos campos se guardan en las tablas paciente o empleado según el rol.
  final rutController = TextEditingController();
  final primerNombreController = TextEditingController();
  final segundoNombreController = TextEditingController();
  final apellidoPaternoController = TextEditingController();
  final apellidoMaternoController = TextEditingController();
  final direccionController = TextEditingController();
  final telefonoController = TextEditingController();
  final fechaNacimientoController = TextEditingController();

  DateTime? fechaNacimientoSeleccionada;
  String rolSeleccionado = 'Paciente';

  // Datos base cargados desde Supabase para no escribir ids manualmente.
  // El usuario selecciona Región y luego se filtran sus comunas.
  // El hogar NO se selecciona: siempre será "Cuidado de Adulto Mayor" en Concepción.
  List<Map<String, dynamic>> regionesRegistro = [];
  List<Map<String, dynamic>> comunasRegistro = [];
  List<Map<String, dynamic>> comunasFiltradasRegistro = [];
  List<Map<String, dynamic>> habitacionesRegistro = [];
  List<Map<String, dynamic>> cargosRegistro = [];
  int? idRegionSeleccionada;
  int? idComunaSeleccionada;
  int? idHogarSeleccionado;
  int? idHabitacionSeleccionada;
  int? idCargoSeleccionado;

  // Catálogo base de regiones y comunas de Chile para que el registro no quede vacío.
  // Si las tablas region/comuna están vacías en Supabase, la app las carga automáticamente.
  final Map<String, List<String>> catalogoChileRegistro = const {
    'Arica y Parinacota': ['Arica', 'Camarones', 'Putre', 'General Lagos'],
    'Tarapacá': [
      'Iquique',
      'Alto Hospicio',
      'Pozo Almonte',
      'Camiña',
      'Colchane',
      'Huara',
      'Pica',
    ],
    'Antofagasta': [
      'Antofagasta',
      'Mejillones',
      'Sierra Gorda',
      'Taltal',
      'Calama',
      'Ollagüe',
      'San Pedro de Atacama',
      'Tocopilla',
      'María Elena',
    ],
    'Atacama': [
      'Copiapó',
      'Caldera',
      'Tierra Amarilla',
      'Chañaral',
      'Diego de Almagro',
      'Vallenar',
      'Alto del Carmen',
      'Freirina',
      'Huasco',
    ],
    'Coquimbo': [
      'La Serena',
      'Coquimbo',
      'Andacollo',
      'La Higuera',
      'Paiguano',
      'Vicuña',
      'Illapel',
      'Canela',
      'Los Vilos',
      'Salamanca',
      'Ovalle',
      'Combarbalá',
      'Monte Patria',
      'Punitaqui',
      'Río Hurtado',
    ],
    'Valparaíso': [
      'Valparaíso',
      'Casablanca',
      'Concón',
      'Juan Fernández',
      'Puchuncaví',
      'Quintero',
      'Viña del Mar',
      'Isla de Pascua',
      'Los Andes',
      'Calle Larga',
      'Rinconada',
      'San Esteban',
      'La Ligua',
      'Cabildo',
      'Papudo',
      'Petorca',
      'Zapallar',
      'Quillota',
      'Calera',
      'Hijuelas',
      'La Cruz',
      'Nogales',
      'San Antonio',
      'Algarrobo',
      'Cartagena',
      'El Quisco',
      'El Tabo',
      'Santo Domingo',
      'San Felipe',
      'Catemu',
      'Llaillay',
      'Panquehue',
      'Putaendo',
      'Santa María',
      'Quilpué',
      'Limache',
      'Olmué',
      'Villa Alemana',
    ],
    'Metropolitana de Santiago': [
      'Santiago',
      'Cerrillos',
      'Cerro Navia',
      'Conchalí',
      'El Bosque',
      'Estación Central',
      'Huechuraba',
      'Independencia',
      'La Cisterna',
      'La Florida',
      'La Granja',
      'La Pintana',
      'La Reina',
      'Las Condes',
      'Lo Barnechea',
      'Lo Espejo',
      'Lo Prado',
      'Macul',
      'Maipú',
      'Ñuñoa',
      'Pedro Aguirre Cerda',
      'Peñalolén',
      'Providencia',
      'Pudahuel',
      'Quilicura',
      'Quinta Normal',
      'Recoleta',
      'Renca',
      'San Joaquín',
      'San Miguel',
      'San Ramón',
      'Vitacura',
      'Puente Alto',
      'Pirque',
      'San José de Maipo',
      'Colina',
      'Lampa',
      'Tiltil',
      'San Bernardo',
      'Buin',
      'Calera de Tango',
      'Paine',
      'Melipilla',
      'Alhué',
      'Curacaví',
      'María Pinto',
      'San Pedro',
      'Talagante',
      'El Monte',
      'Isla de Maipo',
      'Padre Hurtado',
      'Peñaflor',
    ],
    'Libertador General Bernardo O’Higgins': [
      'Rancagua',
      'Codegua',
      'Coinco',
      'Coltauco',
      'Doñihue',
      'Graneros',
      'Las Cabras',
      'Machalí',
      'Malloa',
      'Mostazal',
      'Olivar',
      'Peumo',
      'Pichidegua',
      'Quinta de Tilcoco',
      'Rengo',
      'Requínoa',
      'San Vicente',
      'Pichilemu',
      'La Estrella',
      'Litueche',
      'Marchigüe',
      'Navidad',
      'Paredones',
      'San Fernando',
      'Chépica',
      'Chimbarongo',
      'Lolol',
      'Nancagua',
      'Palmilla',
      'Peralillo',
      'Placilla',
      'Pumanque',
      'Santa Cruz',
    ],
    'Maule': [
      'Talca',
      'Constitución',
      'Curepto',
      'Empedrado',
      'Maule',
      'Pelarco',
      'Pencahue',
      'Río Claro',
      'San Clemente',
      'San Rafael',
      'Cauquenes',
      'Chanco',
      'Pelluhue',
      'Curicó',
      'Hualañé',
      'Licantén',
      'Molina',
      'Rauco',
      'Romeral',
      'Sagrada Familia',
      'Teno',
      'Vichuquén',
      'Linares',
      'Colbún',
      'Longaví',
      'Parral',
      'Retiro',
      'San Javier',
      'Villa Alegre',
      'Yerbas Buenas',
    ],
    'Ñuble': [
      'Chillán',
      'Bulnes',
      'Chillán Viejo',
      'El Carmen',
      'Pemuco',
      'Pinto',
      'Quillón',
      'San Ignacio',
      'Yungay',
      'Quirihue',
      'Cobquecura',
      'Coelemu',
      'Ninhue',
      'Portezuelo',
      'Ránquil',
      'Treguaco',
      'San Carlos',
      'Coihueco',
      'Ñiquén',
      'San Fabián',
      'San Nicolás',
    ],
    'Biobío': [
      'Concepción',
      'Coronel',
      'Chiguayante',
      'Florida',
      'Hualqui',
      'Lota',
      'Penco',
      'San Pedro de la Paz',
      'Santa Juana',
      'Talcahuano',
      'Tomé',
      'Hualpén',
      'Lebu',
      'Arauco',
      'Cañete',
      'Contulmo',
      'Curanilahue',
      'Los Álamos',
      'Tirúa',
      'Los Ángeles',
      'Antuco',
      'Cabrero',
      'Laja',
      'Mulchén',
      'Nacimiento',
      'Negrete',
      'Quilaco',
      'Quilleco',
      'San Rosendo',
      'Santa Bárbara',
      'Tucapel',
      'Yumbel',
      'Alto Biobío',
    ],
    'La Araucanía': [
      'Temuco',
      'Carahue',
      'Cunco',
      'Curarrehue',
      'Freire',
      'Galvarino',
      'Gorbea',
      'Lautaro',
      'Loncoche',
      'Melipeuco',
      'Nueva Imperial',
      'Padre Las Casas',
      'Perquenco',
      'Pitrufquén',
      'Pucón',
      'Saavedra',
      'Teodoro Schmidt',
      'Toltén',
      'Vilcún',
      'Villarrica',
      'Cholchol',
      'Angol',
      'Collipulli',
      'Curacautín',
      'Ercilla',
      'Lonquimay',
      'Los Sauces',
      'Lumaco',
      'Purén',
      'Renaico',
      'Traiguén',
      'Victoria',
    ],
    'Los Ríos': [
      'Valdivia',
      'Corral',
      'Lanco',
      'Los Lagos',
      'Máfil',
      'Mariquina',
      'Paillaco',
      'Panguipulli',
      'La Unión',
      'Futrono',
      'Lago Ranco',
      'Río Bueno',
    ],
    'Los Lagos': [
      'Puerto Montt',
      'Calbuco',
      'Cochamó',
      'Fresia',
      'Frutillar',
      'Los Muermos',
      'Llanquihue',
      'Maullín',
      'Puerto Varas',
      'Castro',
      'Ancud',
      'Chonchi',
      'Curaco de Vélez',
      'Dalcahue',
      'Puqueldón',
      'Queilén',
      'Quellón',
      'Quemchi',
      'Quinchao',
      'Osorno',
      'Puerto Octay',
      'Purranque',
      'Puyehue',
      'Río Negro',
      'San Juan de la Costa',
      'San Pablo',
      'Chaitén',
      'Futaleufú',
      'Hualaihué',
      'Palena',
    ],
    'Aysén del General Carlos Ibáñez del Campo': [
      'Coyhaique',
      'Lago Verde',
      'Aysén',
      'Cisnes',
      'Guaitecas',
      'Cochrane',
      'O’Higgins',
      'Tortel',
      'Chile Chico',
      'Río Ibáñez',
    ],
    'Magallanes y de la Antártica Chilena': [
      'Punta Arenas',
      'Laguna Blanca',
      'Río Verde',
      'San Gregorio',
      'Cabo de Hornos',
      'Antártica',
      'Porvenir',
      'Primavera',
      'Timaukel',
      'Natales',
      'Torres del Paine',
    ],
  };

  // Campo adicional para validar la creación de cuentas de administrador.
  final numeroSerieAdminController = TextEditingController();

  // Indica si el formulario está procesando una petición hacia Supabase.
  // Sirve para bloquear botones mientras se valida el inicio de sesión,
  // se crea una cuenta o se solicita recuperación de contraseña.
  bool cargandoAuth = false;

  // Controla si las contraseñas se muestran u ocultan al presionar el ícono de ojo.
  bool verPasswordLogin = false;
  bool verPasswordRegistro = false;
  bool verConfirmarPasswordRegistro = false;
  bool verSerieAdministrador = false;

  // Valida que el correo ingresado sea exclusivamente Gmail.
  // Se usa tanto para iniciar sesión, crear cuenta y recuperar contraseña.
  bool correoGmailValido(String correo) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(correo);
  }

  @override
  void initState() {
    super.initState();
    cargarDatosBaseRegistro();
  }

  Future<void> cargarDatosBaseRegistro() async {
    try {
      final supabase = Supabase.instance.client;

      // Antes de consultar, asegura que existan regiones y comunas chilenas.
      // Así el formulario no queda vacío aunque Supabase aún no tenga datos base cargados.
      await asegurarRegionesYComunasChile(supabase);

      // Carga regiones y comunas desde Supabase para que el registro use datos reales.
      final regiones = await supabase
          .from('region')
          .select('id_region, nombre_region')
          .order('nombre_region');
      final comunas = await supabase
          .from('comuna')
          .select('id_comuna, nombre_comuna, id_region')
          .order('nombre_comuna');
      final habitaciones = await supabase
          .from('habitacion')
          .select('id_habitacion, nro_hab, piso, estado');
      final cargos = await supabase
          .from('cargo')
          .select('id_cargo, nombre_cargo');

      final regionesLista = List<Map<String, dynamic>>.from(regiones);
      final comunasLista = List<Map<String, dynamic>>.from(comunas);

      int? regionInicial;
      int? comunaInicial;

      if (regionesLista.isNotEmpty) {
        regionInicial = regionesLista.first['id_region'] as int;
        final comunasRegion = comunasLista
            .where((c) => c['id_region'] == regionInicial)
            .toList();
        comunaInicial = comunasRegion.isNotEmpty
            ? comunasRegion.first['id_comuna'] as int
            : null;
      }

      final idHogar = await obtenerOCrearHogarUnico(
        supabase,
        regionesLista,
        comunasLista,
      );

      if (!mounted) return;
      setState(() {
        regionesRegistro = regionesLista;
        comunasRegistro = comunasLista;
        habitacionesRegistro = List<Map<String, dynamic>>.from(habitaciones);
        cargosRegistro = List<Map<String, dynamic>>.from(cargos);
        idRegionSeleccionada ??= regionInicial;
        comunasFiltradasRegistro = comunasRegistro
            .where((c) => c['id_region'] == idRegionSeleccionada)
            .toList();
        idComunaSeleccionada ??= comunaInicial;
        idHogarSeleccionado = idHogar;
        idHabitacionSeleccionada ??= habitacionesRegistro.isNotEmpty
            ? habitacionesRegistro.first['id_habitacion'] as int
            : null;
        idCargoSeleccionado ??= cargosRegistro.isNotEmpty
            ? cargosRegistro.first['id_cargo'] as int
            : null;
      });
    } catch (_) {
      // Si aún no existen datos base, el formulario mostrará el error al crear cuenta.
    }
  }

  // Inserta automáticamente regiones y comunas de Chile si las tablas están vacías.
  // Esto permite que los dropdowns de Región y Comuna funcionen sin depender de carga manual previa.
  Future<void> asegurarRegionesYComunasChile(SupabaseClient supabase) async {
    final regionesExistentes = await supabase
        .from('region')
        .select('id_region, nombre_region');
    final comunasExistentes = await supabase
        .from('comuna')
        .select('id_comuna')
        .limit(1);

    // Si no hay regiones, carga el catálogo local de Chile.
    if (List<Map<String, dynamic>>.from(regionesExistentes).isEmpty) {
      await supabase
          .from('region')
          .insert(
        catalogoChileRegistro.keys
            .map((nombre) => {'nombre_region': nombre})
            .toList(),
      );
    }

    // Si no hay comunas, las carga asociadas a la región que corresponda.
    if (List<Map<String, dynamic>>.from(comunasExistentes).isEmpty) {
      final regionesActuales = List<Map<String, dynamic>>.from(
        await supabase.from('region').select('id_region, nombre_region'),
      );

      final idPorNombreRegion = <String, int>{};
      for (final region in regionesActuales) {
        idPorNombreRegion[(region['nombre_region'] ?? '').toString()] =
        region['id_region'] as int;
      }

      final comunasParaInsertar = <Map<String, dynamic>>[];
      catalogoChileRegistro.forEach((nombreRegion, comunas) {
        final idRegion = idPorNombreRegion[nombreRegion];
        if (idRegion != null) {
          for (final comuna in comunas) {
            comunasParaInsertar.add({
              'nombre_comuna': comuna,
              'id_region': idRegion,
            });
          }
        }
      });

      if (comunasParaInsertar.isNotEmpty) {
        await supabase.from('comuna').insert(comunasParaInsertar);
      }
    }
  }

  // Obtiene el hogar único del proyecto. Si no existe, intenta crearlo en Concepción.
  Future<int?> obtenerOCrearHogarUnico(
      SupabaseClient supabase,
      List<Map<String, dynamic>> regiones,
      List<Map<String, dynamic>> comunas,
      ) async {
    final hogarExistente = await supabase
        .from('hogar')
        .select('id_hogar, nombre_hogar')
        .eq('nombre_hogar', 'Cuidado de Adulto Mayor')
        .maybeSingle();

    if (hogarExistente != null) {
      return hogarExistente['id_hogar'] as int;
    }

    // Busca la comuna Concepción para dejar fijo el hogar en esa ciudad.
    final comunaConcepcion = comunas.where((c) {
      final nombre = (c['nombre_comuna'] ?? '').toString().toLowerCase();
      return nombre == 'concepción' || nombre == 'concepcion';
    }).toList();

    if (comunaConcepcion.isEmpty) return null;

    final hogarInsertado = await supabase
        .from('hogar')
        .insert({
      'nombre_hogar': 'Cuidado de Adulto Mayor',
      'direccion': 'Concepción, Chile',
      'correo': 'cuidadodeadultomayor@gmail.com',
      'telefono': '912345678',
      'id_comuna': comunaConcepcion.first['id_comuna'],
    })
        .select('id_hogar')
        .single();

    return hogarInsertado['id_hogar'] as int;
  }

  void actualizarComunasPorRegion(int? idRegion) {
    setState(() {
      idRegionSeleccionada = idRegion;
      comunasFiltradasRegistro = comunasRegistro
          .where((c) => c['id_region'] == idRegionSeleccionada)
          .toList();
      idComunaSeleccionada = comunasFiltradasRegistro.isNotEmpty
          ? comunasFiltradasRegistro.first['id_comuna'] as int
          : null;
    });
  }

  Future<void> seleccionarFechaNacimientoRegistro() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: fechaNacimientoSeleccionada ?? DateTime(1950, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'CL'),
    );
    if (fecha != null) {
      setState(() {
        fechaNacimientoSeleccionada = fecha;
        fechaNacimientoController.text = formatDate(fecha);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            // El ancho se adapta: en teléfono ocupa el espacio disponible y en Web queda limitado.
            width: MediaQuery.of(context).size.width < 430
                ? double.infinity
                : 380,
            padding: const EdgeInsets.all(28),
            decoration: cardDecoration(),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFDDEBFF),
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.blue,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'SeniorCare',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Gestión de Cuidado para Adultos Mayores',
                  style: TextStyle(color: Colors.blueGrey),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      authButton('Iniciar Sesión', Icons.login, AuthTab.login),
                      authButton(
                        'Crear Cuenta',
                        Icons.person_add_alt,
                        AuthTab.register,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (selectedTab == AuthTab.login) loginForm(),
                if (selectedTab == AuthTab.register) registerForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget authButton(String text, IconData icon, AuthTab tab) {
    final isSelected = selectedTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 5,
              ),
            ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.blue : Colors.blueGrey,
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.blueGrey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Traduce errores técnicos frecuentes a mensajes entendibles para el usuario.
  String mensajeErrorSupabase(Object error) {
    final mensaje = error.toString().toLowerCase();
    if (mensaje.contains('email rate limit exceeded')) {
      return 'Supabase bloqueó temporalmente el envío de correos. Esta versión evita ese problema usando registro local en la tabla usuario.';
    }
    if (mensaje.contains('invalid login credentials')) {
      return 'Correo o contraseña incorrectos.';
    }
    if (mensaje.contains('duplicate key') ||
        mensaje.contains('already registered') ||
        mensaje.contains('already exists')) {
      return 'Ya existe una cuenta registrada con ese correo.';
    }
    if (mensaje.contains('row-level security') || mensaje.contains('rls')) {
      return 'Supabase bloqueó la operación por políticas RLS. Revisa las políticas de la tabla usuario.';
    }
    return error.toString();
  }

  // Busca un registro en la tabla usuario usando el correo.
  // IMPORTANTE: no se usan relaciones automáticas como rol(*) o est_usuario(*),
  // porque tu base de datos tiene más de una relación posible y Supabase puede lanzar
  // el error "Multiple Choices". Por eso se consulta cada tabla por separado.
  Future<Map<String, dynamic>?> buscarUsuarioPorCorreo(String correo) async {
    final supabase = Supabase.instance.client;
    return await supabase
        .from('usuario')
        .select(
      'id_usuario, nombre, correo, contrasena, id_paciente, id_rol, id_est_usuario',
    )
        .eq('correo', correo)
        .maybeSingle();
  }

  // Obtiene el nombre del rol desde la tabla rol usando el id_rol guardado en usuario.
  Future<String> obtenerNombreRol(int idRol) async {
    final supabase = Supabase.instance.client;
    final rol = await supabase
        .from('rol')
        .select('nombre_rol')
        .eq('id_rol', idRol)
        .maybeSingle();
    return (rol?['nombre_rol'] ?? '').toString();
  }

  // Obtiene el estado del usuario desde la tabla est_usuario usando el id_est_usuario.
  Future<String> obtenerNombreEstadoUsuario(int idEstado) async {
    final supabase = Supabase.instance.client;
    final estado = await supabase
        .from('est_usuario')
        .select('nombre_est')
        .eq('id_est_usuario', idEstado)
        .maybeSingle();
    return (estado?['nombre_est'] ?? '').toString();
  }

  // Carga los datos reales del usuario que inició sesión desde Supabase.
  // Así el perfil del paciente o profesional se completa con los datos usados al registrarse.
  Future<void> cargarSesionDesdeSupabase(
      Map<String, dynamic> usuario,
      String rol,
      ) async {
    final supabase = Supabase.instance.client;
    usuarioSesion = usuario;
    rolSesion = rol;
    pacienteSesion = null;
    empleadoSesion = null;

    pacientes.clear();
    empleados.clear();
    solicitudes.clear();
    habitaciones.clear();
    turnos.clear();
    contactosEmergencia.clear();

    final habitacionesDb = await supabase
        .from('habitacion')
        .select('id_habitacion, nro_hab, piso, capacidad, estado');
    for (final h in List<Map<String, dynamic>>.from(habitacionesDb)) {
      habitaciones.add(
        Habitacion(
          idHabitacion: h['id_habitacion'] as int?,
          numero: (h['nro_hab'] ?? '').toString(),
          piso: 'Piso ${h['piso'] ?? ''}',
          capacidad: h['capacidad'] ?? 1,
          ocupantes: 0,
          estado: (h['estado'] ?? 'Disponible').toString(),
          paciente: 'Sin paciente',
        ),
      );
    }

    // IMPORTANTE: no se usa select('*, habitacion(...)') porque en la BD hay varias
    // relaciones entre paciente, habitacion e hist_hab. Si se usa embed, Supabase
    // lanza error PGRST201. Por eso se consulta paciente y habitación por separado.
    final pacientesDb = await supabase.from('paciente').select();
    for (final p in List<Map<String, dynamic>>.from(pacientesDb)) {
      final nombreCompleto =
      '${p['p_nombre'] ?? ''} ${p['s_nombre'] ?? ''} ${p['ap_paterno'] ?? ''} ${p['ap_materno'] ?? ''}'
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      String textoHabitacion = 'Sin habitación';
      final idHabitacion = p['id_habitacion'];
      if (idHabitacion != null) {
        final habitacionDb = await supabase
            .from('habitacion')
            .select('nro_hab')
            .eq('id_habitacion', idHabitacion)
            .maybeSingle();
        if (habitacionDb != null) {
          textoHabitacion = (habitacionDb['nro_hab'] ?? 'Sin habitación')
              .toString();
        }
      }

      final paciente = Paciente(
        idPaciente: p['id_paciente'] as int?,
        idUsuario: p['id_usuario'] as int?,
        idHabitacion: p['id_habitacion'] as int?,
        nombre: nombreCompleto,
        rut: (p['rut_paciente'] ?? '').toString(),
        telefono: (p['telefono'] ?? '').toString(),
        correo: (usuario['correo'] ?? '').toString(),
        direccion: (p['direccion'] ?? '').toString(),
        fechaNacimiento:
        DateTime.tryParse((p['fecha_nacimiento'] ?? '').toString()) ??
            DateTime(1950, 1, 1),
        habitacion: textoHabitacion,
        fechaIngreso: (p['fecha_ingreso'] ?? '').toString(),
        estado: (p['estado'] ?? 'Activo').toString(),
        diagnostico: '',
        alergias: '',
        medicamentos: '',
      );
      pacientes.add(paciente);
      if (p['id_usuario'] == usuario['id_usuario']) pacienteSesion = paciente;
    }

    // Se consulta cargo aparte para evitar problemas similares de relaciones automáticas.
    final empleadosDb = await supabase.from('empleado').select();
    for (final e in List<Map<String, dynamic>>.from(empleadosDb)) {
      final nombreCompleto =
      '${e['p_nombre'] ?? ''} ${e['s_nombre'] ?? ''} ${e['ap_paterno'] ?? ''} ${e['ap_materno'] ?? ''}'
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      String nombreCargo = 'Empleado';
      final idCargo = e['id_cargo'];
      if (idCargo != null) {
        final cargoDb = await supabase
            .from('cargo')
            .select('nombre_cargo')
            .eq('id_cargo', idCargo)
            .maybeSingle();
        if (cargoDb != null)
          nombreCargo = (cargoDb['nombre_cargo'] ?? 'Empleado').toString();
      }

      final empleado = Empleado(
        idEmpleado: e['id_empleado'] as int?,
        idUsuario: e['id_usuario'] as int?,
        idCargo: e['id_cargo'] as int?,
        nombre: nombreCompleto,
        rut: (e['rut_empleado'] ?? '').toString(),
        cargo: nombreCargo,
        telefono: (e['telefono'] ?? '').toString(),
        estado: 'Activo',
      );
      empleados.add(empleado);
      if (e['id_usuario'] == usuario['id_usuario']) empleadoSesion = empleado;
    }

    // Carga todos los contactos de emergencia desde Supabase.
    // El paciente verá solo sus propios contactos por el filtro de la pantalla,
    // mientras que el administrador podrá ver todos los contactos registrados.
    final contactosDb = await supabase
        .from('paciente_cont')
        .select('id_paciente_cont, prioridad, id_cont_emer, id_paciente');
    for (final c in List<Map<String, dynamic>>.from(contactosDb)) {
      final idContacto = c['id_cont_emer'];
      final idPacienteContacto = c['id_paciente'];
      if (idContacto == null || idPacienteContacto == null) continue;

      final pacienteRelacionado = pacientes
          .where((p) => p.idPaciente == idPacienteContacto)
          .toList();
      final nombrePacienteContacto = pacienteRelacionado.isNotEmpty
          ? pacienteRelacionado.first.nombre
          : 'Paciente no cargado';

      final ce = await supabase
          .from('cont_emer')
          .select(
        'p_nombre, ap_paterno, ap_materno, telefono, correo, direccion',
      )
          .eq('id_cont_emer', idContacto)
          .maybeSingle();
      if (ce == null) continue;

      contactosEmergencia.add(
        ContactoEmergencia(
          idContEmer: idContacto as int?,
          idPacienteCont: c['id_paciente_cont'] as int?,
          idPaciente: idPacienteContacto as int?,
          paciente: nombrePacienteContacto,
          nombre:
          '${ce['p_nombre'] ?? ''} ${ce['ap_paterno'] ?? ''} ${ce['ap_materno'] ?? ''}'
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim(),
          telefono: (ce['telefono'] ?? '').toString(),
          email: (ce['correo'] ?? '').toString(),
          direccion: (ce['direccion'] ?? '').toString(),
          prioridad: c['prioridad'] ?? 1,
        ),
      );
    }

    // Carga solicitudes reales desde Supabase sin relaciones embebidas.
    final solicitudesDb = await supabase
        .from('solicitud')
        .select(
      'id_solicitud, fecha_creacion, descripcion, id_tipo, id_paciente',
    );
    for (final sol in List<Map<String, dynamic>>.from(solicitudesDb)) {
      final idPaciente = sol['id_paciente'];
      final pacienteRelacionado = pacientes
          .where((p) => p.idPaciente == idPaciente)
          .toList();
      final nombrePaciente = pacienteRelacionado.isNotEmpty
          ? pacienteRelacionado.first.nombre
          : 'Paciente no cargado';

      String tipoNombre = 'Otro';
      if (sol['id_tipo'] != null) {
        final tipoDb = await supabase
            .from('tipo_solicitud')
            .select('nombre_tipo')
            .eq('id_tipo', sol['id_tipo'])
            .maybeSingle();
        if (tipoDb != null)
          tipoNombre = (tipoDb['nombre_tipo'] ?? 'Otro').toString();
      }

      String prioridadNombre = 'Media';
      final priDb = await supabase
          .from('sol_prioridad')
          .select('id_prioridad')
          .eq('id_solicitud', sol['id_solicitud'])
          .order('fecha_cambio', ascending: false)
          .limit(1)
          .maybeSingle();
      if (priDb != null && priDb['id_prioridad'] != null) {
        final pDb = await supabase
            .from('prioridad')
            .select('tipo_prioridad')
            .eq('id_prioridad', priDb['id_prioridad'])
            .maybeSingle();
        if (pDb != null)
          prioridadNombre = (pDb['tipo_prioridad'] ?? 'Media').toString();
      }

      String estadoNombre = 'Creada';
      String asignadoNombre = 'Sin asignar';
      int? idAsignacion;
      int? idEmpleadoAsignado;
      String? horaAsignacion;
      final asigDb = await supabase
          .from('asignacion')
          .select('id_asig, fecha_asignacion, id_empleado')
          .eq('id_solicitud', sol['id_solicitud'])
          .order('fecha_asignacion', ascending: false)
          .limit(1)
          .maybeSingle();
      if (asigDb != null) {
        idAsignacion = asigDb['id_asig'] as int?;
        idEmpleadoAsignado = asigDb['id_empleado'] as int?;
        final empleadoRelacionado = empleados
            .where((e) => e.idEmpleado == idEmpleadoAsignado)
            .toList();
        if (empleadoRelacionado.isNotEmpty)
          asignadoNombre = empleadoRelacionado.first.nombre;
        final fechaAsig = DateTime.tryParse(
          (asigDb['fecha_asignacion'] ?? '').toString(),
        );
        if (fechaAsig != null) horaAsignacion = formatDateTime(fechaAsig);
        final estadoAsigDb = await supabase
            .from('asig_estado')
            .select('id_est_asig')
            .eq('id_asig', idAsignacion ?? -1)
            .order('fecha', ascending: false)
            .limit(1)
            .maybeSingle();
        if (estadoAsigDb != null && estadoAsigDb['id_est_asig'] != null) {
          final eDb = await supabase
              .from('estado_asig')
              .select('nombre')
              .eq('id_est_asig', estadoAsigDb['id_est_asig'])
              .maybeSingle();
          if (eDb != null)
            estadoNombre = (eDb['nombre'] ?? 'Asignada').toString();
        } else {
          estadoNombre = 'Asignada';
        }
      }

      // Revisa el último estado real guardado por el profesional en historial_sol.
      // La tabla solicitud no tiene columna estado, por eso el estado actual se recupera
      // desde el último registro de historial_sol.
      final histDb = await supabase
          .from('historial_sol')
          .select('id_est, fecha')
          .eq('id_solicitud', sol['id_solicitud'])
          .order('fecha', ascending: false)
          .limit(1)
          .maybeSingle();

      if (histDb != null && histDb['id_est'] != null) {
        final estadoDb = await supabase
            .from('estado_sol')
            .select('nombre_estado')
            .eq('id_est', histDb['id_est'])
            .maybeSingle();
        if (estadoDb != null) {
          estadoNombre = (estadoDb['nombre_estado'] ?? estadoNombre).toString();
        }
      }

      final fechaCreacion = DateTime.tryParse(
        (sol['fecha_creacion'] ?? '').toString(),
      );
      solicitudes.add(
        Solicitud(
          idSolicitud: sol['id_solicitud'] as int?,
          idAsignacion: idAsignacion,
          idEmpleadoAsignado: idEmpleadoAsignado,
          titulo: 'Solicitud #${sol['id_solicitud']}',
          descripcion: (sol['descripcion'] ?? '').toString(),
          paciente: nombrePaciente,
          tipo: tipoNombre,
          fecha: fechaCreacion == null ? '' : formatDate(fechaCreacion),
          estado: estadoNombre,
          prioridad: prioridadNombre,
          asignadoA: asignadoNombre,
          horaCreacion: fechaCreacion == null
              ? ''
              : formatDateTime(fechaCreacion),
          horaAsignacion: horaAsignacion,
        ),
      );
    }

    // Carga turnos reales desde Supabase.
    final turnosDb = await supabase
        .from('turno')
        .select('id_turno, dia_semana, hora_inicio, hora_fin, id_empleado');
    for (final t in List<Map<String, dynamic>>.from(turnosDb)) {
      final idEmpleado = t['id_empleado'] as int?;
      final empleadoRelacionado = empleados
          .where((e) => e.idEmpleado == idEmpleado)
          .toList();
      final empleado = empleadoRelacionado.isNotEmpty
          ? empleadoRelacionado.first
          : null;
      final diaTurno = (t['dia_semana'] ?? '').toString();
      final esLibre = diaTurno.startsWith('Libre:');
      turnos.add(
        Turno(
          idTurno: t['id_turno'] as int?,
          idEmpleado: idEmpleado,
          empleado: empleado?.nombre ?? 'Empleado no cargado',
          cargo: empleado?.cargo ?? 'Sin cargo',
          fecha: esLibre
              ? diaTurno.replaceFirst('Libre:', '').trim()
              : diaTurno,
          horaInicio: esLibre
              ? 'Libre'
              : (t['hora_inicio'] ?? '').toString().substring(0, 5),
          horaTermino: esLibre
              ? 'Libre'
              : (t['hora_fin'] ?? '').toString().substring(0, 5),
          estado: esLibre ? 'Libre' : 'Asignado',
        ),
      );
    }

    await SeniorCareDb.cargarPermisosTemporalesDesdeSupabase();
    eliminarDuplicadosSesionEnMemoria();

    sincronizarHabitacionesConPacientes();
  }

  // Navega al panel correcto según el rol guardado en la base de datos.
  Future<void> navegarSegunRol(Map<String, dynamic> usuario) async {
    final idRol = usuario['id_rol'];
    final idEstado = usuario['id_est_usuario'];

    if (idRol == null || idEstado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El usuario no tiene rol o estado asignado en la base de datos.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final estadoUsuario = (await obtenerNombreEstadoUsuario(
      idEstado as int,
    )).toLowerCase();
    if (estadoUsuario == 'inactivo' || estadoUsuario == 'eliminado') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El usuario está inactivo o eliminado. Contacta al administrador.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final rol = (await obtenerNombreRol(idRol as int)).toLowerCase();
    await cargarSesionDesdeSupabase(usuario, rol);

    if (rol == 'administrador') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
      );
    } else if (rol == 'paciente') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PatientDashboardPage()),
      );
    } else if (rol == 'empleado' ||
        rol == 'profesional' ||
        rol == 'trabajador') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfessionalDashboardPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rol no reconocido en la base de datos: $rol'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Inicia sesión directamente con la tabla usuario.
  // Esta versión NO usa Supabase Auth, por lo tanto NO envía correos y NO puede generar
  // el error "email rate limit exceeded".
  Future<void> iniciarSesionSupabase() async {
    final correo = correoController.text.trim().toLowerCase();
    final contrasena = passwordController.text.trim();

    if (correo.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes ingresar correo y contraseña.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!correoGmailValido(correo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solo se permiten correos @gmail.com.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => cargandoAuth = true);

    try {
      final usuario = await buscarUsuarioPorCorreo(correo);
      if (usuario == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No existe una cuenta creada con ese correo.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final contrasenaBd = (usuario['contrasena'] ?? '').toString();
      if (contrasenaBd != contrasena) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Correo o contraseña incorrectos.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!mounted) return;
      await navegarSegunRol(usuario);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensajeErrorSupabase(e)),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => cargandoAuth = false);
    }
  }

  // Recuperación de contraseña sin enviar correo automático.
  // Se valida que el correo exista en la tabla usuario y se muestra un mensaje.
  // Así se evita por completo el error "email rate limit exceeded" durante las pruebas.
  Future<void> recuperarContrasenaSupabase() async {
    final correoRecuperacionController = TextEditingController(
      text: correoController.text.trim(),
    );

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Recuperar contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ingresa el correo Gmail con el que creaste tu cuenta.'),
            const SizedBox(height: 14),
            TextField(
              controller: correoRecuperacionController,
              keyboardType: TextInputType.emailAddress,
              decoration: inputDecoration().copyWith(
                labelText: 'Correo electrónico',
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
              final correo = correoRecuperacionController.text
                  .trim()
                  .toLowerCase();

              if (correo.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Debes ingresar un correo.'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (!correoGmailValido(correo)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Solo se permiten correos @gmail.com para recuperar contraseña.',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                final usuario = await buscarUsuarioPorCorreo(correo);
                if (usuario == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'No existe una cuenta registrada con ese correo.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (!mounted) return;
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Cuenta encontrada. Para el prototipo, solicita al administrador restablecer la contraseña.',
                    ),
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(mensajeErrorSupabase(e)),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  // Crea una cuenta directamente en Supabase usando la tabla usuario.
  // Además crea el registro asociado en paciente o empleado, según el rol seleccionado.
  // De esta forma, al iniciar sesión el perfil se completa con los datos reales del registro.
  Future<void> crearCuentaSupabase() async {
    final nombreUsuario = nombreController.text.trim();
    final correo = nuevoCorreoController.text.trim().toLowerCase();
    final contrasena = nuevaPasswordController.text.trim();
    final confirmar = confirmarPasswordController.text.trim();
    final rut = formatearRut(limpiarRut(rutController.text.trim()));
    final primerNombre = primerNombreController.text.trim();
    final segundoNombre = segundoNombreController.text.trim();
    final apellidoPaterno = apellidoPaternoController.text.trim();
    final apellidoMaterno = apellidoMaternoController.text.trim();
    final direccion = direccionController.text.trim();
    final telefono = telefonoController.text.trim().replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    if (nombreUsuario.isEmpty ||
        correo.isEmpty ||
        contrasena.isEmpty ||
        confirmar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes completar usuario, correo y contraseña.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!correoGmailValido(correo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Solo se permiten correos @gmail.com para crear cuentas.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (contrasena.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener al menos 6 caracteres.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (contrasena != confirmar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (rolSeleccionado == 'Administrador' &&
        numeroSerieAdminController.text.trim() != numeroSerieAdministrador) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Número de serie de administrador incorrecto.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final requiereFicha =
        rolSeleccionado == 'Paciente' || rolSeleccionado == 'Empleado';
    if (requiereFicha) {
      if (rut.isEmpty ||
          primerNombre.isEmpty ||
          apellidoPaterno.isEmpty ||
          apellidoMaterno.isEmpty ||
          direccion.isEmpty ||
          telefono.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes completar los datos personales del registro.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!validarRutChileno(rut)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'El RUT ingresado no es válido. Usa el formato 12.345.678-9 o 12.345.678-K.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!validarTelefonoChile(telefono)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'El teléfono debe tener exactamente 9 números, por ejemplo 912345678.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (idRegionSeleccionada == null ||
          idComunaSeleccionada == null ||
          idHogarSeleccionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Debes tener regiones, comunas y el hogar único cargados en Supabase.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    if (rolSeleccionado == 'Paciente' && fechaNacimientoSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes seleccionar la fecha de nacimiento del paciente.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // La habitación NO se pide al paciente durante el registro.
    // Queda sin asignar y luego el administrador debe asignarla desde Gestión de Pacientes/Habitaciones.

    if (rolSeleccionado == 'Empleado' && idCargoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes tener cargos creados en Supabase para registrar empleados.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => cargandoAuth = true);

    try {
      final supabase = Supabase.instance.client;

      // Validación previa para evitar correos duplicados antes de insertar.
      // Además, la tabla usuario mantiene UNIQUE(correo), por lo que Supabase también lo bloqueará.
      final existe = await buscarUsuarioPorCorreo(correo);
      if (existe != null) {
        throw Exception('Ya existe una cuenta registrada con ese correo.');
      }

      final rolData = await supabase
          .from('rol')
          .select('id_rol')
          .eq('nombre_rol', rolSeleccionado)
          .maybeSingle();

      final estadoData = await supabase
          .from('est_usuario')
          .select('id_est_usuario')
          .eq('nombre_est', 'Activo')
          .maybeSingle();

      if (rolData == null || estadoData == null) {
        throw Exception(
          'No existen datos base de rol o estado de usuario. Ejecuta los INSERT del DDL en Supabase.',
        );
      }

      final usuarioInsertado = await supabase
          .from('usuario')
          .insert({
        'nombre': nombreUsuario,
        'correo': correo,
        'contrasena': contrasena,
        'id_est_usuario': estadoData['id_est_usuario'],
        'id_rol': rolData['id_rol'],
      })
          .select('id_usuario')
          .single();

      final int idUsuario = usuarioInsertado['id_usuario'] as int;

      if (rolSeleccionado == 'Paciente') {
        final pacienteInsertado = await supabase
            .from('paciente')
            .insert({
          'rut_paciente': rut,
          'p_nombre': primerNombre,
          's_nombre': segundoNombre.isEmpty ? null : segundoNombre,
          'ap_paterno': apellidoPaterno,
          'ap_materno': apellidoMaterno,
          'fecha_nacimiento': fechaNacimientoSeleccionada!
              .toIso8601String()
              .split('T')
              .first,
          'fecha_ingreso': DateTime.now()
              .toIso8601String()
              .split('T')
              .first,
          'estado': 'Activo',
          'direccion': direccion,
          'telefono': telefono,
          'id_hogar': idHogarSeleccionado,
          'id_comuna': idComunaSeleccionada,
          'id_usuario': idUsuario,
        })
            .select('id_paciente')
            .single();

        await supabase
            .from('usuario')
            .update({'id_paciente': pacienteInsertado['id_paciente']})
            .eq('id_usuario', idUsuario);
      }

      if (rolSeleccionado == 'Empleado') {
        await supabase.from('empleado').insert({
          'rut_empleado': rut,
          'p_nombre': primerNombre,
          's_nombre': segundoNombre.isEmpty ? null : segundoNombre,
          'ap_paterno': apellidoPaterno,
          'ap_materno': apellidoMaterno,
          'direccion': direccion,
          'telefono': telefono,
          'id_hogar': idHogarSeleccionado,
          'id_cargo': idCargoSeleccionado,
          'id_comuna': idComunaSeleccionada,
          'id_usuario': idUsuario,
        });
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cuenta de $rolSeleccionado creada correctamente. Ahora puedes iniciar sesión.',
          ),
        ),
      );

      setState(() {
        selectedTab = AuthTab.login;
        correoController.text = correo;
        passwordController.clear();
        nombreController.clear();
        nuevoCorreoController.clear();
        nuevaPasswordController.clear();
        confirmarPasswordController.clear();
        rutController.clear();
        primerNombreController.clear();
        segundoNombreController.clear();
        apellidoPaternoController.clear();
        apellidoMaternoController.clear();
        direccionController.clear();
        telefonoController.clear();
        fechaNacimientoController.clear();
        fechaNacimientoSeleccionada = null;
        numeroSerieAdminController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensajeErrorSupabase(e)),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => cargandoAuth = false);
    }
  }

  Widget loginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label('Correo Electrónico'),
        input(correoController, 'usuario@gmail.com'),
        label('Contraseña'),
        input(
          passwordController,
          '********',
          obscure: !verPasswordLogin,
          onToggleVisibility: () =>
              setState(() => verPasswordLogin = !verPasswordLogin),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: cargandoAuth ? null : iniciarSesionSupabase,
            child: Text(cargandoAuth ? 'Validando...' : 'Iniciar Sesión'),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: cargandoAuth ? null : recuperarContrasenaSupabase,
            child: const Text('¿Olvidaste tu contraseña?'),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Para ingresar debes tener una cuenta creada en la tabla usuario de Supabase y usar correo @gmail.com.',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget registerForm() {
    final requiereFicha =
        rolSeleccionado == 'Paciente' || rolSeleccionado == 'Empleado';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label('Nombre de Usuario'),
        input(nombreController, 'Ej: jperez'),
        label('Correo Electrónico'),
        input(nuevoCorreoController, 'correo@gmail.com'),
        label('Rol'),
        DropdownButtonFormField<String>(
          value: rolSeleccionado,
          decoration: inputDecoration(),
          items: const [
            DropdownMenuItem(value: 'Paciente', child: Text('Paciente')),
            DropdownMenuItem(value: 'Empleado', child: Text('Empleado')),
            DropdownMenuItem(
              value: 'Administrador',
              child: Text('Administrador'),
            ),
          ],
          onChanged: (value) => setState(() => rolSeleccionado = value!),
        ),
        const SizedBox(height: 14),

        if (requiereFicha) ...[
          const Divider(),
          const Text(
            'Datos personales',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          label('RUT'),
          TextField(
            controller: rutController,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [RutInputFormatter()],
            decoration: inputDecoration().copyWith(
              hintText: rolSeleccionado == 'Paciente'
                  ? '12.345.678-9'
                  : '15.678.901-K',
              helperText:
              'Máximo 8 números más dígito verificador. Puede terminar en K.',
            ),
          ),
          label('Primer nombre'),
          input(primerNombreController, 'Ej: María'),
          label('Segundo nombre'),
          input(segundoNombreController, 'Opcional'),
          label('Apellido paterno'),
          input(apellidoPaternoController, 'Ej: González'),
          label('Apellido materno'),
          input(apellidoMaternoController, 'Ej: Soto'),
          label('Teléfono'),
          TextField(
            controller: telefonoController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
            decoration: inputDecoration().copyWith(
              hintText: '912345678',
              helperText: 'Ingresa 9 números, sin +56.',
            ),
          ),
          label('Dirección'),
          input(direccionController, 'Dirección del domicilio'),
          label('Región'),
          DropdownButtonFormField<int>(
            value: idRegionSeleccionada,
            isExpanded: true,
            hint: const Text('Selecciona una región'),
            disabledHint: const Text('Cargando regiones...'),
            decoration: inputDecoration(),
            items: regionesRegistro
                .map(
                  (r) => DropdownMenuItem<int>(
                value: r['id_region'] as int,
                child: Text((r['nombre_region'] ?? '').toString()),
              ),
            )
                .toList(),
            onChanged: regionesRegistro.isEmpty
                ? null
                : actualizarComunasPorRegion,
          ),
          const SizedBox(height: 14),
          label('Comuna'),
          DropdownButtonFormField<int>(
            value: idComunaSeleccionada,
            isExpanded: true,
            hint: const Text('Selecciona una comuna'),
            disabledHint: const Text('Selecciona una región primero'),
            decoration: inputDecoration(),
            items: comunasFiltradasRegistro
                .map(
                  (c) => DropdownMenuItem<int>(
                value: c['id_comuna'] as int,
                child: Text((c['nombre_comuna'] ?? '').toString()),
              ),
            )
                .toList(),
            onChanged: comunasFiltradasRegistro.isEmpty
                ? null
                : (value) => setState(() => idComunaSeleccionada = value),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Hogar asignado automáticamente: Cuidado de Adulto Mayor, Concepción, Chile.',
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
          ),
          const SizedBox(height: 14),
        ],

        if (rolSeleccionado == 'Paciente') ...[
          label('Fecha de nacimiento'),
          TextField(
            controller: fechaNacimientoController,
            readOnly: true,
            onTap: seleccionarFechaNacimientoRegistro,
            decoration: inputDecoration().copyWith(
              hintText: 'Seleccionar fecha',
              suffixIcon: const Icon(Icons.calendar_month),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'La habitación no se selecciona al registrarse. El administrador la asignará después desde Gestión de Pacientes o Habitaciones.',
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
          ),
          const SizedBox(height: 14),
        ],

        if (rolSeleccionado == 'Empleado') ...[
          label('Cargo'),
          DropdownButtonFormField<int>(
            value: idCargoSeleccionado,
            decoration: inputDecoration(),
            items: cargosRegistro
                .map(
                  (c) => DropdownMenuItem<int>(
                value: c['id_cargo'] as int,
                child: Text((c['nombre_cargo'] ?? '').toString()),
              ),
            )
                .toList(),
            onChanged: (value) => setState(() => idCargoSeleccionado = value),
          ),
          const SizedBox(height: 14),
        ],

        if (rolSeleccionado == 'Administrador') ...[
          label('Número de serie de administrador'),
          input(
            numeroSerieAdminController,
            'Ej: SC-ADMIN-2026',
            obscure: !verSerieAdministrador,
            onToggleVisibility: () =>
                setState(() => verSerieAdministrador = !verSerieAdministrador),
          ),
          const SizedBox(height: 6),
          const Text(
            'Este número evita que cualquier persona pueda crear una cuenta administrativa.',
            style: TextStyle(fontSize: 11, color: Colors.blueGrey),
          ),
          const SizedBox(height: 14),
        ],
        label('Contraseña'),
        input(
          nuevaPasswordController,
          'Mínimo 6 caracteres',
          obscure: !verPasswordRegistro,
          onToggleVisibility: () =>
              setState(() => verPasswordRegistro = !verPasswordRegistro),
        ),
        label('Confirmar Contraseña'),
        input(
          confirmarPasswordController,
          'Repite la contraseña',
          obscure: !verConfirmarPasswordRegistro,
          onToggleVisibility: () => setState(
                () => verConfirmarPasswordRegistro = !verConfirmarPasswordRegistro,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.green),
            onPressed: cargandoAuth ? null : crearCuentaSupabase,
            child: Text(cargandoAuth ? 'Creando cuenta...' : 'Crear Cuenta'),
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Al registrarte aceptas los términos y condiciones de SeniorCare.',
            style: TextStyle(fontSize: 11, color: Colors.blueGrey),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// VISTA ADMINISTRADOR
// ============================================================

// Panel principal del administrador con indicadores y accesos rápidos.
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pendientes = solicitudes
        .where((s) => s.estado != 'Completada' && s.estado != 'Cancelada')
        .length;
    final disponibles = habitaciones
        .where((h) => h.estado == 'Disponible')
        .length;
    final asignadas = solicitudes
        .where((s) => s.asignadoA != 'Sin asignar' && s.estado != 'Cancelada')
        .length;

    return AdminLayout(
      title: 'Panel Administrador',
      subtitle: 'Resumen general del sistema SeniorCare',
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
                'Pacientes Activos',
                pacientes.where((p) => p.estado == 'Activo').length.toString(),
                Icons.groups,
                Colors.blue,
              ),
              summaryCard(
                'Empleados/Profesionales',
                empleados.length.toString(),
                Icons.badge,
                Colors.green,
              ),
              summaryCard(
                'Solicitudes Pendientes',
                pendientes.toString(),
                Icons.assignment,
                Colors.deepOrange,
              ),
              summaryCard(
                'Solicitudes Asignadas',
                asignadas.toString(),
                Icons.access_time,
                Colors.cyan,
              ),
              summaryCard(
                'Habitaciones Disponibles',
                disponibles.toString(),
                Icons.bed,
                Colors.indigo,
              ),
              summaryCard(
                'Permisos Temporales',
                permisosTemporales
                    .where((p) => p.estado == 'Activo')
                    .length
                    .toString(),
                Icons.admin_panel_settings,
                Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 26),
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
                const SizedBox(height: 20),
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
                    quickAccess(
                      context,
                      'Ver Pacientes',
                      Icons.groups,
                      const PatientsPage(),
                    ),
                    quickAccess(
                      context,
                      'Historial Pacientes Inactivos',
                      Icons.person_off,
                      const InactivePatientsHistoryPage(),
                    ),
                    quickAccess(
                      context,
                      'Ver Equipo',
                      Icons.badge,
                      const EmployeesPage(),
                    ),
                    quickAccess(
                      context,
                      'Ver Solicitudes',
                      Icons.assignment,
                      const RequestsPage(),
                    ),
                    quickAccess(
                      context,
                      'Ver Habitaciones',
                      Icons.bed,
                      const RoomsPage(),
                    ),
                    quickAccess(
                      context,
                      'Ver Turnos',
                      Icons.calendar_month,
                      const ShiftsPage(),
                    ),
                    quickAccess(
                      context,
                      'Contactos Emergencia',
                      Icons.phone,
                      const AdminEmergencyContactsPage(),
                    ),
                    quickAccess(
                      context,
                      'Permisos Empleados',
                      Icons.admin_panel_settings,
                      const PermissionsPage(),
                    ),
                    quickAccess(
                      context,
                      'Historial Admin',
                      Icons.history,
                      const AdminHistoryPage(),
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
}

// Vista administrativa de pacientes activos e inactivos, sin creación manual de pacientes.
class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Gestión de Pacientes',
      subtitle: 'Lista de todos los pacientes registrados',
      actionButton: OutlinedButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const InactivePatientsHistoryPage(),
          ),
        ),
        icon: const Icon(Icons.history),
        label: const Text('Historial inactivos'),
      ),
      child: Column(
        children: [
          searchBox('Buscar por nombre o RUT...'),
          const SizedBox(height: 20),
          ...pacientes.map(
                (p) => listCard(
              title: p.nombre,
              subtitle: p.estado == 'Inactivo'
                  ? p.descripcionInactividad
                  : null,
              children: [
                infoRow('RUT', p.rut),
                infoRow('Teléfono', p.telefono),
                infoRow(
                  'Habitación',
                  p.estado == 'Activo' ? p.habitacion : 'Sin habitación activa',
                ),
                infoRow('Fecha de Ingreso', p.fechaIngreso),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      p.estado == 'Activo' ? Icons.check_circle : Icons.cancel,
                      color: p.estado == 'Activo' ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 6),
                    statusChip(p.estado),
                  ],
                ),
                if (p.estado == 'Inactivo')
                  infoRow('Motivo', p.motivoInactividad),
                if (p.estado == 'Inactivo')
                  infoRow('Fecha inactividad', p.fechaInactividad),
                if (p.estado == 'Activo')
                  OutlinedButton.icon(
                    onPressed: () => asignarHabitacionPaciente(context, p),
                    icon: const Icon(Icons.bed),
                    label: const Text('Cambiar habitación'),
                  ),
                if (p.estado == 'Activo')
                  OutlinedButton.icon(
                    onPressed: () => marcarPacienteInactivo(context, p),
                    icon: const Icon(Icons.person_off),
                    label: const Text('Marcar inactivo'),
                  ),
                if (p.estado == 'Inactivo' &&
                    p.motivoInactividad != 'Fallecimiento')
                  OutlinedButton.icon(
                    onPressed: () => reactivarPaciente(context, p),
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text('Reactivar'),
                  ),
                if (p.estado == 'Inactivo' &&
                    p.motivoInactividad == 'Fallecimiento')
                  const Text(
                    'No reactivable por fallecimiento',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void marcarPacienteInactivo(BuildContext context, Paciente paciente) {
    if (paciente.estado == 'Inactivo') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Este paciente ya está inactivo. La acción no se repetirá en el historial.',
          ),
        ),
      );
      return;
    }
    String motivo = 'Retiro a casa';
    final descripcionController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Marcar inactivo a ${paciente.nombre}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Registra el motivo para mantener el historial del paciente.',
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: motivo,
                decoration: inputDecoration().copyWith(labelText: 'Motivo'),
                items: const [
                  DropdownMenuItem(
                    value: 'Retiro a casa',
                    child: Text('Retiro a casa'),
                  ),
                  DropdownMenuItem(
                    value: 'Fallecimiento',
                    child: Text('Fallecimiento'),
                  ),
                  DropdownMenuItem(
                    value: 'Traslado a otro centro',
                    child: Text('Traslado a otro centro'),
                  ),
                  DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                ],
                onChanged: (value) => setDialogState(() => motivo = value!),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: descripcionController,
                maxLines: 4,
                decoration: inputDecoration().copyWith(
                  labelText: 'Descripción de lo ocurrido',
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
                final hora = formatDateTime(DateTime.now());
                final descripcion = descripcionController.text.trim().isEmpty
                    ? 'Sin descripción registrada.'
                    : descripcionController.text.trim();
                try {
                  await SeniorCareDb.actualizarEstadoPaciente(
                    paciente,
                    'Inactivo',
                  );
                  await SeniorCareDb.registrarPacienteInactivo(
                    paciente: paciente,
                    motivo: motivo,
                    descripcion: descripcion,
                    responsable: 'Administrador',
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al guardar estado: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                setState(() {
                  paciente.estado = 'Inactivo';
                  paciente.motivoInactividad = motivo;
                  paciente.descripcionInactividad = descripcion;
                  paciente.fechaInactividad = hora;
                  paciente.habitacion = 'Sin habitación';
                  if (!historialPacientesInactivos.any(
                        (h) =>
                    h.paciente == paciente.nombre &&
                        h.motivo == motivo &&
                        h.fecha == hora,
                  )) {
                    historialPacientesInactivos.insert(
                      0,
                      HistorialPacienteInactivo(
                        paciente: paciente.nombre,
                        motivo: motivo,
                        descripcion: descripcion,
                        fecha: hora,
                        responsable: 'Administrador',
                      ),
                    );
                  }
                  sincronizarHabitacionesConPacientes();
                });
                registrarHistorial(
                  'Paciente inactivo',
                  '${paciente.nombre} fue marcado/a como inactivo/a a las $hora. Motivo: $motivo. $descripcion',
                );
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Paciente marcado como inactivo'),
                  ),
                );
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void reactivarPaciente(BuildContext context, Paciente paciente) {
    if (paciente.motivoInactividad == 'Fallecimiento') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se puede reactivar un paciente registrado como fallecido.',
          ),
        ),
      );
      return;
    }

    () async {
      try {
        await SeniorCareDb.actualizarEstadoPaciente(paciente, 'Activo');
        await SeniorCareDb.registrarPacienteReactivado(
          paciente: paciente,
          responsable: 'Administrador',
        );

        setState(() {
          paciente.estado = 'Activo';
          paciente.motivoInactividad = '';
          paciente.descripcionInactividad = '';
          paciente.fechaInactividad = '';
        });

        registrarHistorial(
          'Paciente reactivado',
          '${paciente.nombre} fue reactivado/a a las ${formatDateTime(DateTime.now())}. Debe asignarse habitación nuevamente.',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Paciente reactivado. Asigna una habitación cuando corresponda.',
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al reactivar paciente: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }();
  }

  void asignarHabitacionPaciente(BuildContext context, Paciente paciente) {
    String habitacionSeleccionada = paciente.habitacion;
    final habitacionesAsignables = habitaciones
        .where((h) => h.estado != 'Mantenimiento')
        .toList();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Cambiar habitación de ${paciente.nombre}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'El administrador puede asignar o mover pacientes entre habitaciones. Si la habitación está llena, el sistema realizará el movimiento y dejará libre la habitación anterior del paciente.',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: habitacionSeleccionada,
                decoration: inputDecoration().copyWith(
                  labelText: 'Habitación de destino',
                ),
                items: habitacionesAsignables.map((h) {
                  final estaLlena = h.ocupantes >= h.capacidad;
                  final textoEstado = estaLlena ? 'Llena' : h.estado;
                  return DropdownMenuItem(
                    value: h.numero,
                    child: Text(
                      'Habitación ${h.numero} - $textoEstado (${h.ocupantes}/${h.capacidad})',
                    ),
                  );
                }).toList(),
                onChanged: (value) =>
                    setDialogState(() => habitacionSeleccionada = value!),
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
                  final destino = habitaciones.firstWhere(
                        (h) => h.numero == habitacionSeleccionada,
                  );
                  await SeniorCareDb.actualizarHabitacionPaciente(
                    paciente,
                    destino,
                  );
                  setState(() {
                    final habitacionAnterior = paciente.habitacion;
                    paciente.habitacion = habitacionSeleccionada;
                    paciente.idHabitacion = destino.idHabitacion;
                    sincronizarHabitacionesConPacientes();
                    registrarHistorial(
                      'Cambio de habitación',
                      '${paciente.nombre} fue movido/a desde la habitación $habitacionAnterior a la habitación $habitacionSeleccionada.',
                    );
                  });
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Habitación actualizada correctamente'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al guardar habitación: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Guardar cambio'),
            ),
          ],
        ),
      ),
    );
  }
}

// Historial administrativo de pacientes retirados, trasladados o fallecidos.
class InactivePatientsHistoryPage extends StatelessWidget {
  const InactivePatientsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final registrosMap = <String, HistorialPacienteInactivo>{};
    for (final h in historialPacientesInactivos) {
      registrosMap['${h.paciente}|${h.motivo}|${h.fecha}'] = h;
    }
    for (final p in pacientes.where(
          (p) => p.estado == 'Inactivo' && p.fechaInactividad.isNotEmpty,
    )) {
      final h = HistorialPacienteInactivo(
        paciente: p.nombre,
        motivo: p.motivoInactividad,
        descripcion: p.descripcionInactividad,
        fecha: p.fechaInactividad,
        responsable: 'Administrador',
      );
      registrosMap['${h.paciente}|${h.motivo}|${h.fecha}'] = h;
    }
    final registros = registrosMap.values.toList();

    return AdminLayout(
      title: 'Historial de Pacientes Inactivos',
      subtitle: 'Registro de pacientes retirados, trasladados o fallecidos',
      child: Column(
        children: [
          if (registros.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: cardDecoration(),
              child: const Center(
                child: Text('No existen pacientes inactivos registrados.'),
              ),
            ),
          ...registros.map(
                (h) => listCard(
              title: h.paciente,
              subtitle: h.descripcion,
              children: [
                statusChip(h.motivo),
                infoRow('Fecha y hora', h.fecha),
                infoRow('Responsable', h.responsable),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Vista administrativa con el listado de profesionales del hogar.
class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Gestión de Empleados',
      subtitle: 'Lista de todos los profesionales y empleados',
      actionButton: FilledButton.icon(
        onPressed: abrirNuevoEmpleado,
        icon: const Icon(Icons.person_add),
        label: const Text('Nuevo Empleado'),
      ),
      child: Column(
        children: [
          searchBox('Buscar por nombre o RUT...'),
          const SizedBox(height: 20),
          if (empleados.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: cardDecoration(),
              child: const Center(
                child: Text('No existen empleados cargados desde Supabase.'),
              ),
            ),
          ...empleados.map(
                (e) => listCard(
              title: e.nombre,
              children: [
                infoRow('RUT', e.rut),
                infoRow('Cargo', e.cargo),
                infoRow('Teléfono', e.telefono),
                statusChip(e.estado),
                if (e.permisoAdminTemporal) statusChip('Permiso temporal'),
                OutlinedButton.icon(
                  onPressed: () => confirmarEliminarEmpleado(e),
                  icon: const Icon(
                    Icons.person_remove_alt_1,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Desactivar empleado',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> abrirNuevoEmpleado() async {
    final cargos = await SeniorCareDb.obtenerCargos();
    if (cargos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No existen cargos registrados en Supabase.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final usuarioCtrl = TextEditingController();
    final correoCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final rutCtrl = TextEditingController();
    final pNombreCtrl = TextEditingController();
    final sNombreCtrl = TextEditingController();
    final apPatCtrl = TextEditingController();
    final apMatCtrl = TextEditingController();
    final direccionCtrl = TextEditingController();
    final telefonoCtrl = TextEditingController();
    int idCargo = cargos.first['id_cargo'] as int;
    bool verPassEmpleado = false;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nuevo empleado'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: usuarioCtrl,
                  decoration: inputDecoration().copyWith(
                    labelText: 'Nombre de usuario',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: correoCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration().copyWith(
                    labelText: 'Correo Gmail',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passCtrl,
                  obscureText: !verPassEmpleado,
                  decoration: inputDecoration().copyWith(
                    labelText: 'Contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(
                        !verPassEmpleado
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () => setDialogState(
                            () => verPassEmpleado = !verPassEmpleado,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: rutCtrl,
                  inputFormatters: [RutInputFormatter()],
                  decoration: inputDecoration().copyWith(labelText: 'RUT'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: pNombreCtrl,
                  decoration: inputDecoration().copyWith(
                    labelText: 'Primer nombre',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: sNombreCtrl,
                  decoration: inputDecoration().copyWith(
                    labelText: 'Segundo nombre (opcional)',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: apPatCtrl,
                  decoration: inputDecoration().copyWith(
                    labelText: 'Apellido paterno',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: apMatCtrl,
                  decoration: inputDecoration().copyWith(
                    labelText: 'Apellido materno',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: direccionCtrl,
                  decoration: inputDecoration().copyWith(
                    labelText: 'Dirección',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: telefonoCtrl,
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
                DropdownButtonFormField<int>(
                  value: idCargo,
                  decoration: inputDecoration().copyWith(labelText: 'Cargo'),
                  items: cargos
                      .map(
                        (c) => DropdownMenuItem<int>(
                      value: c['id_cargo'] as int,
                      child: Text((c['nombre_cargo'] ?? '').toString()),
                    ),
                  )
                      .toList(),
                  onChanged: (value) => setDialogState(() => idCargo = value!),
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
                final correo = correoCtrl.text.trim().toLowerCase();
                final telefono = telefonoCtrl.text.trim();
                final rut = formatearRut(limpiarRut(rutCtrl.text.trim()));
                if (usuarioCtrl.text.trim().isEmpty ||
                    correo.isEmpty ||
                    passCtrl.text.trim().isEmpty ||
                    pNombreCtrl.text.trim().isEmpty ||
                    apPatCtrl.text.trim().isEmpty ||
                    apMatCtrl.text.trim().isEmpty ||
                    direccionCtrl.text.trim().isEmpty ||
                    telefono.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Completa todos los campos obligatorios.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (!RegExp(
                  r'^[a-zA-Z0-9._%+-]+@gmail\.com$',
                ).hasMatch(correo)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Solo se permiten correos @gmail.com.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (passCtrl.text.trim().length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'La contraseña debe tener al menos 6 caracteres.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (!validarRutChileno(rut)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('El RUT ingresado no es válido.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (!validarTelefonoChile(telefono)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'El teléfono debe tener exactamente 9 números.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  final ids = await SeniorCareDb.crearEmpleadoDesdeAdmin(
                    nombreUsuario: usuarioCtrl.text.trim(),
                    correo: correo,
                    contrasena: passCtrl.text.trim(),
                    rut: rut,
                    primerNombre: pNombreCtrl.text.trim(),
                    segundoNombre: sNombreCtrl.text.trim(),
                    apellidoPaterno: apPatCtrl.text.trim(),
                    apellidoMaterno: apMatCtrl.text.trim(),
                    direccion: direccionCtrl.text.trim(),
                    telefono: telefono,
                    idCargo: idCargo,
                  );
                  final cargoNombre = cargos
                      .firstWhere(
                        (c) => c['id_cargo'] == idCargo,
                  )['nombre_cargo']
                      .toString();
                  setState(() {
                    empleados.add(
                      Empleado(
                        idEmpleado: ids['id_empleado'] as int?,
                        idUsuario: ids['id_usuario'] as int?,
                        idCargo: idCargo,
                        nombre:
                        '${pNombreCtrl.text.trim()} ${sNombreCtrl.text.trim()} ${apPatCtrl.text.trim()} ${apMatCtrl.text.trim()}'
                            .replaceAll(RegExp(r'\s+'), ' ')
                            .trim(),
                        rut: rut,
                        cargo: cargoNombre,
                        telefono: telefono,
                        estado: 'Activo',
                      ),
                    );
                  });
                  registrarHistorial(
                    'Empleado creado',
                    'Se registró el empleado ${pNombreCtrl.text.trim()} ${apPatCtrl.text.trim()} desde administración.',
                  );
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Empleado creado correctamente'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al crear empleado: $e'),
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

  void confirmarEliminarEmpleado(Empleado empleado) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Desactivar empleado'),
        content: Text(
          '¿Deseas desactivar a ${empleado.nombre}? No se borrará su historial, solo dejará de aparecer como trabajador activo.',
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
                await SeniorCareDb.desactivarEmpleado(empleado);
                setState(() {
                  empleado.estado = 'Inactivo';
                  empleados.remove(empleado);
                  turnos.removeWhere(
                        (t) =>
                    t.idEmpleado == empleado.idEmpleado ||
                        t.empleado == empleado.nombre,
                  );
                });
                registrarHistorial(
                  'Empleado desactivado',
                  '${empleado.nombre} fue desactivado por el administrador.',
                );
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Empleado desactivado correctamente'),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al desactivar empleado: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Desactivar'),
          ),
        ],
      ),
    );
  }
}

// Vista administrativa de solicitudes; permite asignar o reasignar profesionales.
class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  String filtroEstado = 'Todos';

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Gestión de Solicitudes',
      subtitle:
      'Todas las solicitudes del sistema. El administrador solo asigna o reasigna profesionales responsables.',
      child: Column(
        children: [
          filterBoxEstado(),
          const SizedBox(height: 20),
          ...solicitudes
              .where((s) => filtroEstado == 'Todos' || s.estado == filtroEstado)
              .map(
                (s) => listCard(
              title: s.titulo,
              subtitle: s.descripcion,
              children: [
                statusChip(s.estado),
                statusChip(s.prioridad),
                infoRow('Paciente', s.paciente),
                infoRow('Tipo', s.tipo),
                infoRow('Fecha de solicitud', s.fecha),
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
                if (s.estado != 'Completada' && s.estado != 'Cancelada')
                  OutlinedButton.icon(
                    onPressed: () => asignarSolicitud(context, s),
                    icon: Icon(
                      s.asignadoA != 'Sin asignar'
                          ? Icons.swap_horiz
                          : Icons.person_add,
                    ),
                    label: Text(
                      s.asignadoA != 'Sin asignar'
                          ? 'Reasignar empleado'
                          : 'Asignar empleado',
                    ),
                  ),
                if (s.estado != 'Completada' && s.estado != 'Cancelada')
                  OutlinedButton.icon(
                    onPressed: () => cancelarSolicitudAdmin(context, s),
                    icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                    label: const Text('Cancelar solicitud', style: TextStyle(color: Colors.red)),
                  ),
                OutlinedButton.icon(
                  onPressed: () => eliminarSolicitudAdmin(context, s),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text('Eliminar solicitud', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget filterBoxEstado() {
    final estados = [
      'Todos',
      'Creada',
      'Asignada',
      'Reasignada',
      'Pendiente',
      'Aceptada',
      'En Proceso',
      'Completada',
      'Cancelada',
    ];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filtros', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: filtroEstado,
            decoration: inputDecoration().copyWith(labelText: 'Estado'),
            items: estados
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) => setState(() => filtroEstado = value!),
          ),
        ],
      ),
    );
  }

  void asignarSolicitud(BuildContext context, Solicitud solicitud) {
    String empleadoSeleccionado = solicitud.asignadoA != 'Sin asignar'
        ? solicitud.asignadoA
        : empleados.first.nombre;
    final teniaAsignado = solicitud.asignadoA != 'Sin asignar';
    final estabaCancelada = solicitud.estado == 'Cancelada';
    final descripcionReasignacionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            teniaAsignado || estabaCancelada
                ? 'Reasignar solicitud'
                : 'Asignar solicitud',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selecciona el profesional responsable. Esta acción quedará registrada con fecha y hora.',
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: empleadoSeleccionado,
                decoration: inputDecoration().copyWith(
                  labelText: 'Empleado responsable',
                ),
                items: empleados
                    .map(
                      (e) => DropdownMenuItem(
                    value: e.nombre,
                    child: Text('${e.nombre} - ${e.cargo}'),
                  ),
                )
                    .toList(),
                onChanged: (value) =>
                    setDialogState(() => empleadoSeleccionado = value!),
              ),
              if (teniaAsignado || estabaCancelada) ...[
                const SizedBox(height: 14),
                TextField(
                  controller: descripcionReasignacionController,
                  maxLines: 4,
                  decoration: inputDecoration().copyWith(
                    labelText: 'Descripción del motivo de reasignación',
                  ),
                ),
              ],
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
                final horaAccion = formatDateTime(DateTime.now());
                try {
                  final esReasignacion = teniaAsignado || estabaCancelada;
                  final descripcionReasignacion =
                  descripcionReasignacionController.text.trim();
                  if (esReasignacion && descripcionReasignacion.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Debes indicar una descripción del motivo de reasignación.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  final idEmpleado = await SeniorCareDb.asignarSolicitud(
                    solicitud: solicitud,
                    empleadoNombre: empleadoSeleccionado,
                    reasignar: esReasignacion,
                    descripcion: esReasignacion
                        ? descripcionReasignacion
                        : null,
                  );
                  if (idEmpleado == null)
                    throw Exception(
                      'No se pudo encontrar el empleado en Supabase.',
                    );
                  setState(() {
                    solicitud.idEmpleadoAsignado = idEmpleado;
                    solicitud.asignadoA = empleadoSeleccionado;
                    solicitud.estado = teniaAsignado || estabaCancelada
                        ? 'Reasignada'
                        : 'Asignada';
                    solicitud.horaCancelacion = null;
                    solicitud.horaInicioAtencion = null;
                    solicitud.horaFinalizacion = null;
                    if (teniaAsignado || estabaCancelada) {
                      solicitud.horaReasignacion = horaAccion;
                    } else {
                      solicitud.horaAsignacion = horaAccion;
                    }
                  });
                  registrarHistorial(
                    teniaAsignado || estabaCancelada
                        ? 'Reasignación de solicitud'
                        : 'Asignación de solicitud',
                    (teniaAsignado || estabaCancelada)
                        ? '${solicitud.titulo} pasó de $empleadoAnterior a $empleadoSeleccionado a las $horaAccion. Motivo: ${descripcionReasignacionController.text.trim()}'
                        : '${solicitud.titulo} fue asignada a $empleadoSeleccionado a las $horaAccion.',
                  );
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        teniaAsignado || estabaCancelada
                            ? 'Solicitud reasignada correctamente'
                            : 'Solicitud asignada correctamente',
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al guardar asignación: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                teniaAsignado || estabaCancelada ? 'Reasignar' : 'Asignar',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void cancelarSolicitudAdmin(BuildContext context, Solicitud solicitud) {
    final motivoController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancelar solicitud'),
        content: TextField(
          controller: motivoController,
          maxLines: 4,
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
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final hora = formatDateTime(DateTime.now());
              final motivo = motivoController.text.trim().isEmpty
                  ? 'Cancelada por administrador sin motivo registrado.'
                  : motivoController.text.trim();
              try {
                await SeniorCareDb.cancelarSolicitudAdmin(
                  solicitud: solicitud,
                  motivo: '${solicitud.titulo} fue cancelada por administrador a las $hora. Motivo: $motivo',
                );
                setState(() {
                  solicitud.estado = 'Cancelada';
                  solicitud.horaCancelacion = hora;
                  solicitud.motivoCancelacion = motivo;
                  solicitud.asignadoA = 'Sin asignar';
                });
                registrarHistorial(
                  'Solicitud cancelada por administrador',
                  '${solicitud.titulo} fue cancelada a las $hora. Motivo: $motivo',
                );
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Solicitud cancelada correctamente')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al cancelar solicitud: $e'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Cancelar solicitud'),
          ),
        ],
      ),
    );
  }

  void eliminarSolicitudAdmin(BuildContext context, Solicitud solicitud) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar solicitud'),
        content: Text(
          '¿Seguro que deseas eliminar ${solicitud.titulo}? Esta acción eliminará su asignación, prioridad e historial asociado en Supabase.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Volver'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await SeniorCareDb.eliminarSolicitudCompleta(solicitud);
                setState(() => solicitudes.remove(solicitud));
                registrarHistorial(
                  'Solicitud eliminada',
                  '${solicitud.titulo} fue eliminada por administrador.',
                );
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Solicitud eliminada correctamente')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al eliminar solicitud: $e'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

}

// Vista administrativa de habitaciones; permite asignar y mover pacientes entre habitaciones.
class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  @override
  Widget build(BuildContext context) {
    sincronizarHabitacionesConPacientes();
    return AdminLayout(
      title: 'Gestión de Habitaciones',
      subtitle: 'Estado de habitaciones del hogar',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final columnas = width >= 1100
              ? 3
              : width >= 720
              ? 2
              : 1;
          const separacion = 18.0;
          final itemWidth = columnas == 1
              ? width
              : (width - (separacion * (columnas - 1))) / columnas;

          if (habitaciones.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: cardDecoration(),
              child: const Center(
                child: Text('No existen habitaciones cargadas desde Supabase.'),
              ),
            );
          }

          return Wrap(
            spacing: separacion,
            runSpacing: separacion,
            children: habitaciones
                .map(
                  (h) => SizedBox(
                width: itemWidth,
                child: habitacionCard(context, h),
              ),
            )
                .toList(),
          );
        },
      ),
    );
  }

  Widget habitacionCard(BuildContext context, Habitacion h) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: cardDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconBox(Icons.bed, Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Habitación ${h.numero}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(h.piso, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          infoRow('Capacidad', '${h.capacidad} persona(s)'),
          const SizedBox(height: 8),
          infoRow('Ocupantes', '${h.ocupantes}/${h.capacidad}'),
          const SizedBox(height: 8),
          statusChip(h.estado),
          const SizedBox(height: 8),
          infoRow('Paciente', h.paciente),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: h.estado == 'Mantenimiento'
                  ? null
                  : () => abrirAsignacionHabitacion(context, h),
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Asignar / mover paciente'),
            ),
          ),
        ],
      ),
    );
  }

  void abrirAsignacionHabitacion(
      BuildContext context,
      Habitacion habitacionDestino,
      ) {
    if (pacientes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No existen pacientes cargados para asignar habitación.',
          ),
        ),
      );
      return;
    }

    String pacienteSeleccionado = pacientes.first.nombre;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Asignar habitación ${habitacionDestino.numero}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estado actual: ${habitacionDestino.estado} (${habitacionDestino.ocupantes}/${habitacionDestino.capacidad})',
                ),
                const SizedBox(height: 10),
                const Text(
                  'Selecciona el paciente que será movido a esta habitación. El cambio quedará registrado en el historial administrativo.',
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: pacienteSeleccionado,
                  isExpanded: true,
                  decoration: inputDecoration().copyWith(labelText: 'Paciente'),
                  items: pacientes
                      .map(
                        (p) => DropdownMenuItem(
                      value: p.nombre,
                      child: Text(
                        '${p.nombre} - Habitación ${p.habitacion}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => pacienteSeleccionado = value!),
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
                try {
                  final paciente = pacientes.firstWhere(
                        (p) => p.nombre == pacienteSeleccionado,
                  );
                  await SeniorCareDb.actualizarHabitacionPaciente(
                    paciente,
                    habitacionDestino,
                  );
                  setState(() {
                    final habitacionAnterior = paciente.habitacion;
                    paciente.habitacion = habitacionDestino.numero;
                    paciente.idHabitacion = habitacionDestino.idHabitacion;
                    sincronizarHabitacionesConPacientes();
                    registrarHistorial(
                      'Asignación de habitación',
                      '$pacienteSeleccionado fue movido/a desde la habitación $habitacionAnterior a la habitación ${habitacionDestino.numero}.',
                    );
                  });
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Movimiento de habitación realizado correctamente',
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al guardar movimiento: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Guardar movimiento'),
            ),
          ],
        ),
      ),
    );
  }
}

// Vista administrativa para revisar y crear turnos de los profesionales.
class ShiftsPage extends StatefulWidget {
  const ShiftsPage({super.key});

  @override
  State<ShiftsPage> createState() => _ShiftsPageState();
}

class _ShiftsPageState extends State<ShiftsPage> {
  final diasSemana = const [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Gestión de Turnos',
      subtitle: 'Turnos asignados a cada empleado y días libres registrados',
      actionButton: FilledButton.icon(
        onPressed: abrirNuevoTurno,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Turno'),
      ),
      child: Column(
        children: [
          if (turnos.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: cardDecoration(),
              child: const Center(
                child: Text('No existen turnos registrados.'),
              ),
            ),
          ...turnos.map(
                (t) => listCard(
              title: t.empleado,
              subtitle: t.cargo,
              children: [
                infoRow('Día', t.fecha),
                if (t.estado == 'Libre')
                  statusChip('Libre')
                else ...[
                  infoRow('Hora inicio', t.horaInicio),
                  infoRow('Hora término', t.horaTermino),
                  infoRow(
                    'Duración',
                    '${calcularDuracionHoras(t.horaInicio, t.horaTermino).toStringAsFixed(1)} horas',
                  ),
                  statusChip(t.estado),
                ],
                if (t.estado != 'Libre')
                  OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        await SeniorCareDb.eliminarTurno(t);
                        setState(() => turnos.remove(t));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Turno eliminado correctamente'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al eliminar turno: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'Eliminar turno',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double calcularDuracionHoras(String inicio, String termino) {
    final i = inicio.split(':');
    final f = termino.split(':');
    var ini = DateTime(2024, 1, 1, int.parse(i[0]), int.parse(i[1]));
    var fin = DateTime(2024, 1, 1, int.parse(f[0]), int.parse(f[1]));
    if (!fin.isAfter(ini)) fin = fin.add(const Duration(days: 1));
    return fin.difference(ini).inMinutes / 60.0;
  }

  Future<void> abrirNuevoTurno() async {
    if (empleados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero debes tener empleados registrados.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String empleadoSeleccionado = empleados.first.nombre;
    String diaSeleccionado = diasSemana.first;
    bool diaLibre = false;
    DateTime inicio = DateTime.now().copyWith(
      hour: 8,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
    DateTime termino = DateTime.now().copyWith(
      hour: 16,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nuevo turno'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: empleadoSeleccionado,
                  decoration: inputDecoration().copyWith(labelText: 'Empleado'),
                  items: empleados
                      .map(
                        (e) => DropdownMenuItem(
                      value: e.nombre,
                      child: Text('${e.nombre} - ${e.cargo}'),
                    ),
                  )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => empleadoSeleccionado = value!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: diaSeleccionado,
                  decoration: inputDecoration().copyWith(labelText: 'Día'),
                  items: diasSemana
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => diaSeleccionado = value!),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Marcar como día libre'),
                  value: diaLibre,
                  onChanged: (value) => setDialogState(() => diaLibre = value),
                ),
                if (!diaLibre) ...[
                  const SizedBox(height: 12),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: formatTime(inicio)),
                    onTap: () async {
                      final hora = await seleccionarHoraRueda(
                        context,
                        TimeOfDay(hour: inicio.hour, minute: inicio.minute),
                        'Seleccionar hora de inicio',
                      );
                      if (hora != null) {
                        final hoy = DateTime.now();
                        setDialogState(
                              () => inicio = DateTime(
                            hoy.year,
                            hoy.month,
                            hoy.day,
                            hora.hour,
                            hora.minute,
                          ),
                        );
                      }
                    },
                    decoration: inputDecoration().copyWith(
                      labelText: 'Hora inicio',
                      suffixIcon: const Icon(Icons.access_time),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: formatTime(termino),
                    ),
                    onTap: () async {
                      final hora = await seleccionarHoraRueda(
                        context,
                        TimeOfDay(hour: termino.hour, minute: termino.minute),
                        'Seleccionar hora de término',
                      );
                      if (hora != null) {
                        final hoy = DateTime.now();
                        setDialogState(
                              () => termino = DateTime(
                            hoy.year,
                            hoy.month,
                            hoy.day,
                            hora.hour,
                            hora.minute,
                          ),
                        );
                      }
                    },
                    decoration: inputDecoration().copyWith(
                      labelText: 'Hora término',
                      suffixIcon: const Icon(Icons.access_time_filled),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Los turnos deben durar mínimo 8 horas y máximo 12 horas. Si el término es menor que el inicio, se interpreta como turno nocturno al día siguiente.',
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                  ),
                ],
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
                final empleado = empleados.firstWhere(
                      (e) => e.nombre == empleadoSeleccionado,
                );

                if (diaLibre) {
                  final nuevoLibre = Turno(
                    idEmpleado: empleado.idEmpleado,
                    empleado: empleado.nombre,
                    cargo: empleado.cargo,
                    fecha: diaSeleccionado,
                    horaInicio: 'Libre',
                    horaTermino: 'Libre',
                    estado: 'Libre',
                  );
                  try {
                    nuevoLibre.idTurno = await SeniorCareDb.crearTurno(
                      nuevoLibre,
                    );
                    setState(() => turnos.add(nuevoLibre));
                    registrarHistorial(
                      'Día libre registrado',
                      '${empleado.nombre} quedó libre el día $diaSeleccionado.',
                    );
                    Navigator.pop(dialogContext);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al guardar día libre: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  return;
                }

                var terminoReal = termino;
                if (!terminoReal.isAfter(inicio))
                  terminoReal = terminoReal.add(const Duration(days: 1));
                final duracionHoras =
                    terminoReal.difference(inicio).inMinutes / 60.0;
                if (duracionHoras < 8 || duracionHoras > 12) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'El turno debe durar mínimo 8 horas y máximo 12 horas.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final nuevo = Turno(
                  idEmpleado: empleado.idEmpleado,
                  empleado: empleado.nombre,
                  cargo: empleado.cargo,
                  fecha: diaSeleccionado,
                  horaInicio: formatTime(inicio),
                  horaTermino: formatTime(termino),
                  estado: 'Asignado',
                );
                try {
                  nuevo.idTurno = await SeniorCareDb.crearTurno(nuevo);
                  setState(() => turnos.add(nuevo));
                  registrarHistorial(
                    'Turno creado',
                    '${empleado.nombre} trabajará $diaSeleccionado de ${formatTime(inicio)} a ${formatTime(termino)} (${duracionHoras.toStringAsFixed(1)} horas).',
                  );
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Turno creado correctamente')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al crear turno: $e'),
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

// Vista solo lectura para que el administrador revise contactos de emergencia de pacientes.
class AdminEmergencyContactsPage extends StatefulWidget {
  const AdminEmergencyContactsPage({super.key});

  @override
  State<AdminEmergencyContactsPage> createState() =>
      _AdminEmergencyContactsPageState();
}

class _AdminEmergencyContactsPageState
    extends State<AdminEmergencyContactsPage> {
  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Contactos de Emergencia',
      subtitle:
      'Contactos registrados por los pacientes. El administrador solo puede verlos.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final columnas = width >= 1000 ? 2 : 1;
          const separacion = 22.0;
          final itemWidth = columnas == 1 ? width : (width - separacion) / 2;

          if (contactosEmergencia.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: cardDecoration(),
              child: const Center(
                child: Text('No existen contactos de emergencia registrados.'),
              ),
            );
          }

          return Wrap(
            spacing: separacion,
            runSpacing: separacion,
            children: contactosEmergencia
                .map(
                  (c) => SizedBox(
                width: itemWidth,
                child: contactoEmergenciaAdminCard(c),
              ),
            )
                .toList(),
          );
        },
      ),
    );
  }

  Widget contactoEmergenciaAdminCard(ContactoEmergencia c) {
    final paciente = pacientes.where((p) => p.nombre == c.paciente).toList();
    final puedeEliminar =
        paciente.isNotEmpty &&
            paciente.first.estado == 'Inactivo' &&
            paciente.first.motivoInactividad == 'Fallecimiento';

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: cardDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            c.nombre,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Paciente: ${c.paciente}',
            style: const TextStyle(color: Colors.blueGrey),
          ),
          const SizedBox(height: 8),
          Chip(
            label: Text('Prioridad ${c.prioridad}'),
            backgroundColor: const Color(0xFFDDEBFF),
            labelStyle: const TextStyle(color: Colors.blue),
          ),
          const SizedBox(height: 14),
          infoRow('Teléfono', c.telefono),
          const SizedBox(height: 8),
          infoRow('Email', c.email),
          const SizedBox(height: 8),
          infoRow('Dirección', c.direccion),
          const SizedBox(height: 16),
          if (!puedeEliminar)
            const Text(
              'Solo lectura para administrador',
              style: TextStyle(color: Colors.blueGrey, fontSize: 12),
            )
          else
            OutlinedButton.icon(
              onPressed: () async {
                try {
                  await SeniorCareDb.eliminarContacto(c);
                  setState(() => contactosEmergencia.remove(c));
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
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: const Text(
                'Eliminar por fallecimiento',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}

// Vista para otorgar permisos temporales a profesionales durante su jornada.
class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  String? empleadoSeleccionado;
  String permisoSeleccionado = 'Asignar solicitudes';

  // La fecha se genera automáticamente con el día actual.
  // El administrador solo selecciona la hora de inicio y término del permiso.
  DateTime inicioPermiso = DateTime.now().copyWith(
    hour: 16,
    minute: 0,
    second: 0,
    millisecond: 0,
    microsecond: 0,
  );
  DateTime terminoPermiso = DateTime.now().copyWith(
    hour: 23,
    minute: 59,
    second: 0,
    millisecond: 0,
    microsecond: 0,
  );

  Future<void> seleccionarHoraPermiso({required bool esInicio}) async {
    final actual = esInicio ? inicioPermiso : terminoPermiso;

    final hora = await seleccionarHoraRueda(
      context,
      TimeOfDay(hour: actual.hour, minute: actual.minute),
      esInicio ? 'Seleccionar hora de inicio' : 'Seleccionar hora de término',
    );
    if (hora == null) return;

    final hoy = DateTime.now();
    final nuevaFechaHora = DateTime(
      hoy.year,
      hoy.month,
      hoy.day,
      hora.hour,
      hora.minute,
    );

    setState(() {
      if (esInicio) {
        inicioPermiso = nuevaFechaHora;
      } else {
        terminoPermiso = nuevaFechaHora;
      }
    });
  }

  DateTime terminoPermisoEfectivo() {
    var termino = terminoPermiso;
    if (!termino.isAfter(inicioPermiso)) {
      termino = termino.add(const Duration(days: 1));
    }
    return termino;
  }

  String? validarPermiso() {
    final terminoReal = terminoPermisoEfectivo();
    final existeTraslape = permisosTemporales.any(
          (p) =>
      p.estado == 'Activo' &&
          p.empleado == empleadoSeleccionado &&
          rangoSeTraslapa(inicioPermiso, terminoReal, p.inicio, p.termino),
    );
    if (existeTraslape)
      return 'Ya existe un permiso activo para ese empleado en ese horario.';
    return null;
  }

  Future<void> guardarPermiso() async {
    if (empleadoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No existen empleados disponibles para otorgar permisos.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final error = validarPermiso();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    final nuevoPermiso = PermisoTemporal(
      empleado: empleadoSeleccionado!,
      permiso: permisoSeleccionado,
      inicio: inicioPermiso,
      termino: terminoPermisoEfectivo(),
      estado: 'Activo',
      horaOtorgado: formatDateTime(DateTime.now()),
    );

    try {
      nuevoPermiso.idPermiso = await SeniorCareDb.guardarPermisoTemporal(nuevoPermiso);

      setState(() {
        permisosTemporales.add(nuevoPermiso);
        final empleado = empleados.firstWhere(
              (e) => e.nombre == empleadoSeleccionado,
        );
        empleado.permisoAdminTemporal = nuevoPermiso.activoAhora;
      });

      registrarHistorial(
        'Permiso temporal otorgado',
        '${empleadoSeleccionado!} recibió permiso para: $permisoSeleccionado desde ${formatDate(inicioPermiso)} ${formatTime(inicioPermiso)} hasta ${formatDate(terminoPermisoEfectivo())} ${formatTime(terminoPermisoEfectivo())}.',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso guardado correctamente en Supabase')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar permiso en Supabase: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    empleadoSeleccionado ??= empleados.isNotEmpty
        ? empleados.first.nombre
        : null;
    return AdminLayout(
      title: 'Permisos Temporales',
      subtitle:
      'Permite que un trabajador pueda realizar funciones similares al administrador durante su jornada',
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Otorgar permiso a empleado',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: empleadoSeleccionado,
                  decoration: inputDecoration().copyWith(labelText: 'Empleado'),
                  items: empleados
                      .map(
                        (e) => DropdownMenuItem(
                      value: e.nombre,
                      child: Text('${e.nombre} - ${e.cargo}'),
                    ),
                  )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => empleadoSeleccionado = value!),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: permisoSeleccionado,
                  decoration: inputDecoration().copyWith(labelText: 'Permiso'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Asignar solicitudes',
                      child: Text('Asignar solicitudes'),
                    ),
                    DropdownMenuItem(
                      value: 'Cancelar solicitudes',
                      child: Text('Cancelar solicitudes'),
                    ),
                    DropdownMenuItem(
                      value: 'Cambiar estado de solicitudes',
                      child: Text('Cambiar estado de solicitudes'),
                    ),
                    DropdownMenuItem(
                      value: 'Asignar habitaciones',
                      child: Text('Asignar habitaciones'),
                    ),
                    DropdownMenuItem(
                      value: 'Ver historial administrativo',
                      child: Text('Ver historial administrativo'),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => permisoSeleccionado = value!),
                ),
                const SizedBox(height: 14),
                TextField(
                  readOnly: true,
                  onTap: () => seleccionarHoraPermiso(esInicio: true),
                  controller: TextEditingController(
                    text: formatTime(inicioPermiso),
                  ),
                  decoration: inputDecoration().copyWith(
                    labelText: 'Hora de inicio del permiso',
                    suffixIcon: const Icon(Icons.access_time),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  readOnly: true,
                  onTap: () => seleccionarHoraPermiso(esInicio: false),
                  controller: TextEditingController(
                    text: formatTime(terminoPermiso),
                  ),
                  decoration: inputDecoration().copyWith(
                    labelText: 'Hora de término del permiso',
                    suffixIcon: const Icon(Icons.access_time_filled),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: guardarPermiso,
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar permiso'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          ...permisosTemporales.map(
                (p) => listCard(
              title: p.empleado,
              subtitle: p.permiso,
              children: [
                infoRow('Fecha inicio', formatDate(p.inicio)),
                infoRow('Hora inicio', formatTime(p.inicio)),
                infoRow('Fecha término', formatDate(p.termino)),
                infoRow('Hora término', formatTime(p.termino)),
                infoRow('Otorgado el', p.horaOtorgado),
                if (p.horaRevocado != null)
                  infoRow('Revocado el', p.horaRevocado!),
                statusChip(p.estado),
                if (p.estado == 'Activo')
                  OutlinedButton.icon(
                    onPressed: () async {
                      final horaAccion = formatDateTime(DateTime.now());
                      try {
                        await SeniorCareDb.revocarPermisoTemporal(p);
                        setState(() {
                          p.estado = 'Revocado';
                          p.horaRevocado = horaAccion;
                          final tieneOtroActivo = permisosTemporales.any(
                                (permiso) =>
                            permiso.empleado == p.empleado &&
                                permiso.activoAhora,
                          );
                          empleados
                              .firstWhere((e) => e.nombre == p.empleado)
                              .permisoAdminTemporal =
                              tieneOtroActivo;
                        });
                        registrarHistorial(
                          'Permiso revocado',
                          'Se revocó el permiso "${p.permiso}" de ${p.empleado} a las $horaAccion.',
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Permiso revocado correctamente')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al revocar permiso: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.block),
                    label: const Text('Revocar'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Vista del historial general de acciones administrativas y trazabilidad.
class AdminHistoryPage extends StatelessWidget {
  const AdminHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Historial del Administrador',
      subtitle: 'Registro de cancelaciones, asignaciones y cambios importantes',
      child: Column(
        children: [
          if (historialAdmin.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: cardDecoration(),
              child: const Center(
                child: Text('Aún no existen acciones registradas.'),
              ),
            ),
          ...historialAdmin.map(
                (h) => listCard(
              title: h.accion,
              subtitle: h.detalle,
              children: [
                infoRow('Fecha y hora', h.fecha),
                infoRow('Responsable', h.responsable),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LAYOUTS GENERALES
// ============================================================

// Layout base para pantallas administrativas.
class AdminLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? actionButton;

  const AdminLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      role: 'Administrador',
      homePage: const AdminDashboardPage(),
      title: title,
      subtitle: subtitle,
      actionButton: actionButton,
      child: child,
    );
  }
}

// Layout base para pantallas del paciente.
class PatientLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const PatientLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      role: 'Paciente',
      homePage: const PatientDashboardPage(),
      title: title,
      subtitle: subtitle,
      child: child,
    );
  }
}

// Estructura general reutilizable con encabezado, rol, botones de inicio y cierre de sesión.
class BaseLayout extends StatelessWidget {
  final String role;
  final Widget homePage;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? actionButton;

  const BaseLayout({
    super.key,
    required this.role,
    required this.homePage,
    required this.title,
    required this.subtitle,
    required this.child,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 6,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFDDEBFF),
              child: Icon(Icons.favorite_border, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SeniorCare',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    role,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: isMobile
            ? [
          IconButton(
            tooltip: 'Inicio',
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => homePage),
            ),
            icon: const Icon(Icons.home),
          ),
          IconButton(
            tooltip: 'Cerrar Sesión',
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            ),
            icon: const Icon(Icons.logout, color: Colors.red),
          ),
        ]
            : [
          TextButton.icon(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => homePage),
            ),
            icon: const Icon(Icons.home),
            label: const Text('Inicio'),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            ),
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(width: 16),
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
                Row(
                  children: [
                    Expanded(
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
                        ],
                      ),
                    ),
                    if (actionButton != null && !isMobile) actionButton!,
                  ],
                ),
                if (actionButton != null && isMobile) ...[
                  const SizedBox(height: 14),
                  actionButton!,
                ],
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

// ============================================================
// WIDGETS REUTILIZABLES
// ============================================================

// ============================================================
// AYUDAS RESPONSIVAS
// ============================================================

// Determina si el ancho actual corresponde a una pantalla de teléfono.
bool isMobileScreen(BuildContext context) =>
    MediaQuery.of(context).size.width < 600;

// Determina si el ancho actual corresponde a una pantalla intermedia, como tablet.
bool isTabletScreen(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width >= 600 && width < 1024;
}

// Determina si el ancho actual corresponde a escritorio o navegador web amplio.
bool isDesktopScreen(BuildContext context) =>
    MediaQuery.of(context).size.width >= 1024;

// Entrega la cantidad de columnas adecuada según el ancho disponible.
// Esto permite que las tarjetas se vean en una columna en móvil y en varias columnas en Web.
int responsiveColumns(
    BuildContext context, {
      int mobile = 1,
      int tablet = 2,
      int desktop = 3,
      int largeDesktop = 4,
    }) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 1400) return largeDesktop;
  if (width >= 1024) return desktop;
  if (width >= 600) return tablet;
  return mobile;
}

// Ajusta la proporción de las tarjetas para que no queden ni muy altas en móvil ni muy aplastadas en Web.
double responsiveAspectRatio(
    BuildContext context, {
      double mobile = 1.3,
      double tablet = 2.2,
      double desktop = 3.2,
      double largeDesktop = 3.8,
    }) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 1400) return largeDesktop;
  if (width >= 1024) return desktop;
  if (width >= 600) return tablet;
  return mobile;
}

// Limita el ancho del contenido en Web para que la interfaz no se estire demasiado.
double responsiveMaxWidth(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 1400) return 1280;
  if (width >= 1024) return 1180;
  return double.infinity;
}

// Aplica un padding distinto según el dispositivo.
EdgeInsets responsivePadding(BuildContext context) {
  if (isMobileScreen(context)) return const EdgeInsets.all(16);
  if (isTabletScreen(context)) return const EdgeInsets.all(22);
  return const EdgeInsets.all(28);
}

// Estilo reutilizable para tarjetas blancas con borde redondeado y sombra.
BoxDecoration cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.10),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ],
  );
}

// Texto reutilizable para etiquetas de formularios.
Widget label(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 6, top: 10),
  child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
);

// Decoración reutilizable para campos de texto.
InputDecoration inputDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: const Color(0xFFF8FAFC),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );
}

// Campo de texto reutilizable para formularios simples.
Widget input(
    TextEditingController controller,
    String hint, {
      bool obscure = false,
      VoidCallback? onToggleVisibility,
    }) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    decoration: inputDecoration().copyWith(
      hintText: hint,
      suffixIcon: onToggleVisibility == null
          ? null
          : IconButton(
        icon: Icon(
          obscure
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
        onPressed: onToggleVisibility,
      ),
    ),
  );
}

// Tarjeta de resumen con título, valor e icono.
// Está preparada para Web, tablet y móvil. Usa LayoutBuilder, FittedBox y tamaños
// compactos para evitar los errores visuales "BOTTOM OVERFLOWED BY ... PIXELS".
Widget summaryCard(String title, String value, IconData icon, Color color) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final alto = constraints.maxHeight;
      final compacta = alto < 115;
      final muyCompacta = alto < 95;

      final padding = muyCompacta
          ? 10.0
          : compacta
          ? 12.0
          : 16.0;
      final tituloSize = muyCompacta ? 12.0 : 14.0;
      final valorSize = muyCompacta
          ? 20.0
          : compacta
          ? 23.0
          : 26.0;
      final iconPadding = muyCompacta ? 8.0 : 10.0;
      final iconSize = muyCompacta ? 20.0 : 24.0;

      return Container(
        padding: EdgeInsets.all(padding),
        decoration: cardDecoration(),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: tituloSize,
                      ),
                    ),
                  ),
                  SizedBox(height: muyCompacta ? 2 : 6),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: valorSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: EdgeInsets.all(iconPadding),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: iconSize),
            ),
          ],
        ),
      );
    },
  );
}

// Botón de acceso rápido usado principalmente en el administrador.
// El contenido se reduce de forma automática si la tarjeta queda baja en Web.
Widget quickAccess(
    BuildContext context,
    String text,
    IconData icon,
    Widget page,
    ) {
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () =>
        Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final compacta = constraints.maxHeight < 100;
        return Container(
          padding: EdgeInsets.all(compacta ? 8 : 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(compacta ? 8 : 12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.blue, size: compacta ? 20 : 24),
              ),
              SizedBox(height: compacta ? 6 : 10),
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: compacta ? 12 : 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

// Botón de acceso rápido usado en el panel del paciente.
// Se adapta a tarjetas bajas para evitar overflow en Web, tablet y móvil.
Widget patientQuickAccess(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    Widget page,
    ) {
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () =>
        Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final compacta = constraints.maxHeight < 95;
        return Container(
          padding: EdgeInsets.all(compacta ? 10 : 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: compacta ? 17 : 20,
                backgroundColor: color,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: compacta ? 18 : 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: compacta ? 12 : 14,
                      ),
                    ),
                    SizedBox(height: compacta ? 2 : 4),
                    Flexible(
                      child: Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: compacta ? 10 : 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

// Contenedor visual reutilizable para iconos.
Widget iconBox(IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, color: color),
  );
}

// Campo de búsqueda reutilizable.
Widget searchBox(String hint) => TextField(
  decoration: inputDecoration().copyWith(
    hintText: hint,
    prefixIcon: const Icon(Icons.search),
  ),
);

// Caja de filtros reutilizable para listados.
Widget filterBox() {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: cardDecoration(),
    child: LayoutBuilder(
      builder: (context, constraints) {
        // En teléfono los filtros se ordenan en columna para evitar desbordes.
        final useColumn = constraints.maxWidth < 520;
        final estado = TextField(
          decoration: inputDecoration().copyWith(labelText: 'Estado'),
        );
        final prioridad = TextField(
          decoration: inputDecoration().copyWith(labelText: 'Prioridad'),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtros',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (useColumn) ...[
              estado,
              const SizedBox(height: 12),
              prioridad,
            ] else
              Row(
                children: [
                  Expanded(child: estado),
                  const SizedBox(width: 20),
                  Expanded(child: prioridad),
                ],
              ),
          ],
        );
      },
    ),
  );
}

// Tarjeta reutilizable para mostrar registros en forma de lista.
Widget listCard({
  required String title,
  String? subtitle,
  required List<Widget> children,
}) {
  return Builder(
    builder: (context) {
      final mobile = isMobileScreen(context);
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(mobile ? 14 : 20),
        decoration: cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: mobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!),
            ],
            const SizedBox(height: 14),
            Wrap(spacing: mobile ? 18 : 40, runSpacing: 10, children: children),
          ],
        ),
      );
    },
  );
}

// Muestra una etiqueta y su valor en formato compacto.
Widget infoRow(String label, String value) {
  return Builder(
    builder: (context) {
      final mobile = isMobileScreen(context);
      return SizedBox(
        width: mobile ? double.infinity : 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      );
    },
  );
}

// Chip visual que cambia de color según estado, prioridad o condición.
Widget statusChip(String text) {
  Color color = Colors.blue;
  if (text == 'Activo' ||
      text == 'Disponible' ||
      text == 'Asignado' ||
      text == 'Aceptada' ||
      text == 'Completada' ||
      text == 'Permiso temporal' ||
      text == 'Solicitud de Paciente')
    color = Colors.green;
  if (text == 'Ocupada' ||
      text == 'Urgente' ||
      text == 'Cancelada' ||
      text == 'Inactivo' ||
      text == 'Fallecimiento')
    color = Colors.red;
  if (text == 'En Proceso' || text == 'Alta') color = Colors.orange;
  if (text == 'Mantenimiento' ||
      text == 'Pendiente' ||
      text == 'Revocado' ||
      text == 'Reasignada')
    color = Colors.blueGrey;
  return Chip(
    label: Text(text),
    backgroundColor: color.withOpacity(0.15),
    labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
  );
}
