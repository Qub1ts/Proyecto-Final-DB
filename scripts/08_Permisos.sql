-- =====================================================
-- SCRIPT 4: PERMISOS
-- =====================================================

\c organizaciones_comunitarias;
SET search_path TO comunidad_educativa, public;

-- Permisos para rol de administrador
GRANT ALL PRIVILEGES ON SCHEMA comunidad_educativa TO sistema_comunitario_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA comunidad_educativa TO sistema_comunitario_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA comunidad_educativa TO sistema_comunitario_admin;

-- Permisos para rol de lectura
GRANT USAGE ON SCHEMA comunidad_educativa TO sistema_comunitario_read;
GRANT SELECT ON ALL TABLES IN SCHEMA comunidad_educativa TO sistema_comunitario_read;

-- Permisos para rol de usuario
GRANT USAGE ON SCHEMA comunidad_educativa TO sistema_comunitario_user;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA comunidad_educativa TO sistema_comunitario_user;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA comunidad_educativa TO sistema_comunitario_user;