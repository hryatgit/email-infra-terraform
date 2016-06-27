# Bastion Host

resource "aws_instance" "bastion-host" {
  connection {
    user = "ubuntu"
    agent = false
    private_key = "${file(var.aws_key_path)}"
  }
  
  instance_type = "t2.micro"
  ami = "ami-9abea4fb"
  key_name = "mail-keypair"
  vpc_security_group_ids = ["${aws_security_group.public.id}"]
  subnet_id = "${aws_subnet.public-1.id}"
}

# Mail Server
# Software: Dovecot, Postfix

resource "aws_instance" "mail-server" {
  connection {
    user = "ubuntu"
    agent = false
    private_key = "${file(var.aws_key_path)}"
  }
  instance_type = "t2.micro"
  ami = "ami-9abea4fb"
  key_name = "mail-keypair"
  vpc_security_group_ids = ["${aws_security_group.public.id}"]
  subnet_id = "${aws_subnet.public-1.id}"

  provisioner {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install postfix",
      "sudo apt-get install dovecot-imapd dovecot-pop3d"
    ]
  }
}

# Webmail
# Software: Roundcube

resource "aws_instance" "roundcube" {
  connection {
    user = "ubuntu"
    agent = false
    private_key = "${file(var.aws_key_path)}"
  }
  instance_type = "t2.micro"
  ami = "ami-9abea4fb"
  key_name = "mail-keypair"
  vpc_security_group_ids = ["${aws_security_group.public.id}"]
  subnet_id = "${aws_subnet.public-1.id}"

  provisioner {
    inline = [
      "sudo apt-get update",
      "echo 'install roundcube'"
    ]
  }
}

# Nameserver
# Software: bind

resource "aws_instance" "nameserver" {
  connection {
    user = "ubuntu"
    agent = false
    private_key = "${file(var.aws_key_path)}"
  }
  instance_type = "t2.micro"
  ami = "ami-9abea4fb"
  key_name = "mail-keypair"
  vpc_security_group_ids = ["${aws_security_group.public.id}"]
  subnet_id = "${aws_subnet.public-1.id}"

  provisioner {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install bind9 bind9utils bind9-doc"
    ]
  }
}

# Webserver / Homepage
# Software: nginx

resource "aws_instance" "homepage" {
  connection {
    user = "ubuntu"
    agent = false
    private_key = "${file(var.aws_key_path)}"
  }
  instance_type = "t2.micro"
  ami = "ami-9abea4fb"
  key_name = "mail-keypair"
  vpc_security_group_ids = ["${aws_security_group.public.id}"]
  subnet_id = "${aws_subnet.public-1.id}"

  provisioner "remote-exec" {
    # Install Nginx
    # Start service
    inline = [
      "sudo apt-get update"
    ]
  }
}

# User Database
# Software: MySQL

resource "aws_instance" "user-db" {
  connection {
    user = "ubuntu"
    agent = false
    private_key = "${file(var.aws_key_path)}"
  }

  instance_type = "t2.micro"
  ami = "ami-9abea4fb"
  key_name = "mail-keypair"
  vpc_security_group_ids = ["${aws_security_group.private.id}"]
  subnet_id = "${aws_subnet.private-1.id}"

  provisioner "remote-exec" {
    connection {
      bastion_host = "${aws_instance.bastion-host.public_ip}"
    }
    # Install MySQL
    # Securely configure MySQL
    inline = [
      "sudo apt-get update"
    ]
  }
}
