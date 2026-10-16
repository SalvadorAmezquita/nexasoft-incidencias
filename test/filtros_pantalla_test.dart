import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexasoft_incidencias/ui/pantalla_principal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  testWidgets('Combinar criterios y limpiar restaura controles y lista',
      (tester) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    await SharedPreferencesAsync().setString(
        'nexasoft_incidencias_v1',
        jsonEncode([
          {
            'id': 'A',
            'titulo': 'WiFi oficina',
            'estado': 'Pendiente',
            'prioridad': 'Alta'
          },
          {
            'id': 'B',
            'titulo': 'Correo',
            'descripcion': 'WiFi',
            'estado': 'Resuelta',
            'prioridad': 'Baja'
          },
          {
            'id': 'C',
            'titulo': 'Pantalla',
            'estado': 'Pendiente',
            'prioridad': 'Alta'
          },
        ]));
    await tester.pumpWidget(const MaterialApp(home: PantallaPrincipal()));
    await tester.pumpAndSettle();
    expect(find.text('3 registros'), findsOneWidget);

    await tester.enterText(find.byType(TextField), ' WIFI ');
    await tester.pumpAndSettle();
    expect(find.text('2 registros'), findsOneWidget);
    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pendiente').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alta').last);
    await tester.pumpAndSettle();
    expect(find.text('1 registros'), findsOneWidget);
    expect(find.text('WiFi oficina'), findsOneWidget);
    expect(find.text('Correo'), findsNothing);
    expect(find.text('Pantalla'), findsNothing);

    await tester.enterText(find.byType(TextField), 'sin coincidencias');
    await tester.pumpAndSettle();
    expect(find.text('No se encontraron incidencias'), findsOneWidget);
    await tester.tap(find.text('Limpiar filtros'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty);
    expect(find.text('Todos'), findsOneWidget);
    expect(find.text('Todas'), findsOneWidget);
    expect(find.text('3 registros'), findsOneWidget);
    expect(find.text('WiFi oficina'), findsOneWidget);
    expect(find.text('Correo'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Pantalla'), 100,
        scrollable: find.byType(Scrollable).last);
    expect(find.text('Pantalla'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
