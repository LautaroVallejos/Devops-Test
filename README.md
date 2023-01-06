# Devops-Test by Lautaro Vallejos
La Infraestructura consta de **7 módulos** y **un archivo de variables**:

1. **Provider.tf**: Configuración del proveedor (AWS en este caso).
2. **State.tf**: Documento de configuración del backend de terraform, encargado de proteger el .tfstate y setear las llaves del bucket de S3. 
3. **IAM.tf**: En este módulo se configura el usuario, el rol, los permisos y la policy que luego utilizara la instancia de EC2, la tabla de Dynamo y el bucket de S3.
4. **VPC.tf**: Aquí se setea toda la red compuesta para que los módulos se comuniquen entre sí. Además de configurar las rutas, asociaciones y security groups.
5. **DynamoDB.tf**: Este archivo crea una tabla de Dynamo que resultara importante para el funcionamiento del bucket de S3.
6. **S3.tf**: Creación del bucket y seteo de accesos (ACL).
7. **EC2.tf**: En este último archivo se configura la instancia de ec2, tanto como su ami, su conexión y la propia installación de NGINX.

8. *Variables.tf*: Este documento declara las variables que son utilizadas en algunas partes del código. *De cualquier manera, para que funcione la infraestructura se deben declarar sus valores en un archivo terraform.tfvars, además de configurar el aws cli (`aws configure`).*