\# EstofariaPro - Documentação Completa



\## 1. Visão Geral

EstofariaPro é um sistema de gestão para estofarias, desenvolvido em Flutter com integração Firebase. Funciona em Android, Windows e Web.



\## 2. Requisitos

\- Flutter 3.8.1 ou superior

\- Android Studio / SDK Android

\- CMake (para Windows)

\- Git



\## 3. Configuração Inicial

1\. Clonar o repositório:

&nbsp;  ```bash

&nbsp;  git clone https://github.com/comsudlg-hub/EstofariaPro.git

Entrar no diretório do projeto:



bash

Copiar código

cd frontend/estofariapro\_app

Instalar dependências:



bash

Copiar código

flutter pub get

4\. Build Android

Navegar até o diretório Android:



bash

Copiar código

cd android

Build debug:



bash

Copiar código

flutter run -d android

Build release:



bash

Copiar código

flutter build apk

5\. Build Windows

Navegar para o diretório do app:



bash

Copiar código

cd frontend/estofariapro\_app

Build/debug Windows:



bash

Copiar código

flutter run -d windows

Dica: caso ocorra erro de memória, usar o mínimo de memória disponível no computador.



6\. Configuração Firebase

O arquivo firebase.json e lib/firebase\_options.dart já estão incluídos.



Para alterar as configurações, seguir as instruções no console do Firebase.



7\. Versionamento

Para criar uma nova tag:



bash

Copiar código

git tag -a vX.X.X -m "Descrição da versão"

git push origin vX.X.X

8\. Contato

Desenvolvedor: Ivam Pereira



Email: \[coloque seu email]



yaml

Copiar código



\- Salve e feche o arquivo.



---



\*\*2️⃣ Adicionar `DOCUMENTATION.md` ao Git:\*\*



```powershell

git add DOCUMENTATION.md

3️⃣ Commitar as alterações:



powershell

Copiar código

git commit -m "Adicionar DOCUMENTATION.md com guia completo do projeto"

4️⃣ Dar push para o repositório remoto:



powershell

Copiar código

git push origin main

