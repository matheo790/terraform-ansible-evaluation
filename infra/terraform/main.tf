# TODO: provision infra Docker
# Recommandation:
# - docker_network
# - docker_container app (image = tp-app:latest)
# - docker_container nginx (image nginx:alpine) + config reverse proxy
#
# Hint: vous pouvez monter un fichier de conf nginx (host_path -> container_path)

resource "docker_network" "evaluation_network" {
  name = "evaluation_network"
}

resource "docker_image" "app_image" {
  name = "tp-app:latest"
}



resource "docker_image" "nginx" {
  name = "nginx:latest"
}


