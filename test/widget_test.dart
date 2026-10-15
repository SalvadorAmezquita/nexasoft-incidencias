import 'package:flutter_test/flutter_test.dart';
import 'package:nexasoft_incidencias/model/incidencia.dart';

void main() {
  test('Una incidencia antigua puede convertirse desde JSON', () {
    final registro = Incidencia.desdeJson({
      'id': 'INC-DEMO',
      'titulo': 'Prueba',
      'descripcion': 'Caso de ejemplo',
      'cliente': 'Cliente ficticio',
      'categoria': 'Redes',
      'estado': 'Pendiente',
      'fecha': '2026-10-12',
    });
    expect(registro.id, 'INC-DEMO');
    expect(registro.toJson()['estado'], 'Pendiente');
    expect(registro.prioridad, 'Media');
    expect(registro.toJson()['prioridad'], 'Media');
  });

  test('Las tres prioridades se conservan al convertir a JSON y leerlo', () {
    for (final prioridad in ['Baja', 'Media', 'Alta']) {
      final registro = Incidencia.desdeJson({'prioridad': prioridad});
      final recuperado = Incidencia.desdeJson(registro.toJson());
      expect(recuperado.prioridad, prioridad);
    }
  });

  test('Una prioridad inválida en JSON usa Media', () {
    for (final valor in [null, '', 'Urgente', 42]) {
      expect(Incidencia.desdeJson({'prioridad': valor}).prioridad, 'Media');
    }
  });

  test('Asignar una prioridad inválida no modifica la prioridad anterior', () {
    final registro = Incidencia.desdeJson({'prioridad': 'Alta'});
    expect(() => registro.prioridad = 'Urgente', throwsArgumentError);
    expect(registro.prioridad, 'Alta');
  });
}
