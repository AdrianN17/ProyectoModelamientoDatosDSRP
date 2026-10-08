# Caso Propuesto: Sistema de Gestión de Tickets ITSM

Resumen ejecutivo del proyecto.

---

## Contexto: Banco Andino

**Banco Andino** es una entidad financiera ficticia con más de 25 años de trayectoria, presencia en todo el país y millones de clientes que cada día consultan sus saldos, transfieren dinero y pagan servicios desde la **banca móvil**, la **banca web** y los cajeros automáticos. Detrás de esa experiencia trabajan cientos de profesionales de tecnología, organizados en equipos especializados: Canales Digitales, Core Bancario, Seguridad, Devops y Cloud.

En los últimos años el banco creció rápido. Migró parte de su plataforma a la nube, lanzó nuevas funcionalidades en sus aplicaciones y amplió su equipo de TI. Con ese crecimiento aumentaron también las solicitudes y los incidentes: accesos que no funcionan, cambios que deben planificarse, fallas que afectan a clientes. Hasta hoy, todo eso llega por **correos y mensajes** que se pierden entre bandejas de entrada.

### La decisión

La gerencia de TI decide dejar de depender de correos y mensajes sueltos, y **centralizar la gestión de solicitudes e incidentes en un sistema único** donde cada caso quede registrado, asignado, clasificado y con todo su historial a la vista. Este proyecto nace para hacerlo realidad.

---

## 1. Introducción y solución

Se propone implementar un sistema centralizado para registrar, organizar y dar seguimiento al ciclo de vida de las solicitudes e incidentes de TI.

- **Modelo:** relacional, garantizando integridad referencial.
- **Plataforma:** Microsoft Azure SQL Database.
- **Alcance:** gestión de tickets ITSM, comentarios y transiciones.
- **Fuera de alcance:** subtareas y varios equipos resolutores por ticket.

## 2. Problemática actual

La gestión mediante correos y mensajes genera descentralización y falta de visibilidad en:

- Identificación de solicitantes y responsables asignados.
- Clasificación de impacto, prioridad y servicios afectados.
- Trazabilidad de estados, cambios e historial de atención.
- Tiempos de respuesta y registro de comentarios.

## 3. Objetivo general

Diseñar e implementar un sistema ITSM integral para **clasificar, atender y auditar solicitudes e incidentes**, asegurando la trazabilidad completa en cada etapa de su ciclo de vida.

## 4. Objetivos específicos

- **Gestión de accesos:** usuarios, roles y asignaciones.
- **Infraestructura:** catálogo de servicios e inventario de equipos.
- **Operación:** tipificación, priorización y comentarios en tickets.
- **Control:** historial de transiciones y comentarios.

---

## 5. Catálogos del sistema

Datos de negocio con los que se puebla el sistema inicialmente.

### Categorías de atención

Clasificación temática de los incidentes:

- Aplicaciones y Base de Datos
- Redes y Comunicaciones
- Seguridad de la Información
- Accesos y Permisos
- Infraestructura

### Tipos de ticket

Tipificación según impacto y flujo:

- **Incidente:** falla o interrupción.
- **Requerimiento:** solicitud de servicio.
- **Problema:** causa raíz recurrente.
- **Cambio:** modificación planeada.

### Equipos solucionadores

Unidades operativas de atención:

- Canales Digitales
- Core Bancario
- Seguridad
- Devops
- Cloud

### Catálogo de servicios

Servicios de TI soportados:

- Aplicación Banca Móvil
- Aplicación Banca Web
- Plataforma Core Bancario
- Azure
- Onpremise
- Accesos

### Ciclo de vida (estados)

Etapas de gestión del ticket:

- **Fase inicial:** Nuevo, Asignado.
- **Atención:** En Progreso, En Espera.
- **Cierre:** Resuelto, Cerrado.
- **Excepción:** Cancelado.

### Roles de usuario

Perfiles con acceso al sistema:

- **Software Engineer:** resolutor técnico.
- **Team Leader:** gestión y asignación.
- **Operador:** registro y monitoreo.
- **Proveedor:** soporte externo.

---

## 6. Reglas de negocio

### Reglas de transición de estados

Definen las rutas permitidas para garantizar la trazabilidad y el control de calidad operativa.

**Flujo operativo secuencial:**

| Inicio | Atención | Cierre |
|---|---|---|
| Nuevo → Asignado | En Progreso / En Espera | Resuelto → Cerrado |

- **Inicio:** un ticket *Nuevo* debe pasar obligatoriamente a *Asignado*.
- **Atención:** desde *Asignado* se inicia la solución (*En Progreso*) o se suspende temporalmente (*En Espera*).
- **Pausa y reasignación:** desde *En Espera* se puede retomar la atención (*En Progreso*) o devolver a cola (*Asignado*).
- **Cierre:** la resolución (*Resuelto*) solo proviene de *En Progreso* y habilita el paso a *Cerrado*.

**Regla especial de cancelación:** cualquier ticket activo en estado *Nuevo*, *Asignado*, *En Progreso*, *En Espera* o *Resuelto* puede ser interrumpido y pasar a *Cancelado* en cualquier momento.

### Matriz de cobertura servicio – equipo

Restringe el enrutamiento de tickets asignando explícitamente qué equipos atienden cada servicio.

| Equipo | Servicios que atiende |
|---|---|
| Canales Digitales | Aplicación Banca Móvil, Aplicación Banca Web |
| Core Bancario | Plataforma Core Bancario, Onpremise |
| Seguridad | Accesos, Azure |
| DevOps | Onpremise, Azure |
| Cloud | Azure |
