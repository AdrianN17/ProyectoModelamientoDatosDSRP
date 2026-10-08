-- ============================================================
-- DATOS DE PRUEBA (contexto bancario)
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
    (1, 'Aplicaciones', 1),
    (2, 'Base de Datos', 1),
    (3, 'Redes y Comunicaciones', 1),
    (4, 'Seguridad de la Informacion', 1),
    (5, 'Hardware y Perifericos', 1),
    (6, 'Accesos y Permisos', 1),
    (7, 'Procesos Batch', 1),
    (8, 'Telefonia y Videoconferencia', 1),
    (9, 'Licencias de Software', 0);
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
    (1,  'Aplicacion Banca Movil', 1, 1),
    (2,  'Aplicacion Banca Web', 1, 1),
    (3,  'Plataforma Core Bancario', 2, 1),
    (4,  'Planificador Batch', 2, 1),
    (5,  'Gestion de Accesos', 3, 1),
    (6,  'Plataforma Antifraude', 3, 1),
    (7,  'Red Corporativa', 4, 1),
    (8,  'Infraestructura ATM', 4, 1),
    (9,  'Plataforma POS', 6, 1),
    (10, 'Mesa de Ayuda TI', 5, 1);
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
    (1,  'TKT-00001', 1, '2026-09-28T08:15:00', 1, 6, 1, 2, 1, 1,  1),
    (2,  'TKT-00002', 2, '2026-09-28T09:40:00', 1, 7, 2, 3, 1, 3,  1),
    (3,  'TKT-00003', 3, '2026-09-29T10:05:00', 0, 8, 3, 4, 4, 6,  1),
    (4,  'TKT-00004', 2, '2026-09-29T11:30:00', 1, 6, 4, 5, 5, 8,  1),
    (5,  'TKT-00005', 3, '2026-09-30T14:20:00', 1, 7, 1, 1, 1, 2,  2),
    (6,  'TKT-00006', 4, '2026-09-30T15:45:00', 1, 9, 4, 5, 3, 7,  4),
    (7,  'TKT-00007', 1, '2026-10-01T07:50:00', 1, 6, 2, 3, 7, 4,  3),
    (8,  'TKT-00008', 2, '2026-10-01T13:10:00', 1, 7, 3, 4, 2, 5,  2),
    (9,  'TKT-00009', 3, '2026-10-02T09:00:00', 1, 8, 1, 2, 1, 1,  4),
    (10, 'TKT-00010', 4, '2026-10-02T16:25:00', 0, 6, 5, 1, 6, 10, 2);
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
