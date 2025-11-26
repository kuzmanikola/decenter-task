module "ecs_cluster" {
  source = "./ecs_module"

  cluster_name = var.cluster_name
  service_name = var.service_name

  container_name   = var.container_name
  container_image  = var.container_image
  container_cpu    = var.container_cpu
  container_memory = var.container_memory
  container_port   = var.container_port

  desired_count = var.desired_count

  app_environment = var.app_environment

  subnets          = var.subnets
  security_groups  = var.security_groups
  assign_public_ip = var.assign_public_ip

  aws_region         = var.aws_region
  log_retention_days = var.log_retention_days

  sre_task_owner = var.sre_task_owner
}
