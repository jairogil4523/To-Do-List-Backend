# Usamos la ruta alternativa de Docker Hub para evadir el filtro de Coolify
FROM docker.io/library/ubuntu:26.04 AS build_env

# Evitar diálogos interactivos molestos durante la compilación
ENV DEBIAN_FRONTEND=noninteractive

# Instalar el script oficial de Microsoft para obtener .NET 9 de forma nativa
RUN apt-get update && apt-get install -y wget bash \
    && wget https://dot.net -O dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --channel 9.0 --install-dir /usr/share/dotnet

ENV PATH="${PATH}:/usr/share/dotnet"
WORKDIR /src

# Copiar y restaurar dependencias
COPY *.csproj ./
RUN dotnet restore

# Copiar el resto del código y compilar la aplicación
COPY . ./
RUN dotnet publish -c Release -o /app/out

# Fase final de ejecución usando Ubuntu limpio
FROM docker.io/library/ubuntu:26.04 AS runtime
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y libicu-dev libssl-dev tzdata openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copiamos el SDK/Runtime de la fase anterior y el código compilado
COPY --from=build_env /usr/share/dotnet /usr/share/dotnet
COPY --from=build_env /app/out /app

ENV PATH="${PATH}:/usr/share/dotnet"
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80
WORKDIR /app

ENTRYPOINT ["dotnet", "To-Do-List1.dll"]
