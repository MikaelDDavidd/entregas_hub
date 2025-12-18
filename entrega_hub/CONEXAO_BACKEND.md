# 🔗 Conectando App Flutter ao Backend

## ✅ Configuração Aplicada

### Backend Docker
- **URL**: `http://localhost:3000`
- **CORS**: Configurado para aceitar todas as origens
- **Endpoints disponíveis**:
  - `GET /api/packages` - Listar entregas
  - `POST /api/packages` - Criar entrega
  - `POST /api/upload` - Upload de imagem
  - `PUT /api/upload/:id` - Atualizar com IA

### App Flutter
- **iOS Simulator**: `http://localhost:3000/api`
- **Android Emulator**: `http://10.0.2.2:3000/api`
- **Configuração automática**: Detecta a plataforma

## 🚀 Como Testar

### 1. Certifique-se que o Backend está rodando

```bash
cd /Users/mikaeldavid/Documents/GitHub/entregas_hub/entregas_hub_back_end

# Se ainda não iniciou
docker-compose up -d

# Ver logs
docker-compose logs -f backend
```

### 2. Rode o App Flutter

```bash
cd /Users/mikaeldavid/Documents/GitHub/entregas_hub/entrega_hub

# iOS
flutter run

# Android (se preferir)
flutter run -d <device-id>
```

### 3. Teste a Conexão

1. **Login**: Digite seu nome de entregador
2. **Home**: A tela deve carregar as entregas do backend
3. **Se aparecer erro de conexão**:
   - Verifique se o backend está rodando: `curl http://localhost:3000/api/packages`
   - Veja os logs do backend: `docker-compose logs backend`

## 🔧 Troubleshooting

### Backend não está respondendo

```bash
# Verificar se containers estão rodando
docker-compose ps

# Reiniciar backend
docker-compose restart backend

# Ver logs completos
docker-compose logs backend
```

### App não conecta

**iOS Simulator:**
```dart
// api_config.dart já está configurado para:
'http://localhost:3000/api' ✅
```

**Android Emulator:**
```dart
// api_config.dart já está configurado para:
'http://10.0.2.2:3000/api' ✅
```

**Dispositivo Físico:**
Se estiver testando em dispositivo físico, precisa usar o IP da sua máquina:

1. Descobrir seu IP:
```bash
# macOS
ipconfig getifaddr en0
# ou
ifconfig | grep "inet " | grep -v 127.0.0.1
```

2. Editar `api_config.dart` e trocar `localhost` pelo seu IP:
```dart
return 'http://SEU_IP_AQUI:3000/api';
```

### CORS Error

Se aparecer erro de CORS, verifique se o backend tem esta configuração em `deliveries_routes.js`:

```javascript
const corsOptions = {
  origin: "*",
  optionsSuccessStatus: 200,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
};
```

## 📱 Fluxo Completo de Teste

1. ✅ Backend rodando em Docker
2. ✅ App Flutter conectando ao backend
3. ✅ Login salva nome do entregador
4. ✅ Home lista entregas do MongoDB
5. ✅ Registrar entrega envia dados + imagem
6. ✅ Dados salvos no MongoDB via API

## 🎯 Próximos Passos

- [ ] Testar upload de imagem
- [ ] Testar fluxo completo de entrega
- [ ] Configurar Gemini API para extração de nomes
- [ ] Testar em dispositivo físico
