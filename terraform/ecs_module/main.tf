resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name     = var.cluster_name
    SRE_TASK = var.sre_task_owner
  }
}

resource "aws_cloudwatch_log_group" "group" {
  name              = "/ecs/${var.cluster_name}/${var.service_name}"
  retention_in_days = var.log_retention_days

  tags = {
    Name     = "${var.cluster_name}-${var.service_name}-logs"
    SRE_TASK = var.sre_task_owner
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.cluster_name}-${var.service_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name     = "${var.cluster_name}-${var.service_name}-execution-role"
    SRE_TASK = var.sre_task_owner
  }
}

resource "aws_iam_role_policy" "ecs_task_execution_cloudwatch" {
  name = "${var.cluster_name}-${var.service_name}-cloudwatch-logs"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.group.arn}:*"
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.cluster_name}-${var.service_name}-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name     = "${var.cluster_name}-${var.service_name}-task-role"
    SRE_TASK = var.sre_task_owner
  }
}

resource "aws_ecs_task_definition" "definition" {
  family                   = "${var.cluster_name}-${var.service_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "APP_ENV"
          value = var.app_environment
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.group.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = var.container_name
        }
      }
    }
  ])

  tags = {
    Name     = "${var.cluster_name}-${var.service_name}-task"
    SRE_TASK = var.sre_task_owner
  }
}

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.definition.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }

  tags = {
    Name     = var.service_name
    SRE_TASK = var.sre_task_owner
  }
}
