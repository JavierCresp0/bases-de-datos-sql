# 🗃️ Bases de Datos · Proyecto completo en Oracle SQL + PL/SQL

Proyecto completo de la asignatura **Bases de Datos** (3º curso) que cubre todo el ciclo de diseño e implementación de una base de datos relacional: desde el **modelo Entidad-Relación** hasta la **lógica de negocio en PL/SQL** (procedimientos, funciones y triggers).

## 🏛️ Caso de estudio

Gestión de un **club deportivo** que incluye:
- 🏢 **Salas** y **pistas** del club
- 👤 **Abonados** y **trabajadores** (monitores incluidos)
- 🏋️ **Clases** impartidas y asistencias
- 📅 **Reservas** de pistas con control de solapamientos
- 🎟️ **Descuentos** por abonado

## 📁 Estructura

```
├── Memoria.pdf                  ← memoria completa del proyecto
├── diagramas/
│   ├── Diagrama-ER.png          ← diagrama Entidad-Relación
│   └── Diagrama-ER.drawio       ← fuente editable
├── scripts/
│   ├── crearbd.sql              ← DDL: tablas y restricciones
│   ├── datos.sql                ← DML: datos de prueba
│   ├── modificaciones.sql       ← ALTER TABLE: evolución del esquema
│   └── borrar.sql               ← limpieza de la BD
└── plsql/
    ├── bloques.sql              ← bloques anónimos PL/SQL
    ├── funciones/
    │   ├── TOTAL_RESERVAS_PISTA.sql
    │   ├── PISTAS_RESERVA_FECHA.sql
    │   └── TOTAL_GASTO_SALARIOS.sql
    ├── procedimientos/
    │   ├── REGISTRAR_RESERVA.sql        ← alta de reservas con validaciones
    │   ├── LISTAR_CLASES_MONITOR.sql
    │   ├── SUBIR_SUELDO_TRABAJADOR.sql
    │   └── MARCAR_DESCUENTO_USADO.sql
    └── triggers/
        ├── SOLAPA_RESERVAS.sql          ← impide reservas solapadas (BEFORE INSERT)
        └── NUMCLASES.sql                ← mantiene contador de clases por monitor
```

## 🛠️ Tecnologías

![Oracle](https://img.shields.io/badge/Oracle-F80000?style=flat&logo=oracle&logoColor=white)
![PL/SQL](https://img.shields.io/badge/PL%2FSQL-F80000?style=flat)

- **Oracle SQL** (DDL + DML)
- **PL/SQL** (procedimientos almacenados, funciones, triggers, bloques anónimos)
- **drawio** para el modelado E-R

## 🎯 Conceptos aplicados

### Diseño
- Modelo Entidad-Relación (E-R) y paso al modelo relacional
- Claves primarias/foráneas y restricciones de integridad (`NOT NULL`, `UNIQUE`, `CHECK`)
- Evolución del esquema con `ALTER TABLE`

### PL/SQL
- **Procedimientos almacenados** con validaciones y `RAISE_APPLICATION_ERROR`
- **Funciones** con parámetros anclados a tipos de columna (`%TYPE`)
- **Triggers** `BEFORE INSERT` / `FOR EACH ROW` para reglas de negocio
- Cursores y bloques anónimos

## 🚀 Cómo ejecutar

Conéctate a una base de datos Oracle (SQL*Plus, SQL Developer, etc.) y ejecuta en orden:

```sql
@scripts/crearbd.sql
@scripts/datos.sql
@scripts/modificaciones.sql
-- Lógica de negocio
@plsql/triggers/SOLAPA_RESERVAS.sql
@plsql/triggers/NUMCLASES.sql
@plsql/procedimientos/REGISTRAR_RESERVA.sql
-- ... (resto de procedimientos y funciones)
```

Para empezar de cero: `@scripts/borrar.sql`

## 📊 Vista previa del modelo

![Diagrama Entidad-Relación](diagramas/Diagrama-ER.png)

---

📌 *Proyecto del 3º curso del Grado en Ingeniería Informática — Universidad Miguel Hernández.*
