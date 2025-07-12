-- =====================================================
-- SCRIPT 1: CREACIÓN DE USUARIOS Y ROLES
-- Proyecto: Sistema de Gestión de Organizaciones Comunitarias
-- Autores: Julio Lucero, Benjamin Oyarzun, Christian 
-- Fecha: Julio 2025
-- =====================================================

-- Crear rol principal para la aplicación
CREATE ROLE sistema_comunitario_admin WITH 
    LOGIN 
    PASSWORD 'C0mun1d@d2025'
    CREATEDB
    CREATEROLE;

-- Crear rol para lectura (consultas/reportes)
CREATE ROLE sistema_comunitario_read WITH 
    LOGIN 
    PASSWORD 'L3ctur@2025';

-- Crear rol para operaciones básicas
CREATE ROLE sistema_comunitario_user WITH 
    LOGIN 
    PASSWORD 'Us3r2025';


    










