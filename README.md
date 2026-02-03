# Travel App

**Plataforma de Solicitação de Viagens Corporativas**
Aplicativo Flutter desenvolvido para gerenciamento de solicitações de viagens, integração com webhooks via N8N/Sheets e fluxo de aprovação/rejeição de solicitações.

---

## 🛠 Tecnologias

* **Flutter**: desenvolvimento de interfaces responsivas e interativas.
* **Dart**: lógica de aplicação e manipulação de dados.
* **HTTP**: integração com webhooks e APIs externas.
* **Intl**: formatação de datas para exibição no app.
* **Figma → Flutter**: fidelidade de design e componentes consistentes.

---

## 📂 Estrutura do Projeto

```
flutter-travel-app/
│
├─ lib/
│  ├─ main.dart                 # Ponto de entrada do aplicativo
│  ├─ models/
│  │  └─ travel_request.dart    # Modelo de dados da solicitação de viagem
│  ├─ screens/
│  │  ├─ login_screen.dart      # Tela de login
│  │  ├─ travel_form_screen.dart# Formulário de solicitação de viagem
│  │  └─ dashboard_screen.dart  # Dashboard com lista de solicitações
│  ├─ services/
│  │  ├─ api_service.dart       # Integração com API/Webhook
│  │  └─ teste_webhook.dart     # Teste de envio de dados para N8N
│  └─ widgets/
│     ├─ primary_button.dart    # Botão reutilizável
│     ├─ status_badge.dart      # Badge de status da solicitação
│     └─ travel_card.dart       # Cartão visual de cada solicitação
│
├─ pubspec.yaml                 # Dependências e configuração do projeto
```

---

## 📌 Funcionalidades

1. **Autenticação simples**

   * Tela de login funcional para demonstração.
   * Validação de e-mail e senha.

2. **Formulário de solicitação de viagem**

   * Campos do solicitante: nome, e-mail, empresa/setor, centro de custo.
   * Campos da viagem: origem, destino, datas, justificativa.
   * Validação de datas (fim ≥ início).
   * Envio da solicitação via webhook (`N8N`) com payload JSON.

3. **Dashboard de solicitações**

   * Lista todas as solicitações enviadas.
   * Filtros por status: todos, pendente, aprovado, rejeitado.
   * Indicadores de quantidade total e por status.
   * Ações de aprovação ou rejeição para solicitações pendentes.
   * Atualização de status em tempo real e envio de webhook de confirmação.

4. **Componentes reutilizáveis**

   * `TravelCard`: apresenta nome, origem/destino, datas e status.
   * `StatusBadge`: cor consistente para status (aprovado, pendente, rejeitado).
   * `PrimaryButton`: botão com estilo uniforme.

5. **Integração com N8N/Webhooks**

   * Envio de dados de solicitação para automação.
   * Testes de envio com `teste_webhook.dart`.

---

## 📦 Modelo de Dados

O modelo principal é `TravelRequest`:

* Campos essenciais: `id`, `name`, `email`, `company`, `costCenter`, `origin`, `destination`, `startDate`, `endDate`, `reason`, `status`.
* Conversão para JSON para webhooks e Google Sheets.
* Normalização automática de status (`pendente`, `aprovado`, `rejeitado`).
* Função `copyWith` para atualizar objetos sem modificar o original.

---

## 🎨 Design e UX

* UI limpa e responsiva, baseada em **Figma**.
* Feedback imediato ao usuário (SnackBars, loaders, diálogos de confirmação).
* Componentes modulares, fáceis de reutilizar e manter.
* Ações condicionais (botões de aprovação/rejeição aparecem apenas para pendentes).

---

## ⚡ Pontos Técnicos Relevantes

* **Flutter & Dart**

  * Widgets modulares e gerenciáveis.
  * ListView.builder para renderização dinâmica de solicitações.
  * Uso de `StatefulWidget` e gerenciamento de estado local simples.

* **Integração Backend**

  * `http` para POST/GET de dados.
  * Payload JSON flat compatível com N8N/Sheets.
  * Tratamento de erros e status de resposta da API.

* **UX/Front-end**

  * Status visual com cores consistentes.
  * Indicadores de filtro e quantidade.
  * Diálogos de confirmação antes de aprovar ou rejeitar solicitações.

---

## ⚙️ Como Rodar o Projeto

1. **Clone o repositório**

```bash
git clone https://github.com/AndrewMBarros/flutter-travel-app
cd flutter-travel-app
```

2. **Instale as dependências**

```bash
flutter pub get
```

3. **Execute o app**

```bash
flutter run
```

* Requer Flutter SDK ≥ 2.19.0.
* Pode ser executado em Android, iOS ou Web (adaptar layout para Web se necessário).

---

## 🚀 Próximos Passos / Melhorias

- Sincronização completa com todas as colunas do Google Sheets via N8N.
- Implementar autenticação real via backend.
- Dashboard: adicionar pesquisa e ordenação de solicitações.
- Notificações em tempo real (Firebase ou WebSockets).
- Adicionar testes unitários e de widgets para maior confiabilidade.
