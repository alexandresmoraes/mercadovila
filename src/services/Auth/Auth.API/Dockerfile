FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["services/Auth/Auth.API/Auth.API.csproj", "services/Auth/Auth.API/"]
COPY ["common/Common.WebAPI/Common.WebAPI.csproj", "common/Common.WebAPI/"]
COPY ["common/Common.EventBus/Common.EventBus.csproj", "common/Common.EventBus/"]
RUN dotnet restore "./services/Auth/Auth.API/Auth.API.csproj"
COPY . .
WORKDIR "/src/services/Auth/Auth.API"
RUN dotnet build "./Auth.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Auth.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Auth.API.dll"]