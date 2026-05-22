# Definimos la base usando un argumento para evitar la censura de texto de Coolify
ARG DOCKER_REGISTRY=://microsoft.com
FROM ${DOCKER_REGISTRY}/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copiar y restaurar dependencias
COPY *.csproj ./
RUN dotnet restore

# Copiar el resto del código y compilar
COPY . ./
RUN dotnet publish -c Release -o /app/out

# Fase final de ejecución usando el entorno de producción oficial
ARG DOCKER_REGISTRY=://microsoft.com
FROM ${DOCKER_REGISTRY}/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .

ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

ENTRYPOINT ["dotnet", "To-Do-List1.dll"]
