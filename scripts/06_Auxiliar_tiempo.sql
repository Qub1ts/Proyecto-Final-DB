-- =====================================================
-- SCRIPT 5: FUNCIONES AUXILIARES
-- =====================================================
\c organizaciones_comunitarias;
SET search_path TO comunidad_educativa, public;

-- Función para actualizar timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para actualizar timestamp
CREATE TRIGGER update_organizacion_updated_at BEFORE UPDATE
    ON organizacion FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();