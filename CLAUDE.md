# CLAUDE.md

Este arquivo fornece orientações para o Claude Code (claude.ai/code) ao trabalhar com código neste repositório.

## Contexto de Trabalho

Claude está posicionado na raiz do repositório para trabalhar em **todas as frentes simultaneamente**: mobile apps (entrega_hub, logistics_app, eaasy_stock), web panel (entregas_hub_web_panel) e backend API (entregas_hub_back_end).

**Objetivo atual**: Integrar completamente todos os componentes do sistema hoje. Claude deve trabalhar em qualquer parte do projeto conforme necessário para garantir a integração completa entre:
- Apps mobile e API backend
- Web panel e API backend
- Firebase Realtime Database (eaasy_stock) e web panel
- Fluxos de dados entre todas as plataformas

Claude tem permissão total para modificar código em qualquer um dos 5 componentes do projeto.

## Visão Geral do Projeto

Kit de Logística de Encomendas - Um sistema completo de gerenciamento logístico para entregas de pacotes, integrando apps mobile, painel web e API backend.

### Componentes

1. **entrega_hub** - App mobile Flutter (iOS/Android) para entregadores capturarem pacotes e registrarem dados dos recebedores
2. **logistics_app** - App mobile Flutter (iOS/Android) para gerenciamento de retiradas com recursos de localização de pacotes
3. **eaasy_stock** - App mobile Flutter (iOS/Android) para escaneamento de pacotes no armazém e controle de estoque
4. **entregas_hub_web_panel** - Painel web Flutter para monitoramento em tempo real de entregas, retiradas e estoque
5. **entregas_hub_back_end** - API REST Node.js para gerenciar dados de entregas e retiradas

## Stack Tecnológica

- **Mobile & Web**: Flutter 3.38.3+ com gerenciamento de estado GetX
- **Backend**: Node.js v24+ com Express
- **Banco de Dados**: MongoDB Atlas (para entregas/retiradas), Firebase Realtime Database (para controle de estoque no eaasy_stock)
- **Armazenamento de Imagens**: Armazenamento em arquivos VPS com multer
- **Integração IA**: Google Generative AI (Gemini) para extração de dados de pacotes

## Comandos de Desenvolvimento

### Apps Flutter (entrega_hub, logistics_app, eaasy_stock, entregas_hub_web_panel)

```bash
# Instalar dependências
flutter pub get

# Executar geração de código (para modelos Hive no entrega_hub)
flutter pub run build_runner build --delete-conflicting-outputs

# Executar em dispositivo/emulador
flutter run

# Build para produção
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Painel web

# Limpar artefatos de build
flutter clean
```

### API Backend (entregas_hub_back_end)

```bash
# Instalar dependências
npm install

# Executar servidor de desenvolvimento com auto-reload
npm run dev

# Iniciar servidor de produção
node server.js
```

Servidor roda na porta 3000 por padrão.

## Arquitetura & Fluxo de Dados

### Processo de Entrega
1. Entregador usa **entrega_hub** para capturar pacote e dados do recebedor
2. Dados enviados para API **entregas_hub_back_end** (`POST /api/packages`)
3. API armazena no MongoDB e retorna confirmação
4. **entregas_hub_web_panel** exibe status da entrega em tempo real

### Processo de Retirada
1. Usuário usa **logistics_app** para registrar retirada de pacote
2. App mostra localização do pacote no armazenamento
3. Dados sincronizados via API **entregas_hub_back_end**
4. Painel web reflete status atualizado da retirada

### Gerenciamento de Estoque
1. Pacotes escaneados no **eaasy_stock** ao chegarem no armazém
2. Dados atualizados no Firebase Realtime Database em tempo real
3. **entregas_hub_web_panel** mostra estoque atual na seção "Estoque"
4. Sem integração direta com API - usa Firebase para sincronização em tempo real

## Estrutura de Código

### Apps Flutter (Padrão GetX)

```
lib/
├── app/
│   ├── data/         # Services e clientes API
│   ├── models/       # Modelos de dados
│   ├── modules/      # Módulos de funcionalidades
│   │   └── [feature]/
│   │       ├── bindings/    # Injeção de dependência
│   │       ├── controllers/ # Lógica de negócio
│   │       ├── views/       # Telas UI
│   │       └── widgets/     # Widgets específicos da funcionalidade
│   └── routes/       # Configuração de navegação
└── main.dart         # Ponto de entrada do app
```

### API Backend

```
src/
├── config/
│   └── db_config.js       # Conexão MongoDB
├── models/
│   └── deliveries_model.js # Operações de banco de dados
├── controller/
│   └── deliveries_controller.js # Manipuladores de requisição
├── routes/
│   └── deliveries_routes.js     # Definições de rotas
└── services/
    └── gemini_service.js         # Integração IA
```

## Detalhes Importantes de Implementação

### Gerenciamento de Estado
- Todos os apps Flutter usam **GetX** para gerenciamento de estado, roteamento e injeção de dependência
- Controllers estendem `GetxController` e são vinculados via classes `Binding`
- Estado reativo usa observables `.obs` e widgets `Obx()`

### Armazenamento Local
- **entrega_hub**: Usa Hive para cache local de entregas quando offline
- **eaasy_stock** & **logistics_app**: Usam SharedPreferences para armazenamento simples de chave-valor

### Integração com API
- URL base configurada nos arquivos de serviço em `app/data/`
- Usa pacote `http` (entrega_hub, entregas_hub_web_panel) ou `dio` (entrega_hub)
- Imagens enviadas separadamente via endpoint `POST /api/upload` com multipart/form-data
- Dados principais de entrega via `POST /api/packages` com body JSON

### Manipulação de Imagens
- Backend: Middleware Multer com nomes de arquivo aleatórios gerados por crypto
- Armazenamento: Sistema de arquivos VPS no diretório `uploads/`
- Formato de URL pública: `http://mikaeldavid.online/api/uploads/{filename}`
- Flutter: image_picker para captura, dio/http para upload

### Funcionalidades de IA (entregas_hub_back_end)
- Serviço Gemini AI extrai nomes de destino de imagens de pacotes
- Usado no endpoint `PUT /api/upload/:id` para preencher automaticamente dados de entrega

## Configuração de Ambiente

### Arquivo .env do Backend
Variáveis de ambiente necessárias:
- String de conexão MongoDB
- Chave de API Google Generative AI para Gemini

### Configuração Firebase
- Necessário apenas para o app **eaasy_stock**
- Usa Firebase Realtime Database para atualizações de estoque em tempo real
- Não é necessária configuração Firebase para entrega_hub ou logistics_app

## Tarefas Comuns

### Adicionar Novo Módulo de Funcionalidade Flutter
1. Criar diretório do módulo: `lib/app/modules/[feature]/`
2. Adicionar subdiretórios: `bindings/`, `controllers/`, `views/`, opcionalmente `widgets/`
3. Criar controller estendendo `GetxController`
4. Criar binding implementando `Bindings`
5. Criar view como stateless widget
6. Registrar rota em `lib/app/routes/app_routes.dart` e `app_pages.dart`

### Adicionar Novo Endpoint na API
1. Adicionar função em `src/models/deliveries_model.js` para operações de banco de dados
2. Criar função controller em `src/controller/deliveries_controller.js`
3. Registrar rota em `src/routes/deliveries_routes.js`
4. Incluir configuração CORS se necessário

### Trabalhando com Hive (apenas entrega_hub)
1. Definir classes de modelo com anotações Hive
2. Executar build_runner para gerar adaptadores de tipo
3. Registrar adaptadores em `main.dart` antes de abrir box
4. Abrir box com `Hive.openBox('boxName')`

## Notas de Build & Deploy

- Apps mobile requerem iOS 12.0+ e Android SDK conforme definido no Flutter
- Painel web pode ser implantado em qualquer hospedagem estática ou servido via servidor web Flutter
- Backend requer Node.js 14.0+ e npm 6.0+
- Backend espera que diretório `uploads/` exista na raiz do projeto (criado automaticamente se não existir)
- Todo código Flutter segue padrão de arquitetura GetX consistentemente entre os apps
