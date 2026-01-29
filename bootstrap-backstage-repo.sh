#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="backstage"
OWNER="teste"
GITHUB_SLUG="spaschoalick/backstage"

echo "📁 Criando estrutura de diretórios..."

mkdir -p databases
mkdir -p templates/postgres-database/skeleton

echo "📝 Criando catalog-info.yaml (raiz)..."

cat <<EOF > catalog-info.yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: ${REPO_NAME}
  annotations:
    github.com/project-slug: ${GITHUB_SLUG}
spec:
  type: service
  lifecycle: production
  owner: ${OWNER}
EOF

echo "📝 Criando databases/catalog-info.yaml..."

cat <<EOF > databases/catalog-info.yaml
apiVersion: backstage.io/v1alpha1
kind: System
metadata:
  name: databases
spec:
  owner: ${OWNER}
EOF

echo "📝 Criando template.yaml..."

cat <<EOF > templates/postgres-database/template.yaml
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: postgres-database
  title: PostgreSQL Database (Crossplane)
  description: Provisiona um PostgreSQL via Crossplane
spec:
  owner: ${OWNER}
  type: resource

  parameters:
    - title: Database configuration
      required:
        - name
      properties:
        name:
          title: Database name
          type: string

  steps:
    - id: fetch
      name: Fetch skeleton
      action: fetch:template
      input:
        url: ./skeleton
        values:
          name: \${{ parameters.name }}

    - id: register
      name: Register in catalog
      action: catalog:register
      input:
        repoContentsUrl: \${{ steps.fetch.output.repoContentsUrl }}
        catalogInfoPath: catalog-info.yaml
EOF

echo "📝 Criando skeleton/catalog-info.yaml..."

cat <<EOF > templates/postgres-database/skeleton/catalog-info.yaml
apiVersion: backstage.io/v1alpha1
kind: Resource
metadata:
  name: \${{ values.name }}-postgres
spec:
  type: database
  owner: ${OWNER}
  system: databases
EOF

echo "📝 Criando skeleton/claim.yaml..."

cat <<EOF > templates/postgres-database/skeleton/claim.yaml
apiVersion: database.example.org/v1alpha1
kind: PostgreSQLInstance
metadata:
  name: \${{ values.name }}
spec:
  parameters:
    storageGB: 20
EOF

echo "✅ Repositório bootstrapado com sucesso!"
