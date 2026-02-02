# TODO: provision infra Docker
# Recommandation:
# - docker_network
# - docker_container app (image = tp-app:latest)
# - docker_container nginx (image nginx:alpine) + config reverse proxy
#
# Hint: vous pouvez monter un fichier de conf nginx (host_path -> container_path)
terraform {

}

resource "docker_network" "evaluation_network" {
  name = "evaluation_network"
}

resource "docker_image" "app_image" {
  name = "tp-app:latest"
}

resource "docker_container" "app" {
  name  = "evaluation_container"
  image = docker_image.app_image.name

  networks_advanced {
    name = docker_network.evaluation_network.name
  }

  env = [
    "APP_ENV=prod",
    "PORT=5000"
  ]
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
  name  = "evaluation_nginx"
  image = docker_image.nginx.name

  ports {
    internal = 80
    external = 8080
  }

  networks_advanced {
    name = docker_network.evaluation_network.name
  }

  volumes {
    host_path      = abspath("${path.module}/nginx.conf")
    container_path = "/etc/nginx/conf.d/default.conf"
    read_only      = true
  }

}
