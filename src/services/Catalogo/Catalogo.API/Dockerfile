FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["services/Catalogo/Catalogo.API/Catalogo.API.csproj", "services/Catalogo/Catalogo.API/"]
COPY ["common/Common.EventBus/Common.EventBus.csproj", "common/Common.EventBus/"]
COPY ["common/Common.WebAPI/Common.WebAPI.csproj", "common/Common.WebAPI/"]
RUN dotnet restore "./services/Catalogo/Catalogo.API/Catalogo.API.csproj"
COPY . .
WORKDIR "/src/services/Catalogo/Catalogo.API"
RUN dotnet build "./Catalogo.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Catalogo.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Catalogo.API.dll"]