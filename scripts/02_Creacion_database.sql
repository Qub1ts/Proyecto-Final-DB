-- =====================================================
-- SCRIPT 2: CREACIÓN DE DATABASE
-- =====================================================

-- Crear la base de datos
CREATE DATABASE organizaciones_comunitarias
    WITH 
    OWNER = sistema_comunitario_admin
    ENCODING = 'UTF8'
    LC_COLLATE = 'es_CL.UTF-8'
    LC_CTYPE = 'es_CL.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- Conectar a la base de datos
\c organizaciones_comunitarias;

-- Crear schema
CREATE SCHEMA IF NOT EXISTS comunidad_educativa
    AUTHORIZATION sistema_comunitario_admin;

-- Establecer search_path
SET search_path TO comunidad_educativa, public;