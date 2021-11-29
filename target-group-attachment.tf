# This template is designed for implementing a target group attachment from the Morpheus UI. 

resource "aws_lb_target_group_attachment" "attachment" {
  target_group_arn = "<%=customOptions.ot_target_group_arn%>"
  target_id = "<%=customOptions.ot_target_id%>"
}
