#!/bin/bash
# Script para ejecutar todos los scripts SQL en orden

echo "=========================================="
echo "Instalación de Base de Datos Comunitaria"
echo "=========================================="

# Variables
DB_HOST="localhost"
DB_PORT="5432"
SUPERUSER="qub1ts"

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Función para ejecutar scripts
ejecutar_script() {
    local script=$1
    local usuario=$2
    local db=$3
    
    echo -e "\n${GREEN}Ejecutando: $script${NC}"
    
    if [ -z "$db" ]; then
        psql -h "$DB_HOST" -p "$DB_PORT" -U "$usuario" -f "$script"
    else
        psql -h "$DB_HOST" -p "$DB_PORT" -U "$usuario" -d "$db" -f "$script"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Completado${NC}"
    else
        echo -e "${RED}✗ Error al ejecutar $script${NC}"
        exit 1
    fi
}

# Verificar que PostgreSQL esté corriendo
echo "Verificando conexión a PostgreSQL..."
psql -h "$DB_HOST" -p "$DB_PORT" -U "$SUPERUSER" -c "SELECT version();" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: No se puede conectar a PostgreSQL${NC}"
    echo "Asegúrate de que PostgreSQL esté corriendo y puedas acceder como $SUPERUSER"
    exit 1
fi

# Ejecutar scripts en orden
echo -e "\n${GREEN}Iniciando instalación...${NC}"

ejecutar_script "scripts/01_Creacion_roles.sql" "$SUPERUSER"
ejecutar_script "scripts/02_Creacion_database.sql" "$SUPERUSER"
ejecutar_script "scripts/03_Creacion_schema.sql" "sistema_comunitario_admin" "organizaciones_comunitarias"
ejecutar_script "scripts/04_creacion_tablas.sql" "sistema_comunitario_admin" "organizaciones_comunitarias"
ejecutar_script "scripts/05_creacion_indices.sql" "sistema_comunitario_admin" "organizaciones_comunitarias"
ejecutar_script "scripts/06_Auxiliar_tiempo.sql" "sistema_comunitario_admin" "organizaciones_comunitarias"
ejecutar_script "scripts/07_Vistas_utiles.sql" "sistema_comunitario_admin" "organizaciones_comunitarias"
ejecutar_script "scripts/08_Permisos.sql" "sistema_comunitario_admin" "organizaciones_comunitarias"
ejecutar_script "scripts/10_Procedimiento.sql" "sistema_comunitario_admin" "organizaciones_comunitarias"
ejecutar_script "scripts/11_Consultas.sql" "sistema_comunitario_admin" "organizaciones_comunitarias"
ejecutar_script "scripts/12_Consultas_adicionales.sql" "sistema_comunitario_admin" "organizaciones_comunitarias"

# Preguntar si cargar datos de ejemplo
echo -e "\n¿Desea cargar los datos de ejemplo? (s/n)"
read -r respuesta
if [[ "$respuesta" =~ ^[Ss]$ ]]; then
    ejecutar_script "scripts/09_Carga_datos.sql" "sistema_comunitario_admin" "organizaciones_comunitarias"
fi

echo -e "\n${GREEN}=========================================="
echo "¡Instalación completada exitosamente!"
echo "==========================================${NC}"
echo ""
echo "Base de datos: organizaciones_comunitarias"
echo "Usuario admin: sistema_comunitario_admin"
echo "Contraseña: C0mun1d@d2025"
echo ""
echo "Para conectarte:"
echo "psql -h localhost -U sistema_comunitario_admin -d organizaciones_comunitarias"