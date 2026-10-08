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
    descripcion VARCHAR(50) NULL,
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
