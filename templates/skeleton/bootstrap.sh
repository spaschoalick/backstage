#!/usr/bin/env bash
set -e

DB_NAME="${DATABASE_NAME:-$1}"

echo "Skeleton do banco PostgreSQL gerado: $DB_NAME"
echo "Verifique os arquivos database.yaml e catalog-info.yaml no diretório do Scaffolder"
