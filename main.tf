resource "aws_security_group" "allow_elasticstack" {
  name = "allow_elasticstack"
  description = "All all elasticsearch traffic"
  #vpc_id = "${aws_vpc.main.id}"

  # Elasticsearch Port
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Logstash Port
  ingress {
    from_port   = 5043
    to_port     = 5044
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kibana Ports
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "elasticstack" {
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key}"
  vpc_security_group_ids = [
    "${aws_security_group.allow_elasticstack.id}",
  ]

  tags {
    Name = "${var.instance_name}"
  }

  root_block_device {
    volume_type = "${var.root_volume_type}"
    volume_size = "${var.root_volume_size}"
    delete_on_termination = "${var.root_volume_delete_on_termination}"
  }

  # Elasticsearch Config
  provisioner "file" {
    source        = "${path.module}/config/elasticsearch.yml"
    destination   = "/tmp/elasticsearch.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  # Kibana Config
  provisioner "file" {
    source        = "${path.module}/config/kibana.yml"
    destination   = "/tmp/kibana.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  # Logstach Config
  provisioner "file" {
		source        = "${path.module}/config/logstash.yml"
    destination   = "/tmp/logstash.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  # Filebeat Config
  provisioner "file" {
    source        = "${path.module}/config/filebeat.yml"
    destination   = "/tmp/filebeat.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  # Beats Config
  provisioner "file" {
    source        = "${path.module}/config/beats.conf"
    destination   = "/tmp/beats.conf"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  # Elastic Stack provisioner script
  provisioner "remote-exec" {
    script        = "${path.module}/provision.sh"
    
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  depends_on = ["aws_security_group.allow_elasticstack"]
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.elasticstack.id}"
}
