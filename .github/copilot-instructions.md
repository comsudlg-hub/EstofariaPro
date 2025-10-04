# Copilot Instructions — EstofariaPro

## Visão Geral
Este projeto é um app Flutter modular, com arquitetura orientada a camadas e forte padronização visual e funcional. O foco é manter consistência, reutilização e separação clara entre UI, lógica de negócio, dados e integrações externas.

## Estrutura Principal
- **lib/core/**: Temas, utilitários, helpers, constantes, validações, máscaras e helpers de responsividade.
- **lib/presentation/common_widgets/**: Componentes reutilizáveis (botões, campos, cards, estados vazios).
- **lib/core/theme/color_schemes.dart**: Paleta de cores MD3 obrigatória.
- **lib/core/utils/text_theme_util.dart**: Função createTextTheme() para tipografia.
- **lib/core/constants/colors.dart**: Cores fixas nomeadas.
- **lib/core/utils/validators.dart**: Validações centralizadas.
- **lib/core/utils/formatters.dart**: Máscaras e formatação.
- **lib/core/utils/helpers.dart**: Funções utilitárias de tela/responsividade.
- **lib/data/services/**: Integração com Firebase e APIs externas.
- **lib/data/repositories/**: Repositórios para abstração de dados.
- **lib/state/**: Providers para gerenciamento de estado.

## Fluxos de Desenvolvimento
- **Build:**
  - `flutter pub get` para dependências.
  - `flutter run` para rodar local.
  - `flutter build apk` ou `flutter build web` para produção.
- **Testes:**
  - Testes em `test/` (ex: `widget_test.dart`).
  - Rodar com `flutter test`.
- **Debug:**
  - Use o modo debug do Flutter e o DevTools.
  - Não debugue lógica de dados diretamente nas telas; use providers/services.

## Padrões Específicos
- **Nunca acesse Firebase direto nas telas.** Use services/repositories/providers.
- **Cores e fontes:** Sempre via arquivos de tema/utilitários.
- **Componentes:** Use sempre os de `common_widgets/` para UI.
- **Responsividade:** LayoutBuilder/MediaQuery + helpers.
- **Validações e máscaras:** Centralizadas, nunca duplicadas.
- **Feedback ao usuário:** Mensagens e loading padronizados.
- **Nomenclatura:** snake_case para arquivos, CamelCase para classes.
- **Comentários:** Apenas para lógica complexa, curtos e objetivos.

## Exemplos de Ajuste
- Para alterar cor de botão, modifique o parâmetro em `custom_button.dart` usando ColorScheme.
- Para criar campo de texto, utilize `custom_text_field.dart` e aplique validação via utilitário.
- Para responsividade, use helpers de `helpers.dart`.

## Convenções de Integração
- Integrações externas (ex: Firebase) sempre via services.
- Comunicação entre camadas por providers/repositories.

## Referências
- [Guia de Padronização Visual](Fonte da Verdade/Guia de Padronização Visual.docx)
- [Plano Mestre Arquitetura](Fonte da Verdade/Plano_Mestre_Arquitetura.docx)

---

> Siga rigorosamente as instruções do Prompt Mestre e do Guia de Padronização. Em caso de dúvida, peça esclarecimento antes de alterar qualquer código.
