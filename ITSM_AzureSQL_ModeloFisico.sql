-- ============================================================
-- 0. SCHEMA: modelado
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'modelado')
    EXEC('CREATE SCHEMA modelado');
GO

-- ============================================================
-- 1. TABLA: Rol
-- ============================================================
CREATE TABLE modelado.Rol
(
    id_rol INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    estado INT NULL,

    CONSTRAINT PK_Rol PRIMARY KEY (id_rol),
    CONSTRAINT UQ_Rol_nombre UNIQUE (nombre),
    CONSTRAINT CK_Rol_estado CHECK (estado IN (0, 1)) -- 1 = Activo, 0 = Inactivo
);
GO

-- ============================================================
-- 2. TABLA: Equipo
-- ============================================================
CREATE TABLE modelado.Equipo
(
    id_equipo INT NOT NULL,
    descripcion VARCHAR(20) NULL,
    estado INT NULL,

    CONSTRAINT PK_Equipo PRIMARY KEY (id_equipo),
    CONSTRAINT CK_Equipo_estado CHECK (estado IN (0, 1))
);
GO

-- ============================================================
-- 3. TABLA: Usuario
-- ============================================================
CREATE TABLE modelado.Usuario
(
    id_usuario INT NOT NULL,
    codigo_usuario VARCHAR(10) NULL,
    nombre VARCHAR(100) NULL,
    apellido VARCHAR(100) NULL,
    correo VARCHAR(100) NULL,
    telefono VARCHAR(11) NULL,
    id_rol INT NULL,
    estado INT NULL,
    cod_asignatario VARCHAR(10) NULL,
    id_equipo INT NULL,

    CONSTRAINT PK_Usuario PRIMARY KEY (id_usuario),
    CONSTRAINT CK_Usuario_estado CHECK (estado IN (0, 1)),

    CONSTRAINT FK_Usuario_Rol
        FOREIGN KEY (id_rol)
        REFERENCES modelado.Rol (id_rol),

    CONSTRAINT FK_Usuario_Equipo
        FOREIGN KEY (id_equipo)
        REFERENCES modelado.Equipo (id_equipo)
);
GO

-- ============================================================
-- 4. TABLA: Categoria
-- ============================================================
CREATE TABLE modelado.Categoria
(
    id_categoria INT NOT NULL,
    descripcion VARCHAR(20) NULL,
    estado INT NULL,

    CONSTRAINT PK_Categoria PRIMARY KEY (id_categoria),
    CONSTRAINT CK_Categoria_estado CHECK (estado IN (0, 1))
);
GO

-- ============================================================
-- 5. TABLA: Prioridad
-- ============================================================
CREATE TABLE modelado.Prioridad
(
    id_prioridad INT NOT NULL,
    descripcion VARCHAR(20) NULL,
    estado INT NULL,

    CONSTRAINT PK_Prioridad PRIMARY KEY (id_prioridad),
    CONSTRAINT CK_Prioridad_estado CHECK (estado IN (0, 1))
);
GO

-- ============================================================
-- 6. TABLA: TipoTicket
-- ============================================================
CREATE TABLE modelado.TipoTicket
(
    id_tipo_ticket INT NOT NULL,
    descripcion VARCHAR(20) NULL,
    estado INT NULL,

    CONSTRAINT PK_TipoTicket PRIMARY KEY (id_tipo_ticket),
    CONSTRAINT CK_TipoTicket_estado CHECK (estado IN (0, 1))
);
GO

-- ============================================================
-- 7. TABLA: Servicio
-- ============================================================
CREATE TABLE modelado.Servicio
(
    id_servicio INT NOT NULL,
    descripcion VARCHAR(20) NULL,
    id_equipo INT NULL,
    estado INT NULL,

    CONSTRAINT PK_Servicio PRIMARY KEY (id_servicio),
    CONSTRAINT CK_Servicio_estado CHECK (estado IN (0, 1)),

    CONSTRAINT FK_Servicio_Equipo
        FOREIGN KEY (id_equipo)
        REFERENCES modelado.Equipo (id_equipo)
);
GO

-- ============================================================
-- 8. TABLA: EstadoTransicion
-- ============================================================
CREATE TABLE modelado.EstadoTransicion
(
    id_estado_transicion INT NOT NULL,
    descripcion VARCHAR(20) NULL,
    estado INT NULL,

    CONSTRAINT PK_EstadoTransicion PRIMARY KEY (id_estado_transicion),
    CONSTRAINT CK_EstadoTransicion_estado CHECK (estado IN (0, 1))
);
GO

-- ============================================================
-- 9. TABLA: Ticket
-- ============================================================
CREATE TABLE modelado.Ticket
(
    id_ticket INT NOT NULL,
    codigo_ticket VARCHAR(10) NULL,
    id_prioridad INT NULL,
    fecha DATETIME NULL,
    estado INT NULL,
    id_usuario INT NULL,
    id_equipo INT NULL,
    id_asignatario INT NULL,
    id_categoria INT NULL,
    id_servicio INT NULL,
    id_tipo INT NULL,

    CONSTRAINT PK_Ticket PRIMARY KEY (id_ticket),
    CONSTRAINT CK_Ticket_estado CHECK (estado IN (0, 1)),

    CONSTRAINT FK_Ticket_Prioridad
        FOREIGN KEY (id_prioridad)
        REFERENCES modelado.Prioridad (id_prioridad),

    CONSTRAINT FK_Ticket_Usuario
        FOREIGN KEY (id_usuario)
        REFERENCES modelado.Usuario (id_usuario),

    CONSTRAINT FK_Ticket_Equipo
        FOREIGN KEY (id_equipo)
        REFERENCES modelado.Equipo (id_equipo),

    CONSTRAINT FK_Ticket_Asignatario
        FOREIGN KEY (id_asignatario)
        REFERENCES modelado.Usuario (id_usuario),

    CONSTRAINT FK_Ticket_Categoria
        FOREIGN KEY (id_categoria)
        REFERENCES modelado.Categoria (id_categoria),

    CONSTRAINT FK_Ticket_Servicio
        FOREIGN KEY (id_servicio)
        REFERENCES modelado.Servicio (id_servicio),

    CONSTRAINT FK_Ticket_TipoTicket
        FOREIGN KEY (id_tipo)
        REFERENCES modelado.TipoTicket (id_tipo_ticket)
);
GO

-- ============================================================
-- 10. TABLA: Comentario
-- ============================================================
CREATE TABLE modelado.Comentario
(
    id_comentario INT NOT NULL,
    texto TEXT NULL,
    id_usuario INT NULL,
    id_ticket INT NULL,
    estado INT NULL,

    CONSTRAINT PK_Comentario PRIMARY KEY (id_comentario),
    CONSTRAINT CK_Comentario_estado CHECK (estado IN (0, 1)),

    CONSTRAINT FK_Comentario_Usuario
        FOREIGN KEY (id_usuario)
        REFERENCES modelado.Usuario (id_usuario),

    CONSTRAINT FK_Comentario_Ticket
        FOREIGN KEY (id_ticket)
        REFERENCES modelado.Ticket (id_ticket)
);
GO

-- ============================================================
-- 11. TABLA: Transicion
-- ============================================================
CREATE TABLE modelado.Transicion
(
    id_transicion INT NOT NULL,
    id_usuario INT NULL,
    id_ticket INT NULL,
    fecha DATETIME NULL,
    id_transicion_antes INT NULL,
    id_transicion_despues INT NULL,
    estado INT NULL,

    CONSTRAINT PK_Transicion PRIMARY KEY (id_transicion),
    CONSTRAINT CK_Transicion_estado CHECK (estado IN (0, 1)),

    CONSTRAINT FK_Transicion_Usuario
        FOREIGN KEY (id_usuario)
        REFERENCES modelado.Usuario (id_usuario),

    CONSTRAINT FK_Transicion_Ticket
        FOREIGN KEY (id_ticket)
        REFERENCES modelado.Ticket (id_ticket),

    -- Según el diagrama, ambos campos apuntan a EstadoTransicion.
    CONSTRAINT FK_Transicion_EstadoAntes
        FOREIGN KEY (id_transicion_antes)
        REFERENCES modelado.EstadoTransicion (id_estado_transicion),

    CONSTRAINT FK_Transicion_EstadoDespues
        FOREIGN KEY (id_transicion_despues)
        REFERENCES modelado.EstadoTransicion (id_estado_transicion)
);
GO

-- ============================================================
-- EXTRA: DATOS DE PRUEBA (contexto bancario)
-- Orden respeta las claves foraneas. estado: 1 = Activo, 0 = Inactivo
-- ============================================================

-- Rol
INSERT INTO modelado.Rol (id_rol, nombre, estado)
VALUES
    (1, 'Software Engineer', 1),
    (2, 'Team Leader', 1),
    (3, 'Operador', 1),
    (4, 'Proveedor', 1);
GO

-- Equipo
INSERT INTO modelado.Equipo (id_equipo, descripcion, estado)
VALUES
    (1, 'Canales Digitales', 1),
    (2, 'Core Bancario', 1),
    (3, 'Seguridad TI', 1),
    (4, 'Infraestructura', 1),
    (5, 'Atencion al Cliente', 1),
    (6, 'Tarjetas y Pagos', 1);
GO

-- Usuario
INSERT INTO modelado.Usuario
    (id_usuario, codigo_usuario, nombre, apellido, correo, telefono, id_rol, estado, cod_asignatario, id_equipo)
VALUES
    (1,  'USR0001', 'Carlos',   'Mendoza',   'cmendoza@bancoandino.com',   '51987654321', 2, 1, 'ASG0001', 1),
    (2,  'USR0002', 'Lucia',    'Fernandez', 'lfernandez@bancoandino.com', '51987654322', 1, 1, 'ASG0002', 1),
    (3,  'USR0003', 'Jorge',    'Ramirez',   'jramirez@bancoandino.com',   '51987654323', 1, 1, 'ASG0003', 2),
    (4,  'USR0004', 'Valeria',  'Torres',    'vtorres@bancoandino.com',    '51987654324', 2, 1, 'ASG0004', 3),
    (5,  'USR0005', 'Miguel',   'Castillo',  'mcastillo@bancoandino.com',  '51987654325', 1, 1, 'ASG0005', 4),
    (6,  'USR0006', 'Andrea',   'Salazar',   'asalazar@bancoandino.com',   '51987654326', 3, 1, NULL,      5),
    (7,  'USR0007', 'Ricardo',  'Paredes',   'rparedes@bancoandino.com',   '51987654327', 3, 1, NULL,      5),
    (8,  'USR0008', 'Sofia',    'Quispe',    'squispe@bancoandino.com',    '51987654328', 3, 1, NULL,      6),
    (9,  'USR0009', 'Diego',    'Herrera',   'dherrera@redtelecom.com',    '51987654329', 4, 1, NULL,      NULL),
    (10, 'USR0010', 'Patricia', 'Luna',      'pluna@procesadorpagos.com',  '51987654330', 4, 0, NULL,      NULL);
GO

-- Categoria
INSERT INTO modelado.Categoria (id_categoria, descripcion, estado)
VALUES
    (1, 'Tarjetas', 1),
    (2, 'Transferencias', 1),
    (3, 'Banca Movil', 1),
    (4, 'Banca por Internet', 1),
    (5, 'Cajeros Automaticos', 1),
    (6, 'Prestamos', 1),
    (7, 'Seguridad', 1),
    (8, 'Chequeras', 0);
GO

-- Prioridad
INSERT INTO modelado.Prioridad (id_prioridad, descripcion, estado)
VALUES
    (1, 'Critica', 1),
    (2, 'Alta', 1),
    (3, 'Media', 1),
    (4, 'Baja', 1);
GO

-- TipoTicket
INSERT INTO modelado.TipoTicket (id_tipo_ticket, descripcion, estado)
VALUES
    (1, 'Incidente', 1),
    (2, 'Requerimiento', 1),
    (3, 'Problema', 1),
    (4, 'Cambio', 1);
GO

-- Servicio
INSERT INTO modelado.Servicio (id_servicio, descripcion, id_equipo, estado)
VALUES
    (1,  'Banca Movil', 1, 1),
    (2,  'Banca Web', 1, 1),
    (3,  'Core de Cuentas', 2, 1),
    (4,  'Procesos Batch', 2, 1),
    (5,  'Control de Accesos', 3, 1),
    (6,  'Monitoreo Fraude', 3, 1),
    (7,  'Red y Comunicacion', 4, 1),
    (8,  'Red de Cajeros ATM', 4, 1),
    (9,  'Autorizacion POS', 6, 1),
    (10, 'Mesa de Ayuda', 5, 1);
GO

-- EstadoTransicion
INSERT INTO modelado.EstadoTransicion (id_estado_transicion, descripcion, estado)
VALUES
    (1, 'Nuevo', 1),
    (2, 'Asignado', 1),
    (3, 'En Progreso', 1),
    (4, 'En Espera', 1),
    (5, 'Resuelto', 1),
    (6, 'Cerrado', 1),
    (7, 'Cancelado', 1);
GO

-- Ticket
INSERT INTO modelado.Ticket
    (id_ticket, codigo_ticket, id_prioridad, fecha, estado, id_usuario, id_equipo, id_asignatario, id_categoria, id_servicio, id_tipo)
VALUES
    (1,  'TKT-00001', 1, '2026-09-28T08:15:00', 1, 6, 1, 2, 3, 1,  1),
    (2,  'TKT-00002', 2, '2026-09-28T09:40:00', 1, 7, 2, 3, 2, 3,  1),
    (3,  'TKT-00003', 3, '2026-09-29T10:05:00', 0, 8, 3, 4, 7, 6,  1),
    (4,  'TKT-00004', 2, '2026-09-29T11:30:00', 1, 6, 4, 5, 5, 8,  1),
    (5,  'TKT-00005', 3, '2026-09-30T14:20:00', 1, 7, 1, 1, 4, 2,  2),
    (6,  'TKT-00006', 4, '2026-09-30T15:45:00', 1, 9, 4, 5, 5, 7,  4),
    (7,  'TKT-00007', 1, '2026-10-01T07:50:00', 1, 6, 2, 3, 2, 4,  3),
    (8,  'TKT-00008', 2, '2026-10-01T13:10:00', 1, 7, 3, 4, 7, 5,  2),
    (9,  'TKT-00009', 3, '2026-10-02T09:00:00', 1, 8, 1, 2, 3, 1,  4),
    (10, 'TKT-00010', 4, '2026-10-02T16:25:00', 0, 6, 5, 1, 1, 10, 2);
GO

-- Comentario
INSERT INTO modelado.Comentario (id_comentario, texto, id_usuario, id_ticket, estado)
VALUES
    (1,  'Clientes reportan error al iniciar sesion en la app movil.', 6, 1, 1),
    (2,  'Se identifico fallo en el servicio de autenticacion, se reinicia el nodo.', 2, 1, 1),
    (3,  'Transferencias interbancarias rechazadas con codigo de error 504.', 7, 2, 1),
    (4,  'Se solicita al proveedor el log de la pasarela de pagos.', 3, 2, 1),
    (5,  'Alerta de operaciones sospechosas en tarjetas de debito.', 8, 3, 1),
    (6,  'Se bloquean las tarjetas afectadas y se notifica a los clientes.', 4, 3, 1),
    (7,  'Cajero de la agencia Miraflores sin dispositivo dispensador de billetes.', 6, 4, 1),
    (8,  'Se espera repuesto del proveedor, fecha estimada en 48 horas.', 5, 4, 1),
    (9,  'Se requiere ampliar el limite diario de transferencias para clientes premium.', 7, 5, 1),
    (10, 'Ventana de mantenimiento de red programada para el domingo a las 02:00.', 9, 6, 1),
    (11, 'El proceso de conciliacion nocturna falla de forma recurrente.', 6, 7, 1),
    (12, 'Se solicita acceso privilegiado a la base de datos para auditoria.', 7, 8, 1);
GO

-- Transicion
INSERT INTO modelado.Transicion
    (id_transicion, id_usuario, id_ticket, fecha, id_transicion_antes, id_transicion_despues, estado)
VALUES
    (1,  1, 1,  '2026-09-28T08:20:00', 1, 2, 1),
    (2,  2, 1,  '2026-09-28T08:35:00', 2, 3, 1),
    (3,  2, 1,  '2026-09-28T11:10:00', 3, 5, 1),
    (4,  3, 2,  '2026-09-28T09:50:00', 1, 2, 1),
    (5,  3, 2,  '2026-09-28T10:05:00', 2, 3, 1),
    (6,  3, 2,  '2026-09-28T15:30:00', 3, 4, 1),
    (7,  4, 3,  '2026-09-29T10:10:00', 1, 2, 1),
    (8,  4, 3,  '2026-09-29T10:25:00', 2, 3, 1),
    (9,  4, 3,  '2026-09-29T13:00:00', 3, 5, 1),
    (10, 4, 3,  '2026-09-30T09:00:00', 5, 6, 1),
    (11, 5, 4,  '2026-09-29T11:40:00', 1, 2, 1),
    (12, 5, 4,  '2026-09-29T12:00:00', 2, 3, 1),
    (13, 5, 4,  '2026-09-30T10:15:00', 3, 4, 1),
    (14, 1, 5,  '2026-09-30T14:30:00', 1, 2, 1),
    (15, 1, 5,  '2026-10-01T09:00:00', 2, 3, 1),
    (16, 1, 5,  '2026-10-01T12:00:00', 3, 5, 1),
    (17, 5, 6,  '2026-09-30T16:00:00', 1, 2, 1),
    (18, 5, 6,  '2026-10-01T08:30:00', 2, 4, 1),
    (19, 3, 7,  '2026-10-01T08:00:00', 1, 2, 1),
    (20, 3, 7,  '2026-10-01T08:15:00', 2, 3, 1),
    (21, 4, 8,  '2026-10-01T13:20:00', 1, 2, 1),
    (22, 4, 8,  '2026-10-02T09:30:00', 2, 3, 1),
    (23, 2, 9,  '2026-10-02T09:10:00', 1, 2, 1),
    (24, 1, 10, '2026-10-02T16:30:00', 1, 2, 1),
    (25, 1, 10, '2026-10-02T17:10:00', 2, 5, 1),
    (26, 1, 10, '2026-10-02T17:20:00', 5, 6, 1);
GO

-- ============================================================
-- EXTRA: SCRIPT DE ELIMINACION
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