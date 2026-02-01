# Terraform (Starter)

Objectif : provisionner une infra locale Docker :
- réseau docker dédié
- conteneur `app`
- conteneur `nginx` exposé sur `localhost:8080` (reverse proxy vers `app:5000`)
- outputs utiles

## TODO
- Compléter `main.tf` et `outputs.tf`
- Utiliser provider Docker : `kreuzwerker/docker`

## Validation
- `terraform init`
- `terraform plan`
- `terraform apply`
- `curl http://localhost:8080/health`
- `terraform destroy`
