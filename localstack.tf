/*
Provision Localstack with Docker TF provider
*/

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

/*
Pulls the image
*/

resource "docker_image" "localstack_image" {
  name         = "localstack/localstack:1.2"
  force_remove = true
}

/*
Creates a container
*/

resource "docker_container" "localstack_container" {
  image  = docker_image.localstack_image.image_id
  name   = "tf_localstack"
  memory = 2048
  rm     = true

  ports {
    internal = 4566
    external = 4566
  }

  healthcheck {
    test         = ["CMD", "curl", "-f", "localhost:4566"]
    interval     = "10s"
    start_period = "10s"
    retries      = 3
    timeout      = "3s"
  }

  env = ["DEFAULT_REGION=us-east-1", "EDGE_PORT=4566"]
}