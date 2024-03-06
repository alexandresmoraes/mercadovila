#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["services/Vendas/Vendas.API/Vendas.API.csproj", "services/Vendas/Vendas.API/"]
COPY ["common/Common.EventBus/Common.EventBus.csproj", "common/Common.EventBus/"]
COPY ["common/Common.Grpc/Common.Grpc.csproj", "common/Common.Grpc/"]
COPY ["services/Vendas/Vendas.Domain/Vendas.Domain.csproj", "services/Vendas/Vendas.Domain/"]
COPY ["common/Common.WebAPI/Common.WebAPI.csproj", "common/Common.WebAPI/"]
COPY ["services/Vendas/Vendas.Infra/Vendas.Infra.csproj", "services/Vendas/Vendas.Infra/"]
RUN dotnet restore "./services/Vendas/Vendas.API/Vendas.API.csproj"
COPY . .
WORKDIR "/src/services/Vendas/Vendas.API"
RUN dotnet build "./Vendas.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Vendas.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Vendas.API.dll"]