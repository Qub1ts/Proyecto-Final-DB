-- =====================================================
-- SCRIPT 8: CONSULTAS SOLICITADAS
-- =====================================================

\c organizaciones_comunitarias;
SET search_path TO comunidad_educativa, public;

-- 1. Cantidad de proyectos realizados por organización
SELECT 
    o.nombre as organizacion,
    COUNT(p.id_proyecto) as cantidad_proyectos,
    COUNT(CASE WHEN p.estado = 'completado' THEN 1 END) as proyectos_completados,
    COUNT(CASE WHEN p.estado = 'en_progreso' THEN 1 END) as proyectos_en_progreso
FROM organizacion o
LEFT JOIN proyecto_educativo p ON o.id_organizacion = p.id_organizacion
GROUP BY o.nombre
ORDER BY cantidad_proyectos DESC;

-- 2. Cantidad de participantes por curso/organización
SELECT 
    o.nombre as organizacion,
    p.nombre as proyecto,
    COUNT(DISTINCT a.id_participante) as cantidad_participantes
FROM organizacion o
JOIN proyecto_educativo p ON o.id_organizacion = p.id_organizacion
JOIN sesion s ON p.id_proyecto = s.id_proyecto
JOIN asistencia a ON s.id_sesion = a.id_sesion
WHERE a.presente = true
GROUP BY o.nombre, p.nombre
ORDER BY o.nombre, cantidad_participantes DESC;

-- 3. Cantidad de participantes por organización (únicos)
SELECT 
    o.nombre as organizacion,
    COUNT(DISTINCT a.id_participante) as participantes_unicos
FROM organizacion o
JOIN proyecto_educativo p ON o.id_organizacion = p.id_organizacion
JOIN sesion s ON p.id_proyecto = s.id_proyecto
JOIN asistencia a ON s.id_sesion = a.id_sesion
WHERE a.presente = true
GROUP BY o.nombre;

-- 4. Cantidad de horas realizadas por proyecto
SELECT 
    p.nombre as proyecto,
    COUNT(s.id_sesion) as sesiones_realizadas,
    SUM(COALESCE(s.duracion_real, p.duracion_sesion_minutos)) / 60.0 as horas_totales
FROM proyecto_educativo p
LEFT JOIN sesion s ON p.id_proyecto = s.id_proyecto
GROUP BY p.nombre
ORDER BY horas_totales DESC;

-- 5. Asistencia más exitosa por proyecto
WITH asistencia_por_sesion AS (
    SELECT 
        p.nombre as proyecto,
        s.numero_sesion,
        s.fecha,
        COUNT(a.id_participante) as total_convocados,
        SUM(CASE WHEN a.presente THEN 1 ELSE 0 END) as presentes,
        ROUND(AVG(CASE WHEN a.presente THEN 1 ELSE 0 END) * 100, 2) as porcentaje
    FROM proyecto_educativo p
    JOIN sesion s ON p.id_proyecto = s.id_proyecto
    LEFT JOIN asistencia a ON s.id_sesion = a.id_sesion
    GROUP BY p.nombre, s.numero_sesion, s.fecha
)
SELECT DISTINCT ON (proyecto)
    proyecto,
    numero_sesion,
    fecha,
    presentes,
    porcentaje as porcentaje_asistencia
FROM asistencia_por_sesion
ORDER BY proyecto, porcentaje DESC, fecha;

-- 6. Histograma de asistencia por organización/proyecto
SELECT 
    o.nombre as organizacion,
    p.nombre as proyecto,
    CASE 
        WHEN porcentaje < 25 THEN '0-25%'
        WHEN porcentaje < 50 THEN '25-50%'
        WHEN porcentaje < 75 THEN '50-75%'
        ELSE '75-100%'
    END as rango_asistencia,
    COUNT(*) as cantidad_sesiones
FROM (
    SELECT 
        o.id_organizacion,
        p.id_proyecto,
        o.nombre,
        p.nombre,
        s.id_sesion,
        AVG(CASE WHEN a.presente THEN 1.0 ELSE 0.0 END) * 100 as porcentaje
    FROM organizacion o
    JOIN proyecto_educativo p ON o.id_organizacion = p.id_organizacion
    JOIN sesion s ON p.id_proyecto = s.id_proyecto
    LEFT JOIN asistencia a ON s.id_sesion = a.id_sesion
    GROUP BY o.id_organizacion, p.id_proyecto, o.nombre, p.nombre, s.id_sesion
) as asistencia_sesiones
GROUP BY organizacion, proyecto, rango_asistencia
ORDER BY organizacion, proyecto, rango_asistencia;

-- 7. Métodos más efectivos para mejorar participación
SELECT 
    mp.nombre_metodo,
    AVG(mp.efectividad_percibida) as efectividad_promedio,
    COUNT(DISTINCT mp.id_proyecto) as proyectos_implementados,
    STRING_AGG(DISTINCT p.nombre, ', ') as proyectos
FROM metodo_participacion mp
JOIN proyecto_educativo p ON mp.id_proyecto = p.id_proyecto
GROUP BY mp.nombre_metodo
ORDER BY efectividad_promedio DESC;

-- 8. Duración media y desviación estándar por tipo
-- Por curso/organización
SELECT 
    o.nombre as organizacion,
    p.nombre as proyecto,
    p.tipo_proyecto,
    AVG(COALESCE(s.duracion_real, p.duracion_sesion_minutos)) as duracion_media,
    STDDEV(COALESCE(s.duracion_real, p.duracion_sesion_minutos)) as desviacion_estandar,
    COUNT(s.id_sesion) as total_sesiones
FROM organizacion o
JOIN proyecto_educativo p ON o.id_organizacion = p.id_organizacion
LEFT JOIN sesion s ON p.id_proyecto = s.id_proyecto
GROUP BY o.nombre, p.nombre, p.tipo_proyecto
ORDER BY o.nombre, p.nombre;

-- Por organización
SELECT 
    o.nombre as organizacion,
    p.tipo_proyecto,
    AVG(COALESCE(s.duracion_real, p.duracion_sesion_minutos)) as duracion_media,
    STDDEV(COALESCE(s.duracion_real, p.duracion_sesion_minutos)) as desviacion_estandar
FROM organizacion o
JOIN proyecto_educativo p ON o.id_organizacion = p.id_organizacion
LEFT JOIN sesion s ON p.id_proyecto = s.id_proyecto
GROUP BY o.nombre, p.tipo_proyecto
ORDER BY o.nombre, p.tipo_proyecto;

-- General
SELECT 
    p.tipo_proyecto,
    AVG(COALESCE(s.duracion_real, p.duracion_sesion_minutos)) as duracion_media,
    STDDEV(COALESCE(s.duracion_real, p.duracion_sesion_minutos)) as desviacion_estandar,
    COUNT(DISTINCT p.id_proyecto) as cantidad_proyectos
FROM proyecto_educativo p
LEFT JOIN sesion s ON p.id_proyecto = s.id_proyecto
GROUP BY p.tipo_proyecto
ORDER BY p.tipo_proyecto;

-- 9. Promedio y desviación estándar por etapa
SELECT 
    p.tipo_proyecto,
    s.etapa,
    AVG(s.duracion_real) as duracion_media,
    STDDEV(s.duracion_real) as desviacion_estandar,
    COUNT(*) as cantidad_sesiones
FROM proyecto_educativo p
JOIN sesion s ON p.id_proyecto = s.id_proyecto
WHERE s.etapa IS NOT NULL
GROUP BY p.tipo_proyecto, s.etapa
ORDER BY p.tipo_proyecto, s.etapa;

-- 10. Registro de formadores por organización
SELECT 
    o.nombre as organizacion,
    f.nombre_anonimizado as formador,
    f.tipo_formador,
    f.especialidad,
    COUNT(DISTINCT fp.id_proyecto) as proyectos_participados,
    SUM(fp.horas_dedicadas) as total_horas
FROM organizacion o
JOIN proyecto_educativo p ON o.id_organizacion = p.id_organizacion
JOIN formador_proyecto fp ON p.id_proyecto = fp.id_proyecto
JOIN formador f ON fp.id_formador = f.id_formador
GROUP BY o.nombre, f.nombre_anonimizado, f.tipo_formador, f.especialidad
ORDER BY o.nombre, total_horas DESC;

-- 11. Extensión de documentación
SELECT 
    p.nombre as proyecto,
    COUNT(d.id_documento) as cantidad_documentos,
    STRING_AGG(DISTINCT d.tipo_documento, ', ') as tipos_documentos
FROM proyecto_educativo p
LEFT JOIN sesion s ON p.id_proyecto = s.id_proyecto
LEFT JOIN documentacion d ON s.id_sesion = d.id_sesion
GROUP BY p.nombre
ORDER BY cantidad_documentos DESC;

-- 12. Tamaño en MB de documentos por sesión
SELECT 
    p.nombre as proyecto,
    s.numero_sesion,
    COUNT(d.id_documento) as cantidad_documentos,
    COALESCE(SUM(d.tamano_mb), 0) as tamano_total_mb,
    COALESCE(AVG(d.tamano_mb), 0) as tamano_promedio_mb
FROM proyecto_educativo p
JOIN sesion s ON p.id_proyecto = s.id_proyecto
LEFT JOIN documentacion d ON s.id_sesion = d.id_sesion
GROUP BY p.nombre, s.numero_sesion
ORDER BY p.nombre, s.numero_sesion;

-- 13. Licencias de derechos de autor
SELECT 
    d.licencia,
    COUNT(DISTINCT d.id_documento) as cantidad_documentos,
    COUNT(DISTINCT s.id_proyecto) as cantidad_proyectos,
    ROUND(AVG(d.tamano_mb), 2) as tamano_promedio_mb
FROM documentacion d
JOIN sesion s ON d.id_sesion = s.id_sesion
GROUP BY d.licencia
ORDER BY cantidad_documentos DESC;

-- 14. Tiempo total por curso (preparación, ejecución, evaluación)
WITH tiempos_etapa AS (
    SELECT 
        p.nombre as proyecto,
        s.etapa,
        SUM(COALESCE(s.duracion_real, p.duracion_sesion_minutos)) / 60.0 as horas_etapa
    FROM proyecto_educativo p
    LEFT JOIN sesion s ON p.id_proyecto = s.id_proyecto
    WHERE s.etapa IS NOT NULL
    GROUP BY p.nombre, s.etapa
)
SELECT 
    proyecto,
    COALESCE(MAX(CASE WHEN etapa = 'preparacion' THEN horas_etapa END), 0) as horas_preparacion,
    COALESCE(MAX(CASE WHEN etapa = 'ejecucion' THEN horas_etapa END), 0) as horas_ejecucion,
    COALESCE(MAX(CASE WHEN etapa = 'evaluacion' THEN horas_etapa END), 0) as horas_evaluacion,
    COALESCE(SUM(horas_etapa), 0) as total_horas
FROM tiempos_etapa
GROUP BY proyecto
ORDER BY total_horas DESC;

-- 15. Visualizar progreso de cada estudiante
SELECT 
    pa.nombre_anonimizado as estudiante,
    p.nombre as proyecto,
    COUNT(DISTINCT s.id_sesion) as sesiones_totales,
    COUNT(DISTINCT CASE WHEN a.presente THEN s.id_sesion END) as sesiones_asistidas,
    ROUND(AVG(CASE WHEN a.presente THEN 1.0 ELSE 0.0 END) * 100, 2) as porcentaje_asistencia,
    r.calificacion_numerica,
    r.calificacion_cualitativa
FROM participante pa
JOIN asistencia a ON pa.id_participante = a.id_participante
JOIN sesion s ON a.id_sesion = s.id_sesion
JOIN proyecto_educativo p ON s.id_proyecto = p.id_proyecto
LEFT JOIN retroalimentacion r ON pa.id_participante = r.id_participante AND p.id_proyecto = r.id_proyecto
GROUP BY pa.nombre_anonimizado, p.nombre, r.calificacion_numerica, r.calificacion_cualitativa
ORDER BY pa.nombre_anonimizado, p.nombre;

-- 16. Estimar costo total de cada curso/proyecto
SELECT 
    p.nombre as proyecto,
    COALESCE(SUM(CASE WHEN c.tipo_costo = 'preparacion' THEN c.monto END), 0) as costo_preparacion,
    COALESCE(SUM(CASE WHEN c.tipo_costo = 'ejecucion' THEN c.monto END), 0) as costo_ejecucion,
    COALESCE(SUM(CASE WHEN c.tipo_costo = 'evaluacion' THEN c.monto END), 0) as costo_evaluacion,
    COALESCE(SUM(CASE WHEN c.tipo_costo = 'materiales' THEN c.monto END), 0) as costo_materiales,
    COALESCE(SUM(CASE WHEN c.tipo_costo NOT IN ('preparacion','ejecucion','evaluacion','materiales') THEN c.monto END), 0) as otros_costos,
    COALESCE(SUM(c.monto), 0) as costo_total
FROM proyecto_educativo p
LEFT JOIN costo_proyecto c ON p.id_proyecto = c.id_proyecto
GROUP BY p.nombre
ORDER BY costo_total DESC;

-- 17. Estimar aporte a la riqueza común
WITH metricas_proyecto AS (
    SELECT 
        o.nombre as organizacion,
        p.nombre as proyecto,
        COUNT(DISTINCT pa.id_participante) as beneficiarios,
        COUNT(DISTINCT s.id_sesion) * AVG(p.duracion_sesion_minutos) / 60 as horas_impartidas,
        COUNT(DISTINCT d.id_documento) as recursos_generados,
        COALESCE(SUM(d.tamano_mb), 0) as mb_documentacion,
        COUNT(DISTINCT CASE WHEN d.licencia IN ('Copyleft', 'Creative Commons', 'Dominio Publico') THEN d.id_documento END) as recursos_libres
    FROM organizacion o
    JOIN proyecto_educativo p ON o.id_organizacion = p.id_organizacion
    LEFT JOIN sesion s ON p.id_proyecto = s.id_proyecto
    LEFT JOIN asistencia a ON s.id_sesion = a.id_sesion AND a.presente = true
    LEFT JOIN participante pa ON a.id_participante = pa.id_participante
    LEFT JOIN documentacion d ON s.id_sesion = d.id_sesion
    GROUP BY o.nombre, p.nombre
)
SELECT 
    organizacion,
    proyecto,
    beneficiarios,
    ROUND(horas_impartidas, 1) as horas_impartidas,
    recursos_generados,
    recursos_libres,
    ROUND(mb_documentacion, 2) as mb_documentacion,
    ROUND(beneficiarios * horas_impartidas, 0) as indice_impacto_social
FROM metricas_proyecto
ORDER BY indice_impacto_social DESC;

-- 18. Consultar retroalimentación de estudiantes
SELECT 
    p.nombre as proyecto,
    COUNT(r.id_retroalimentacion) as total_evaluaciones,
    ROUND(AVG(r.calificacion_numerica), 2) as promedio_numerico,
    MODE() WITHIN GROUP (ORDER BY r.calificacion_cualitativa) as moda_cualitativa,
    COUNT(CASE WHEN r.calificacion_cualitativa = 'excelente' THEN 1 END) as evaluaciones_excelentes,
    COUNT(CASE WHEN r.calificacion_cualitativa IN ('bueno', 'muy bueno') THEN 1 END) as evaluaciones_positivas,
    COUNT(CASE WHEN r.calificacion_cualitativa IN ('malo', 'regular') THEN 1 END) as evaluaciones_negativas
FROM proyecto_educativo p
LEFT JOIN retroalimentacion r ON p.id_proyecto = r.id_proyecto
GROUP BY p.nombre
ORDER BY promedio_numerico DESC;

-- 19. Evaluación general por curso y año
SELECT 
    EXTRACT(YEAR FROM p.fecha_inicio) as año,
    p.nombre as proyecto,
    COUNT(r.id_retroalimentacion) as evaluaciones,
    ROUND(AVG(r.calificacion_numerica), 2) as promedio,
    STDDEV(r.calificacion_numerica) as desviacion
FROM proyecto_educativo p
LEFT JOIN retroalimentacion r ON p.id_proyecto = r.id_proyecto
WHERE p.fecha_inicio IS NOT NULL
GROUP BY EXTRACT(YEAR FROM p.fecha_inicio), p.nombre
ORDER BY año DESC, promedio DESC;

-- 20. Proyectos propuestos por estudiantes
SELECT 
    p.nombre as proyecto,
    p.tipo_proyecto,
    p.area_conocimiento,
    p.numero_sesiones,
    p.estado,
    COUNT(DISTINCT s.id_sesion) as sesiones_realizadas
FROM proyecto_educativo p
LEFT JOIN sesion s ON p.id_proyecto = s.id_proyecto
WHERE p.propuesto_por_estudiante = true
GROUP BY p.nombre, p.tipo_proyecto, p.area_conocimiento, p.numero_sesiones, p.estado;

-- 21. Extensión de proyectos propuestos
SELECT 
    CASE 
        WHEN p.propuesto_por_estudiante THEN 'Propuesto por estudiante'
        ELSE 'Propuesto por organización'
    END as tipo_propuesta,
    AVG(p.numero_sesiones) as promedio_sesiones,
    AVG(p.duracion_sesion_minutos) as promedio_duracion_sesion,
    COUNT(*) as cantidad_proyectos
FROM proyecto_educativo p
GROUP BY p.propuesto_por_estudiante;