# Stocky - Sistema de Gestión de Inventarios Profesional

Stocky es una plataforma integral diseñada para la administración de inventarios, orientada a proporcionar a negocios una herramienta robusta y segura para el control de activos. La aplicación utiliza Flutter para su interfaz y una arquitectura de nube moderna basada en Supabase, permitiendo una gestión de datos centralizada, segura y escalable.

## Propósito del Proyecto

Este sistema fue desarrollado para solventar la necesidad de una gestión de stock centralizada y reactiva. Su arquitectura desacoplada permite que la lógica de negocio y la persistencia en la nube funcionen de manera fluida, garantizando que el usuario siempre tenga acceso a información precisa sobre su inventario desde cualquier dispositivo con conexión a internet.

## Flujo de Operación del Usuario

Para asegurar una comprensión clara del funcionamiento de Stocky, se describe el flujo estándar de interacción:

1. **Autenticación**: El usuario se registra mediante un sistema de gestión de negocios. Cada cuenta posee un entorno de datos completamente aislado mediante identificadores únicos.
2. **Panel de Control (Dashboard)**: Tras acceder, el sistema presenta un resumen financiero y operativo calculado en tiempo real que incluye la inversión total, el recuento de artículos con poco stock y la categoría con mayor volumen de existencias.
3. **Gestión de Productos**: El usuario puede añadir nuevos artículos especificando nombre, categoría, precio, existencias e incluso adjuntar una imagen del producto capturada desde la cámara o galería.
4. **Análisis y Reportes**: La plataforma permite la exportación de los datos a formato PDF profesional para auditorías, revisiones externas o control administrativo.

## Funcionalidades y Lógica de Negocio

### Control Inteligente de Stock
La aplicación integra una regla de negocio crítica para la prevención de quiebres de inventario:
- **Alerta de Stock Bajo**: El sistema identifica automáticamente cualquier producto con 3 unidades o menos. Estos artículos se resaltan visualmente en la interfaz con indicadores de alerta en color rojo y etiquetas de advertencia, permitiendo al administrador tomar decisiones de reabastecimiento inmediatas.

### Gestión Multimedia
- **Almacenamiento de Imágenes**: Integración con Supabase Storage para el almacenamiento de fotografías de los productos, facilitando la identificación visual de los artículos en el inventario.

### Dashboard de Análisis en Tiempo Real
El panel principal ofrece métricas calculadas dinámicamente mediante el procesamiento de los datos del inventario:
- **Inversión Total**: Cálculo automático del valor monetario total del inventario (Precio x Stock).
- **Top Categoría**: Identificación de la categoría con mayor volumen de existencias acumulado.
- **Indicador Crítico**: Contador en tiempo real de productos en estado de alerta por bajo stock.

### Módulo de Exportación PDF
Incluye un servicio dedicado para la generación de reportes profesionales. El documento PDF generado incluye:
- Encabezado con el nombre del negocio y fecha de emisión.
- Tabla detallada de productos con subtotales financieros por línea.
- Resumen de inversión total consolidado al final del documento.

## Stack Tecnológico

- **Frontend**: Flutter SDK (Framework de UI multi-plataforma).
- **Lenguaje**: Dart.
- **Backend-as-a-Service**: Supabase (Autenticación, Base de datos PostgreSQL y Storage).
- **Gestión de Estado y Datos**: Streams para actualizaciones reactivas en tiempo real.
- **Gestión de Configuración**: flutter_dotenv para el manejo seguro de claves de API y variables de entorno.
- **Generación de Documentos**: Librerías PDF y Printing para la creación de reportes dinámicos.

## Arquitectura Técnica

El proyecto sigue un patrón de diseño limpio y escalable, separando las responsabilidades en capas claras:

- **Capa de Datos (`lib/database/`)**: Centraliza la comunicación con Supabase, manejando la persistencia de datos, autenticación de usuarios y subida de archivos multimedia.
- **Capa de Servicios (`lib/services/`)**: Contiene la lógica de negocio para la generación de documentos PDF y procesos auxiliares independientes de la UI.
- **Capa de Interfaz (`lib/views/`)**: Implementa componentes reactivos que se actualizan automáticamente ante cualquier cambio en el backend mediante el uso de StreamBuilder.

## Requisitos e Instalación

### Requisitos del Entorno
- Flutter SDK (Canal estable).
- Una instancia de proyecto en Supabase.
- Archivo `.env` en la raíz del proyecto con las credenciales de Supabase (`SUPABASE_URL` y `SUPABASE_ANON_KEY`).

### Pasos para el Despliegue Local
1. Clonar el repositorio.
2. Ejecutar `flutter pub get` para obtener las dependencias.
3. Configurar el archivo `.env` con las claves correspondientes.
4. Lanzar la aplicación:
   ```bash
   flutter run
   ```

## Desarrolladores del Proyecto

- Adrian
- Odelkis
