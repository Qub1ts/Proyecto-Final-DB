-- =====================================================
-- SCRIPT 7: VISTAS ÚTILES
-- =====================================================

\c organizaciones_comunitarias;
SET search_path TO comunidad_educativa, public;

-- Vista de resumen de proyectos
CREATE VIEW v_resumen_proyectos AS
SELECT 
    o.nombre as organizacion,
    p.nombre as proyecto,
    p.tipo_proyecto,
    p.area_conocimiento,
    p.numero_sesiones,
    p.estado,
    COUNT(DISTINCT fp.id_formador) as cantidad_formadores
FROM proyecto_educativo p
JOIN organizacion o ON p.id_organizacion = o.id_organizacion
LEFT JOIN formador_proyecto fp ON p.id_proyecto = fp.id_proyecto
GROUP BY o.nombre, p.nombre, p.tipo_proyecto, p.area_conocimiento, p.numero_sesiones, p.estado;

-- Vista de asistencia por sesión
CREATE VIEW v_asistencia_sesiones AS
SELECT 
    p.nombre as proyecto,
    s.numero_sesion,
    s.fecha,
    COUNT(a.id_participante) as total_convocados,
    SUM(CASE WHEN a.presente THEN 1 ELSE 0 END) as presentes,
    ROUND(AVG(CASE WHEN a.presente THEN 1 ELSE 0 END) * 100, 2) as porcentaje_asistencia
FROM sesion s
JOIN proyecto_educativo p ON s.id_proyecto = p.id_proyecto
LEFT JOIN asistencia a ON s.id_sesion = a.id_sesion
GROUP BY p.nombre, s.numero_sesion, s.fecha
ORDER BY p.nombre, s.numero_sesion;
