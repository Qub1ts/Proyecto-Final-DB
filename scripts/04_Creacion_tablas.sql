-- =====================================================
-- SCRIPT 3: CREACIÓN DE TABLAS (MIGRACIÓN INICIAL)
-- =====================================================

-- Conectar a la base de datos
\c organizaciones_comunitarias;

-- Usar el esquema
SET search_path TO comunidad_educativa, public;

-- Tabla de migraciones
CREATE TABLE IF NOT EXISTS migraciones (
    id SERIAL PRIMARY KEY,
    version VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    fecha_aplicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar primera migración
INSERT INTO migraciones (version, descripcion) 
VALUES ('001_esquema_inicial', 'Creación de esquema inicial del sistema');

-- ORGANIZACION
CREATE TABLE organizacion (
    id_organizacion SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    fecha_fundacion DATE,
    tipo_constitucion VARCHAR(100),
    codigo_comportamiento TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ESPACIO
CREATE TABLE espacio (
    id_espacio SERIAL PRIMARY KEY,
    direccion VARCHAR(300) NOT NULL,
    tipo_tenencia VARCHAR(50) CHECK (tipo_tenencia IN ('propio', 'arrendado', 'donado', 'comodato', 'otro')),
    comuna VARCHAR(100),
    capacidad INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PARTICIPANTE
CREATE TABLE participante (
    id_participante SERIAL PRIMARY KEY,
    nombre_anonimizado VARCHAR(100) NOT NULL,
    edad INTEGER CHECK (edad > 0 AND edad < 120),
    genero VARCHAR(50),
    fecha_ingreso DATE NOT NULL,
    tipo_participante VARCHAR(50),
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- FORMADOR
CREATE TABLE formador (
    id_formador SERIAL PRIMARY KEY,
    nombre_anonimizado VARCHAR(100) NOT NULL,
    especialidad VARCHAR(200),
    tipo_formador VARCHAR(50) CHECK (tipo_formador IN ('profesor', 'guia', 'facilitador', 'voluntario')),
    anos_experiencia INTEGER DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PROYECTO_EDUCATIVO
CREATE TABLE proyecto_educativo (
    id_proyecto SERIAL PRIMARY KEY,
    id_organizacion INTEGER NOT NULL REFERENCES organizacion(id_organizacion),
    nombre VARCHAR(200) NOT NULL,
    tipo_proyecto VARCHAR(50) CHECK (tipo_proyecto IN ('curso', 'taller', 'seminario', 'conversatorio', 'otro')),
    area_conocimiento VARCHAR(100),
    numero_sesiones INTEGER NOT NULL CHECK (numero_sesiones > 0),
    duracion_sesion_minutos INTEGER CHECK (duracion_sesion_minutos > 0),
    fecha_inicio DATE,
    fecha_fin DATE,
    estado VARCHAR(50) DEFAULT 'planificado',
    propuesto_por_estudiante BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SESION
CREATE TABLE sesion (
    id_sesion SERIAL PRIMARY KEY,
    id_proyecto INTEGER NOT NULL REFERENCES proyecto_educativo(id_proyecto),
    id_espacio INTEGER REFERENCES espacio(id_espacio),
    numero_sesion INTEGER NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME,
    duracion_real INTEGER,
    etapa VARCHAR(50) CHECK (etapa IN ('preparacion', 'ejecucion', 'evaluacion')),
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(id_proyecto, numero_sesion)
);

-- ASISTENCIA
CREATE TABLE asistencia (
    id_asistencia SERIAL PRIMARY KEY,
    id_sesion INTEGER NOT NULL REFERENCES sesion(id_sesion),
    id_participante INTEGER NOT NULL REFERENCES participante(id_participante),
    presente BOOLEAN DEFAULT FALSE,
    hora_llegada TIME,
    observacion VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(id_sesion, id_participante)
);

-- DOCUMENTACION
CREATE TABLE documentacion (
    id_documento SERIAL PRIMARY KEY,
    id_sesion INTEGER REFERENCES sesion(id_sesion),
    tipo_documento VARCHAR(50) CHECK (tipo_documento IN ('texto', 'audio', 'video', 'imagen', 'presentacion', 'otro')),
    tamano_mb DECIMAL(10,2),
    licencia VARCHAR(50) CHECK (licencia IN ('Copyright', 'Copyleft', 'Creative Commons', 'Dominio Publico', 'Otra')),
    url_anonimizada VARCHAR(500),
    descripcion TEXT,
    fecha_creacion DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RETROALIMENTACION
CREATE TABLE retroalimentacion (
    id_retroalimentacion SERIAL PRIMARY KEY,
    id_proyecto INTEGER NOT NULL REFERENCES proyecto_educativo(id_proyecto),
    id_participante INTEGER NOT NULL REFERENCES participante(id_participante),
    calificacion_numerica INTEGER CHECK (calificacion_numerica >= 1 AND calificacion_numerica <= 10),
    calificacion_cualitativa VARCHAR(50) CHECK (calificacion_cualitativa IN ('malo', 'regular', 'bueno', 'muy bueno', 'excelente')),
    comentarios TEXT,
    fecha_evaluacion DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- COLABORACION
CREATE TABLE colaboracion (
    id_colaboracion SERIAL PRIMARY KEY,
    id_organizacion INTEGER NOT NULL REFERENCES organizacion(id_organizacion),
    nombre_entidad VARCHAR(200) NOT NULL,
    tipo_colaboracion VARCHAR(100),
    fecha_inicio DATE,
    fecha_fin DATE,
    activa BOOLEAN DEFAULT TRUE,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- FORMADOR_PROYECTO (tabla intermedia)
CREATE TABLE formador_proyecto (
    id_formador INTEGER NOT NULL REFERENCES formador(id_formador),
    id_proyecto INTEGER NOT NULL REFERENCES proyecto_educativo(id_proyecto),
    rol VARCHAR(100),
    horas_dedicadas DECIMAL(10,2) DEFAULT 0,
    fecha_asignacion DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (id_formador, id_proyecto)
);

-- COSTO_PROYECTO
CREATE TABLE costo_proyecto (
    id_costo SERIAL PRIMARY KEY,
    id_proyecto INTEGER NOT NULL REFERENCES proyecto_educativo(id_proyecto),
    tipo_costo VARCHAR(50) CHECK (tipo_costo IN ('preparacion', 'ejecucion', 'evaluacion', 'materiales', 'transporte', 'otro')),
    monto DECIMAL(12,2) NOT NULL,
    descripcion TEXT,
    fecha DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- MÉTODO_PARTICIPACION (para tracking de estrategias contra ausentismo)
CREATE TABLE metodo_participacion (
    id_metodo SERIAL PRIMARY KEY,
    id_proyecto INTEGER NOT NULL REFERENCES proyecto_educativo(id_proyecto),
    nombre_metodo VARCHAR(200),
    descripcion TEXT,
    efectividad_percibida INTEGER CHECK (efectividad_percibida >= 1 AND efectividad_percibida <= 10),
    fecha_implementacion DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear índices para mejorar performance
CREATE INDEX idx_proyecto_organizacion ON proyecto_educativo(id_organizacion);
CREATE INDEX idx_sesion_proyecto ON sesion(id_proyecto);
CREATE INDEX idx_asistencia_sesion ON asistencia(id_sesion);
CREATE INDEX idx_asistencia_participante ON asistencia(id_participante);
CREATE INDEX idx_documentacion_sesion ON documentacion(id_sesion);
CREATE INDEX idx_retroalimentacion_proyecto ON retroalimentacion(id_proyecto);

\echo 'Tablas creadas exitosamente'