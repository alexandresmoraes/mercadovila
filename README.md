<p align="center">
    <img alt="logo" src="https://github.com/alexandresmoraes/mercadovila/blob/master/assets/logo.png?raw=true" />    
</p>

# MercadoVila - Um aplicativo de referência de microsserviços desenvolvido com ASP.NET 6 & Flutter


https://github.com/alexandresmoraes/mercadovila/assets/26805150/a1d56a17-79d9-443c-a1d2-cadceccee9b5


O aplicativo é um projeto de código aberto desenvolvido com objetivo compartilhar as melhores práticas e abordagens para o desenvolvimento de aplicativos completos e complexos utilizando tecnologias .NET.

---

###### Este projeto foi inspirado em [eShop](https://github.com/dotnet/eShop), com algumas particularidades.

## Mostre seu apoio dando uma estrela! :star:

Se algo aqui foi útil para você, ficaríamos imensamente gratos se você nos desse uma estrela. Seu apoio nos ajuda a continuar fornecendo conteúdo valioso e aprimorando nossos projetos.

<p align="center">
    <img alt="MercadoMaluco" src="https://github.com/alexandresmoraes/vilasesmo/raw/master/assets/arch_vilasesmo.png?raw=true" />
</p>

## Tecnologias

- .NET 6

  - ASP.NET MVC
  - ASP.NET WebApi
  - ASP.NET Identity Core
  - Refresh Token
  - JWT
  - gRPC
  - Entity Framework Core 6

- Componentes / Serviços

  - Kafka
  - PostgreSQL
  - MongoDB
  - Polly.NET
  - Dapper
  - FluentValidator
  - MediatR
  - Swagger UI

- Hosting
  - NGINX
  - Docker

## Arquitetura:

- Clean Code
- Clean Architecture
- SOLID Principles
- DDD - Domain Driven Design
- Domain Events
- Domain Notification
- Domain Validations
- Integrations Events
- CQRS
- Fail Fast Validations
- Retry Pattern
- Circuit Breaker
- Unit of Work
- Repository Pattern
- Result Pattern
- Publish/Subscribe Pattern

## Mobile/Web/Desktop:

- Flutter (Android, iOS, Web, Windows, macOS)
- Flutter Modular
- Flutter Mobx (Stores/Controllers)

---

## Rodando localmente :rocket:

### Pré-requisitos

- (Somente Win) Instale o Visual Studio. [Visual Studio 2022](https://visualstudio.microsoft.com/vs/preview/) ou
- (Win/Mac) Instale o Visual Studio Code. [Visual Studio Code](https://code.visualstudio.com/Download)
- Instale o .NET Core 6. [.NET 6 SDK](https://dotnet.microsoft.com/pt-br/download/dotnet/6.0)
- Instale o Docker. [Docker](https://docs.docker.com/get-docker/)
- Instale o Flutter (recomendo a versão 3.13.9). [Flutter Download](https://docs.flutter.dev/release/archive)
- Instale o Git. [Git Download](https://git-scm.com/downloads)

### Rodando

### 1. Clone o repository: https://github.com/alexandresmoraes/mercadovila e acesse a pasta src
```
git clone https://github.com/alexandresmoraes/mercadovila
cd .\mercadovila\src\
```
### 2. Copie e edite se necessário o arquivo sample.env para .env
(macOS/Linux)
```sh
cp sample.env .env
```
(Win)
```powershell
copy sample.env .env
```

### 3. Rode os serviços necessários:

> [!WARNING]
> Confira se o Docker está inicializado.

```
docker-compose -f docker-compose.dev.yml up
```

### 4. Build & Run:
**Parte 1 (Opcional):** (Somente Win) Rodando aplicação pelo Visual Studio:
 - Abra o arquivo `mercadovila.sln` no Visual Studio
 - Selecione os projetos para Startup, Auth.API, Catalogo.API, Compras.API e Vendas.API
 - Pressione F5 para iniciar

**Parte 2 (Obrigatório):** (Win/macOS/Linux) Rodando aplicação pelo Visual Studio Code: 
 - Utilize o arquivo launch.json e tasks.json para uma melhor experiência [confira](https://code.visualstudio.com/docs/editor/debugging):
 - Escolha seu device para rodar o flutter.
 - Se optou pela opção 1, aqui não é necessário rodar "Start All" e selecionar apenas "Mercado Vila Mobile (debug mode)", senão "Start All".

tasks.json
```json
{
    "version": "2.0.0",
    "tasks": [      
        {
            "label": "build",
            "command": "dotnet",
            "type": "process",
            "args": [
                "build",
                "${workspaceFolder}/src/mercadovila.sln",
                "/property:GenerateFullPaths=true",
                "/consoleloggerparameters:NoSummary"
            ],
            "problemMatcher": "$msCompile"
        }
    ]
}
```

launch.json
```json
{    
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Mercado Vila Auth API",
            "type": "coreclr",
            "request": "launch",
            "preLaunchTask": "build",
            "program": "${workspaceFolder}/src/services/Auth/Auth.API/bin/Debug/net6.0/Auth.API.dll",
            "args": [],
            "cwd": "${workspaceFolder}/src/services/Auth/Auth.API",
            "console": "internalConsole",
            "stopAtEntry": false
        },
        {
            "name": "Mercado Vila Catalogo API",
            "type": "coreclr",
            "request": "launch",
            "preLaunchTask": "build",
            "program": "${workspaceFolder}/src/services/Catalogo/Catalogo.API/bin/Debug/net6.0/Catalogo.API.dll",
            "args": [],
            "cwd": "${workspaceFolder}/src/services/Catalogo/Catalogo.API",
            "console": "internalConsole",
            "stopAtEntry": false
        },
        {
            "name": "Mercado Vila Compras API",
            "type": "coreclr",
            "request": "launch",
            "preLaunchTask": "build",
            "program": "${workspaceFolder}/src/services/Compras/Compras.API/bin/Debug/net6.0/Compras.API.dll",
            "args": [],
            "cwd": "${workspaceFolder}/src/services/Compras/Compras.API",
            "console": "internalConsole",
            "stopAtEntry": false
        },
        {
            "name": "Mercado Vila Vendas API",
            "type": "coreclr",
            "request": "launch",
            "preLaunchTask": "build",
            "program": "${workspaceFolder}/src/services/Vendas/Vendas.API/bin/Debug/net6.0/Vendas.API.dll",
            "args": [],
            "cwd": "${workspaceFolder}/src/services/Vendas/Vendas.API",
            "console": "internalConsole",
            "stopAtEntry": false
        },
        {
            "name": "Mercado Vila Mobile (debug mode)",
            "cwd": "${workspaceFolder}/src/mobile",
            "request": "launch",
            "type": "dart",
            "flutterMode": "debug",
            "toolArgs": [
                "--dart-define", "BASE_URL=http://<seu_ip>:8081"                
            ]
        }
    ],
    "compounds": [
        {
            "name": "Start all",
            "configurations": [
                "Mercado Vila Auth API",
                "Mercado Vila Catalogo API",
                "Mercado Vila Compras API",
                "Mercado Vila Vendas API",
                "Mercado Vila Mobile (debug mode)"                
            ],
            "stopAll": true
        }
    ]    
}
```


## Aviso Legal

- Este repositório não pretende ser um modelo de referência para todas as aplicações .NET.
- Nosso objetivo principal é compartilhar conhecimento e experiência.
- Tenha cuidado com o excesso de arquitetura em seus serviços. Nem sempre é necessário muitos padrões e implementações.
- Pedimos desculpas pela mescla de português e inglês. Optamos por usar o máximo possível de termos em português nos domínios para facilitar a compreensão do DDD por parte dos estudantes. Lembre-se de que até mesmo Game of Thrones não seria tão impactante se Jon Snow se chamasse João das Neves.

## Pull-Requests

Vamos abrir uma discussão sobre problemas e possíveis soluções! Se você está interessado em contribuir, é importante focarmos em problemas já identificados e discutidos. Antes de enviar um Pull Request, vamos garantir que o problema tenha sido aprovado e discutido adequadamente pela equipe.

Se estiver disposto a ajudar, escolha um problema que tenha sido aprovado e debatido. Uma vez selecionado, podemos discutir como abordar a implementação de forma eficaz e alinhada com as diretrizes do projeto.

## About

Criado com :heart: por Alexandre de Moraes
