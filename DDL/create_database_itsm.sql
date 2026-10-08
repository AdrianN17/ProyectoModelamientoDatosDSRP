-- ============================================================
-- 0. SCHEMA: modelado
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'modelado')
    EXEC('CREATE SCHEMA modelado');

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

-- ============================================================
-- 2. TABLA: Equipo
-- ============================================================
CREATE TABLE modelado.Equipo
(
    id_equipo INT NOT NULL,
    descripcion VARCHAR(50) NULL,
    estado INT NULL,

    CONSTRAINT PK_Equipo PRIMARY KEY (id_equipo),
    CONSTRAINT CK_Equipo_estado CHECK (estado IN (0, 1))
);

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

-- ============================================================
-- 4. TABLA: Categoria
-- ============================================================
CREATE TABLE modelado.Categoria
(
    id_categoria INT NOT NULL,
    descripcion VARCHAR(50) NULL,
    estado INT NULL,

    CONSTRAINT PK_Categoria PRIMARY KEY (id_categoria),
    CONSTRAINT CK_Categoria_estado CHECK (estado IN (0, 1))
);

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

-- ============================================================
-- 7. TABLA: Servicio
-- ============================================================
CREATE TABLE modelado.Servicio
(
    id_servicio INT NOT NULL,
    descripcion VARCHAR(50) NULL,
    estado INT NULL,

    CONSTRAINT PK_Servicio PRIMARY KEY (id_servicio),
    CONSTRAINT CK_Servicio_estado CHECK (estado IN (0, 1))
);

-- ============================================================
-- 8. TABLA: EquipoServicio (relacion Equipo - Servicio)
-- ============================================================
CREATE TABLE modelado.EquipoServicio
(
    id_equipo_servicio INT NOT NULL,
    id_equipo INT NOT NULL,
    id_servicio INT NOT NULL,
    estado INT NULL,

    CONSTRAINT PK_EquipoServicio PRIMARY KEY (id_equipo_servicio),
    CONSTRAINT UQ_EquipoServicio_equipo_servicio UNIQUE (id_equipo, id_servicio),
    CONSTRAINT CK_EquipoServicio_estado CHECK (estado IN (0, 1)),

    CONSTRAINT FK_EquipoServicio_Equipo
        FOREIGN KEY (id_equipo)
        REFERENCES modelado.Equipo (id_equipo),

    CONSTRAINT FK_EquipoServicio_Servicio
        FOREIGN KEY (id_servicio)
        REFERENCES modelado.Servicio (id_servicio)
);

-- ============================================================
-- 9. TABLA: EstadoTransicion
-- ============================================================
CREATE TABLE modelado.EstadoTransicion
(
    id_estado_transicion INT NOT NULL,
    descripcion VARCHAR(20) NULL,
    estado INT NULL,

    CONSTRAINT PK_EstadoTransicion PRIMARY KEY (id_estado_transicion),
    CONSTRAINT CK_EstadoTransicion_estado CHECK (estado IN (0, 1))
);

-- ============================================================
-- 9.1 TABLA: TransicionPermitida
-- ============================================================
CREATE TABLE modelado.TransicionPermitida
(
    id_transicion_permitida INT NOT NULL,
    id_estado_antes INT NOT NULL,
    id_estado_despues INT NOT NULL,
    estado INT NOT NULL,

    CONSTRAINT PK_TransicionPermitida PRIMARY KEY (id_transicion_permitida),
    CONSTRAINT CK_TransicionPermitida_estado CHECK (estado IN (0, 1)),

    CONSTRAINT FK_TransicionPermitida_EstadoAntes
        FOREIGN KEY (id_estado_antes)
        REFERENCES modelado.EstadoTransicion (id_estado_transicion),

    CONSTRAINT FK_TransicionPermitida_EstadoDespues
        FOREIGN KEY (id_estado_despues)
        REFERENCES modelado.EstadoTransicion (id_estado_transicion),

    CONSTRAINT UQ_TransicionPermitida
        UNIQUE (id_estado_antes, id_estado_despues)
);

-- ============================================================
-- 10. TABLA: Ticket
-- ============================================================
CREATE TABLE modelado.Ticket
(
    id_ticket INT NOT NULL,
    codigo_ticket VARCHAR(10) NULL,
    id_prioridad INT NULL,
    fecha DATETIME NULL,
    estado INT NULL,
    id_usuario INT NULL,
    id_asignatario INT NULL,
    id_categoria INT NULL,
    id_equipo INT NULL,
    id_servicio INT NULL,
    id_tipo INT NULL,
    resumen VARCHAR(100) NULL,
    descripcion TEXT NULL,

    CONSTRAINT PK_Ticket PRIMARY KEY (id_ticket),
    CONSTRAINT CK_Ticket_estado CHECK (estado IN (0, 1)),

    CONSTRAINT FK_Ticket_Prioridad
        FOREIGN KEY (id_prioridad)
        REFERENCES modelado.Prioridad (id_prioridad),

    CONSTRAINT FK_Ticket_Usuario
        FOREIGN KEY (id_usuario)
        REFERENCES modelado.Usuario (id_usuario),

    CONSTRAINT FK_Ticket_Asignatario
        FOREIGN KEY (id_asignatario)
        REFERENCES modelado.Usuario (id_usuario),

    CONSTRAINT FK_Ticket_Categoria
        FOREIGN KEY (id_categoria)
        REFERENCES modelado.Categoria (id_categoria),

    CONSTRAINT FK_Ticket_Servicio
        FOREIGN KEY (id_servicio)
        REFERENCES modelado.Servicio (id_servicio),

    -- El equipo debe dar soporte al servicio del ticket
    CONSTRAINT FK_Ticket_EquipoServicio
        FOREIGN KEY (id_equipo, id_servicio)
        REFERENCES modelado.EquipoServicio (id_equipo, id_servicio),

    CONSTRAINT FK_Ticket_TipoTicket
        FOREIGN KEY (id_tipo)
        REFERENCES modelado.TipoTicket (id_tipo_ticket)
);

-- ============================================================
-- 11. TABLA: Comentario
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

-- ============================================================
-- 12. TABLA: Transicion
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
        REFERENCES modelado.EstadoTransicion (id_estado_transicion),

    -- Solo se permiten cambios de estado definidos en TransicionPermitida
    CONSTRAINT FK_Transicion_TransicionPermitida
        FOREIGN KEY (id_transicion_antes, id_transicion_despues)
        REFERENCES modelado.TransicionPermitida (id_estado_antes, id_estado_despues)
);
