# Ansible (Starter)

Objectif : automatiser le déploiement/configuration.

Approche recommandée :
- cibler `localhost` (ansible_connection=local)
- piloter Docker localement

## TODO
- Remplacer les tâches `debug` par des tâches effectives (idempotentes)
- Vérification post-déploiement

## Validation
- `ansible-playbook -i inventory.ini site.yml`
- 2e exécution => idempotent (peu ou pas de `changed`)
