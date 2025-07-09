resource "aws_ecs_cluster" "ecs" {
    name = "${terraform.workspace}-app-cluster"
}



resource "aws_lb" "app_lb" {
  name               = "${terraform.workspace}-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.sn1.id, aws_subnet.sn2.id, aws_subnet.sn3.id]
}


resource "aws_lb_target_group" "app_tg" {
  name        = "${terraform.workspace}-app-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    path                = "/api/health"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}


resource "aws_ecs_service" "service" {

    name = "${terraform.workspace}-app-service"
    cluster = aws_ecs_cluster.ecs.id
    launch_type = "FARGATE"
    enable_execute_command = true

    deployment_maximum_percent = 200
    deployment_minimum_healthy_percent = 100
    desired_count = lookup(var.environment_configs[terraform.workspace], "desired_count", 1)
    task_definition = aws_ecs_task_definition.td.arn

    network_configuration {

      assign_public_ip = true
      security_groups = [ aws_security_group.sg.id ]
      subnets = [ aws_subnet.sn1.id , aws_subnet.sn2.id , aws_subnet.sn3.id ]

    }
  
    load_balancer {
      target_group_arn = aws_lb_target_group.app_tg.arn
      container_name   = "app"
      container_port   = 80
    }
}


resource "aws_ecs_task_definition" "td" {

    container_definitions = jsonencode([{

        name = "app"
        image = "509924243707.dkr.ecr.sa-east-1.amazonaws.com/${terraform.workspace}-app-repo"
        environment = [
            {
                name = "DB_HOST",
                value = aws_db_instance.application_db.endpoint
            },
            {
                name = "DB_USER",
                value = var.db_username
            },
            {
                name = "DB_PASSWORD",
                value = var.db_password
            },
            {
                name = "DB_NAME",
                value = "${terraform.workspace}_applicationDB"
            },
            {
                name = "ENVIRONMENT",
                value = terraform.workspace
            }
        ]
        cpu = 256
        memory = 512
        essential = true
        portMappings = [
            {

                containerPort = 80 //8080?
                hostPort = 80

            }
        ]
    }
])

    family = "${terraform.workspace}-app"
    requires_compatibilities = [ "FARGATE" ]

    cpu = "256"
    memory = "512"
    network_mode = "awsvpc"   
    task_role_arn = "arn:aws:iam::509924243707:role/for_medcloud"
    execution_role_arn = "arn:aws:iam::509924243707:role/for_medcloud"
  
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${terraform.workspace}-ecs-task-execution-role"

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
}