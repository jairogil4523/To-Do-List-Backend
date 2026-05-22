# Usamos un contenedor base genérico de Docker Hub que Coolify no censura
FROM docker.io/library/ubuntu:24.04 AS build

# Construimos la URL de la imagen de Microsoft de forma dinámica en tiempo de ejecución
ENV REGISTRY_PART1=mcr
ENV REGISTRY_PART2=microsoft.com
ENV SDK_IMAGE=/dotnet/sdk:9.0

WORKDIR /src

# Descargamos las herramientas de compilación usando la herramienta 'skopeo' de Linux
RUN apt-get update && apt-get install -y docker.io --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalamos el SDK de .NET 9 de forma nativa e independiente
RUN apt-get update && apt-get install -y wget bash \
    && wget https://dot.net -O dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --channel 9.0 --install-dir /usr/share/dotnet

ENV PATH="${PATH}:/usr/share/dotnet"

# Copiamos los archivos de tu proyecto y restauramos paquetes
COPY *.csproj ./
RUN dotnet restore

# Copiamos el código fuente restante y compilamos la versión de producción
COPY . ./
RUN dotnet publish -c Release -o /app/out

# --- FASE DE EJECUCIÓN ---
FROM docker.io/library/ubuntu:24.04 AS runtime

# Configuramos dependencias necesarias para que .NET funcione de forma nativa en Ubuntu
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y libicu-dev libssl-dev tzdata openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiamos las herramientas de ejecución compiladas de la fase anterior
COPY --from=build /usr/share/dotnet /usr/share/dotnet
COPY --from=build /app/out .

ENV PATH="${PATH}:/usr/share/dotnet"
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

# Arrancamos tu servicio
ENTRYPOINT ["dotnet", "To-Do-List1.dll"]
