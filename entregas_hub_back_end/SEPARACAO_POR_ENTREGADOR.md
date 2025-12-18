# 👥 Separação de Encomendas por Entregador

## ✅ Sistema Implementado

Agora cada entregador vê **APENAS suas próprias entregas**!

---

## 🔧 Como Funciona

### Backend (Node.js)

**1. Model (`deliveries_model.js`)**
```javascript
export async function getAllDeliveries(deliveryMan = null) {
  if (deliveryMan) {
    return dbCollection.find({ deliveryMan }).toArray(); // ✅ Filtra por entregador
  }
  return dbCollection.find().toArray(); // Sem filtro (admin)
}
```

**2. Controller (`deliveries_controller.js`)**
```javascript
export async function listDeliveries(req, res) {
  const { deliveryMan } = req.query; // Query param: ?deliveryMan=mikael
  const deliveries = await getAllDeliveries(deliveryMan);

  res.status(200).json({
    status: 200,
    data: deliveries
  });
}
```

**3. Endpoint**
```
GET /api/packages?deliveryMan=mikael
```

---

### App Flutter

**1. Ao Buscar Entregas**
```dart
// home_controller.dart
Future<void> fetchData() async {
  final url = '${ApiConfig.baseUrl}/packages?deliveryMan=${userName.value.toLowerCase()}';
  final response = await https.get(Uri.parse(url));
  // Retorna apenas pacotes do entregador logado
}
```

**2. Ao Criar Entrega**
```dart
// home_controller.dart
final newPackage = {
  'trackingCode': qrCode.value,
  'ownerName': ownerName,
  'deliveryMan': userName.value.toLowerCase(), // ✅ Salva nome do entregador
  // ... outros campos
};
```

---

## 📊 Estrutura no MongoDB

Cada entrega agora tem o campo `deliveryMan`:

```json
{
  "_id": "...",
  "trackingCode": "BR123456789",
  "ownerName": "João Silva",
  "cpf": "123.456.789-00",
  "relation": "Morador",
  "location": "Estante A",
  "deliveryMan": "mikael",  // ← NOVO CAMPO
  "registerDate": "2025-12-09 14:30:00",
  "imageUrl": "..."
}
```

---

## 🎯 Fluxo Completo

### Login
1. Usuário digita: "Mikael"
2. App salva localmente: "mikael" (lowercase)

### Criar Entrega
1. Entregador "mikael" escaneia QR Code
2. Preenche dados do recebedor
3. App envia para API:
```json
{
  "trackingCode": "BR123456789",
  "ownerName": "João Silva",
  "deliveryMan": "mikael"  ← Automaticamente incluído
}
```

### Listar Entregas
1. App busca: `GET /api/packages?deliveryMan=mikael`
2. Backend filtra: `{ deliveryMan: "mikael" }`
3. Retorna apenas pacotes do Mikael

---

## 🧪 Testar Manualmente

### Criar entrega para "mikael"
```bash
curl -X POST http://localhost:3000/api/packages \
  -H "Content-Type: application/json" \
  -d '{
    "trackingCode": "BR111111111",
    "ownerName": "Teste Mikael",
    "deliveryMan": "mikael"
  }'
```

### Criar entrega para "joao"
```bash
curl -X POST http://localhost:3000/api/packages \
  -H "Content-Type: application/json" \
  -d '{
    "trackingCode": "BR222222222",
    "ownerName": "Teste João",
    "deliveryMan": "joao"
  }'
```

### Buscar entregas do "mikael"
```bash
curl "http://localhost:3000/api/packages?deliveryMan=mikael"
# Retorna apenas BR111111111
```

### Buscar entregas do "joao"
```bash
curl "http://localhost:3000/api/packages?deliveryMan=joao"
# Retorna apenas BR222222222
```

### Buscar TODAS (admin)
```bash
curl "http://localhost:3000/api/packages"
# Retorna todas as entregas
```

---

## 🔒 Segurança

**Nível Atual:** Básico (apenas separação por query param)

**Próximas Melhorias:**
- [ ] Autenticação JWT
- [ ] Validação de token no backend
- [ ] Middleware de autorização
- [ ] Criptografia de senhas
- [ ] Roles (entregador, admin, gerente)

---

## 📱 No App

Cada entregador vê apenas suas entregas:
- ✅ Login: "Mikael" → Vê só suas entregas
- ✅ Login: "João" → Vê só suas entregas
- ✅ Novo pacote: Automaticamente vinculado ao entregador logado

---

## ⚡ Vantagens

1. **Isolamento** - Cada entregador vê apenas seu trabalho
2. **Rastreabilidade** - Sabe quem fez cada entrega
3. **Relatórios** - Pode contar entregas por pessoa
4. **Escalável** - Fácil adicionar múltiplos entregadores

---

## 🐛 Troubleshooting

### Entregador não vê suas entregas antigas
**Causa:** Entregas criadas antes dessa implementação não têm o campo `deliveryMan`

**Solução:** Atualizar entregas antigas no MongoDB:
```javascript
db.deliveries.updateMany(
  { deliveryMan: { $exists: false } },
  { $set: { deliveryMan: "nome_do_entregador" } }
)
```

### App mostra "Nenhuma entrega"
- ✅ Verificar se nome está correto (lowercase)
- ✅ Ver logs do backend: `docker-compose logs backend`
- ✅ Testar endpoint manualmente: `curl "http://localhost:3000/api/packages?deliveryMan=mikael"`
