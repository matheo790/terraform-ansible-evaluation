# Rapport de projet : Terraform / Ansible – Déploiement local automatisé

## 🎯 Objectif 🎯

Industrialiser le déploiement d’une application web **locale** en mettant en place :

1) La conteneurisation avec Docker (Dockerfile)
2) Le provisionnement de l’infrastructure locale avec Terraform (provider Docker)
3) L’automatisation complète du déploiement et de la configuration avec Ansible
4) Une logique de chaîne CI/CD

Notre objectif est qu’une seule commande permette de tout déployer sans aucune intervention humaine manuelle.

## 🐋 Etape 1 - Conteneurisation de l’application

Un `Dockerfile` a été créé dans `./app/` afin de conteneuriser l’application Flask.

Les points importants :
1)  L’utilisation d’une image `python:slim` (pour que ce soit léger)
2)  L’installation des dépendances via le `requirements.txt`
3)  L’exposition du port `5000`
4)  L’ajout d’un `HEALTHCHECK` Docker sur `/health`

Le .dockerignore permet d’éviter d’embarquer `.venv`, `.git`, `__pycache__`, etc. dans l’image, afin de la rendre plus légère.

## 🧪 Test manuel pour valider la demande de l’énoncé
```bash
docker build -t tp-app:latest app/
docker run -p 8080:5000 tp-app:latest
curl http://localhost:8080/health
```
## 🌍 Etape 2 - Terraform (Docker Provider)

Infrastructure déployée

1)  Un réseau Docker `evaluation_network`
2)  Un conteneur `evaluation_container`
3)  Un conteneur `evaluation_nginx` exposé sur le port `8080`
4)  Un reverse proxy `Nginx` qui redirige vers le conteneur Flask via son nom Docker sur le réseau

La solution impose que le nom du conteneur soit fixe, ce qui est un point clé.

```bash
proxy_pass http://evaluation_container:5000;
```
Outputs Terraform
- URL d'accès
- Nom des conteneurs

### 🧪 Test manuel pour valider la demande de l’énoncé

```bash
cd ./infra/terraform
terraform init
terraform apply
```

## 🏗️ Etape 3 - Ansible

Afin de respecter la séparation des rôles (Terraform pour l’infrastructure et Ansible pour la configuration) :

1)  Terraform ne gère désormais plus que le réseau et la déclaration des images. Les ressources `docker_container` ont volontairement été supprimées du `main.tf`.
2)  Ansible est devenu l’orchestrateur principal : il effectue le build, appelle Terraform, puis déploie les services avec leurs variables d’environnement `APP_ENV`, `PORT`.
3)  Pour le reverse proxy, Ansible injecte directement la configuration Nginx via un montage de volume.

### 🧪 Test manuel pour valider la demande de l’énoncé

```bash
cd ./infra/ansible
ansible-playbook site.yml
```
## ♾️ Etape 4 - CI/CD

Un workflow `ci.yml` a été mis en place, découpé en plusieurs jobs, afin que chaque étape soit validée successivement.

1)  Job Build qui vérifie la validité du Dockerfile et la capacité de l’image à se construire
2)  Job Terraform qui valide le plan d’infrastructure (réseau et images)
3)  Job Deploy qui installe Terraform et Ansible sur l’agent GitHub, déploie l’application complète, puis termine par un healthcheck final

```bash 
TASK [Vérification post-déploiement (healthcheck)] *****************************
ok: [localhost]
{"status":"ok"}
```


## ⚠️ Problèmes rencontrés

### Nom aléatoire des conteneurs
Docker générait des noms comme `hopeful_goldwasser`.
Nginx ne pouvait donc pas joindre l’application.

Solution : imposer le nom du conteneur avec Terraform.

### Terraform refusait ./nginx.conf

Dans le `main.tf` :

```yml
host_path = "${path.module}/nginx.conf"
```
Il a fallu le remplacer par :

```yml
host_path = abspath("${path.module}/nginx.conf")
```
### Terraform tentait de pull l’image au lieu d’utiliser l’image locale

Erreur rencontrée :

```bash 
pull access denied for tp-app
```
Terraform pensait que l’image provenait d’un registre.
Solution : construire l’image automatiquement avant le `terraform apply`.

### Variables Terraform non déclarées

Erreur :

```bash 
Reference to undeclared input variable
```
Solution : créer un fichier `variables.tf` dans `./infra/terraform/`.

### Ansible échouait avec sudo

```bash
sudo: a password is required
```
Solution : définir `become: false`.
