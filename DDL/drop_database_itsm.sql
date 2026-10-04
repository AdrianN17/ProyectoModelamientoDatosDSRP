-- ============================================================
-- SCRIPT DE ELIMINACION
-- Borra las tablas (y sus datos) en orden inverso a las claves foraneas
-- ============================================================
DROP TABLE IF EXISTS modelado.Transicion;
DROP TABLE IF EXISTS modelado.Comentario;
DROP TABLE IF EXISTS modelado.Ticket;
DROP TABLE IF EXISTS modelado.EstadoTransicion;
DROP TABLE IF EXISTS modelado.Servicio;
DROP TABLE IF EXISTS modelado.TipoTicket;
DROP TABLE IF EXISTS modelado.Prioridad;
DROP TABLE IF EXISTS modelado.Categoria;
DROP TABLE IF EXISTS modelado.Usuario;
DROP TABLE IF EXISTS modelado.Equipo;
DROP TABLE IF EXISTS modelado.Rol;
DROP SCHEMA IF EXISTS modelado;
GO
