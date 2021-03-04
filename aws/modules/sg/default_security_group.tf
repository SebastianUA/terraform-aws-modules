#---------------------------------------------------
# AWS security group (default)
#---------------------------------------------------
resource "aws_default_security_group" "default_security_group" {
  count = var.enable_default_security_group ? 1 : 0

  vpc_id = var.default_security_group_vpc_id

  dynamic "ingress" {
    iterator = ingress
    for_each = length(keys(var.default_security_group_ingress)) > 0 ? [var.default_security_group_ingress] : []

    content {
      protocol  = lookup(ingress.value, "protocol", null)
      from_port = lookup(ingress.value, "from_port", null)
      to_port   = lookup(ingress.value, "to_port", null)

      cidr_blocks      = lookup(ingress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(ingress.value, "prefix_list_ids", null)
      description      = lookup(ingress.value, "description", null)
      security_groups  = lookup(ingress.value, "security_groups", null)
      self             = lookup(ingress.value, "self", null)
    }
  }

  dynamic "egress" {
    iterator = egress
    for_each = length(keys(var.default_security_group_egress)) > 0 ? [var.default_security_group_egress] : []

    content {
      protocol  = lookup(egress.value, "protocol", null)
      from_port = lookup(egress.value, "from_port", null)
      to_port   = lookup(egress.value, "to_port", null)

      cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(egress.value, "prefix_list_ids", null)
      description      = lookup(egress.value, "description", null)
      security_groups  = lookup(egress.value, "security_groups", null)
      self             = lookup(egress.value, "self", null)
    }
  }

  tags = merge(
    {
      Name = var.default_security_group_name != "" ? lower(var.default_security_group_name) : "default"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = []
}