# Respuestas — Laboratorio SQL Server ITSM

Resultados de las consultas de [preguntas.md](./preguntas.md) con los datos de `DML/insert_data.sql`.

---

## Pregunta 1 — Tickets activos desde el 2026-09-29

| Código | Fecha | Id prioridad | Id equipo |
|---|---|---|---|
| TKT-00009 | 2026-10-04 10:00 | 3 | 2 |
| TKT-00008 | 2026-10-03 16:30 | 1 | 3 |
| TKT-00007 | 2026-10-03 08:10 | 2 | 6 |
| TKT-00006 | 2026-10-02 11:45 | 3 | 5 |
| TKT-00005 | 2026-10-02 09:00 | 4 | 1 |
| TKT-00004 | 2026-10-01 14:20 | 3 | 3 |
| TKT-00003 | 2026-09-30 10:05 | 1 | 2 |
| TKT-00002 | 2026-09-29 09:30 | 2 | 1 |

## Pregunta 2 — Resumen general de tickets

| TotalTickets | TicketsActivos | TicketsInactivos | PrimerTicket | UltimoTicket |
|---|---|---|---|---|
| 9 | 9 | 0 | 2026-09-28 08:15 | 2026-10-04 10:00 |

## Pregunta 3 — Tickets por categoría

| Categoría | CantidadTickets |
|---|---|
| Aplicaciones | 2 |
| Base de Datos | 2 |
| Infraestructura | 2 |
| Accesos y Permisos | 1 |
| Redes y Comunicaciones | 1 |
| Seguridad de la Informacion | 1 |
| Telefonia y Videoconferencia | 0 |

## Pregunta 4 — Carga de trabajo por equipo (2 o más tickets)

| Equipo | CantidadTickets | AsignatariosDistintos |
|---|---|---|
| Canales Digitales | 2 | 1 |
| Cloud | 2 | 1 |
| Core Bancario | 2 | 1 |
| Seguridad | 2 | 1 |

Devops (1 ticket) no aparece por el `HAVING`.

## Pregunta 5 — Cuello de botella por ticket

| CodigoTicket | EstadoAntes | EstadoDespues | Minutos | Ranking |
|---|---|---|---|---|
| TKT-00001 | Resuelto | Cerrado | 3960 | 1 |
| TKT-00002 | Resuelto | Cerrado | 1300 | 1 |
| TKT-00003 | En Espera | En Progreso | 1290 | 1 |
| TKT-00004 | Asignado | En Progreso | 40 | 1 |
| TKT-00006 | Asignado | Cancelado | 130 | 1 |
| TKT-00007 | Asignado | En Espera | 100 | 1 |
| TKT-00008 | Resuelto | Cerrado | 4290 | 1 |
| TKT-00009 | En Progreso | Cancelado | 1345 | 1 |

`TKT-00005` no aparece porque no tiene transiciones (sigue en Nuevo).

## Pregunta 6 — Asignatario más cargado por equipo

| Equipo | Asignatario | Tickets | PctDelEquipo | Ranking |
|---|---|---|---|---|
| Canales Digitales | Diego Herrera | 1 | 100.00 | 1 |
| Cloud | Jorge Ramirez | 2 | 100.00 | 1 |
| Core Bancario | Ricardo Paredes | 2 | 100.00 | 1 |
| Devops | Andrea Salazar | 1 | 100.00 | 1 |
| Seguridad | Sofia Quispe | 2 | 100.00 | 1 |

Cada equipo tiene un solo asignatario. `TKT-00005` no tiene asignatario y se excluye.

---

## Challenge — ¿Estamos cumpliendo los SLA de atención?

Se analizan 7 tickets; los cancelados `TKT-00006` y `TKT-00009` se excluyen.

### Paso 2 — Resultado por ticket (preguntas 1 y 2)

| CodigoTicket | Prioridad | SLA (min) | Resolución (min) | Resultado |
|---|---|---|---|---|
| TKT-00001 | Critica | 240 | 405 | Incumple |
| TKT-00003 | Critica | 240 | 1735 | Incumple |
| TKT-00008 | Critica | 240 | 1020 | Incumple |
| TKT-00002 | Alta | 480 | 110 | Cumple |
| TKT-00007 | Alta | 480 | NULL | Sin resolver |
| TKT-00004 | Media | 1440 | NULL | Sin resolver |
| TKT-00005 | Baja | 4320 | NULL | Sin resolver |

### Paso 3 — Cumplimiento por equipo y prioridad (preguntas 3 y 4)

| Equipo | Prioridad | Tickets | Cumplen | Incumplen | SinResolver | %Cumplimiento | %SobreTotalIncumplimientos |
|---|---|---|---|---|---|---|---|
| Cloud | Critica | 1 | 0 | 1 | 0 | 0.00 | 33.33 |
| Core Bancario | Critica | 1 | 0 | 1 | 0 | 0.00 | 33.33 |
| Seguridad | Critica | 1 | 0 | 1 | 0 | 0.00 | 33.33 |
| Canales Digitales | Alta | 1 | 1 | 0 | 0 | 100.00 | 0.00 |
| Cloud | Alta | 1 | 0 | 0 | 1 | 0.00 | 0.00 |
| Seguridad | Media | 1 | 0 | 0 | 1 | 0.00 | 0.00 |
| Canales Digitales | Baja | 1 | 0 | 0 | 1 | 0.00 | 0.00 |

Cumplimiento por prioridad: Crítica 0 %, Alta 50 %, Media 0 %, Baja 0 %.

### Paso 4 — Asignatarios con más tickets sin resolver (pregunta 5)

| Asignatario | TicketsSinResolver | Ranking |
|---|---|---|
| Jorge Ramirez | 1 | 1 |
| Sofia Quispe | 1 | 1 |

`TKT-00005` no tiene asignatario y no cuenta.

### Paso 5 — Concentración de problemas por equipo (pregunta 6)

| Equipo | Problemas | PctDelTotal | PctAcumulado |
|---|---|---|---|
| Cloud | 2 | 33.33 | 33.33 |
| Seguridad | 2 | 33.33 | 66.67 |
| Canales Digitales | 1 | 16.67 | 83.33 |
| Core Bancario | 1 | 16.67 | 100.00 |

Ningún equipo explica por sí solo más de la mitad de los problemas; Cloud y Seguridad juntos concentran el 66.67 %.
