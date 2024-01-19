resource "aws_ecs_cluster" "this" {
  name = "ecs-cluster"
}
resource "aws_ecs_task_definition" "this" {
  family                   = "nginx"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc" #auto assigns ENI
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions    = <<EOF
[
  {
    "portMappings": [
      {
        "hostPort": 80,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "cpu": 512,
    "environment": [
      {
        "name": "ECS_ENABLE_CONTAINER_METADATA",
        "value": "true"
      }
    ],
    "memory": 1024,
    "image": "public.ecr.aws/docker/library/httpd:latest",
    "essential": true,
    "name": "fargate-app",
    "entryPoint": [
      "sh",
      "-c"
    ],
    "command" : [
      "apt-get update && apt-get install -y curl && apt-get install -y jq && apt-get install -y sed && tARN=$(curl $${ECS_CONTAINER_METADATA_URI_V4}/task | jq --raw-output '.TaskARN') && cARN=$(curl $${ECS_CONTAINER_METADATA_URI_V4} | jq --raw-output '.ContainerARN') && AZ=$(curl $${ECS_CONTAINER_METADATA_URI_V4}/task | jq --raw-output '.AvailabilityZone')&& echo '<html> <head> <title>Wanted: Lost Task</title> <style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center><center><h1>My Name is Task, I come from the Planet of Fargate. </h1></center> <h2>My Home is in Zone of AZID</h2> <h3> Please find me. </h3> <p> My TaskARN : tARN </p> <p> My ContainerARN : cARN </p> </div></body></html> <p></p> <center><h1>It is so dark out here, please FIND ME. </h1></center> ' > /usr/local/index.txt && sed -i -e \"s@tARN@$tARN@\" -e \"s@cARN@$cARN@\" -e \"s@AZID@$AZ@\" /usr/local/index.txt && cp /usr/local/index.txt /usr/local/apache2/htdocs/index.html && httpd-foreground"
    ],
    "linuxParameters": 
      {
      "initProcessEnabled": true
      }
  }
]
EOF
}
resource "aws_security_group" "ecs_tasks" {
  name   = "http-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
#policies and roles 
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
#ecs task role 
resource "aws_iam_role" "ecs_task_role" {
  name = "nginx-task-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ecs-ssm-role-policy-attach" {
  role       = aws_iam_role.ecs_task_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_ecs_service" "this" {
  name                               = "fargate-service"
  cluster                            = aws_ecs_cluster.this.id
  task_definition                    = aws_ecs_task_definition.this.arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  enable_execute_command             = true
  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = module.vpc.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "fargate-app"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

#toDo: 1. Container Image erstellen mit cUrl, jq und sed --> 2. in ECR/DockerHub/... hochladen --> 3. Img anpassen 
/*
#ecr for container image
resource "aws_ecr_repository" "this" {
  name                 = "nginximage"
  image_tag_mutability = "MUTABLE" #necessary to put a latest tag on the most recent image
}
#keep last 10 images in ecr repository expire rest
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}
*/

