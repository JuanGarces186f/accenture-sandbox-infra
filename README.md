# Accenture Sandbox Infrastructure - GCP

Infraestructura como código (IaC)  como sandbox para prueba tecnica  Accenture usando Terraform y Google Cloud Platform.

> ⚠️ **Nota sobre acceso público (solo para fines de revisión técnica)**
>
> La base de datos (Cloud SQL) y el servicio de Cloud Run han sido configurados con acceso público con el único fin de facilitar la revisión y evaluación de esta prueba técnica. Tengo pleno conocimiento de que en un ambiente productivo real esto representa una mala práctica de seguridad y no debe hacerse de esta forma.
>
> La configuración ideal para un entorno productivo incluye:
> - Crear una **VPC privada** y restringir el acceso a Cloud SQL y Cloud Run dentro de la red privada, evitando cualquier exposición pública.
> - Para Cloud Run, exponer el servicio únicamente a través de un **API Gateway**, de modo que nunca sea accesible directamente desde internet.
>
> Esta decisión fue tomada deliberadamente para agilizar la entrega dentro de los tiempos disponibles y facilitar la evaluación por parte del equipo revisor.

## 📁 Estructura del Proyecto

```
accenture-sandbox-infra/
├── modules/
│   ├── artifact_registry/    # Módulo para Artifact Registry (imágenes Docker)
│   ├── cloud_run/
│   │   └── service_base/     # Módulo base reutilizable para servicios Cloud Run
│   ├── database/             # Módulo para Cloud SQL PostgreSQL
│   └── secrets/              # Módulo para gestión de secretos (Secret Manager)
├── environments/
│   └── prod/                  # Configuración ambiente desarrollo
└── README.md
```

## 🚀 Componentes de Infraestructura

### 1. Artifact Registry
- **Nombre**: `accenture-sandbox-backend-repo-prod`
- **Formato**: Docker
- **Propósito**: Almacenar imágenes de contenedores para microservicios en Cloud Run

### 2. Cloud SQL PostgreSQL
- **Instancia**: `accenture-sandbox-prod`
- **Versión**: PostgreSQL 17
- **Configuración**:
  - Tier: `db-f1-micro`
  - Almacenamiento: 10 GB SSD (con auto-incremento)
  - Zona: `us-central1-c`
  - Sin alta disponibilidad (zonal)
  - Copias de seguridad automáticas: Deshabilitadas

### 3. Cloud Run
- Módulo base en `modules/cloud_run/service_base` reutilizable por cualquier servicio
- Actualmente despliega el servicio `franquicias-service-prod`
- Configuración: 1 CPU, 512 MB de memoria, concurrencia 80
- Variables de entorno inyectadas: `DB_HOST`, `DB_NAME`, `DB_USER`, `SPRING_PROFILES_ACTIVE`
- Secrets de Secret Manager montados como variables de entorno (`DB_PASS`)

### 4. Secrets (Secret Manager)
- **Propósito**: Gestionar secretos sensibles de forma segura con Google Secret Manager
- **Secret actual**: `db-password-prod` — contraseña de la base de datos generada aleatoriamente por Terraform
- **IAM**: La cuenta de servicio de Compute Engine tiene el rol `secretmanager.secretAccessor` para que Cloud Run pueda leer los secretos

### 5. APIs habilitadas automáticamente por Terraform
- `artifactregistry.googleapis.com`
- `sqladmin.googleapis.com`
- `run.googleapis.com`
- `secretmanager.googleapis.com`
- `compute.googleapis.com`
- `servicecontrol.googleapis.com`
- `servicemanagement.googleapis.com`
- `identitytoolkit.googleapis.com`


## 🆕 Pasos para Crear un Nuevo Ambiente

Para crear un nuevo ambiente (por ejemplo, `prod`), sigue estos pasos:

1. **Crear un proyecto en GCP**
  - Ve a la consola de Google Cloud y crea un nuevo proyecto.

2. **Duplicar la carpeta del ambiente**
  - Copia la carpeta `environments/prod/` a `environments/<ambiente>/` y ajusta los valores en `terraform.tfvars` (principalmente `project_id` y `environment`).

3. **Habilitar la API Cloud Resource Manager manualmente**
  - Este paso es obligatorio una única vez por proyecto antes de ejecutar Terraform, ya que Terraform no puede habilitarla sin tenerla ya activa:
    ```bash
    gcloud services enable cloudresourcemanager.googleapis.com
    ```

4. **Crear un bucket para el estado remoto de Terraform**
  - Crea un bucket en GCS para almacenar el estado de Terraform:
    ```bash
    gsutil mb -p <PROJECT_ID> gs://<BUCKET_NAME>
    ```
  - Edita el bloque `backend "gcs"` en `environments/<ambiente>/main.tf` con el nombre del bucket creado.

5. **Crear una cuenta de servicio para Terraform**
  - Crea una cuenta de servicio con los roles **Editor** y **Administrador IAM** en el proyecto.
  - Descarga el archivo de credenciales JSON.

6. **Agregar el secret en GitHub Actions**
  - Sube el JSON de la cuenta de servicio como secret de GitHub Actions con el nombre `GCP_CREDENTIALS_<AMBIENTE>` (ej. `GCP_CREDENTIALS_PROD`).

7. **Actualizar los workflows de CI/CD**
  - Edita `.github/workflows/terraform.yml` y `.github/workflows/pr-checks.yml` para contemplar el nuevo ambiente según la rama correspondiente.

## 📋 Prerrequisitos

1. **Google Cloud SDK**
   ```bash
   # Instalar gcloud CLI
   # https://cloud.google.com/sdk/docs/install

   # Autenticarse
   gcloud auth application-default login
   ```

2. **Proyecto de GCP**
   - Tener un proyecto creado en GCP
   - Las siguientes APIs se habilitan **automáticamente mediante Terraform** (`apis.tf`):
     ```bash
     artifactregistry.googleapis.com
     sqladmin.googleapis.com
     run.googleapis.com
     secretmanager.googleapis.com
     compute.googleapis.com
     servicecontrol.googleapis.com
     servicemanagement.googleapis.com
     identitytoolkit.googleapis.com
     ```
   - Esta API debe habilitarse **manualmente una sola vez** por proyecto, ya que Terraform la necesita para poder gestionar cualquier recurso:
     ```bash
     gcloud services enable cloudresourcemanager.googleapis.com
     ```


## 🏗️ Extensión de Infraestructura

Para agregar más recursos o servicios:

1. Crea un nuevo módulo en `modules/` o reutiliza `modules/cloud_run/service_base` para nuevos servicios
2. Añade el módulo o recurso a `environments/prod/main.tf` (y al ambiente correspondiente cuando exista)
3. Configura las variables necesarias en `variables.tf` y `terraform.tfvars`

## 📝 Notas Importantes

- **Estado remoto**: El estado de Terraform se almacena en el bucket GCS `sandbox-terraform-state-prod` con el prefijo `terraform/state`
- **Contraseña de BD**: Se genera automáticamente con `random_password` en el root module y se almacena en Secret Manager
- **IAM**: La cuenta de servicio de Compute Engine recibe automáticamente el rol `secretmanager.secretAccessor` para que Cloud Run pueda leer los secretos
- **Costos**: La configuración actual usa recursos de bajo costo (`db-f1-micro`), con la finalidad de evitar costos para la prueba tecnica
- **Seguridad**: En producción, se consideraria siempre:
  - Habilitar Cloud SQL Proxy para conexiones seguras
  - Usar VPC peering para red privada
  - Habilitar copias de seguridad automáticas
  - Implementar alta disponibilidad
  - Usar Cloud Armor para protección DDoS
  - Utilizar api gateway para los servicios en CloudRun


