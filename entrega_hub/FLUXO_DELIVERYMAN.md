# 📦 Fluxo do Campo `deliveryMan`

## 🔍 Valor Usado Atualmente

### Login → Storage → Backend

```
┌─────────────────────────────────────────────────────┐
│  1. LOGIN                                           │
│  User digita: "Mikael"                              │
│  App salva: "mikael" (lowercase)                    │
└─────────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────┐
│  2. HOME CONTROLLER                                 │
│  userName.value = "Mikael" (capitalize para UI)     │
└─────────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────┐
│  3. BUSCAR ENTREGAS                                 │
│  URL: /api/packages?deliveryMan=mikael              │
│  Usa: userName.value.toLowerCase() ✅               │
└─────────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────┐
│  4. CRIAR ENTREGA                                   │
│  Body: { deliveryMan: "mikael", ... }               │
│  Usa: userName.value.toLowerCase() ✅               │
└─────────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────┐
│  5. MONGODB                                         │
│  Salvo: { deliveryMan: "mikael" }                   │
└─────────────────────────────────────────────────────┘
```

---

## 📝 Valores em Cada Camada

| Camada | Variável | Valor | Uso |
|--------|----------|-------|-----|
| **TextField** | `userNameController.text` | "Mikael" | Input do usuário |
| **GetStorage** | `storage.read('userKey')` | "mikael" | Salvo em lowercase |
| **Home UI** | `userName.value` | "Mikael" | Exibição capitalizada |
| **API Query** | `?deliveryMan=` | "mikael" | Busca (lowercase) |
| **API Body** | `{ deliveryMan: }` | "mikael" | Criação (lowercase) |
| **MongoDB** | `deliveryMan` | "mikael" | Armazenado (lowercase) |

---

## 🔧 Código Atual

### 1. Login (Salva em lowercase)
```dart
// login_controller.dart
Future<void> authenticator() async {
  String userName = userNameController.text.toLowerCase(); // ✅ "mikael"
  storage.write(StorageKeys.userKey, userName); // Salva "mikael"
  Get.offNamed('/home');
}
```

### 2. Home (Capitaliza para UI)
```dart
// home_controller.dart
void loadUserName() {
  String name = storage.read(StorageKeys.userKey) ?? 'Entregador'; // Lê "mikael"
  userName.value = _capitalize(name); // Vira "Mikael" para UI
}

String _capitalize(String text) {
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}
```

### 3. Buscar Entregas (Usa lowercase)
```dart
// home_controller.dart
Future<void> fetchData() async {
  final url = '${ApiConfig.baseUrl}/packages?deliveryMan=${userName.value.toLowerCase()}';
  // URL: /api/packages?deliveryMan=mikael ✅
}
```

### 4. Criar Entrega (Usa lowercase)
```dart
// home_controller.dart
addPackage(...) {
  final newPackage = {
    'deliveryMan': userName.value.toLowerCase(), // "mikael" ✅
    // ...
  };
}
```

---

## ✅ Consistência Verificada

### Tudo em Lowercase
```json
// GetStorage
{
  "userKey": "mikael"
}

// Query API
GET /api/packages?deliveryMan=mikael

// Body API
POST /api/packages
{
  "deliveryMan": "mikael"
}

// MongoDB
{
  "_id": "...",
  "deliveryMan": "mikael"
}
```

### UI Capitalizada (apenas exibição)
```
Header: "Bem-vindo de volta, Mikael"
```

---

## 🎯 Por que Lowercase?

1. **Case-insensitive** - Evita problemas de "Mikael" ≠ "mikael"
2. **Consistência** - Todos os dados salvos iguais
3. **Busca confiável** - MongoDB busca exatamente "mikael"
4. **UX melhor** - User vê "Mikael", backend usa "mikael"

---

## 🧪 Exemplo Real

### User digita: "MIKAEL DAVID"

```
Login:
  Input: "MIKAEL DAVID"
  Salvo: "mikael david" ← toLowerCase()

Home UI:
  Exibido: "Mikael david" ← capitalize()

API Busca:
  Query: ?deliveryMan=mikael david ← toLowerCase()

API Cria:
  Body: { deliveryMan: "mikael david" } ← toLowerCase()

MongoDB:
  Salvo: { deliveryMan: "mikael david" }
```

---

## 🔍 Como Verificar

### 1. Ver no GetStorage
```dart
final storage = GetStorage();
print(storage.read('userKey')); // "mikael"
```

### 2. Ver no MongoDB
```bash
docker-compose exec mongodb mongosh -u admin -p admin123
use delivery-hub
db.deliveries.findOne({}, { deliveryMan: 1 })
# Deve mostrar: { deliveryMan: "mikael" }
```

### 3. Ver na API
```bash
# Criar pacote
curl -X POST http://localhost:3000/api/packages \
  -H "Content-Type: application/json" \
  -d '{"deliveryMan":"mikael"}'

# Buscar
curl "http://localhost:3000/api/packages?deliveryMan=mikael"
```

---

## ⚠️ Importante

**SEMPRE usa lowercase para:**
- ✅ Salvar no storage
- ✅ Enviar para API
- ✅ Buscar na API
- ✅ Salvar no MongoDB

**Capitalize APENAS para:**
- 👁️ Exibir na UI (visual)

---

## 🎯 Conclusão

✅ **Tudo consistente em lowercase**
✅ **UI mostra capitalizado**
✅ **Backend usa lowercase**
✅ **MongoDB guarda lowercase**

**Está correto! 🎉**
