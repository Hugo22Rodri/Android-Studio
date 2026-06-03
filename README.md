# Stocky - Ecosistema de Gestión de Inventarios Vibrante

**Stocky** es una plataforma de software profesional diseñada para transformar la administración de inventarios en una experiencia energética, intuitiva y de alto impacto visual. Desarrollada con **Flutter** y **Supabase**, Stocky combina una arquitectura de nube robusta con un lenguaje de diseño moderno orientado a la productividad de pequeños y medianos negocios.

---

## 🎨 Sistema de Diseño: Vibrant & High-Energy

Stocky rompe con la estética tradicional de oficina para adoptar un sistema visual basado en la energía y el contraste:

- **Paleta Cromática**: Uso de Azul Eléctrico (`#2962FF`), Turquesa Neón (`#00E5FF`) y Magenta Energético (`#F50057`).
- **Jerarquía Visual**: Tipografías en mayúsculas para acciones clave, sombras dinámicas con tinte azulado y bordes ultra-redondeados (30px) que transmiten modernidad.
- **Experiencia Inmersiva**: Fondos en degradado dinámico y micro-animaciones (Hero tags) para transiciones fluidas entre pantallas.

---

## 🚀 Características Principales

### 1. Gestión de Acceso Profesional
- **Autenticación en la Nube**: Sistema de registro y acceso seguro vía Supabase Auth.
- **Aislamiento Multitenant**: Estructura de datos diseñada para que cada negocio opere en un entorno privado y seguro.

### 2. Control de Inventario Inteligente (CRUD+)
- **Gestión Multimedia**: Carga y visualización de imágenes de productos almacenadas en Supabase Storage.
- **Calculadora de Margen**: Herramienta integrada en el formulario de creación para calcular precios de venta basados en el costo y el margen de utilidad deseado.
- **Categorización Dinámica**: Clasificación organizada para facilitar el filtrado y análisis.

### 3. Centro de Analíticas y Reportes
- **Dashboard de Métricas**: Pantalla dedicada (`InventorySummaryView`) que procesa en tiempo real la inversión total, el volumen de stock y las categorías dominantes.
- **Exportación PDF**: Generación instantánea de reportes profesionales con subtotales financieros, listos para imprimir o compartir.

### 4. Lógica de Negocio Crítica
- **Sistema de Alerta "¡URGENTE!"**: Identificación automática de productos con stock bajo (≤ 3 unidades) mediante etiquetas vibrantes en magenta, asegurando que el reabastecimiento nunca se olvide.

---

## 🛠️ Stack Tecnológico

- **Frontend**: Flutter (Dart) con Material 3.
- **Backend-as-a-Service**: [Supabase](https://supabase.com/)
  - **Base de Datos**: PostgreSQL con RLS (Row Level Security).
  - **Auth**: Autenticación por correo y contraseña.
  - **Storage**: Gestión de buckets para imágenes de productos.
- **Librerías Clave**:
  - `cached_network_image`: Para carga eficiente de fotos.
  - `shimmer`: Efectos de carga elegantes.
  - `pdf` & `printing`: Motor de reportes.
  - `flutter_dotenv`: Manejo seguro de credenciales.

---

## 📂 Estructura del Sistema

```text
lib/
├── database/
│   └── supabase_service.dart   # Singleton: Auth, DB y Storage.
├── services/
│   └── pdf_service.dart        # Lógica de construcción de documentos.
├── views/
│   ├── welcome_view.dart       # Landing page de alto impacto.
│   ├── login_view.dart         # Acceso con diseño vibrante.
│   ├── register_view.dart      # Registro de nuevos negocios.
│   ├── main_view.dart          # Panel principal y buscador reactivo.
│   ├── gestion_producto_view.dart # Formulario con calculadora de margen.
│   ├── inventory_summary_view.dart # Analíticas y exportación PDF.
│   └── profile_view.dart       # Gestión de cuenta y borrado de datos.
└── main.dart                   # Inicialización de servicios y entorno.
```

---

## 📊 Modelo de Datos (PostgreSQL)

### Tabla: `usuarios`
| Columna | Tipo | Descripción |
|---|-|---|
| `id` | UUID | Identificador único vinculado a Supabase Auth. |
| `nombre_negocio` | Text | Nombre comercial del usuario. |
| `correo` | Text | Email de contacto. |

### Tabla: `productos`
| Columna | Tipo | Descripción |
|---|---|---|
| `id` | BigInt | ID autoincremental. |
| `id_usuario` | UUID | Relación con el dueño del producto. |
| `nombre` | Text | Nombre del artículo. |
| `categoria` | Text | Categoría del producto. |
| `precio` | Numeric | Precio de venta. |
| `stock` | Integer | Cantidad disponible. |
| `imagen_url` | Text | URL pública del archivo en Storage. |

---

## ⚙️ Instalación y Configuración

### 1. Requisitos
- Flutter SDK (Versión estable).
- Proyecto en Supabase con bucket `productos` habilitado.

### 2. Variables de Entorno
Crear un archivo `.env` en la raíz con:
```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu-clave-anonima
```

### 3. Despliegue
```bash
flutter pub get
flutter run
```

---

## 👨‍💻 Autores y Contribución

Desarrollado bajo estándares de ingeniería de software para la gestión moderna de activos.

**Equipo de Desarrollo:**
- **Adrian**
- **Odelkis**

**Licencia:** 
Este proyecto se distribuye bajo la Licencia MIT.
