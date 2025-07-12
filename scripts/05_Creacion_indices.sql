-- =====================================================
-- SCRIPT 5: CREACIÓN DE ÍNDICES
-- =====================================================

\c organizaciones_comunitarias;
SET search_path TO comunidad_educativa, public;

-- Índices para mejorar performance en consultas frecuentes
CREATE INDEX idx_proyecto_organizacion ON proyecto_educativo(id_organizacion);
CREATE INDEX idx_proyecto_estado ON proyecto_educativo(estado);
CREATE INDEX idx_proyecto_tipo ON proyecto_educativo(tipo_proyecto);

CREATE INDEX idx_sesion_proyecto ON sesion(id_proyecto);
CREATE INDEX idx_sesion_fecha ON sesion(fecha);
CREATE INDEX idx_sesion_espacio ON sesion(id_espacio);

CREATE INDEX idx_asistencia_sesion ON asistencia(id_sesion);
CREATE INDEX idx_asistencia_participante ON asistencia(id_participante);
CREATE INDEX idx_asistencia_presente ON asistencia(presente);

CREATE INDEX idx_documentacion_sesion ON documentacion(id_sesion);
CREATE INDEX idx_documentacion_tipo ON documentacion(tipo_documento);
CREATE INDEX idx_documentacion_licencia ON documentacion(licencia);

CREATE INDEX idx_retroalimentacion_proyecto ON retroalimentacion(id_proyecto);
CREATE INDEX idx_retroalimentacion_participante ON retroalimentacion(id_participante);

CREATE INDEX idx_colaboracion_organizacion ON colaboracion(id_organizacion);
CREATE INDEX idx_colaboracion_activa ON colaboracion(activa);

CREATE INDEX idx_costo_proyecto ON costo_proyecto(id_proyecto);
CREATE INDEX idx_costo_tipo ON costo_proyecto(tipo_costo);

CREATE INDEX idx_metodo_proyecto ON metodo_participacion(id_proyecto);

\echo 'Índices creados exitosamente'