import 'package:flutter_test/flutter_test.dart';
import 'package:nexasoft_incidencias/model/incidencia.dart';
import 'package:nexasoft_incidencias/services/gestor_incidencias.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late GestorIncidencias gestor;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    gestor = GestorIncidencias();
    gestor.incidencias = [
      Incidencia.desdeJson({
        'id': 'A',
        'titulo': 'WiFi oficina',
        'descripcion': 'Sin conexión',
        'estado': 'Pendiente',
        'prioridad': 'Alta',
      }),
      Incidencia.desdeJson({
        'id': 'B',
        'titulo': 'Correo',
        'descripcion': 'Falla con WiFi',
        'estado': 'Resuelta',
        'prioridad': 'Alta',
      }),
      Incidencia.desdeJson({
        'id': 'C',
        'titulo': 'WiFi recepción',
        'estado': 'Pendiente',
        'prioridad': 'Baja',
      }),
      Incidencia.desdeJson({
        'id': 'D',
        'titulo': 'Pantalla',
        'estado': 'En proceso',
      }),
    ];
  });

  List<String> ids(String texto, {String? estado, String? prioridad}) => gestor
      .buscar(texto, estado: estado, prioridad: prioridad)
      .map((item) => item.id)
      .toList();

  test('Sin criterios devuelve todos los registros en su orden original', () {
    expect(ids('   '), ['A', 'B', 'C', 'D']);
  });

  test('La búsqueda conserva normalización y coincidencias en descripción', () {
    expect(ids(' WIFI '), ['A', 'B', 'C']);
    expect(ids('CONEXIÓN'), ['A']);
  });

  test('Cada estado y prioridad se pueden filtrar independientemente', () {
    expect(ids('', estado: 'Pendiente'), ['A', 'C']);
    expect(ids('', estado: 'Resuelta'), ['B']);
    expect(ids('', estado: 'En proceso'), ['D']);
    expect(ids('', prioridad: 'Alta'), ['A', 'B']);
    expect(ids('', prioridad: 'Baja'), ['C']);
    expect(ids('', prioridad: 'Media'), ['D']);
  });

  test('Los tres criterios se intersectan, incluyendo la descripción', () {
    expect(ids('', estado: 'Pendiente', prioridad: 'Alta'), ['A']);
    expect(ids(' wifi ', estado: 'Pendiente', prioridad: 'Alta'), ['A']);
    expect(ids('wifi', estado: 'Resuelta', prioridad: 'Alta'), ['B']);
    expect(ids('pantalla', prioridad: 'Alta'), isEmpty);
    expect(ids('', estado: 'Resuelta', prioridad: 'Baja'), isEmpty);
  });

  test('Filtrar no elimina registros ni cambia los contadores generales', () {
    ids('wifi', estado: 'Pendiente', prioridad: 'Alta');
    expect(gestor.incidencias.length, 4);
    expect(gestor.contar('Pendiente'), 2);
    expect(ids(''), ['A', 'B', 'C', 'D']);
  });

  test('Se recalculan los resultados al cambiar estado o prioridad', () {
    gestor.incidencias.first.estado = 'Resuelta';
    expect(ids('', estado: 'Pendiente', prioridad: 'Alta'), isEmpty);
    gestor.incidencias.first.prioridad = 'Baja';
    expect(ids('', estado: 'Resuelta', prioridad: 'Baja'), ['A']);
  });
}
