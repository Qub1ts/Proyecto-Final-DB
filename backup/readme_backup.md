-- Script para realizar backup (ejecutar desde línea de comandos)
-- pg_dump -U sistema_comunitario_admin -h localhost -d organizaciones_comunitarias -F c -b -v -f backup_organizaciones_$(date +%Y%m%d_%H%M%S).backup

-- Script para restaurar backup
-- pg_restore -U sistema_comunitario_admin -h localhost -d organizaciones_comunitarias -v backup_organizaciones_YYYYMMDD_HHMMSS.backup

-- Backup solo del esquema
-- pg_dump -U sistema_comunitario_admin -h localhost -d organizaciones_comunitarias -s -F p -f schema_backup_$(date +%Y%m%d).sql

-- Backup solo de datos
-- pg_dump -U sistema_comunitario_admin -h localhost -d organizaciones_comunitarias -a -F p -f data_backup_$(date +%Y%m%d).sql
