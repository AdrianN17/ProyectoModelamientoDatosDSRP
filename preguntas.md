# 🎫 Laboratorio SQL Server — ITSM (Gestión de Tickets)

Preguntas basadas en el modelo `modelado` (Azure SQL), replicando la dificultad y los comandos de cada nivel del laboratorio de ejemplo.


---

# 🟢 NIVEL FÁCIL — Principiante

## Pregunta 1 — Tickets activos recientes

Mostrar los tickets **activos** (`estado = 1`) registrados a partir del `2026-09-29`.

Mostrar:

```text
Código ticket
Fecha
Id prioridad
Id equipo
```

Ordenar del más reciente al más antiguo.

### Conceptos

```sql
SELECT
FROM
WHERE
ORDER BY
```

### SQL

```sql
SELECT
    codigo_ticket,
    fecha,
    id_prioridad,
    id_equipo
FROM modelado.Ticket
WHERE estado = 1
  AND fecha >= '2026-09-29'
ORDER BY fecha DESC;
```

## Pregunta 2 — Resumen general de tickets

Obtener en una sola fila:

```text
TotalTickets
TicketsActivos
TicketsInactivos
PrimerTicket   (fecha más antigua)
UltimoTicket   (fecha más reciente)
```

Con los datos actuales: `9, 9, 0, 2026-09-28 08:15, 2026-10-04 10:00`.

### Conceptos

```sql
COUNT()
MIN()
MAX()
```

### SQL

```sql
SELECT
    COUNT(*)                                  AS TotalTickets,
    COUNT(CASE WHEN estado = 1 THEN 1 END)    AS TicketsActivos,
    COUNT(CASE WHEN estado = 0 THEN 1 END)    AS TicketsInactivos,
    MIN(fecha)                                AS PrimerTicket,
    MAX(fecha)                                AS UltimoTicket
FROM modelado.Ticket;
```

---

# 🟡 NIVEL MEDIO — Básico / Intermedio

## Pregunta 3 — Tickets por categoría (incluyendo categorías sin uso)

Determinar cuántos tickets tiene cada categoría. Deben aparecer **también las categorías que nunca se han usado**, con cantidad `0`.

Resultado esperado:

```text
Categoria                     CantidadTickets
----------------------------- ---------------
Aplicaciones                  2
Base de Datos                 2
Infraestructura               2
Accesos y Permisos            1
Redes y Comunicaciones        1
Seguridad de la Informacion   1
Telefonia y Videoconferencia  0
```

Ordenar de mayor a menor cantidad de tickets y, en caso de empate, por nombre de categoría.

### Conceptos

```sql
LEFT JOIN
GROUP BY
COUNT()
ORDER BY
```

### SQL

```sql
SELECT
    c.descripcion      AS Categoria,
    COUNT(t.id_ticket) AS CantidadTickets
FROM modelado.Categoria c
LEFT JOIN modelado.Ticket t
       ON t.id_categoria = c.id_categoria
GROUP BY c.descripcion
ORDER BY CantidadTickets DESC, Categoria;
```

## Pregunta 4 — Carga de trabajo por equipo

Determinar cuántos tickets tiene cada equipo y cuántos asignatarios distintos los atienden. Mostrar **solo los equipos con 2 o más tickets**.

Resultado esperado:

```text
Equipo              CantidadTickets  AsignatariosDistintos
------------------- ---------------  ---------------------
Canales Digitales   2                1
Cloud               2                1
Core Bancario       2                1
Seguridad           2                1
```

Ordenar de mayor a menor cantidad de tickets y, en caso de empate, por nombre de equipo. Devops (1 ticket) no aparece por el `HAVING`.

### Conceptos

```sql
INNER JOIN
GROUP BY
COUNT()
COUNT(DISTINCT)
HAVING
ORDER BY
```

### SQL

```sql
SELECT
    e.descripcion                  AS Equipo,
    COUNT(*)                       AS CantidadTickets,
    COUNT(DISTINCT t.id_asignatario) AS AsignatariosDistintos
FROM modelado.Ticket t
INNER JOIN modelado.Equipo e
        ON e.id_equipo = t.id_equipo
GROUP BY e.descripcion
HAVING COUNT(*) >= 2
ORDER BY CantidadTickets DESC, Equipo;
```

---

# 🔴 NIVEL DIFÍCIL — Avanzado

## Pregunta 5 — Cuello de botella en el ciclo de vida de cada ticket

Para cada ticket, calcular cuántos **minutos** pasaron entre una transición y la anterior, y determinar **en qué cambio de estado se demoró más**.

Resultado esperado:

```text
CodigoTicket  EstadoAntes   EstadoDespues  Minutos   Ranking
------------  -----------   -------------  -------   -------
TKT-00001     Resuelto      Cerrado        3960      1
TKT-00002     Resuelto      Cerrado        1300      1
TKT-00003     En Espera     En Progreso    1290      1
TKT-00004     Asignado      En Progreso    40        1
TKT-00006     Asignado      Cancelado      130       1
TKT-00007     Asignado      En Espera      100       1
TKT-00008     Resuelto      Cerrado        4290      1
TKT-00009     En Progreso   Cancelado      1345      1
```

El `TKT-00005` no aparece porque no tiene transiciones (sigue en estado Nuevo).

Mostrar únicamente el **mayor tiempo por ticket** (Ranking = 1).

### Conceptos

```sql
CTE
LAG() OVER (PARTITION BY ... ORDER BY ...)
DATEDIFF()
ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)
INNER JOIN (doble join a EstadoTransicion)
```

### SQL

```sql
WITH tiempos AS (
    SELECT
        tr.id_ticket,
        tr.id_transicion_antes,
        tr.id_transicion_despues,
        DATEDIFF(
            MINUTE,
            LAG(tr.fecha) OVER (PARTITION BY tr.id_ticket ORDER BY tr.fecha),
            tr.fecha
        ) AS minutos
    FROM modelado.Transicion tr
),
ranking AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY id_ticket ORDER BY minutos DESC) AS ranking
    FROM tiempos
    WHERE minutos IS NOT NULL  
)
SELECT
    t.codigo_ticket  AS CodigoTicket,
    ea.descripcion   AS EstadoAntes,
    ed.descripcion   AS EstadoDespues,
    r.minutos        AS Minutos,
    r.ranking        AS Ranking
FROM ranking r
INNER JOIN modelado.Ticket t             ON t.id_ticket = r.id_ticket
INNER JOIN modelado.EstadoTransicion ea  ON ea.id_estado_transicion = r.id_transicion_antes
INNER JOIN modelado.EstadoTransicion ed  ON ed.id_estado_transicion = r.id_transicion_despues
WHERE r.ranking = 1
ORDER BY t.codigo_ticket;
```

## Pregunta 6 — Asignatario más cargado de cada equipo

Para cada equipo, determinar qué asignatario atiende más tickets y qué porcentaje de los tickets del equipo representa. Si hay empate, deben aparecer todos los empatados.

Resultado esperado:

```text
Equipo              Asignatario       Tickets  PctDelEquipo  Ranking
------------------- ----------------  -------  ------------  -------
Canales Digitales   Diego Herrera     1        100.00        1
Cloud               Jorge Ramirez     2        100.00        1
Core Bancario       Ricardo Paredes   2        100.00        1
Devops              Andrea Salazar    1        100.00        1
Seguridad           Sofia Quispe      2        100.00        1
```

Cada equipo tiene un solo asignatario, por eso el porcentaje es 100 en todos los casos. El ticket sin asignatario (`TKT-00005`) se excluye.

### Conceptos

```sql
CTE
GROUP BY
SUM() OVER (PARTITION BY ...)
DENSE_RANK() OVER (PARTITION BY ... ORDER BY ...)
INNER JOIN
```

### SQL

```sql
WITH carga AS (
    SELECT
        t.id_equipo,
        t.id_asignatario,
        COUNT(*) AS tickets
    FROM modelado.Ticket t
    WHERE t.id_asignatario IS NOT NULL
    GROUP BY t.id_equipo, t.id_asignatario
),
ranking AS (
    SELECT
        *,
        SUM(tickets) OVER (PARTITION BY id_equipo) AS total_equipo,
        DENSE_RANK() OVER (PARTITION BY id_equipo ORDER BY tickets DESC) AS ranking
    FROM carga
)
SELECT
    e.descripcion               AS Equipo,
    u.nombre + ' ' + u.apellido AS Asignatario,
    r.tickets                   AS Tickets,
    CAST(100.0 * r.tickets / r.total_equipo AS DECIMAL(5,2)) AS PctDelEquipo,
    r.ranking                   AS Ranking
FROM ranking r
INNER JOIN modelado.Equipo e  ON e.id_equipo  = r.id_equipo
INNER JOIN modelado.Usuario u ON u.id_usuario = r.id_asignatario
WHERE r.ranking = 1
ORDER BY e.descripcion, Asignatario;
```

---

# 🏆 PREGUNTA INTERESANTE — Challenge ⭐⭐⭐

## Caso: "¿Estamos cumpliendo los SLA de atención?"

La gerencia de TI pregunta:

> **"¿Qué equipos y qué prioridades están incumpliendo los tiempos de resolución, y dónde se concentra el problema?"**

No se entrega la consulta: hay que investigarlo con la base de datos.

### Reglas de negocio (SLA)

```text
Prioridad   Tiempo máximo de resolución
---------   ---------------------------
Crítica      4 horas
Alta         8 horas
Media       24 horas
Baja        72 horas
```

```text
Tiempo de resolución = fecha de la transición a "Resuelto" - fecha de creación del ticket
Ticket sin transición a "Resuelto" = "Sin resolver"
Ticket con alguna transición a "Cancelado" = se excluye del análisis de SLA
```

### Preguntas a responder

1. ¿Cuál es el tiempo de resolución (en minutos) de cada ticket?
2. ¿Qué tickets **cumplen**, **incumplen** o están **sin resolver**?
3. ¿Qué porcentaje de cumplimiento tiene cada prioridad?
4. ¿Qué equipo concentra la mayor cantidad de incumplimientos y qué % del total representa?
5. ¿Qué usuario asignatario tiene más tickets sin resolver?
6. ¿Existe concentración? ¿Un solo equipo explica más de la mitad de los problemas?

Resultado esperado (ejemplo de formato):

```text
Equipo           Prioridad  Tickets  Cumplen  Incumplen  SinResolver  %Cumplimiento  %SobreTotalIncumplimientos
---------------  ---------  -------  -------  ---------  -----------  -------------  --------------------------
Canales Digitales Crítica   ...      ...      ...        ...          ...            ...
...
```

### Conceptos

```sql
CTE (varias encadenadas)
LEFT JOIN
CASE
DATEDIFF()
GROUP BY
SUM() OVER()
ROW_NUMBER() / RANK()
Subconsultas
```

### SQL

**Paso 1 — Base de SLA por ticket** (se guarda en una tabla temporal para reutilizarla)

```sql
DROP TABLE IF EXISTS #sla;

WITH resolucion AS (
    SELECT id_ticket, MIN(fecha) AS fecha_resolucion
    FROM modelado.Transicion
    WHERE id_transicion_despues = 5          -- 5 = Resuelto
    GROUP BY id_ticket
),
base AS (
    SELECT
        t.id_ticket,
        t.codigo_ticket,
        t.id_equipo,
        t.id_asignatario,
        t.id_prioridad,
        p.descripcion AS prioridad,
        CASE t.id_prioridad
            WHEN 1 THEN 4  * 60
            WHEN 2 THEN 8  * 60
            WHEN 3 THEN 24 * 60
            WHEN 4 THEN 72 * 60
        END AS sla_minutos,
        DATEDIFF(MINUTE, t.fecha, r.fecha_resolucion) AS minutos_resolucion
    FROM modelado.Ticket t
    INNER JOIN modelado.Prioridad p ON p.id_prioridad = t.id_prioridad
    LEFT JOIN resolucion r          ON r.id_ticket = t.id_ticket
    WHERE NOT EXISTS (                       -- 7 = Cancelado
        SELECT 1
        FROM modelado.Transicion c
        WHERE c.id_ticket = t.id_ticket
          AND c.id_transicion_despues = 7
    )
)
SELECT
    *,
    CASE
        WHEN minutos_resolucion IS NULL         THEN 'Sin resolver'
        WHEN minutos_resolucion <= sla_minutos  THEN 'Cumple'
        ELSE 'Incumple'
    END AS resultado
INTO #sla
FROM base;
```

**Paso 2 — Preguntas 1 y 2: resultado por ticket**

```sql
SELECT
    codigo_ticket,
    prioridad,
    sla_minutos,
    minutos_resolucion,
    resultado
FROM #sla
ORDER BY id_prioridad, codigo_ticket;
```

**Paso 3 — Preguntas 3 y 4: cumplimiento por equipo y prioridad**

```sql
SELECT
    e.descripcion AS Equipo,
    s.prioridad   AS Prioridad,
    COUNT(*)      AS Tickets,
    SUM(CASE WHEN s.resultado = 'Cumple'       THEN 1 ELSE 0 END) AS Cumplen,
    SUM(CASE WHEN s.resultado = 'Incumple'     THEN 1 ELSE 0 END) AS Incumplen,
    SUM(CASE WHEN s.resultado = 'Sin resolver' THEN 1 ELSE 0 END) AS SinResolver,
    CAST(100.0 * SUM(CASE WHEN s.resultado = 'Cumple' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,2)) AS PctCumplimiento,
    CAST(100.0 * SUM(CASE WHEN s.resultado = 'Incumple' THEN 1 ELSE 0 END)
         / NULLIF(SUM(SUM(CASE WHEN s.resultado = 'Incumple' THEN 1 ELSE 0 END)) OVER (), 0)
         AS DECIMAL(5,2)) AS PctSobreTotalIncumplimientos
FROM #sla s
LEFT JOIN modelado.Equipo e ON e.id_equipo = s.id_equipo
GROUP BY e.descripcion, s.id_prioridad, s.prioridad
ORDER BY s.id_prioridad, Incumplen DESC;
```

**Paso 4 — Pregunta 5: asignatarios con más tickets sin resolver**

```sql
SELECT
    u.nombre + ' ' + u.apellido AS Asignatario,
    COUNT(*)                    AS TicketsSinResolver,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS Ranking
FROM #sla s
INNER JOIN modelado.Usuario u ON u.id_usuario = s.id_asignatario
WHERE s.resultado = 'Sin resolver'
GROUP BY u.nombre, u.apellido
ORDER BY Ranking;
```

**Paso 5 — Pregunta 6: concentración de problemas por equipo**

Problema = ticket que no cumple (`Incumple` + `Sin resolver`).

```sql
WITH por_equipo AS (
    SELECT
        e.descripcion AS Equipo,
        COUNT(*)      AS Problemas
    FROM #sla s
    LEFT JOIN modelado.Equipo e ON e.id_equipo = s.id_equipo
    WHERE s.resultado <> 'Cumple'
    GROUP BY e.descripcion
)
SELECT
    Equipo,
    Problemas,
    CAST(100.0 * Problemas / SUM(Problemas) OVER () AS DECIMAL(5,2)) AS PctDelTotal,
    CAST(100.0 * SUM(Problemas) OVER (ORDER BY Problemas DESC, Equipo
                                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
         / SUM(Problemas) OVER () AS DECIMAL(5,2)) AS PctAcumulado
FROM por_equipo
ORDER BY Problemas DESC, Equipo;
```

### Resultado con los datos actuales

Se analizan 7 tickets (los cancelados `TKT-00006` y `TKT-00009` quedan fuera).

```text
Resultado por ticket (Paso 2)
CodigoTicket  Prioridad  SLA(min)  Resolucion(min)  Resultado
------------  ---------  --------  ---------------  ------------
TKT-00001     Critica    240       405              Incumple
TKT-00003     Critica    240       1735             Incumple
TKT-00008     Critica    240       1020             Incumple
TKT-00002     Alta       480       110              Cumple
TKT-00007     Alta       480       NULL             Sin resolver
TKT-00004     Media      1440      NULL             Sin resolver
TKT-00005     Baja       4320      NULL             Sin resolver

Cumplimiento por prioridad: Critica 0%, Alta 50%, Media 0%, Baja 0%.
Asignatarios con tickets sin resolver (Paso 4): Jorge Ramirez 1, Sofia Quispe 1 (Ranking 1 ambos).
TKT-00005 no tiene asignatario, por eso no aparece en el Paso 4.

Concentracion de problemas (Paso 5)
Equipo             Problemas  PctDelTotal  PctAcumulado
-----------------  ---------  -----------  ------------
Cloud              2          33.33        33.33
Seguridad          2          33.33        66.67
Canales Digitales  1          16.67        83.33
Core Bancario      1          16.67        100.00
```

Ningún equipo explica por sí solo más de la mitad de los problemas; Cloud y Seguridad juntos concentran el 66.67%.
