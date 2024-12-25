resource "aws_eip" "nat_gateway_ip" {
  vpc = true
  tags = {
    "Name" = "${var.prefix}-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_ip.id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = {
    "Name" = "${var.prefix}-ngw"
  }
}
