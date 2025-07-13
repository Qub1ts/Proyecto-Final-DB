-- =====================================================
-- SCRIPT 6: CARGA DE DATOS DE EJEMPLO
-- =====================================================

\c organizaciones_comunitarias;
SET search_path TO comunidad_educativa, public;

-- Insertar organizaciones
INSERT INTO organizacion (nombre, fecha_fundacion, tipo_constitucion, codigo_comportamiento) VALUES
('Escuela Pública Comunitaria Franklin', '2011-08-01', 'Organización autogestionada', 'Solidaridad, fraternidad, respeto, autocuidado colectivo y compromiso con la transformación social'),
('Bioescuela Aulaviva Puente Alto', '2019-03-15', 'Programa comunitario', 'Respeto por la naturaleza, trabajo colaborativo, cuidado del medio ambiente y aprendizaje experiencial');

-- Insertar espacios
INSERT INTO espacio (direccion, tipo_tenencia, comuna, capacidad) VALUES
('Placer 530, esquina Berta Fernández', 'comodato', 'Santiago', 50),
('Mar Báltico Dos Oriente 1953', 'donado', 'Puente Alto', 30),
('Presidente Kennedy 5770, of 210', 'arrendado', 'Vitacura', 20);

-- Insertar participantes (datos anonimizados)
INSERT INTO participante (nombre_anonimizado, edad, genero, fecha_ingreso, tipo_participante) VALUES
('Participante_001', 25, 'Femenino', '2024-03-01', 'estudiante'),
('Participante_002', 32, 'Masculino', '2024-03-15', 'estudiante'),
('Participante_003', 28, 'No binario', '2024-04-01', 'estudiante'),
('Participante_004', 45, 'Femenino', '2024-04-10', 'estudiante'),
('Participante_005', 19, 'Masculino', '2024-05-01', 'estudiante'),
('Participante_006', 8, 'Femenino', '2024-03-20', 'estudiante'),
('Participante_007', 10, 'Masculino', '2024-03-20', 'estudiante'),
('Participante_008', 35, 'Femenino', '2024-06-01', 'estudiante'),
('Participante_009', 42, 'Masculino', '2024-06-15', 'estudiante'),
('Participante_010', 27, 'Femenino', '2024-07-01', 'estudiante');

-- Insertar formadores
INSERT INTO formador (nombre_anonimizado, especialidad, tipo_formador, anos_experiencia) VALUES
('Formador_001', 'Educación Popular', 'profesor', 10),
('Formador_002', 'Español para migrantes', 'profesor', 5),
('Formador_003', 'Educación Ambiental', 'guia', 7),
('Formador_004', 'Permacultura', 'facilitador', 8),
('Formador_005', 'Historia Latinoamericana', 'profesor', 12),
('Formador_006', 'Huerta Comunitaria', 'voluntario', 3);

-- Insertar proyectos educativos
INSERT INTO proyecto_educativo (id_organizacion, nombre, tipo_proyecto, area_conocimiento, numero_sesiones, duracion_sesion_minutos, fecha_inicio, fecha_fin, estado) VALUES
(1, 'Nivelación de Estudios Básicos', 'curso', 'Educación General', 30, 120, '2024-03-01', '2024-06-30', 'completado'),
(1, 'Español para Comunidad Migrante', 'taller', 'Idiomas', 20, 90, '2024-04-01', '2024-07-15', 'en_progreso'),
(1, 'Historia y Memoria Latinoamericana', 'seminario', 'Ciencias Sociales', 8, 150, '2024-05-01', '2024-06-20', 'completado'),
(2, 'Huerta Escolar Comunitaria', 'taller', 'Medio Ambiente', 15, 60, '2024-03-15', '2024-07-30', 'en_progreso'),
(2, 'Reciclaje y Compostaje', 'taller', 'Medio Ambiente', 10, 90, '2024-04-01', '2024-06-15', 'completado'),
(2, 'Biodiversidad Local', 'curso', 'Ciencias Naturales', 12, 60, '2024-05-01', '2024-07-20', 'en_progreso');

-- Insertar sesiones
INSERT INTO sesion (id_proyecto, id_espacio, numero_sesion, fecha, hora_inicio, duracion_real, etapa) VALUES
-- Sesiones del proyecto 1 (Nivelación)
(1, 1, 1, '2024-03-01', '19:00', 115, 'ejecucion'),
(1, 1, 2, '2024-03-04', '19:00', 120, 'ejecucion'),
(1, 1, 3, '2024-03-06', '19:00', 125, 'ejecucion'),
(1, 1, 4, '2024-03-08', '19:00', 110, 'ejecucion'),
-- Sesiones del proyecto 4 (Huerta)
(4, 2, 1, '2024-03-15', '10:00', 65, 'ejecucion'),
(4, 2, 2, '2024-03-22', '10:00', 60, 'ejecucion'),
(4, 2, 3, '2024-03-29', '10:00', 70, 'ejecucion');

-- Insertar asistencias
INSERT INTO asistencia (id_sesion, id_participante, presente, hora_llegada) VALUES
(1, 1, true, '19:05'),
(1, 2, true, '19:00'),
(1, 3, false, NULL),
(1, 4, true, '19:15'),
(2, 1, true, '19:00'),
(2, 2, true, '19:10'),
(2, 3, true, '19:00'),
(2, 4, false, NULL),
(5, 6, true, '10:00'),
(5, 7, true, '10:05'),
(6, 6, true, '10:00'),
(6, 7, false, NULL);

-- Insertar formadores en proyectos
INSERT INTO formador_proyecto (id_formador, id_proyecto, rol, horas_dedicadas) VALUES
(1, 1, 'Profesor Principal', 65.5),
(2, 2, 'Profesor Principal', 32.0),
(5, 3, 'Facilitador', 24.0),
(3, 4, 'Guía Principal', 18.0),
(4, 4, 'Apoyo Técnico', 12.0),
(3, 5, 'Profesor Principal', 16.0),
(6, 6, 'Facilitador', 14.0);

-- Insertar documentación
INSERT INTO documentacion (id_sesion, tipo_documento, tamano_mb, licencia, url_anonimizada, descripcion, fecha_creacion) VALUES
(1, 'texto', 2.5, 'Creative Commons', '/docs/sesion1_material.pdf', 'Material didáctico sesión 1', '2024-03-01'),
(1, 'presentacion', 15.3, 'Copyleft', '/docs/sesion1_slides.pptx', 'Presentación introductoria', '2024-03-01'),
(2, 'video', 250.0, 'Creative Commons', '/videos/sesion2_clase.mp4', 'Grabación de la clase', '2024-03-04'),
(5, 'imagen', 8.2, 'Dominio Publico', '/imgs/huerta_inicio.jpg', 'Fotos del inicio de la huerta', '2024-03-15');

-- Insertar retroalimentación
INSERT INTO retroalimentacion (id_proyecto, id_participante, calificacion_numerica, calificacion_cualitativa, comentarios) VALUES
(1, 1, 9, 'muy bueno', 'Excelente metodología, muy clara la explicación'),
(1, 2, 8, 'bueno', 'Buen ritmo de clases, me gustaría más ejercicios prácticos'),
(1, 4, 10, 'excelente', 'Superó mis expectativas, profesores muy comprometidos'),
(4, 6, 9, 'muy bueno', 'Me encanta aprender sobre plantas y naturaleza'),
(4, 7, 8, 'bueno', 'Divertido pero a veces hace mucho calor');

-- Insertar costos
INSERT INTO costo_proyecto (id_proyecto, tipo_costo, monto, descripcion) VALUES
(1, 'materiales', 45000, 'Fotocopias y materiales didácticos'),
(1, 'transporte', 20000, 'Movilización profesores'),
(1, 'preparacion', 80000, 'Horas de preparación de clases'),
(4, 'materiales', 35000, 'Semillas, tierra y herramientas'),
(4, 'ejecucion', 60000, 'Pago facilitadores');

-- Insertar métodos de participación
INSERT INTO metodo_participacion (id_proyecto, nombre_metodo, descripcion, efectividad_percibida) VALUES
(1, 'Recordatorio WhatsApp', 'Mensajes grupales día anterior a la clase', 8),
(1, 'Círculo de inicio', 'Compartir experiencias al comenzar cada sesión', 9),
(4, 'Registro de crecimiento', 'Cada niño documenta el crecimiento de sus plantas', 9);

-- Insertar colaboraciones
INSERT INTO colaboracion (id_organizacion, nombre_entidad, tipo_colaboracion, fecha_inicio) VALUES
(1, 'Universidad Metropolitana de Ciencias de la Educación', 'Apoyo académico', '2023-03-01'),
(1, 'Coordinadora Territorial Barrio Franklin', 'Colaboración territorial', '2022-08-15'),
(2, 'Ministerio del Medio Ambiente', 'Financiamiento', '2024-01-15'),
(2, 'Vicaría Pastoral Santiago', 'Apoyo logístico', '2023-09-01');