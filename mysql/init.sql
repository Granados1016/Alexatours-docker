-- ============================================================
-- Alexa Tours — Schema inicial + datos seed
-- ============================================================

CREATE DATABASE IF NOT EXISTS alexa_tours CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE alexa_tours;

-- ------------------------------------------------------------
-- DESTINOS
-- ------------------------------------------------------------
CREATE TABLE destinos (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(100) NOT NULL,
  pais        VARCHAR(100) NOT NULL,
  descripcion TEXT,
  imagen_url  VARCHAR(500),
  activo      TINYINT(1) NOT NULL DEFAULT 1,
  created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- PAQUETES
-- ------------------------------------------------------------
CREATE TABLE paquetes (
  id             INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre         VARCHAR(150) NOT NULL,
  descripcion    TEXT,
  precio         DECIMAL(10, 2) NOT NULL,
  duracion_dias  INT UNSIGNED NOT NULL,
  incluye        TEXT COMMENT 'Lista de qué incluye el paquete',
  destino_id     INT UNSIGNED,
  imagen_url     VARCHAR(500),
  activo         TINYINT(1) NOT NULL DEFAULT 1,
  destacado      TINYINT(1) NOT NULL DEFAULT 0,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (destino_id) REFERENCES destinos(id) ON DELETE SET NULL
);

-- ------------------------------------------------------------
-- CLIENTES / LEADS
-- ------------------------------------------------------------
CREATE TABLE clientes (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre     VARCHAR(150) NOT NULL,
  email      VARCHAR(255),
  telefono   VARCHAR(30),
  ciudad     VARCHAR(100),
  mensaje    TEXT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- USUARIOS (admin panel)
-- ------------------------------------------------------------
CREATE TABLE usuarios (
  id             INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email          VARCHAR(255) NOT NULL UNIQUE,
  password_hash  VARCHAR(255) NOT NULL,
  nombre         VARCHAR(150),
  rol            ENUM('admin', 'staff') NOT NULL DEFAULT 'staff',
  activo         TINYINT(1) NOT NULL DEFAULT 1,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- RESERVAS
-- ------------------------------------------------------------
CREATE TABLE reservas (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  cliente_id   INT UNSIGNED NOT NULL,
  paquete_id   INT UNSIGNED NOT NULL,
  fecha_viaje  DATE NOT NULL,
  num_personas INT UNSIGNED NOT NULL DEFAULT 1,
  total        DECIMAL(10, 2) NOT NULL,
  estado       ENUM('pendiente', 'confirmada', 'cancelada', 'completada') NOT NULL DEFAULT 'pendiente',
  notas        TEXT,
  created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (cliente_id) REFERENCES clientes(id),
  FOREIGN KEY (paquete_id) REFERENCES paquetes(id)
);

-- ============================================================
-- SEED DATA
-- ============================================================

INSERT INTO destinos (nombre, pais, descripcion, imagen_url) VALUES
('Cancún',        'México',      'Playas de arena blanca y mar turquesa en el Caribe mexicano.',  'https://images.unsplash.com/photo-1552074284-5e88ef1aef18?w=800'),
('París',         'Francia',     'La ciudad del amor, la moda y la gastronomía.',                  'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800'),
('Nueva York',    'Estados Unidos', 'La ciudad que nunca duerme, llena de cultura y energía.',    'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=800'),
('Punta Cana',    'República Dominicana', 'Resort all-inclusive con playas paradisíacas.',        'https://images.unsplash.com/photo-1570737209810-87a8e7245f88?w=800'),
('Ciudad de México', 'México',   'Historia, gastronomía y cultura a tu alcance.',                 'https://images.unsplash.com/photo-1585464231875-d9ef1f5ad396?w=800'),
('Mérida',        'México',      'La ciudad blanca, puerta a la cultura maya y el sureste.',      'https://images.unsplash.com/photo-1574436328-c6d3703f6a17?w=800');

INSERT INTO paquetes (nombre, descripcion, precio, duracion_dias, incluye, destino_id, destacado) VALUES
('Cancún Todo Incluido', 'Disfruta del Caribe con todo incluido: vuelo, hotel 5 estrellas, traslados y tours.', 18500.00, 7, 'Vuelo redondo,Hotel 5 estrellas,Traslados,Alimentación completa,Tour a Chichén Itzá', 1, 1),
('París Romántico',      'Una escapada perfecta para parejas: Eiffel, Versalles y los mejores restaurantes.',   32000.00, 8, 'Vuelo redondo,Hotel boutique,Desayunos,Tour ciudad,Versalles', 2, 1),
('Nueva York Express',   'La gran manzana en 5 días: Times Square, Central Park, museos y Broadway.',           28500.00, 5, 'Vuelo redondo,Hotel Manhattan,Desayunos,Pase de museos,Tour en bus', 3, 0),
('Punta Cana Relax',     'Resort de lujo en el Caribe con playa privada y actividades acuáticas.',             16900.00, 6, 'Vuelo redondo,Resort all-inclusive,Traslados,Snorkel,Kayak', 4, 1),
('México Cultural',      'Visita Teotihuacán, Xochimilco, el Centro Histórico y la gastronomía mexicana.',     12500.00, 5, 'Vuelo redondo,Hotel céntrico,Desayunos,Tours incluidos,Guía local', 5, 0),
('Ruta Maya Campeche',   'Explora Campeche, Uxmal y las zonas arqueológicas mayas desde el sureste.',           9800.00, 4, 'Transporte,Hotel colonial,Desayunos,Tours arqueológicos,Guía certificado', 6, 0);

INSERT INTO usuarios (email, password_hash, nombre, rol) VALUES
('admin@alexatours.mx', '$2b$10$placeholder_change_on_first_login', 'Administrador', 'admin');
