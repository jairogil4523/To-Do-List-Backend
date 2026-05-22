# Truco de ofuscación: Dividimos la URL oficial para que Coolify no la altere
ARG PART1=mcr
ARG PART2=microsoft.com

# Fase de compilación rápida con el SDK oficial de .NET 9
FROM ${PART1}.${PART2}/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copiar archivos del proyecto y restaurar paquetes de NuGet
COPY *.csproj ./
RUN dotnet restore

# Copiar el código fuente restante y compilar la aplicación
COPY . ./
RUN dotnet publish -c Release -o /app/out

# Fase final de ejecución usando el entorno optimizado de Microsoft
ARG PART1=mcr
ARG PART2=microsoft.com
FROM ${PART1}.${PART2}/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Copiar los archivos binarios compilados en la fase previa
COPY --from=build /app/out .

ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

ENTRYPOINT ["dotnet", "To-Do-List1.dll"]

