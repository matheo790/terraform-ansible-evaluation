# TODO: outputs utiles
# output "url" { value = "http://localhost:8080" }

output "url" {
  value = "http://localhost:8080/health"
}

output "evaluation_container" {
  value = "evaluation_container"
}

output "nginx_container" {
  value = "evaluation_nginx"

}
