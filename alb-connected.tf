# This template is designed for deploying an ALB from the Morpheus UI. 

module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"
  load_balancer_type = "application"
  internal = true
  name = "<%=instance.name%>"
  vpc_id = var.vpc
  subnets = [local.subnets[0], local.subnets[1]]
  security_groups = [var.security_groups]
  target_groups = [{ 
    name = "<%=instance.name%>-80"
    backend_protocol = "HTTP" 
    backend_port = 80 
    target_type = "instance" 
    stickiness = { 
      type = "lb_cookie" 
    } 
    health_check = { 
      enabled = true 
      interval = 10 
      path = "/ping" 
      matcher = 200 
      protocol = "HTTP" 
      healthy_threshold = 3 
      unhealthy_threshold = 3 
      timeout = 6 
    }
    tags = {
      Name = "<%=instance.name%>"
    }
  }
  ]

  http_tcp_listeners = [{
    port = 80
    protocol = "HTTP"
    target_group_index = 0
  }]
}

resource "aws_lb_target_group_attachment" "target_group_attachment_http" {
  count = local.ec2_instance_count
  target_group_arn = module.alb.target_group_arns[0]
  target_id = aws_instance.ec2[count.index].id
}
