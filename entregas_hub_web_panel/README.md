<!-- Banner -->
![Entregas Hub Web Panel](https://via.placeholder.com/1200x300?text=Entregas+Hub+Web+Panel)

# Entregas Hub Web Panel

O **Entregas Hub Web Panel** é um painel web desenvolvido em Flutter para monitorar, em tempo real, as operações de entrega, retirada e controle de estoque do Kit de Logística de Encomendas.

---

## Sumário

- [Visão Geral](#visão-geral)
- [Arquitetura do Projeto](#arquitetura-do-projeto)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Dependências](#dependências)
- [Como Executar](#como-executar)
- [Funcionalidades](#funcionalidades)
- [Como Contribuir](#como-contribuir)
- [Licença](#licença)

---

## Visão Geral

O **Entregas Hub Web Panel** integra-se ao ecossistema do Kit de Logística de Encomendas, permitindo o acompanhamento e gerenciamento das entregas, retiradas e estoque dos pacotes de forma centralizada. A aplicação utiliza o GetX para gerenciamento de estado, injeção de dependências e navegação, além de integrar serviços do Firebase para atualização em tempo real no módulo de estoque.

---

## Arquitetura do Projeto

A aplicação segue uma arquitetura modular, separando as funcionalidades em diferentes módulos:

- **Módulo Home:** Apresenta informações gerais e o dashboard principal.
- **Módulo Stock:** Gerencia o controle do estoque dos pacotes, exibindo dados em tempo real via Firebase.

Outros aspectos importantes da arquitetura:
- **Comunicação com a API:** Implementada na pasta `data/api`.
- **Modelos de Dados:** Definidos na pasta `models`, por exemplo, o `delivery_model.dart`.
- **Configuração de Rotas:** Gerenciada através dos arquivos em `routes` (`app_pages.dart` e `app_routes.dart`).
- **Serviços:** Como o `firebase_service.dart` para integrar a aplicação ao Firebase.
- **Temas e Widgets:** Personalizações de UI estão concentradas em `theme` e `widgets`.

---

## Estrutura de Pastas

```plaintext
lib/
├─ app/
│  ├─ data/
│  │  └─ api/                # Comunicação com a API
│  ├─ models/
│  │  └─ delivery_model.dart # Modelo de dados para entregas
│  ├─ modules/
│  │  ├─ home/               # Módulo Home
│  │  │  ├─ bindings/
│  │  │  │  └─ home_binding.dart
│  │  │  ├─ controllers/
│  │  │  │  └─ home_controller.dart
│  │  │  └─ views/
│  │  │     └─ home_view.dart
│  │  └─ stock/              # Módulo de Estoque
│  │     ├─ bindings/
│  │     │  └─ stock_binding.dart
│  │     ├─ controllers/
│  │     │  └─ stock_controller.dart
│  │     └─ views/
│  │        └─ stock_view.dart
│  ├─ routes/                # Configuração de rotas
│  │  ├─ app_pages.dart
│  │  └─ app_routes.dart
│  ├─ services/              # Serviços, como o Firebase
│  │  └─ firebase_service.dart
│  ├─ theme/                 # Temas e estilos da aplicação
│  │  ├─ app_theme.dart
│  │  ├─ buttons.dart
│  │  ├─ colors.dart
│  │  ├─ text_styles.dart
│  │  └─ theme.dart
│  └─ widgets/               # Widgets e componentes customizados
│     └─ custom_toast.dart
└─ main.dart                 # Ponto de entrada da aplicação
