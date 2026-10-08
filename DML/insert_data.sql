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
    (3, 'Seguridad', 1),
    (5, 'Devops', 1),
    (6, 'Cloud', 1);
GO

-- Servicio
INSERT INTO modelado.Servicio (id_servicio, descripcion, estado)
VALUES
    (1, 'Aplicacion Banca Movil', 1),
    (2, 'Aplicacion Banca Web', 1),
    (3, 'Plataforma Core Bancario', 1),
    (4, 'Azure', 1),
    (5, 'Onpremise', 1),
    (6, 'Accesos', 1);
GO

-- EquipoServicio (equipos que dan soporte a cada servicio)
INSERT INTO modelado.EquipoServicio (id_equipo_servicio, id_equipo, id_servicio, estado)
VALUES
    -- Canales Digitales -> Aplicacion Banca Movil
    (1, 1, 1, 1),
    -- Canales Digitales -> Aplicacion Banca Web
    (2, 1, 2, 1),
    -- Core Bancario -> Plataforma Core Bancario
    (3, 2, 3, 1),
    -- Seguridad -> Accesos
    (4, 3, 6, 1),
    -- Devops -> Onpremise
    (5, 5, 5, 1),
    -- Devops -> Azure
    (6, 5, 4, 1),
    -- Cloud -> Azure
    (7, 6, 4, 1),
    -- Core Bancario -> Onpremise
    (8, 2, 5, 1),
    -- Seguridad -> Azure
    (9, 3, 4, 1);
GO

-- TipoTicket
INSERT INTO modelado.TipoTicket (id_tipo_ticket, descripcion, estado)
VALUES
    (1, 'Incidente', 1),
    (2, 'Requerimiento', 1),
    (3, 'Problema', 1),
    (4, 'Cambio', 1);
GO

-- Usuario
-- cod_asignatario informado = puede ser asignatario de tickets (Operadores)
INSERT INTO modelado.Usuario
    (id_usuario, codigo_usuario, nombre, apellido, correo, telefono, id_rol, estado, cod_asignatario, id_equipo)
VALUES
    (1,  'USR0001', 'Carlos',   'Mendoza',   'cmendoza@bancoandino.com',   '51987654321', 1, 1, NULL,      1),
    (2,  'USR0002', 'Lucia',    'Fernandez', 'lfernandez@bancoandino.com', '51987654322', 2, 1, NULL,      1),
    (3,  'USR0003', 'Jorge',    'Ramirez',   'jramirez@bancoandino.com',   '51987654323', 3, 1, 'ASG0003', 6),
    (4,  'USR0004', 'Valeria',  'Torres',    'vtorres@bancoandino.com',    '51987654324', 1, 1, NULL,      2),
    (5,  'USR0005', 'Miguel',   'Castillo',  'mcastillo@bancoandino.com',  '51987654325', 2, 1, NULL,      5),
    (6,  'USR0006', 'Andrea',   'Salazar',   'asalazar@bancoandino.com',   '51987654326', 3, 1, 'ASG0006', 5),
    (7,  'USR0007', 'Ricardo',  'Paredes',   'rparedes@bancoandino.com',   '51987654327', 3, 1, 'ASG0007', 2),
    (8,  'USR0008', 'Sofia',    'Quispe',    'squispe@bancoandino.com',    '51987654328', 3, 1, 'ASG0008', 3),
    (9,  'USR0009', 'Diego',    'Herrera',   'dherrera@bancoandino.com',   '51987654329', 3, 1, 'ASG0009', 1),
    (10, 'USR0010', 'Patricia', 'Luna',      'pluna@procesadorpagos.com',  '51987654330', 4, 1, NULL,      NULL);
GO

-- Categoria
INSERT INTO modelado.Categoria (id_categoria, descripcion, estado)
VALUES
    (1, 'Aplicaciones', 1),
    (2, 'Base de Datos', 1),
    (3, 'Redes y Comunicaciones', 1),
    (4, 'Seguridad de la Informacion', 1),
    (5, 'Accesos y Permisos', 1),
    (6, 'Infraestructura', 1);
GO

-- Prioridad
INSERT INTO modelado.Prioridad (id_prioridad, descripcion, estado)
VALUES
    (1, 'Critica', 1),
    (2, 'Alta', 1),
    (3, 'Media', 1),
    (4, 'Baja', 1);
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

-- TransicionPermitida
INSERT INTO modelado.TransicionPermitida
    (id_transicion_permitida, id_estado_antes, id_estado_despues, estado)
VALUES
    -- Cancelacion
    (1,  1, 7, 1), -- Nuevo -> Cancelado
    (2,  2, 7, 1), -- Asignado -> Cancelado
    (3,  3, 7, 1), -- En Progreso -> Cancelado
    (4,  4, 7, 1), -- En Espera -> Cancelado
    (5,  5, 7, 1), -- Resuelto -> Cancelado

    -- Flujo normal
    (6,  1, 2, 1), -- Nuevo -> Asignado
    (7,  2, 3, 1), -- Asignado -> En Progreso
    (8,  2, 4, 1), -- Asignado -> En Espera
    (9,  3, 5, 1), -- En Progreso -> Resuelto
    (10, 3, 4, 1), -- En Progreso -> En Espera
    (11, 4, 3, 1), -- En Espera -> En Progreso
    (12, 4, 2, 1), -- En Espera -> Asignado
    (13, 5, 6, 1); -- Resuelto -> Cerrado
GO

-- Ticket
-- Usuarios: Carlos 1, Lucia (TL) 2, Jorge (Op. Cloud) 3, Valeria 4, Miguel (TL Devops) 5,
--           Andrea (Op. Devops) 6, Ricardo (Op. Core) 7, Sofia (Op. Seguridad) 8,
--           Diego (Op. Canales) 9, Patricia (Proveedor) 10
-- El equipo del ticket da soporte al servicio y el asignatario pertenece a ese equipo.
INSERT INTO modelado.Ticket
    (id_ticket, codigo_ticket, id_prioridad, fecha, estado, id_usuario, id_asignatario,
     id_categoria, id_servicio, id_equipo, id_tipo, resumen, descripcion)
VALUES
    (1, 'TKT-00001', 1, '2026-09-28T08:15:00', 1, 1, 3, 6, 4, 6, 1,
        '[ABC] Error acceso a Keyvault',
        'No se tiene acceso al kv abckv01'),
    (2, 'TKT-00002', 2, '2026-09-29T09:30:00', 1, 2, 9, 1, 1, 1, 1,
        'Error al iniciar sesion en la app movil',
        'Varios clientes reportan que la Banca Movil rechaza las credenciales desde las 09:00. Afecta a iOS y Android.'),
    (3, 'TKT-00003', 1, '2026-09-30T10:05:00', 1, 4, 7, 2, 3, 2, 1,
        'Lentitud en consulta de saldos del Core Bancario',
        'La consulta de saldos supera los 15 segundos en horario pico y genera timeouts en los canales.'),
    (4, 'TKT-00004', 3, '2026-10-01T14:20:00', 1, 1, 8, 5, 6, 3, 2,
        'Alta de accesos a la plataforma de monitoreo',
        'Se solicita acceso de solo lectura al panel de monitoreo para el nuevo integrante del equipo.'),
    (5, 'TKT-00005', 4, '2026-10-02T09:00:00', 1, 2, NULL, 1, 2, 1, 4,
        'Ampliar limite diario de transferencias en Banca Web',
        'Cambio para incrementar el limite diario de transferencias del segmento premium.'),
    (6, 'TKT-00006', 3, '2026-10-02T11:45:00', 1, 4, 6, 6, 5, 5, 3,
        'Caidas recurrentes de servidores onpremise del batch',
        'Se observan reinicios intermitentes en los servidores onpremise que ejecutan los procesos batch nocturnos.'),
    (7, 'TKT-00007', 2, '2026-10-03T08:10:00', 1, 5, 3, 3, 4, 6, 4,
        'Habilitar peering entre VNets de pre-produccion',
        'Se requiere habilitar el peering entre las VNets de pre-produccion para las pruebas integradas.'),
    (8, 'TKT-00008', 1, '2026-10-03T16:30:00', 1, 4, 8, 4, 4, 3, 1,
        'Alerta de acceso sospechoso a Key Vault',
        'El monitoreo detecto intentos de acceso desde una IP no reconocida al Key Vault de produccion.'),
    (9, 'TKT-00009', 3, '2026-10-04T10:00:00', 1, 1, 7, 2, 5, 2, 2,
        'Solicitud de backup adicional de base de datos onpremise',
        'Se solicita un respaldo adicional previo al pase a produccion del fin de semana.');
GO

-- Comentario
INSERT INTO modelado.Comentario (id_comentario, texto, id_usuario, id_ticket, estado)
VALUES
    (1,  'Debes solicitar conformidad de tu TL.', 3, 1, 1),
    (2,  'Se adjunta conforme del LT.', 1, 1, 1),
    (3,  'Se continua el ticket.', 3, 1, 1),
    (4,  'Se realizo el ticket, se solicita conforme para cerrar, en caso no se de en 3 dias se cierra.', 3, 1, 1),
    (5,  'Se procede a cerrar el ticket.', 3, 1, 1),
    (6,  'Se reproduce el error en iOS y Android, se revisa el servicio de autenticacion.', 9, 2, 1),
    (7,  'Se reinicio el servicio de tokens y el acceso se normalizo.', 9, 2, 1),
    (8,  'Confirmado por el usuario, se cierra el ticket.', 2, 2, 1),
    (9,  'Se identifica una consulta sin indice en la tabla de saldos.', 7, 3, 1),
    (10, 'Se solicita al proveedor el analisis del plan de ejecucion.', 7, 3, 1),
    (11, 'Se adjunta el analisis del proveedor con el indice recomendado.', 10, 3, 1),
    (12, 'Indice creado en produccion, se espera conformidad para cerrar.', 7, 3, 1),
    (13, 'Se adjunta la aprobacion del jefe del area.', 1, 4, 1),
    (14, 'Se valida el perfil requerido con el area de seguridad.', 8, 4, 1),
    (15, 'Se solicita priorizar el cambio para la ventana del proximo mes.', 2, 5, 1),
    (16, 'Se cancela porque el caso ya esta cubierto por otra atencion en curso.', 6, 6, 1),
    (17, 'Se solicita al equipo de redes confirmar los rangos de IP.', 3, 7, 1),
    (18, 'Se revisa el log de accesos y se detecta una IP no autorizada.', 8, 8, 1),
    (19, 'Se bloquea la IP y se rotan los secretos.', 8, 8, 1),
    (20, 'Se cierra el ticket tras confirmar que no hubo accesos adicionales.', 8, 8, 1),
    (21, 'Se cancela, el respaldo fue atendido por el proceso estandar.', 7, 9, 1);
GO

-- Transicion (historial de estados; todas deben existir en TransicionPermitida)
-- Estados: 1 Nuevo, 2 Asignado, 3 En Progreso, 4 En Espera, 5 Resuelto, 6 Cerrado, 7 Cancelado
INSERT INTO modelado.Transicion
    (id_transicion, id_usuario, id_ticket, fecha, id_transicion_antes, id_transicion_despues, estado)
VALUES
    -- Ticket 1: Nuevo -> Asignado -> En Espera -> Asignado -> En Progreso -> Resuelto -> Cerrado
    (1,  1,  1, '2026-09-28T08:20:00', 1, 2, 1),
    (2,  3,  1, '2026-09-28T09:00:00', 2, 4, 1),
    (3,  1,  1, '2026-09-28T10:30:00', 4, 2, 1),
    (4,  1,  1, '2026-09-28T10:45:00', 2, 3, 1),
    (5,  3,  1, '2026-09-28T15:00:00', 3, 5, 1),
    (6,  3,  1, '2026-10-01T09:00:00', 5, 6, 1),

    -- Ticket 2: Nuevo -> Asignado -> En Progreso -> Resuelto -> Cerrado
    (7,  2,  2, '2026-09-29T09:40:00', 1, 2, 1),
    (8,  9,  2, '2026-09-29T09:55:00', 2, 3, 1),
    (9,  9,  2, '2026-09-29T11:20:00', 3, 5, 1),
    (10, 9,  2, '2026-09-30T09:00:00', 5, 6, 1),

    -- Ticket 3: Nuevo -> Asignado -> En Progreso -> En Espera -> En Progreso -> Resuelto
    (11, 2,  3, '2026-09-30T10:15:00', 1, 2, 1),
    (12, 7,  3, '2026-09-30T10:30:00', 2, 3, 1),
    (13, 7,  3, '2026-09-30T12:00:00', 3, 4, 1),
    (14, 7,  3, '2026-10-01T09:30:00', 4, 3, 1),
    (15, 7,  3, '2026-10-01T15:00:00', 3, 5, 1),

    -- Ticket 4: Nuevo -> Asignado -> En Progreso
    (16, 2,  4, '2026-10-01T14:30:00', 1, 2, 1),
    (17, 8,  4, '2026-10-01T15:10:00', 2, 3, 1),

    -- Ticket 5: sin transiciones (permanece en Nuevo)

    -- Ticket 6: Nuevo -> Asignado -> Cancelado
    (18, 5,  6, '2026-10-02T11:50:00', 1, 2, 1),
    (19, 6,  6, '2026-10-02T14:00:00', 2, 7, 1),

    -- Ticket 7: Nuevo -> Asignado -> En Espera
    (20, 5,  7, '2026-10-03T08:20:00', 1, 2, 1),
    (21, 3,  7, '2026-10-03T10:00:00', 2, 4, 1),

    -- Ticket 8: Nuevo -> Asignado -> En Progreso -> Resuelto -> Cerrado
    (22, 2,  8, '2026-10-03T16:40:00', 1, 2, 1),
    (23, 8,  8, '2026-10-03T16:50:00', 2, 3, 1),
    (24, 8,  8, '2026-10-04T09:30:00', 3, 5, 1),
    (25, 8,  8, '2026-10-07T09:00:00', 5, 6, 1),

    -- Ticket 9: Nuevo -> Asignado -> En Progreso -> Cancelado
    (26, 2,  9, '2026-10-04T10:05:00', 1, 2, 1),
    (27, 7,  9, '2026-10-04T10:20:00', 2, 3, 1),
    (28, 7,  9, '2026-10-05T08:45:00', 3, 7, 1);
GO
