-- =====================================================
-- SCRIPT 9: PROCEDIMIENTOS ALMACENADOS ÚTILES
-- =====================================================

\c organizaciones_comunitarias;
SET search_path TO comunidad_educativa, public;

-- Procedimiento para calcular estadísticas de un proyecto
CREATE OR REPLACE FUNCTION calcular_estadisticas_proyecto(p_id_proyecto INTEGER)
RETURNS TABLE (
    nombre_proyecto VARCHAR,
    sesiones_planificadas INTEGER,
    sesiones_realizadas INTEGER,
    total_participantes INTEGER,
    promedio_asistencia NUMERIC,
    satisfaccion_promedio NUMERIC,
    costo_total NUMERIC,
    costo_por_participante NUMERIC
) AS $
BEGIN
    RETURN QUERY
    SELECT 
        p.nombre,
        p.numero_sesiones,
        COUNT(DISTINCT s.id_sesion)::INTEGER,
        COUNT(DISTINCT a.id_participante)::INTEGER,
        ROUND(AVG(CASE WHEN a.presente THEN 1.0 ELSE 0.0 END) * 100, 2),
        ROUND(AVG(r.calificacion_numerica), 2),
        COALESCE(SUM(DISTINCT c.monto), 0),
        CASE 
            WHEN COUNT(DISTINCT a.id_participante) > 0 
            THEN ROUND(COALESCE(SUM(DISTINCT c.monto), 0) / COUNT(DISTINCT a.id_participante), 2)
            ELSE 0
        END
    FROM proyecto_educativo p
    LEFT JOIN sesion s ON p.id_proyecto = s.id_proyecto
    LEFT JOIN asistencia a ON s.id_sesion = a.id_sesion
    LEFT JOIN retroalimentacion r ON p.id_proyecto = r.id_proyecto
    LEFT JOIN costo_proyecto c ON p.id_proyecto = c.id_proyecto
    WHERE p.id_proyecto = p_id_proyecto
    GROUP BY p.nombre, p.numero_sesiones;
END;
$ LANGUAGE plpgsql;