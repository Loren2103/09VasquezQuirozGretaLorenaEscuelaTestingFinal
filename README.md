# Test Automatizado API PetStore - Karate

Este proyecto contiene la automatización de pruebas para la API pública de [Swagger PetStore](https://petstore.swagger.io/v2/).

## 🛠️ Tecnologías y Herramientas
- **Java 17**
- **Maven** (Gestor de dependencias y ejecución)
- **Karate Framework 1.5.0** (Core de automatización API)

## 📁 Estructura del Proyecto
El framework utiliza un patrón Data-Driven para separar la lógica de prueba de los datos (payloads).

    src/test/java/
    ├── karate-config.js        # Configuración y variables de entorno
    ├── logback-test.xml        # Configuración de logs de consola
    └── petstore/
        ├── PetstoreRunner.java # Clase principal para la ejecución
        ├── data/               # JSONs de las peticiones
        │   ├── pedido-request.json
        │   ├── pet-request.json
        │   └── usuario-request.json
        ├── pet/                # Módulo de Mascotas
        │   └── pet.feature
        ├── store/              # Módulo de Tienda/Órdenes
        │   └── store.feature
        └── user/               # Módulo de Usuarios
            └── user.feature

## 🚀 Módulos Automatizados
La automatización cubre escenarios exitosos (`@HappyPath`) y escenarios de validación de errores (`@UnhappyPath`) en 3 módulos principales:
1. **User:** Creación de usuarios, consulta, actualización, login, logout y eliminación.
2. **Pet:** Creación, búsqueda por estados, actualización, subida de imágenes y eliminación.
3. **Store:** Creación, búsqueda y eliminación de órdenes de compra, y consulta de inventarios.

## ⚙️ Ejecución

### 1. Ejecutar desde IDE
1. Abrir IDE (IntelliJ IDEA, Eclipse, VS Code).
2. Navega hasta el archivo `src/test/java/petstore/PetstoreRunner.java`.
3. Haz clic derecho sobre el archivo o sobre la clase y selecciona **Run 'PetstoreRunner'**.
   Esto ejecutará todas las pruebas y mostrará los resultados en la consola.

### 2. Ejecutar desde Terminal
Para ejecutar todos los escenarios de todos los módulos, ejecuta el siguiente comando en la terminal:
```bash
mvn clean test -Dtest=PetstoreRunner
```

### 3. Ejecutar por Módulo o Tag específico
Para ejecutar únicamente un grupo de pruebas o un escenario en particular, se debe pasar el parámetro de tags a Karate a través de Maven.

**Ejecutar solo las pruebas del módulo de Usuarios:**
```bash
mvn clean test -Dtest=PetstoreRunner -Dkarate.options="--tags @RegresionUser"
```

**Ejecutar solo los escenarios exitosos de toda la API:**
```bash
mvn clean test -Dtest=PetstoreRunner -Dkarate.options="--tags @HappyPath"
```

**Ejecutar un escenario específico (por ejemplo, solo la creación de usuario):**
```bash
mvn clean test -Dtest=PetstoreRunner -Dkarate.options="--tags @CrearUsuario"
```