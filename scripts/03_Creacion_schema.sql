-- =====================================================
-- SCRIPT 3: CREACIÓN DEL ESQUEMA
-- =====================================================

-- Conectar a la base de datos
\c organizaciones_comunitarias;

-- Crear schema
CREATE SCHEMA IF NOT EXISTS comunidad_educativa
    AUTHORIZATION sistema_comunitario_admin;

-- Establecer search_path por defecto
ALTER DATABASE organizaciones_comunitarias 
    SET search_path TO comunidad_educativa, public;

-- Comentario
COMMENT ON SCHEMA comunidad_educativa 
    IS 'Esquema principal para el sistema de gestión comunitaria';

\echo 'Esquema creado exitosamente'