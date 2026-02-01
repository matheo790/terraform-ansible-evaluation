# copilot-instructions.md — TP CI/CD (Starter)

## Règles
- Ne pas inventer de cloud (Azure bloqué).
- Toujours privilégier le local : Docker + Terraform (docker provider) + Ansible.
- Produire des fichiers complets, pas des fragments.
- Idempotence Ansible : modules > shell quand possible.
- Validation finale : `/health` doit répondre `status=ok`.

## Priorités (ordre conseillé)
1) Dockerfile minimal fonctionnel pour `app/`
2) Terraform : réseau + app + nginx + outputs
3) Ansible : automatiser le déploiement (idempotent)
4) CI : build + smoke test (curl /health)
