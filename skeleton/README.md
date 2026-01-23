# Database PostgreSQL - ${{ values.claimName }}

Database PostgreSQL criado via Backstage usando Crossplane.

## 📋 Informações

- **Database Name**: `${{ values.databaseName }}`
- **Claim Name**: `${{ values.claimName }}`
- **Environment**: `${{ values.environment }}`
- **Connection Limit**: `${{ values.connectionLimit }}`
- **Deletion Policy**: `${{ values.deletionPolicy }}`

## 🚀 Como Aplicar

```bash
kubectl apply -f database.yaml
```

## 📊 Verificar Status

```bash
# Ver o claim
kubectl get dakipostgresdatabase ${{ values.claimName }}

# Ver detalhes
kubectl describe dakipostgresdatabase ${{ values.claimName }}

# Ver o database no PostgreSQL
kubectl get databases.postgresql.postgresql.upbound.io
```

## 🗑️ Deletar

```bash
kubectl delete dakipostgresdatabase ${{ values.claimName }}
```

{% if values.deletionPolicy == "Orphan" %}
⚠️ **Atenção**: Você configurou `deletionPolicy: Orphan`. 
O database permanecerá no PostgreSQL mesmo após deletar o claim do Kubernetes.
{% else %}
⚠️ **Atenção**: Você configurou `deletionPolicy: Delete`. 
O database será DELETADO do PostgreSQL quando você deletar o claim do Kubernetes.
{% endif %}

## 🔧 Conectar ao Database

Após o database ser criado, você pode conectar usando as credenciais do provider PostgreSQL configurado.

O owner do database será `aurora` (ou o usuário configurado no ProviderConfig).

---

*Criado via Backstage em {{ '' | now }}*
