-- =====================================================
-- 10 CONSULTAS ADICIONALES PROPUESTAS
-- =====================================================

\c organizaciones_comunitarias;
SET search_path TO comunidad_educativa, public;

-- 1. Tasa de retención de participantes por proyecto
WITH primera_ultima_asistencia AS (
    SELECT 
        p.id_proyecto,
        p.nombre,
        a.id_participante,
        MIN(s.fecha) as primera_asistencia,
        MAX(s.fecha) as ultima_asistencia,
        COUNT(DISTINCT s.id_sesion) as sesiones_asistidas
    FROM proyecto_educativo p
    JOIN sesion s ON p.id_proyecto = s.id_proyecto
    JOIN asistencia a ON s.id_sesion = a.id_sesion
    WHERE a.presente = true
    GROUP BY p.id_proyecto, p.nombre, a.id_participante
)
SELECT 
    nombre as proyecto,
    COUNT(DISTINCT id_participante) as total_participantes,
    COUNT(DISTINCT CASE WHEN sesiones_asistidas >= 3 THEN id_participante END) as participantes_regulares,
    ROUND(COUNT(DISTINCT CASE WHEN sesiones_asistidas >= 3 THEN id_participante END) * 100.0 / 
          NULLIF(COUNT(DISTINCT id_participante), 0), 2) as tasa_retencion
FROM primera_ultima_asistencia
GROUP BY nombre
ORDER BY tasa_retencion DESC;

-- 2. Análisis de puntualidad por organización
SELECT 
    o.nombre as organizacion,
    COUNT(CASE WHEN a.presente AND a.hora_llegada <= s.hora_inicio THEN 1 END) as llegadas_puntuales,
    COUNT(CASE WHEN a.presente AND a.hora_llegada > s.hora_inicio THEN 1 END) as llegadas_tarde,
    ROUND(COUNT(CASE WHEN a.presente AND a.hora_llegada <= s.hora_inicio THEN 1 END) * 100.0 / 
          NULLIF(COUNT(CASE WHEN a.presente THEN 1 END), 0), 2) as porcentaje_puntualidad
FROM organizacion o
JOIN proyecto_educativo p ON o.id_organizacion = p.id_organizacion
JOIN sesion s ON p.id_proyecto = s.id_proyecto
JOIN asistencia a ON s.id_sesion = a.id_sesion
WHERE a.presente = true
GROUP BY o.nombre;

-- 3. Diversidad etaria por proyecto
SELECT 
    p.nombre as proyecto,
    MIN(pa.edad) as edad_minima,
    MAX(pa.edad) as edad_maxima,
    AVG(pa.edad) as edad_promedio,
    STDDEV(pa.edad) as desviacion_edad,
    COUNT(DISTINCT pa.id_participante) as total_participantes
FROM proyecto_educativo p
JOIN sesion s ON p.id_proyecto = s.id_proyecto
JOIN asistencia a ON s.id_sesion = a.id_sesion
JOIN participante pa ON a.id_participante = pa.id_participante
WHERE a.presente = true
GROUP BY p.nombre
ORDER BY edad_promedio;

-- 4. Eficiencia de uso de espacios
SELECT 
    e.direccion,
    e.capacidad,
    COUNT(DISTINCT s.id_sesion) as sesiones_realizadas,
    AVG(asistentes.cantidad) as promedio_asistentes,
    ROUND(AVG(asistentes.cantidad) * 100.0 / NULLIF(e.capacidad, 0), 2) as porcentaje_ocupacion
FROM espacio e
JOIN sesion s ON e.id_espacio = s.id_espacio
JOIN (
    SELECT id_sesion, COUNT(*) as cantidad
    FROM asistencia
    WHERE presente = true
    GROUP BY id_sesion
) asistentes ON s.id_sesion = asistentes.id_sesion
GROUP BY e.direccion, e.capacidad
ORDER BY porcentaje_ocupacion DESC;

-- 5. Correlación entre duración de sesiones y asistencia
WITH sesion_stats AS (
    SELECT 
        p.tipo_proyecto,
        s.duracion_real,
        COUNT(a.id_participante) as total_convocados,
        SUM(CASE WHEN a.presente THEN 1 ELSE 0 END) as presentes,
        AVG(CASE WHEN a.presente THEN 1.0 ELSE 0.0 END) as tasa_asistencia
    FROM proyecto_educativo p
    JOIN sesion s ON p.id_proyecto = s.id_proyecto
    JOIN asistencia a ON s.id_sesion = a.id_sesion
    WHERE s.duracion_real IS NOT NULL
    GROUP BY p.tipo_proyecto, s.duracion_real
)
SELECT 
    tipo_proyecto,
    CASE 
        WHEN duracion_real <= 60 THEN '0-60 min'
        WHEN duracion_real <= 90 THEN '61-90 min'
        WHEN duracion_real <= 120 THEN '91-120 min'
        ELSE 'Más de 120 min'
    END as rango_duracion,
    AVG(tasa_asistencia * 100) as porcentaje_asistencia_promedio,
    COUNT(*) as cantidad_sesiones
FROM sesion_stats
GROUP BY tipo_proyecto, rango_duracion
ORDER BY tipo_proyecto, rango_duracion;

-- 6. Impacto de colaboraciones en proyectos
SELECT 
    o.nombre as organizacion,
    COUNT(DISTINCT c.id_colaboracion) as numero_colaboraciones,
    COUNT(DISTINCT p.id_proyecto) as numero_proyectos,
    COUNT(DISTINCT pa.id_participante) as participantes_alcanzados,
    ROUND(COUNT(DISTINCT pa.id_participante) * 1.0 / NULLIF(COUNT(DISTINCT p.id_proyecto), 0), 2) as participantes_por_proyecto
FROM organizacion o
LEFT JOIN colaboracion c ON o.id_organizacion = c.id_organizacion AND c.activa = true
LEFT JOIN proyecto_educativo p ON o.id_organizacion = p.id_organizacion
LEFT JOIN sesion s ON p.id_proyecto = s.id_proyecto
LEFT JOIN asistencia a ON s.id_sesion = a.id_sesion AND a.presente = true
LEFT JOIN participante pa ON a.id_participante = pa.id_participante
GROUP BY o.nombre
ORDER BY numero_colaboraciones DESC;

-- 7. Análisis de género en participación
SELECT 
    p.nombre as proyecto,
    COUNT(DISTINCT CASE WHEN pa.genero = 'Femenino' THEN pa.id_participante END) as mujeres,
    COUNT(DISTINCT CASE WHEN pa.genero = 'Masculino' THEN pa.id_participante END) as hombres,
    COUNT(DISTINCT CASE WHEN pa.genero NOT IN ('Femenino', 'Masculino') OR pa.genero IS NULL THEN pa.id_participante END) as otros,
    COUNT(DISTINCT pa.id_participante) as total,
    ROUND(COUNT(DISTINCT CASE WHEN pa.genero = 'Femenino' THEN pa.id_participante END) * 100.0 / 
          NULLIF(COUNT(DISTINCT pa.id_participante), 0), 2) as porcentaje_mujeres
FROM proyecto_educativo p
JOIN sesion s ON p.id_proyecto = s.id_proyecto
JOIN asistencia a ON s.id_sesion = a.id_sesion AND a.presente = true
JOIN participante pa ON a.id_participante = pa.id_participante
GROUP BY p.nombre
ORDER BY total DESC;

-- 8. ROI (Retorno de Inversión) Social por proyecto
WITH roi_data AS (
    SELECT 
        p.nombre as proyecto,
        COUNT(DISTINCT a.id_participante) as beneficiarios,
        AVG(r.calificacion_numerica) as satisfaccion_promedio,
        COALESCE(SUM(c.monto), 0) as inversion_total,
        COUNT(DISTINCT s.id_sesion) as sesiones_realizadas
    FROM proyecto_educativo p
    LEFT JOIN sesion s ON p.id_proyecto = s.id_proyecto
    LEFT JOIN asistencia a ON s.id_sesion = a.id_sesion AND a.presente = true
    LEFT JOIN retroalimentacion r ON p.id_proyecto = r.id_proyecto
    LEFT JOIN costo_proyecto c ON p.id_proyecto = c.id_proyecto
    GROUP BY p.nombre
)
SELECT 
    proyecto,
    beneficiarios,
    ROUND(satisfaccion_promedio, 2) as satisfaccion_promedio,
    inversion_total,
    CASE 
        WHEN inversion_total > 0 THEN ROUND(beneficiarios * COALESCE(satisfaccion_promedio, 5) * 1000.0 / inversion_total, 2)
        ELSE NULL 
    END as indice_roi_social
FROM roi_data
ORDER BY indice_roi_social DESC NULLS LAST;

-- 9. Tendencia temporal de participación
SELECT 
    DATE_TRUNC('month', s.fecha) as mes,
    COUNT(DISTINCT p.id_proyecto) as proyectos_activos,
    COUNT(DISTINCT a.id_participante) as participantes_unicos,
    COUNT(DISTINCT s.id_sesion) as total_sesiones,
    SUM(CASE WHEN a.presente THEN 1 ELSE 0 END) as total_asistencias
FROM sesion s
JOIN proyecto_educativo p ON s.id_proyecto = p.id_proyecto
LEFT JOIN asistencia a ON s.id_sesion = a.id_sesion
GROUP BY DATE_TRUNC('month', s.fecha)
ORDER BY mes;

-- 10. Matriz de competencias desarrolladas por organización
SELECT 
    o.nombre as organizacion,
    COUNT(DISTINCT CASE WHEN p.area_conocimiento = 'Educación General' THEN p.id_proyecto END) as educacion_general,
    COUNT(DISTINCT CASE WHEN p.area_conocimiento = 'Idiomas' THEN p.id_proyecto END) as idiomas,
    COUNT(DISTINCT CASE WHEN p.area_conocimiento = 'Ciencias Sociales' THEN p.id_proyecto END) as ciencias_sociales,
    COUNT(DISTINCT CASE WHEN p.area_conocimiento = 'Medio Ambiente' THEN p.id_proyecto END) as medio_ambiente,
    COUNT(DISTINCT CASE WHEN p.area_conocimiento = 'Ciencias Naturales' THEN p.id_proyecto END) as ciencias_naturales,
    COUNT(DISTINCT p.id_proyecto) as total_proyectos
FROM organizacion o
LEFT JOIN proyecto_educativo p ON o.id_organizacion = p.id_organizacion
GROUP BY o.nombre;