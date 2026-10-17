# NexaSoft — Mesa de incidencias

Aplicación de práctica desarrollada con Flutter y Dart para registrar y consultar incidencias técnicas. Incluye correcciones de persistencia, búsqueda y contadores, además de prioridades y filtros combinados. Los datos de demostración son ficticios.

## Funciones

- Registro, listado y detalle de incidencias.
- Cambio de estado con guardado local y contadores actualizados.
- Búsqueda en título y descripción, sin distinguir mayúsculas y omitiendo espacios externos.
- Prioridades Baja, Media y Alta; los registros antiguos sin una prioridad válida utilizan Media.
- Filtros combinables por texto, estado y prioridad, con opción para limpiarlos.
- Restauración de los datos de demostración.

## Ejecutar

Se necesita Flutter instalado y un dispositivo o navegador compatible. Desde la raíz del proyecto:

```bash
flutter pub get
flutter run -d chrome --web-port 8080
```

Para Android, conectar un dispositivo con depuración USB, consultar `flutter devices` y ejecutar `flutter run -d <id>`. Para Windows, utilizar `flutter run -d windows` con las herramientas de compilación instaladas.

Si faltan archivos nativos generados por Flutter, ejecutar desde esta misma carpeta:

```bash
flutter create . --project-name nexasoft_incidencias --platforms android,web,windows
flutter pub get
```

También están disponibles los scripts `preparar.ps1` y `preparar.sh`. No sustituir los archivos de `lib/` ni `assets/` al preparar el entorno.

## Pruebas

```bash
flutter test
flutter analyze
```

El proyecto incluye 11 pruebas de compatibilidad del modelo, lógica de filtros e interacción de pantalla. En la revisión del 16 de octubre de 2026 las 11 aprobaron. El analizador reportó tres avisos informativos pendientes: dos usos obsoletos de `value` en formularios y un uso de `BuildContext` después de una operación asíncrona.

## Estructura

- `lib/`: modelo, almacenamiento local, gestor y pantallas.
- `assets/`: datos iniciales ficticios.
- `test/`: pruebas automáticas.
- `android/`, `web/` y `windows/`: configuración de las plataformas.
- `pubspec.yaml` y `pubspec.lock`: dependencias del proyecto.

## Datos locales

El JSON de `assets/` se usa como semilla; los cambios posteriores se guardan localmente. Modificar la semilla no actualiza registros ya guardados. En Chrome, mantener el mismo origen y perfil para comprobar la persistencia.

La opción **Restablecer demostración** elimina los cambios locales y restaura los datos iniciales.

Las bitácoras y los documentos de entrega se administran por separado y no forman parte de los archivos de esta versión del repositorio.
