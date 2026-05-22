FROM docker.io/library/ubuntu:24.04 AS build

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /src

# Instalar dependencias base e instalar .NET 9 de forma nativa usando la URL directa
RUN apt-get update && apt-get install -y wget bash ca-certificates \
    && wget https://dot.net -O dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --channel 9.0 --install-dir /usr/share/dotnet \
    && rm dotnet-install.sh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PATH="${PATH}:/usr/share/dotnet"

# Copiar archivos del proyecto y restaurar dependencias
COPY *.csproj ./
RUN dotnet restore

# Copiar el código fuente y compilar la aplicación
COPY . ./
RUN dotnet publish -c Release -o /app/out

# --- FASE DE EJECUCIÓN ---
FROM docker.io/library/ubuntu:24.04 AS runtime

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y libicu-dev libssl-dev tzdata openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiar el runtime instalado y la app compilada
COPY --from=build /usr/share/dotnet /usr/share/dotnet
COPY --from=build /app/out .

ENV PATH="${PATH}:/usr/share/dotnet"
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

ENTRYPOINT ["dotnet", "To-Do-List1.dll"]
