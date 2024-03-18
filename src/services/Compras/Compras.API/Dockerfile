FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["services/Compras/Compras.API/Compras.API.csproj", "services/Compras/Compras.API/"]
COPY ["services/Compras/Compras.Domain/Compras.Domain.csproj", "services/Compras/Compras.Domain/"]
COPY ["common/Common.WebAPI/Common.WebAPI.csproj", "common/Common.WebAPI/"]
COPY ["common/Common.EventBus/Common.EventBus.csproj", "common/Common.EventBus/"]
COPY ["services/Compras/Compras.Infra/Compras.Infra.csproj", "services/Compras/Compras.Infra/"]
RUN dotnet restore "./services/Compras/Compras.API/Compras.API.csproj"
COPY . .
WORKDIR "/src/services/Compras/Compras.API"
RUN dotnet build "./Compras.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Compras.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Compras.API.dll"]