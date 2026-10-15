# 🎫 Laboratorio SQL Server — ITSM (Gestión de Tickets)

Preguntas basadas en el modelo `modelado` (Azure SQL), replicando la dificultad y los comandos de cada nivel del laboratorio de ejemplo.

Las soluciones en SQL están en [respuesta.md](./respuesta.md).


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

---

# 🟣 NIVEL PROGRAMABILIDAD — Procedimientos y Funciones

> Las preguntas 7, 8 y 9 se resuelven en orden: la 9 reutiliza los objetos creados en la 8.
> Los ejemplos de ejecución usan `BEGIN TRAN ... ROLLBACK` para no alterar los datos de las demás preguntas.

## Pregunta 7 — Procedimiento almacenado: cambiar el estado de un ticket con validaciones

Hoy cualquier usuario puede insertar directamente en `modelado.Transicion`. Crear el procedimiento `modelado.usp_CambiarEstadoTicket` que registre un cambio de estado de forma controlada.

Parámetros:

```text
@id_ticket        INT
@id_usuario       INT       (quien realiza el cambio)
@id_estado_nuevo  INT
@fecha            DATETIME  (opcional; si no se envía, usar la fecha actual)
```

Reglas:

```text
1. El ticket debe existir y estar activo (estado = 1).         -> error 50001
2. El usuario debe existir y estar activo.                      -> error 50002
3. El estado actual del ticket es el destino de su última transición;
   si no tiene transiciones, el estado actual es 1 (Nuevo).
4. El cambio (estado actual -> estado nuevo) debe existir y estar activo
   en TransicionPermitida.                                      -> error 50003
5. El id_transicion no es IDENTITY: debe calcularse como MAX + 1 sin que dos
   ejecuciones simultáneas obtengan el mismo valor.
6. Al registrar el cambio, el procedimiento devuelve la fila insertada.
```

Probar dentro de una transacción que luego se revierte:

1. `TKT-00005` (id 5, estado actual *Nuevo*) pasa a *Asignado* (id 2), realizado por la usuaria 2 el `2026-10-06 09:00`.
2. `TKT-00004` (id 4, estado actual *En Progreso*) intenta pasar directamente a *Cerrado* (id 6).

Resultado esperado:

```text
-- Llamada 1 (cambio válido): devuelve la fila insertada
id_transicion  id_ticket  id_usuario  fecha                    id_transicion_antes  id_transicion_despues  estado
-------------  ---------  ----------  -----------------------  -------------------  ---------------------  ------
29             5          2           2026-10-06 09:00:00.000  1                    2                      1

-- Llamada 2 (cambio no permitido): se captura el error
ErrorNumero  ErrorMensaje
-----------  ----------------------------------------------------------------------------------
50003        La transicion solicitada no esta permitida desde el estado actual del ticket.

-- Después del ROLLBACK
TotalTransiciones
-----------------
28
```

### Conceptos

```sql
CREATE OR ALTER PROCEDURE
Parámetros con valor por defecto
THROW
INSERT ... SELECT con OUTPUT inserted.*
WITH (UPDLOCK, HOLDLOCK)
TRY ... CATCH
BEGIN TRAN / ROLLBACK
```

## Pregunta 8 — Funciones: estado de un ticket en una fecha y SLA por prioridad

Hoy el cálculo del estado de un ticket y del SLA se repite con `CASE` y subconsultas en cada reporte. Centralizarlo en dos funciones escalares:

```text
modelado.fn_EstadoEnFecha(@id_ticket INT, @fecha_corte DATETIME) RETURNS VARCHAR(20)
    Devuelve la descripción del estado del ticket en esa fecha:
    el destino de su última transición con fecha <= @fecha_corte.
    Si aún no tenía transiciones, devuelve 'Nuevo'.

modelado.fn_SlaMinutos(@id_prioridad INT) RETURNS INT
    Crítica = 240, Alta = 480, Media = 1440, Baja = 4320 (minutos).
```

Usarlas para listar los tickets **aún abiertos** al `2026-10-08` (estado distinto de *Cerrado* y *Cancelado*), con su SLA en minutos y en horas. Ordenar del SLA más corto al más largo.

Resultado esperado:

```text
CodigoTicket  Prioridad  EstadoAlCorte  SlaMinutos  SlaHoras
------------  ---------  -------------  ----------  --------
TKT-00003     Critica    Resuelto       240         4
TKT-00007     Alta       En Espera      480         8
TKT-00004     Media      En Progreso    1440        24
TKT-00005     Baja       Nuevo          4320        72
```

`TKT-00001`, `TKT-00002` y `TKT-00008` están *Cerrado*, y `TKT-00006` y `TKT-00009` están *Cancelado*, por eso no aparecen. `TKT-00003` sigue abierto porque está *Resuelto* pero nunca se cerró.

### Conceptos

```sql
CREATE OR ALTER FUNCTION (escalar)
SELECT TOP (1) @variable = ...
ORDER BY dentro de la función
ISNULL()
CASE
INNER JOIN
WHERE con función escalar
```

## Pregunta 9 — Procedimiento + funciones: tablero de riesgo de SLA a una fecha de corte

La gerencia quiere un tablero que, para cualquier fecha de corte, muestre qué tickets abiertos están **a punto de vencer** o **ya vencieron** su SLA, sin esperar a que se resuelvan.

Crear el procedimiento `modelado.usp_TableroRiesgoSLA` que reutilice `fn_EstadoEnFecha` y `fn_SlaMinutos` de la pregunta 8:

```text
@fecha_corte      DATETIME        fecha de análisis
@id_equipo        INT = NULL      si es NULL, analiza todos los equipos
@total_vencidos   INT OUTPUT      cantidad de tickets con semáforo 'Vencido'
```

Reglas:

```text
Solo se analizan tickets creados hasta la fecha de corte (fecha <= @fecha_corte).
Solo tickets abiertos a esa fecha: estado distinto de Resuelto, Cerrado y Cancelado.
MinTranscurridos = minutos entre la creación del ticket y la fecha de corte.
PctConsumido     = MinTranscurridos / SlaMin * 100  (2 decimales)

Semáforo:
    PctConsumido >= 100  -> Vencido
    PctConsumido >= 75   -> En riesgo
    en otro caso         -> En tiempo
```

Devolver el resultado ordenado del mayor al menor `PctConsumido`.

Ejecutar con `@fecha_corte = '2026-10-03 16:00'`, primero para todos los equipos y luego solo para Cloud (id 6).

Resultado esperado:

```text
-- Todos los equipos
CodigoTicket  Equipo             Prioridad  EstadoAlCorte  SlaMin  MinTranscurridos  PctConsumido  Semaforo
------------  -----------------  ---------  -------------  ------  ----------------  ------------  ---------
TKT-00004     Seguridad          Media      En Progreso    1440    2980              206.94        Vencido
TKT-00007     Cloud              Alta       En Espera      480     470               97.92         En riesgo
TKT-00005     Canales Digitales  Baja       Nuevo          4320    1860              43.06         En tiempo

TotalVencidos
-------------
1

-- Solo Cloud (id 6)
CodigoTicket  Equipo  Prioridad  EstadoAlCorte  SlaMin  MinTranscurridos  PctConsumido  Semaforo
------------  ------  ---------  -------------  ------  ----------------  ------------  ---------
TKT-00007     Cloud   Alta       En Espera      480     470               97.92         En riesgo

TotalVencidos
-------------
0
```

A esa fecha, `TKT-00008` aún no existe (se crea a las 16:30), `TKT-00003` ya está *Resuelto*, `TKT-00001` y `TKT-00002` están *Cerrado* y `TKT-00006` está *Cancelado*.

### Conceptos

```sql
CREATE OR ALTER PROCEDURE
Parámetro OUTPUT
Parámetro opcional con filtro (@id_equipo IS NULL OR ...)
Funciones escalares dentro de CTE
CTE encadenadas
SELECT ... INTO #temporal
DATEDIFF()
CASE
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
