# 🐳 Entregas Hub Backend - Docker Setup

## 🚀 Como rodar

### Opção 1: Com Docker Compose (Recomendado)

```bash
# Subir backend + MongoDB
docker-compose up -d

# Ver logs
docker-compose logs -f backend

# Parar tudo
docker-compose down

# Parar e remover volumes (apaga dados do banco)
docker-compose down -v
```

### Opção 2: Sem Docker (Desenvolvimento Local)

```bash
# Apenas MongoDB no Docker
docker-compose up -d mongodb

# Rodar backend localmente
npm run dev
```

## 🔧 Configuração

### Variáveis de Ambiente

Edite o arquivo `.env`:

```env
STRING_CONEXAO=mongodb://admin:admin123@localhost:27017/delivery-hub?authSource=admin
GEMINI_API_KEY=sua_chave_api_aqui
```

**IMPORTANTE:** Se você tem uma chave do Gemini AI, coloque em `GEMINI_API_KEY`. Se não tiver, pode deixar vazio (funcionalidades de IA não funcionarão).

## 📡 Endpoints Disponíveis

Após rodar, a API estará em: `http://localhost:3000`

- `GET /api/packages` - Listar todas as entregas
- `POST /api/packages` - Criar nova entrega
- `POST /api/upload` - Upload de imagem
- `PUT /api/upload/:id` - Atualizar entrega com IA (requer Gemini API)

## 🗄️ Banco de Dados

**Credenciais MongoDB:**
- Host: `localhost:27017`
- Username: `admin`
- Password: `admin123`
- Database: `delivery-hub`
- Collection: `deliveries`

**Conectar com MongoDB Compass:**
```
mongodb://admin:admin123@localhost:27017/delivery-hub?authSource=admin
```

## 📁 Volumes

- `mongodb_data` - Dados persistentes do MongoDB
- `./uploads` - Imagens das entregas (mapeado para o host)

## 🛠️ Comandos Úteis

```bash
# Rebuild da imagem (após mudanças no código)
docker-compose up -d --build

# Ver status dos containers
docker-compose ps

# Entrar no container do backend
docker-compose exec backend sh

# Entrar no MongoDB
docker-compose exec mongodb mongosh -u admin -p admin123

# Limpar tudo e recomeçar
docker-compose down -v
docker-compose up -d --build
```

## 🔥 Troubleshooting

### Backend não inicia
```bash
# Ver logs detalhados
docker-compose logs backend
```

### Porta 3000 já em uso
Edite `docker-compose.yml` e mude:
```yaml
ports:
  - "8080:3000"  # Agora acesse em localhost:8080
```

### MongoDB não conecta
```bash
# Verificar se MongoDB está rodando
docker-compose ps mongodb

# Reiniciar MongoDB
docker-compose restart mongodb
```

## 📦 Estrutura dos Containers

```
entregas_network (bridge)
├── mongodb (mongo:7)
│   └── porta 27017
└── backend (node:24-alpine)
    └── porta 3000
```

## 🐛 Debug no VS Code

### Configuração Automática

O projeto já está configurado para debug! Basta:

1. **Abrir o VS Code** na pasta do backend
2. **Pressionar F5** ou ir em "Run and Debug"
3. **Selecionar uma das opções:**
   - `Docker: Attach to Node` - Debug no Docker (requer containers rodando)
   - `Local: Launch Server` - Debug local (sem Docker)
   - `Local: Dev Mode (watch)` - Debug com hot reload
   - `Docker: Debug Full Stack` - Sobe containers e conecta debugger

### Debug Rápido no Docker

```bash
# Terminal 1: Subir containers em modo debug
docker-compose -f docker-compose.yml -f docker-compose.debug.yml up --build

# VS Code: Pressione F5 e escolha "Docker: Attach to Node"
```

### Tasks Disponíveis no VS Code

Pressione `Cmd+Shift+P` > `Tasks: Run Task`:
- `docker-compose-up` - Sobe containers
- `docker-compose-down` - Para containers
- `docker-compose-logs` - Ver logs em tempo real
- `docker-compose-debug` - Sobe em modo debug

### Breakpoints

- Coloque breakpoints no código
- Execute requisições na API
- Debug funciona normalmente! 🎯

## ✨ Próximos Passos

1. Colocar sua chave do Gemini AI no `.env`
2. Testar endpoints com Postman/Insomnia
3. Conectar apps mobile ao backend em `http://localhost:3000`
4. Usar F5 no VS Code para debugar 🐛
