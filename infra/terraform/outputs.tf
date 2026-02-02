# TODO: outputs utiles
# output "url" { value = "http://localhost:8080" }

output "url" {
  value = "http://localhost:8080/health"
}

output "evaluation_container" {
  value = docker_container.app.name
}

output "nginx_container" {
  value = docker_container.nginx.name
}
