# EIP
output "elastic ip" {
  value = "${aws_eip.geth-nodes-ct.public_ip}"
}
