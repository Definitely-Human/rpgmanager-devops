resource "null_resource" "copy_ec2_keys" {
  depends_on = [module.ec2bastion]

  connection {
    type    = "ssh"
    host    = aws_eip.bastion_eip.public_ip
    user    = "ec2-user"
    password = ""
    private_key = file("~/.ssh/rpg-project-key.pem")

  }

  provisioner "file" {
    source     = "private-key/art-manjaro.pem"
    destination = "/tmp/art-manjaro.pem"

  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/art-manjaro.pem"
    ]
  }

}