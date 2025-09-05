# 🛋️ EstofariaPro

Plataforma digital B2B2C voltada para estofarias, com foco em profissionalismo, confiança, acolhimento e qualidade artesanal.

## 🎯 Objetivo

Modernizar o setor de estofarias com tecnologia simples, eficiente e acessível, conectando estofarias, fornecedores e clientes finais.

## 🏗️ Arquitetura

* **Frontend:** Flutter com Material 3
* **Backend:** Firebase (Firestore, Auth, Storage, Cloud Functions)
* **IA:** TensorFlow Lite, Google Vision AI
* **Pagamentos:** Google Pay, Stripe
* **Comunicação:** WhatsApp Business API, EmailJS

## 👥 Público-Alvo

* ✅ Estofarias (empresas do setor)
* ✅ Fornecedores de matéria-prima
* ✅ Clientes finais
* ✅ Administradores do sistema

## 🚀 Como Executar

cd frontend/estofariapro\_app
flutter pub get
flutter run



## 📁 Estrutura do Projeto

Veja [docs/estado-atual.md](docs/estado-atual.md) para detalhes completos da estrutura atual.

## 🔧 Estado Atual

✅ Navegação completa entre telas
✅ Sistema de autenticação por tipo de usuário
✅ 4 dashboards diferentes (básicos)
✅ Identidade visual implementada

🚧 Em desenvolvimento:

* Integração com Firebase
* Funcionalidades completas dos dashboards
* Sistema de pedidos e orçamentos



\## 🚧 Status de Build



⚠️ \*\*Android\*\*: Configuração completa, mas build pendente devido a questões de memória  

✅ \*\*Firebase\*\*: Projeto configurado e regras deployadas com sucesso  

✅ \*\*Estrutura\*\*: Código organizado e navegação funcionando  

✅ \*\*GitHub\*\*: Versionamento completo e atualizado  



\## 🔄 Progresso Recente



\### ✅ Concluído:

\- \[x] Configuração completa do Firebase (Firestore, Storage, Auth)

\- \[x] Arquivo google-services.json adicionado

\- \[x] Configuração Android atualizada (package name, minSdkVersion)

\- \[x] Regras de segurança deployadas

\- \[x] Versionamento completo no GitHub



\### 🚧 Em Andamento:

\- \[ ] Resolução de issues de build Android

\- \[ ] Implementação autenticação Firebase Auth

\- \[ ] Integração com APIs reais



\## 🆘 troubleshooting Android Build



Erro atual: `Insufficient memory for Java Runtime Environment`



\*\*Soluções em teste:\*\*

\- Reduzir memória do Gradle (-Xmx1g)

\- Build sem daemon (--no-daemon)

\- Limpeza de cache do Flutter



\## 📊 Estrutura Firebase



\*\*Projeto\*\*: `estofariapro`  

\*\*Database\*\*: Firestore Native Mode  

\*\*Storage\*\*: Bucket configurado  

\*\*Authentication\*\*: Email/senha habilitado  

\*\*Regras\*\*: Security rules deployadas





## 📞 Contato

**Ivam Pereira**  
Proprietário - Compersonalite Gestão Integrada  
ivam@compersonalite.com

## 📄 Licença

Este projeto é propriedade da Compersonalite Gestão Integrada.

