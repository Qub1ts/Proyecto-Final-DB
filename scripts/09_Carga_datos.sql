-- =====================================================
-- SCRIPT 6: CARGA DE DATOS DE EJEMPLO
-- =====================================================

\c organizaciones_comunitarias;
SET search_path TO comunidad_educativa, public;

-- Insertar organizaciones
INSERT INTO organizacion (nombre, fecha_fundacion, tipo_constitucion, codigo_comportamiento) VALUES
('Escuela Pública Comunitaria Franklin', '2011-08-01', 'Organización autogestionada', 'Solidaridad, fraternidad, respeto, autocuidado colectivo y compromiso con la transformación social'),
('Bioescuela Aulaviva Puente Alto', '2019-03-15', 'Programa comunitario', 'Respeto por la naturaleza, trabajo colaborativo, cuidado del medio ambiente y aprendizaje experiencial'),
('Fundación Origen - Escuela Agroecológica de Pirque', '1991-03-01', 'Fundación Educacional', 'Respeto por la naturaleza, compromiso con la comunidad, desarrollo integral, agroecología'),
('Escuela Campesina Ismenia Ortiz Lizama', '2021-01-01', 'Iniciativa Comunitaria', 'Autonomía campesina, aprendizaje colectivo, trabajo territorial y respeto mutuo'),
('Escuela de Artes y Oficios', '2012-02-01', 'Corporación Cultural (sin fines de lucro)', 'Espacio de cuidado, aprendizaje horizontal, inclusión, no discriminación'),
('Hackerspace Santiago', '2023-08-22', 'Asociación comunitaria (hackerspace)', 'Cultura hacker: compartir, transparencia, libertad y no discriminación');

-- Insertar espacios
INSERT INTO espacio (direccion, tipo_tenencia, comuna, capacidad) VALUES
('Placer 530, esquina Berta Fernández', 'comodato', 'Santiago', 50),
('Mar Báltico Dos Oriente 1953', 'donado', 'Puente Alto', 30),
('Presidente Kennedy 5770, of 210', 'arrendado', 'Vitacura', 20),
('Av. Virginia Subercaseaux 2450, Pirque', 'propio', 'Pirque', 100),
('Fundo El Corazón #21, Palquibudis, Rauco', 'donado', 'Rauco', 60),
('Isabel Riquelme 6981',   'comodato',  'Lo Espejo', 100),
('Beaucheff 949',          'arrendado', 'Santiago',  30);

-- Insertar participantes (anonimizados)
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
('Participante_010', 27, 'Femenino', '2024-07-01', 'estudiante'),
('Estudiante_Origen_01', 17, 'Femenino', '2024-03-01', 'alumno'),
('Estudiante_Origen_02', 18, 'Masculino', '2024-03-01', 'alumno'),
('Estudiante_Origen_03', 16, 'Femenino', '2024-03-02', 'alumno'),
('Estudiante_Origen_04', 17, 'Masculino', '2024-03-02', 'alumno'),
('Estudiante_Origen_05', 18, 'Femenino', '2024-03-03', 'alumno'),
('Participante_Ismenia_01', 22, 'Femenino', '2024-04-10', 'campesino'),
('Participante_Ismenia_02', 34, 'Masculino', '2024-04-10', 'campesino'),
('Participante_Ismenia_03', 25, 'Femenino', '2024-04-11', 'campesino'),
('Participante_Ismenia_04', 28, 'Masculino', '2024-04-11', 'campesino'),
('Participante_Ismenia_05', 31, 'Femenino', '2024-04-12', 'campesino'),
('EAO_Participante_001', 14, 'Femenino',  '2024-03-02', 'alumno'),
('EAO_Participante_002', 19, 'Masculino', '2024-04-15', 'alumno'),
('EAO_Participante_003', 26, 'No binario','2024-05-20', 'alumno'),
('EAO_Participante_004', 33, 'Femenino',  '2023-11-05', 'alumno'),
('EAO_Participante_005', 47, 'Masculino', '2024-01-12', 'alumno'),
('EAO_Participante_006', 21, 'Femenino', '2024-02-20', 'alumno'),
('EAO_Participante_007', 30, 'Masculino', '2024-03-05', 'alumno'),
('EAO_Participante_008', 23, 'Femenino', '2024-04-01', 'alumno'),
('Hackerspace_Participante_001', 29, 'Femenino', '2024-02-01', 'miembro'),
('Hackerspace_Participante_002', 31, 'Masculino', '2024-02-15', 'miembro'),
('Hackerspace_Participante_003', 24, 'No binario', '2024-03-01', 'miembro'),
('Hackerspace_Participante_004', 36, 'Femenino', '2024-03-20', 'miembro'),
('Hackerspace_Participante_005', 28, 'Masculino', '2024-04-01', 'miembro'),
('Hackerspace_Participante_006', 33, 'Femenino', '2024-04-15', 'miembro'),
('Hackerspace_Participante_007', 27, 'Masculino', '2024-05-01', 'miembro'),
('Hackerspace_Participante_008', 22, 'Femenino', '2024-05-20', 'miembro');

-- Insertar formadores
INSERT INTO formador (nombre_anonimizado, especialidad, tipo_formador, anos_experiencia) VALUES
('Formador_001', 'Educación Popular', 'profesor', 10),
('Formador_002', 'Español para migrantes', 'profesor', 5),
('Formador_003', 'Educación Ambiental', 'guia', 7),
('Formador_004', 'Permacultura', 'facilitador', 8),
('Formador_005', 'Historia Latinoamericana', 'profesor', 12),
('Formador_006', 'Huerta Comunitaria', 'voluntario', 3),
('Formador_Origen_01', 'Agroecología', 'profesor', 10),
('Formador_Origen_02', 'Horticultura', 'facilitador', 8),
('Formador_Origen_03', 'Educación Ambiental', 'profesor', 12),
('Formador_Ismenia_01', 'Agricultura Campesina', 'facilitador', 5),
('Formador_Ismenia_02', 'Semillas Tradicionales', 'facilitador', 6),
('Formador_Ismenia_03', 'Soberanía Alimentaria', 'facilitador', 7),
('Formador_EAO_01', 'Artes y Oficios', 'profesor', 15),
('Formador_EAO_02', 'Cocina Popular', 'profesor', 10),
('Formador_EAO_03', 'Carpintería', 'profesor', 8),
('Formador_EAO_04', 'Cerámica', 'profesor', 6),
('Formador_EAO_05', 'Teatro Comunitario', 'profesor', 12),
('Formador_Hackerspace_01', 'Programación y Hardware Libre', 'técnico', 3),
('Formador_Hackerspace_02', 'Diseño Digital', 'técnico', 4),
('Formador_Hackerspace_03', 'Robótica Educativa', 'técnico', 5),
('Formador_Hackerspace_04', 'Python y Data Science', 'técnico', 2),
('Formador_Hackerspace_05', 'Electrónica Básica', 'técnico', 6);

-- Insertar proyectos educativos
INSERT INTO proyecto_educativo (id_organizacion, nombre, tipo_proyecto, area_conocimiento, numero_sesiones, duracion_sesion_minutos, fecha_inicio, fecha_fin, estado, propuesto_por_estudiante) VALUES
(1, 'Nivelación de Estudios Básicos', 'curso', 'Educación General', 30, 120, '2024-03-01', '2024-06-30', 'completado', false),
(1, 'Español para Comunidad Migrante', 'taller', 'Idiomas', 20, 90, '2024-04-01', '2024-07-15', 'en_progreso', false),
(1, 'Historia y Memoria Latinoamericana', 'seminario', 'Ciencias Sociales', 8, 150, '2024-05-01', '2024-06-20', 'completado', false),
(2, 'Huerta Escolar Comunitaria', 'taller', 'Medio Ambiente', 15, 60, '2024-03-15', '2024-07-30', 'en_progreso', false),
(2, 'Reciclaje y Compostaje', 'taller', 'Medio Ambiente', 10, 90, '2024-04-01', '2024-06-15', 'completado', false),
(2, 'Biodiversidad Local', 'curso', 'Ciencias Naturales', 12, 60, '2024-05-01', '2024-07-20', 'en_progreso', false),
(3, 'Taller de Agroecología Escolar', 'taller', 'Ciencias Naturales', 6, 90, '2024-04-01', '2024-05-15', 'completado', false),
(3, 'Curso de Compostaje y Permacultura', 'curso', 'Medio Ambiente', 4, 120, '2024-06-01', '2024-07-01', 'en_progreso', false),
(4, 'Diplomado en Agricultura Regenerativa', 'curso', 'Desarrollo Rural', 8, 120, '2024-05-01', '2024-06-30', 'en_progreso', false),
(4, 'Taller de Soberanía Alimentaria', 'taller', 'Educación Popular', 5, 90, '2024-07-05', '2024-08-10', 'planificado', true),
(5, 'Taller de Artes y Oficios', 'taller', 'Artes y Cultura', 10, 90, '2024-03-01', '2024-05-15', 'en_progreso', false),
(5, 'Curso de Cocina Popular', 'curso', 'Gastronomía', 8, 120, '2024-04-01', '2024-06-30', 'completado', false),
(5, 'Taller de Carpintería Comunitaria', 'taller', 'Artesanía', 6, 90, '2024-05-01', '2024-07-15', 'en_progreso', false),
(6, 'Curso de Programación Básica', 'curso', 'Tecnología', 10, 120, '2024-02-01', '2024-04-30', 'en_progreso', false),
(6, 'Taller de Electrónica para Niños y Niñas', 'taller', 'Tecnología', 8, 90, '2024-02-15', '2024-04-15', 'completado', false),
(6, 'Hackerspace: Programación y Hardware Libre', 'taller', 'Tecnología', 12, 90, '2024-02-01', '2024-04-30', 'en_progreso', false),
(6, 'Robótica Educativa para Niños y Niñas', 'taller', 'Tecnología', 10, 120, '2024-03-01', '2024-05-15', 'completado', false);

-- Insertar sesiones
INSERT INTO sesion (id_proyecto, id_espacio, numero_sesion, fecha, hora_inicio, duracion_real, etapa) VALUES
(1, 1, 1, '2024-03-01', '19:00', 115, 'ejecucion'),
(1, 1, 2, '2024-03-04', '19:00', 120, 'ejecucion'),
(1, 1, 3, '2024-03-06', '19:00', 125, 'ejecucion'),
(1, 1, 4, '2024-03-08', '19:00', 110, 'ejecucion'),
(4, 2, 1, '2024-03-15', '10:00', 65, 'ejecucion'),
(4, 2, 2, '2024-03-22', '10:00', 60, 'ejecucion'),
(4, 2, 3, '2024-03-29', '10:00', 70, 'ejecucion'),
(7, 4, 1, '2024-04-01', '09:00', 90, 'ejecucion'),
(7, 4, 2, '2024-04-08', '09:00', 95, 'ejecucion'),
(8, 4, 1, '2024-06-01', '09:00', 120, 'ejecucion'),
(9, 5, 1, '2024-05-01', '10:00', 120, 'ejecucion'),
(9, 5, 2, '2024-05-08', '10:00', 110, 'ejecucion'),
(11, 6, 1, '2024-03-01', '18:00', 90, 'ejecucion'),
(11, 6, 2, '2024-03-08', '18:00', 95, 'ejecucion'),
(12, 6, 1, '2024-04-01', '17:00', 120, 'ejecucion'),
(13, 6, 1, '2024-05-01', '18:00', 90, 'ejecucion'),
(14, 7, 1, '2024-02-01', '19:00', 120, 'ejecucion'),
(15, 7, 1, '2024-02-15', '19:00', 90, 'ejecucion'),
(16, 7, 1, '2024-02-01', '19:00', 90, 'ejecucion'),
(17, 7, 1, '2024-03-01', '19:00', 120, 'ejecucion');

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
(6, 7, false, NULL),
(9, 3, true, '10:00'),
(9, 4, true, '10:10'),
(10, 3, true, '10:00'),
(10, 4, true, '10:05'),
(13, 21, true, '18:05'),
(13, 22, true, '18:00'),
(13, 23, false, NULL),
(13, 24, true, '18:10'),
(13, 25, true, '18:00'),
(17, 29, true, '19:00'),
(17, 30, true, '19:05'),
(17, 31, true, '19:10'),
(17, 32, false, NULL),
(17, 33, true, '19:00');

-- Insertar formadores en proyectos
INSERT INTO formador_proyecto (id_formador, id_proyecto, rol, horas_dedicadas) VALUES
(1, 1, 'Profesor Principal', 65.5),
(2, 2, 'Profesor Principal', 32.0),
(5, 3, 'Facilitador', 24.0),
(3, 4, 'Guía Principal', 18.0),
(4, 4, 'Apoyo Técnico', 12.0),
(3, 5, 'Profesor Principal', 16.0),
(6, 6, 'Facilitador', 14.0),
(7, 7, 'Docente Agroecología', 12.0),
(8, 7, 'Apoyo en campo', 8.0),
(9, 8, 'Coordinador pedagógico', 10.0),
(10, 9, 'Facilitador principal', 16.0),
(11, 9, 'Tallerista de semillas', 10.0),
(12, 10, 'Formador responsable', 12.0),
(13, 11, 'Profesor Principal', 20.0),
(14, 12, 'Profesor Principal', 16.0),
(15, 13, 'Profesor Principal', 12.0),
(16, 14, 'Técnico Principal', 18.0),
(17, 15, 'Técnico Principal', 14.0),
(18, 16, 'Técnico Principal', 20.0),
(19, 17, 'Técnico Principal', 15.0);

-- Insertar documentación
INSERT INTO documentacion (id_sesion, tipo_documento, tamano_mb, licencia, url_anonimizada, descripcion, fecha_creacion) VALUES
(1, 'texto', 2.5, 'Creative Commons', '/docs/sesion1_material.pdf', 'Material didáctico sesión 1', '2024-03-01'),
(1, 'presentacion', 15.3, 'Copyleft', '/docs/sesion1_slides.pptx', 'Presentación introductoria', '2024-03-01'),
(2, 'video', 250.0, 'Creative Commons', '/videos/sesion2_clase.mp4', 'Grabación de la clase', '2024-03-04'),
(5, 'imagen', 8.2, 'Dominio Publico', '/imgs/huerta_inicio.jpg', 'Fotos del inicio de la huerta', '2024-03-15'),
(7, 'texto', 1.2, 'Creative Commons', '/docs/origen_s1.pdf', 'Guía de prácticas agroecológicas', '2024-04-01'),
(8, 'video', 12.5, 'Dominio Publico', '/docs/origen_s2.mp4', 'Documentación audiovisual del taller', '2024-04-08'),
(9, 'presentacion', 4.5, 'Dominio Publico', '/docs/ismenia_s1.pptx', 'Presentación introductoria al diplomado', '2024-05-01'),
(10, 'texto', 0.8, 'Creative Commons', '/docs/ismenia_s2.pdf', 'Manual básico de cultivos campesinos', '2024-05-08'),
(13, 'texto', 1.5, 'Creative Commons', '/docs/eao_sesion1.pdf', 'Guía de taller de artes y oficios', '2024-03-01'),
(17, 'video', 200.0, 'Copyleft', '/videos/hackerspace_sesion1.mp4', 'Grabación de clase de robótica', '2024-03-01');

-- Insertar retroalimentación
INSERT INTO retroalimentacion (id_proyecto, id_participante, calificacion_numerica, calificacion_cualitativa, comentarios) VALUES
(1, 1, 9, 'muy bueno', 'Excelente metodología, muy clara la explicación'),
(1, 2, 8, 'bueno', 'Buen ritmo de clases, me gustaría más ejercicios prácticos'),
(1, 4, 10, 'excelente', 'Superó mis expectativas, profesores muy comprometidos'),
(4, 6, 9, 'muy bueno', 'Me encanta aprender sobre plantas y naturaleza'),
(4, 7, 8, 'bueno', 'Divertido pero a veces hace mucho calor'),
(7, 1, 9, 'muy bueno', 'Muy interesante el enfoque práctico.'),
(7, 2, 10, 'excelente', 'Aprendí mucho en poco tiempo.'),
(9, 3, 8, 'bueno', 'Contenido útil y bien explicado.'),
(7, 3, 9, 'muy bueno', 'Me gustó el trabajo en terreno.'),
(9, 4, 8, 'bueno', 'Me gustaría que el contenido fuera más profundo.'),
(9, 5, 9, 'muy bueno', 'Excelente facilitador.'),
(10, 6, 10, 'excelente', 'Motivador y claro en sus ideas.'),
(11, 21, 9, 'muy bueno', 'Me gustó el enfoque práctico'),
(12, 22, 8, 'bueno', 'Aprendí nuevas recetas populares'),
(14, 29, 10, 'excelente', 'Muy motivador y didáctico'),
(17, 33, 9, 'muy bueno', 'Me gustaría más clases de robótica');

-- Insertar costos
INSERT INTO costo_proyecto (id_proyecto, tipo_costo, monto, descripcion) VALUES
(1, 'materiales', 45000, 'Fotocopias y materiales didácticos'),
(1, 'transporte', 20000, 'Movilización profesores'),
(1, 'preparacion', 80000, 'Horas de preparación de clases'),
(4, 'materiales', 35000, 'Semillas, tierra y herramientas'),
(4, 'ejecucion', 60000, 'Pago facilitadores'),
(7, 'materiales', 30000, 'Fotocopias y compost'),
(7, 'transporte', 15000, 'Movilización e insumos'),
(9, 'ejecucion', 50000, 'Honorarios facilitador'),
(9, 'preparacion', 20000, 'Habilitación de espacios'),
(10, 'materiales', 25000, 'Manual impreso, semillas'),
(11, 'materiales', 20000, 'Materiales para taller de artes'),
(12, 'ejecucion', 15000, 'Honorarios profesor cocina'),
(14, 'materiales', 30000, 'Componentes electrónicos'),
(17, 'ejecucion', 25000, 'Pago facilitador robótica');

-- Insertar métodos de participación
INSERT INTO metodo_participacion (id_proyecto, nombre_metodo, descripcion, efectividad_percibida) VALUES
(1, 'Recordatorio WhatsApp', 'Mensajes grupales día anterior a la clase', 8),
(1, 'Círculo de inicio', 'Compartir experiencias al comenzar cada sesión', 9),
(4, 'Registro de crecimiento', 'Cada niño documenta el crecimiento de sus plantas', 9),
(7, 'Diálogo al inicio', 'Se inicia con círculo de reflexión en cada sesión', 9),
(7, 'Huerta comunitaria', 'Trabajo práctico grupal en huerto', 10),
(9, 'Registro visual', 'Participantes documentan con fotos y dibujos', 8),
(9, 'Bitácora de aprendizajes', 'Cada estudiante completa una bitácora personal', 9),
(10, 'Autoevaluación', 'Participantes reflexionan al final de cada sesión', 8),
(11, 'Taller práctico', 'Aprendizaje basado en proyectos manuales', 9),
(14, 'Laboratorio abierto', 'Sesiones libres para experimentar con hardware', 10);

-- Insertar colaboraciones
INSERT INTO colaboracion (id_organizacion, nombre_entidad, tipo_colaboracion, fecha_inicio) VALUES
(1, 'Universidad Metropolitana de Ciencias de la Educación', 'Apoyo académico', '2023-03-01'),
(1, 'Coordinadora Territorial Barrio Franklin', 'Colaboración territorial', '2022-08-15'),
(2, 'Ministerio del Medio Ambiente', 'Financiamiento', '2024-01-15'),
(2, 'Vicaría Pastoral Santiago', 'Apoyo logístico', '2023-09-01'),
(3, 'Red de Escuelas Agroecológicas de Chile', 'Intercambio pedagógico', '2022-06-01'),
(3, 'Municipalidad de Pirque', 'Apoyo en infraestructura', '2023-03-15'),
(4, 'Red de Semillas Libres del Maule', 'Colaboración técnica', '2024-04-10'),
(4, 'Red de Educación Popular Rural', 'Apoyo curricular', '2024-03-01'),
(5, 'Fundación Víctor Jara',          'Cultura y memoria',            '2023-04-10'),
(5, 'Municipalidad de Lo Espejo',     'Infraestructura y logística',  '2013-05-15'),
(5, 'IberCultura Viva',               'Red internacional',            '2017-08-20'),
(5, 'SERVIU Región Metropolitana',    'Comodato inmueble',            '2013-01-15'),
(6, 'Universidad de Santiago', 'Mentoría tecnológica', '2024-03-01'),
(6, 'PyCon Chile',                    'Divulgación y networking',     '2024-10-25'),
(6, 'FLISoL Santiago',                'Eventos software libre',       '2025-04-27'),
(6, 'Universidad de Chile – DIINF',   'Acceso a laboratorios',        '2024-12-01');
