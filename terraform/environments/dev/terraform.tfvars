cluster_name = "decenter-app-cluster"
service_name = "decenter-web-service"

container_name   = "decenter-app"
container_image  = "ghcr.io/kuzmanikola/decenter-task:393f612" 
container_cpu    = 256                 
container_memory = 512                 
container_port   = 80                  

desired_count = 1

app_environment = "dev"

subnets = [
  "subnet-06a0d88a081ef8b8f"
]

security_groups = [
  "sg-0bf64e8077ae2608e"
]

assign_public_ip = true

aws_region = "us-east-1"

log_retention_days = 30

sre_task_owner = "Nikola Kuzman"